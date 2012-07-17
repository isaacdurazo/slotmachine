package com.solitude.slots.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.codec.digest.DigestUtils;

import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.QueryCondition;
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
	/** private constructor to ensure singleton */
	private PlayerManager() { }
	
	/**
	 * Called on start of game player which will verify redirect parameters (set by system 
	 * property "redirect.validate.enabled") and load player.  If new user  
	 * 
	 * @param userId
	 * @param timestamp
	 * @param verifier
	 * @return
	 * @throws UnAuthorizedException
	 * @throws Exception 
	 */
	public Player startGamePlayer(int userId, long timestamp, String verifier) throws UnAuthorizedException, Exception {
		if (Boolean.valueOf(System.getProperty("redirect.validate.enabled"))) {
			// validate redirect parameters from moco
			String expectedVerifier = DigestUtils.md5Hex(userId+Long.toString(timestamp)+GameUtils.getGameGoldSecret());
			if (expectedVerifier.equalsIgnoreCase(verifier)) throw new UnAuthorizedException("Invalid verifier!");
		}
		// lookup access token via opensocial request
		String accessToken = OpenSocialService.getInstance().fetchOAuthToken(userId, GameUtils.getGameAdminToken());
		// look up user with given access token
		Player player = this.getPlayer(accessToken);
		if (player == null) {
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
			// store player
			GAEDataManager.getInstance().store(player);
		}
		return player;
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
		if (playerIds == null) {
			// make datastore request
			Set<QueryCondition> conditions = new HashSet<QueryCondition>();
			conditions.add(new QueryCondition("accessToken",accessToken));
			List<Player> players = GAEDataManager.getInstance().query(
					Player.class, 
					conditions, 
					Player.ENTITY_CREATION_KEY, 
					true); 				// descending
			// update cache
			playerIds = new ArrayList<Long>(players.size());
			Player result = null;
			for (Player player : players) { 
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
			if (!player.isDeleted()) return player;
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
	public Player getPlayer(int playerId) throws CacheStoreException, DataStoreException {
		Player player = GAECacheManager.getInstance().get(playerId, Player.class);
		if (player != null) return player.isDeleted() ? null : player;
		player = GAEDataManager.getInstance().load(playerId, Player.class);
		GAECacheManager.getInstance().put(player);
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
