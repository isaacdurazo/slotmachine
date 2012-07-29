package com.solitude.slots.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.codec.digest.DigestUtils;

import com.google.appengine.api.utils.SystemProperty;
import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.QueryCondition;
import com.solitude.slots.entities.AbstractGAEPersistent;
import com.solitude.slots.entities.Pair;
import com.solitude.slots.entities.Player;
import com.solitude.slots.opensocial.Person;

/**
 * Manages player data
 * @author kwright
 */
public class PlayerManager {

	/** cache region for custom cache data */	
	private static final String CACHE_REGION = "player.region";
	
	/** singleton instance */
	private static final PlayerManager instance = new PlayerManager();
	/** @return singleton */
	public static PlayerManager getInstance() { return instance; }

    private static final Logger log = Logger.getLogger(instance.getClass().getName());
	
	/** private constructor to ensure singleton */
	private PlayerManager() { }
	
	/**
	 * Called on start of game player for webkit devices where accessToken is known 
	 * @param accessToken for access to moco
	 * @return pair of player (will create if new) and coins awarded as part of consecutive play
	 * @throws Exception on unexpected error
	 */
	public Pair<Player,Integer> startGamePlayer(String accessToken) throws Exception {
		// look up user with given access token
		Player player = this.getPlayer(accessToken);
		boolean newPlayer = player == null;
		if (newPlayer) {
			// create new player by first fetching moco data
			player = new Player();
			Person person = OpenSocialService.getInstance().fetchSelf(accessToken, Person.Field.BIRTHDAY.toString(), 
					Person.Field.GENDER.toString(), Person.Field.LOCALE.toString());
			player.setAccessToken(accessToken);
			if (person.getFieldValue(Person.Field.BIRTHDAY.toString()) != null) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				player.setBirthday(sdf.parse((String)person.getFieldValue(Person.Field.BIRTHDAY.toString())).getTime());
			}
			player.setImage((String)person.getFieldValue(Person.Field.THUMBNAIL_URL.toString()));
			player.setLocale(Player.createLocaleFromString((String)person.getFieldValue(Person.Field.LOCALE.toString())));
			player.setMale("male".equals((String)person.getFieldValue(Person.Field.GENDER.toString())));
			player.setMocoId(Integer.parseInt((String)person.getFieldValue(Person.Field.ID.toString())));
			player.setName((String)person.getFieldValue(Person.Field.DISPLAY_NAME.toString()));
			player.setCoins(Integer.getInteger("new.player.coins", 10));
			log.log(Level.INFO,"sessionstart|new user|uid|"+player.getMocoId()+"|Player="+player.toString());
		} else {
			log.log(Level.INFO,"sessionstart|returning user|uid|"+player.getMocoId()+", Player="+player.toString());
		}
		
		// award coins if consecutive days greater than 0 and last consecutive days increment last than 100 ms (just happened)
		int coinsAwarded = 0;
		if (player.awardConsecutiveDays()) {
			coinsAwarded = Integer.getInteger("consecutive.days.coin.award.per.day")*
					(1+Math.min(player.getConsecutiveDays(),Integer.getInteger("consecutive.days.coin.award.day.cap")));
			player.setCoins(player.getCoins()+coinsAwarded);
		}
		// store player (if new or to track consecutive days)
		GAEDataManager.getInstance().store(player);

		player.setIsNewPlayer(newPlayer); //Important ONLY set this after persisting = IsNewPlayer only true on 1st pgview

