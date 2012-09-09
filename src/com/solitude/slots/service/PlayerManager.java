package com.solitude.slots.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.codec.digest.DigestUtils;

import com.google.appengine.api.LifecycleManager;
import com.google.appengine.api.LifecycleManager.ShutdownHook;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;
import com.google.appengine.api.utils.SystemProperty;
import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.QueryCondition;
import com.solitude.slots.entities.AbstractGAEPersistent;
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
	/** logger */
    private static final Logger log = Logger.getLogger(instance.getClass().getName());
    /** map of player ID to delta info to delay datastore writes */
    private final Map<Long,PlayerDeltaInfo> playerIDtoCoinXPMap;
    /** if true then all player deltas are force flushed */
    private static boolean forceFlushEnabled = false;
	
	/** private constructor to ensure singleton */
	private PlayerManager() {
		playerIDtoCoinXPMap = new ConcurrentHashMap<Long,PlayerDeltaInfo>();
		// start queue flushing
		this.flushDeltaPlayers(false);
		// flush on instance shutdown
		LifecycleManager.getInstance().setShutdownHook(new ShutdownHook() {

			@Override
			public void shutdown() {
				PlayerManager.getInstance().flushDeltaPlayers(true);
			}
			
		});
	}
	
	/**
	 * Called on start of game player for webkit devices where accessToken is known 
	 * @param accessToken for access to moco
	 * @return player (will create if new)
	 * @throws Exception on unexpected error
	 */
	public Player startGamePlayer(String accessToken) throws Exception {
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
			player.setCoins(Integer.getInteger("new.player.coins", 20));
			player.setSessions(1);
			log.log(Level.INFO,"sessionstart|new user|uid|"+player.getMocoId()+"|Player="+player.toString());
		} else {
			player.setSessions(player.getSessions()+1);
			log.log(Level.INFO,"sessionstart|returning user|uid|"+player.getMocoId()+", Player="+player.toString());
		}
		
		// store player to update last access time
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
		return player;
	}
	
	/**
	 * Determines if user has earned coins for returning.  Will increase player's coins and store automatically.
	 * @param player to check
	 * @return coins awarded (0 if none)
	 * @throws DataStoreException data error
	 * @throws CacheStoreException cache error
	 */
	public Integer getRetentionCoinAward(Player player) throws DataStoreException, CacheStoreException {
		// award coins if consecutive days greater than 0 and last consecutive days increment last than 100 ms (just happened)
		int coinsAwarded = 0;
		if (player.awardConsecutiveDays()) {
			coinsAwarded = Integer.getInteger("game.consecutive.days.coin.award.per.day")*
					(1+Math.min(player.getConsecutiveDays(),Integer.getInteger("game.consecutive.days.coin.award.day.cap")));
			player.setCoins(player.getCoins()+coinsAwarded);
			GAEDataManager.getInstance().store(player);
		}		
		return coinsAwarded;
	}
	
	/**
	 * Fetch players who played within the last hours specified
	 * @param hours to include
	 * @param max number of players to return
	 * @return list of players
	 * @throws DataStoreException for data error
	 */
	public List<Player> getRecentPlayers(int hours, int max) throws DataStoreException {
		Set<QueryCondition> conditions = new HashSet<QueryCondition>();
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY,false));
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_UPDATE_KEY,System.currentTimeMillis()-hours*3600*1000,QueryCondition.QUERY_OPERATOR.GREATER_THAN_EQUALS));
		return GAEDataManager.getInstance().query(Player.class, conditions, null, false, max);
	}

	/**
	 * Fetch players who played within the hours defined between starthours and endhours ago
	 * @param starthours begin hour 
	 * @param endhours end hour - must be smaller than starthours
	 * @param max number of players to return
	 * @return list of players
	 * @throws DataStoreException for data error
	 */
	public List<Player> getActiveHoursPlayers(int starthours, int endhours, int max) throws DataStoreException {
		if (starthours<endhours){
			return(new ArrayList<Player>(0));
		}
		Set<QueryCondition> conditions = new HashSet<QueryCondition>();
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY,false));
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_UPDATE_KEY,System.currentTimeMillis()-starthours*3600*1000,QueryCondition.QUERY_OPERATOR.GREATER_THAN_EQUALS));
		conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_UPDATE_KEY,System.currentTimeMillis()-endhours*3600*1000,QueryCondition.QUERY_OPERATOR.LESS_THAN));
		return GAEDataManager.getInstance().query(Player.class, conditions, null, false, max);
	}
	
	
	
	/**
	 * Called on start of game player which will verify redirect parameters (set by system 
	 * property "game.redirect.validate.enabled") and load player.  If new user  
	 * 
	 * @param userId of user
	 * @param timestamp for verification
	 * @param verifier token
	 * @return player (will create if new)
	 * @throws UnAuthorizedException if verifier is invalid
	 * @throws Exception on unexpected error
	 */
	public Player startGamePlayer(int userId, long timestamp, String verifier) throws UnAuthorizedException, Exception {
		if (userId <= 0) throw new IllegalArgumentException("invalid userId: "+userId);
		if (Boolean.getBoolean("game.redirect.validate.enabled") && SystemProperty.environment.get().equals(SystemProperty.Environment.Value.Production)) {
			// validate redirect parameters from moco
			String expectedVerifier = DigestUtils.md5Hex(userId+Long.toString(timestamp)+GameUtils.getGameGoldSecret());
			if (!expectedVerifier.equalsIgnoreCase(verifier)) throw new UnAuthorizedException("Invalid verifier!");
		}
		// lookup access token via opensocial request
		return this.startGamePlayer(OpenSocialService.getInstance().fetchOAuthToken(userId, GameUtils.getGameAdminToken()));
		
	}
	
	/**
	 * Get Player by Moco Id
	 * @param mocoId of user
	 * @return player or null if one does not exist
	 * @throws Exception for unexpected errors or if user is not yet playing the game
	 */
	public Player getPlayerByMocoId(int mocoId) throws Exception {
		return getPlayer(OpenSocialService.getInstance().fetchOAuthToken(mocoId, GameUtils.getGameAdminToken()));
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
					true,
					5); 				// descending
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
		this.storePlayer(player, false);
	}
	
	/**
	 * Store player in DB and cache with option to delay flushing to datastore
	 * 
	 * @param player to be stored
	 * @param delay if true then will flush to datastore every minute
	 * @throws DataStoreException for data issues
	 * @throws CacheStoreException for cache issues
	 */
	public void storePlayer(Player player, boolean delay) throws DataStoreException, CacheStoreException {
		if (!delay || !Boolean.getBoolean("player.delta.flush.enabled")) {
			GAEDataManager.getInstance().store(player);
			updatePlayerLeaderboards(player);
		} else if (Boolean.getBoolean("player.delta.flush.task.queue.enabled")) { 
			// see if we already added by checking cache
			if (GAECacheManager.getInstance().getCustom("playerFlush", Long.toString(player.getId())) == null) {
				// not in cache so put and add to task queue
				GAECacheManager.getInstance().putCustom("playerFlush", Long.toString(player.getId()), "1", 2*60*1000);
				TaskOptions task = TaskOptions.Builder.withUrl("/admin/queue.jsp?queue=flushPlayer&playerId="+player.getId()+"&accessToken="+System.getProperty("queue.token"));
				task.method(Method.GET);
				task.countdownMillis(2*60*1000);
				QueueFactory.getQueue("playerTaskFlush").add(task);				
			}
		} else {
			PlayerDeltaInfo info = playerIDtoCoinXPMap.get(player.getId());
			if (info == null) {
				info = new PlayerDeltaInfo();
				playerIDtoCoinXPMap.put(player.getId(), info);
			}
			info.player = player;
			info.lastAccess = System.currentTimeMillis();
		}
		GAECacheManager.getInstance().put(player);
	}
	
	private void updatePlayerLeaderboards(Player player) {
		if (Boolean.getBoolean("game.xp.leaderboard.enabled")) {
			try {
				OpenSocialService.getInstance().setScores(player.getMocoId(),
						new OpenSocialService.ScoreUpdate((short)1, player.getXp(), false),
						new OpenSocialService.ScoreUpdate((short)2, player.getCoinsWon(), false));
			} catch (Exception ex) {
				log.log(Level.WARNING,"error submitting synchronous score for player: "+player,ex);
			}			
		}
	}
	
	/**
	 * Flush player delta map
	 * @param force if true will flush all without taking last access into account
	 */
	public void flushDeltaPlayers(boolean force) {
		for (PlayerDeltaInfo info : playerIDtoCoinXPMap.values()) {
			try {
				if (forceFlushEnabled || force || System.currentTimeMillis() - info.lastAccess > Integer.getInteger("player.delta.flush.ttl.min", 1)*60*1000) {					
					// fetch from cache to ensure latest
					Player player = GAECacheManager.getInstance().get(info.player.getId(), Player.class);
					if (player == null) player = info.player;
					GAEDataManager.getInstance().store(player);
					playerIDtoCoinXPMap.remove(player.getId());
					updatePlayerLeaderboards(player);
					log.log(Level.FINEST, "flushing player: "+player);
				}
			} catch (Exception e) {
				log.log(Level.WARNING, "Error attempting to flush player "+info.player,e);
			}
		}
		if (!force) {
			try {
				if (log != null) log.log(Level.INFO,"Adding to flush queue");
				TaskOptions task = TaskOptions.Builder.withUrl("/admin/queue.jsp?queue=flushDeltaPlayers&accessToken="+System.getProperty("queue.token"));
				task.method(Method.GET);
				task.countdownMillis(60*1000);
				QueueFactory.getQueue("playerFlush").add(task);
			} catch (Exception e) {
				if (log != null) log.log(Level.WARNING, "Error attempting to add to flush queue",e);
			}
		}
	}
	
	/**
	 * Forces all players to be flushed to the DB and any changes going forward as well
	 * @param enabled to force, false means reset to default behavior
	 */
	public void setForceFlush(boolean enabled) {
		forceFlushEnabled = enabled;
		if (log != null) log.log(Level.WARNING, "Force flush all players to value: "+enabled);
		if (enabled) flushDeltaPlayers(true);
	}
	
	/** @return if force flush enabled */
	public boolean isForceFlush() { return forceFlushEnabled; }
	
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
	
	private static class PlayerDeltaInfo {
		long lastAccess = System.currentTimeMillis();
		Player player;
	}
}