		// add to look up by access token cache
		if (newPlayer) {
			final String cacheKey = "moco_token_"+accessToken;
			List<Long> existingPlayerIds = GAECacheManager.getInstance().getIds(CACHE_REGION, cacheKey);
			if (existingPlayerIds == null) existingPlayerIds = new ArrayList<Long>();
			existingPlayerIds.add(0, player.getId());
			GAECacheManager.getInstance().putIds(CACHE_REGION, cacheKey, existingPlayerIds);
		}
		return new Pair<Player, Integer>(player,coinsAwarded);
	}
	
	/**
	 * Fetch players who played within the last hours specified
	 * @param hours to include
	 * @return list of players
	 * @throws DataStoreException for data error
	 */
	public List<Player> getRecentPlayers(int hours) throws DataStoreException {
		Set<QueryCondition> conditions = new HashSet<QueryCondition>();
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY,false));
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_UPDATE_KEY,System.currentTimeMillis()-hours*3600*1000,QueryCondition.QUERY_OPERATOR.GREATER_THAN_EQUALS));
		return GAEDataManager.getInstance().query(Player.class, conditions, null, false);
	}
	
	/**
	 * Called on start of game player which will verify redirect parameters (set by system 
	 * property "redirect.validate.enabled") and load player.  If new user  
	 * 
	 * @param userId of user
	 * @param timestamp for verification
	 * @param verifier token
	 * @return pair of player (will create if new) and coins awarded as part of consecutive play
	 * @throws UnAuthorizedException if verifier is invalid
	 * @throws Exception on unexpected error
	 */
	public Pair<Player,Integer> startGamePlayer(int userId, long timestamp, String verifier) throws UnAuthorizedException, Exception {
		if (userId <= 0) throw new IllegalArgumentException("invalid userId: "+userId);
		if (Boolean.getBoolean("redirect.validate.enabled") && SystemProperty.environment.get().equals(SystemProperty.Environment.Value.Production)) {
			// validate redirect parameters from moco
			String expectedVerifier = DigestUtils.md5Hex(userId+Long.toString(timestamp)+GameUtils.getGameGoldSecret());
			if (!expectedVerifier.equalsIgnoreCase(verifier)) throw new UnAuthorizedException("Invalid verifier!");
		}
		// lookup access token via opensocial request
		return this.startGamePlayer(OpenSocialService.getInstance().fetchOAuthToken(userId, GameUtils.getGameAdminToken()));
		
	}
	
	/**
	 * Fetch most recent player (by creationtime) with moco accessToken given that is not deleted
	 * @param accessToken of player
	 * @return player (if exists and not deleted) and null otherwise
	 * @throws CacheStoreException for cache issues
	 * @throws DataStoreException for datastore issues
	 */
	public Player getPlayer(String accessToken) throws CacheStoreException, DataStoreException {
		// find players with this moco id
		final String cacheKey = "moco_token_"+accessToken;
		List<Long> playerIds = GAECacheManager.getInstance().getIds(CACHE_REGION, cacheKey);
		if (playerIds == null || playerIds.isEmpty()) {
			// make datastore request
			Set<QueryCondition> conditions = new HashSet<QueryCondition>();
			conditions.add(new QueryCondition("accessToken",accessToken));
			conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY,false));
			List<Player> players = GAEDataManager.getInstance().query(
					Player.class, 
					conditions, 
					Player.ENTITY_CREATION_KEY, 
					true); 				// descending
			// update cache
			playerIds = new ArrayList<Long>(players.size());
			Player result = null;
			for (Player player : players) { 
				if (player == null) continue;
				playerIds.add(player.getId());
				if (result == null && !player.isDeleted()) result = player;
			}
			GAECacheManager.getInstance().putIds(CACHE_REGION, cacheKey, playerIds);
			// player is the first one (most recent)
			return players.isEmpty() ? null : result;
		}
		// load player object and return first that is not null
		if (playerIds.isEmpty()) return null;
		for (long playerId : playerIds) {
			Player player = GAECacheManager.getInstance().get(playerId, Player.class);
			if (player != null && !player.isDeleted()) return player;
		}
		return null;
	}
	
	/**
	 * Fetch player by id
	 * 
	 * @param playerId to be returned
	 * @return player if exists and not null
	 * @throws CacheStoreException for cache issues
	 * @throws DataStoreException for data issues
	 */
	public Player getPlayer(long playerId) throws CacheStoreException, DataStoreException {
		if (playerId < 0) return null;
		Player player = GAECacheManager.getInstance().get(playerId, Player.class);
		if (player != null) return player.isDeleted() ? null : player;
		player = GAEDataManager.getInstance().load(playerId, Player.class);
		if (player == null) GAECacheManager.getInstance().putNull(playerId, Player.class);
		else GAECacheManager.getInstance().put(player);
		return player;
	}
	
	/**
	 * Store player in DB and cache
	 * 
	 * @param player to be stored
	 * @throws DataStoreException for data issues
	 * @throws CacheStoreException for cache issues
	 */
	public void storePlayer(Player player) throws DataStoreException, CacheStoreException {
		GAEDataManager.getInstance().store(player);
		GAECacheManager.getInstance().put(player);
	}
	
	/**
	 * Indicates an unauthorized action has occurred
	 * @author kwright
	 */
	@SuppressWarnings("serial")
	public static class UnAuthorizedException extends Exception {
		
		/** @param message with detail */
		public UnAuthorizedException(String message) {
			super(message);
		}
	}
}
