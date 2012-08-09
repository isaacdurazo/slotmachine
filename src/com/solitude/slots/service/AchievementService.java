package com.solitude.slots.service;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.QueryCondition;
import com.solitude.slots.entities.AbstractGAEPersistent;
import com.solitude.slots.entities.Achievement;
import com.solitude.slots.entities.AchievementGrant;
import com.solitude.slots.entities.Pair;
import com.solitude.slots.entities.Player;

/**
 * Grants achievements for players and lists those that are available
 * @author kwright
 */
public class AchievementService {
	
	/** cache region */
	private static final String CACHE_REGION = "achievement";
	/** singleton instance */
	private static final AchievementService instance = new AchievementService();
	/** @return singleton */
	public static AchievementService getInstance() { return instance; }
	/** private constructor to ensure singleton */
	private AchievementService() { }
	
	/**
	 * Different types of achievements
	 * @author kwright
	 */
	public static enum Type {
		/** based on # invites sent */
		INVITE(new AchievementGrantFactory() {

			@Override
			boolean grantAchievement(Achievement achievement, Player player) {
				return player.getNumInvitesSent() >= achievement.getValue();
			} 
			
		}),
		/** based on # sessions */
		SESSION(new AchievementGrantFactory() {

			@Override
			boolean grantAchievement(Achievement achievement, Player player) {
				return player.getNumSessions() >= achievement.getValue();
			} 
			
		}),
		/** based on # of max spin bets placed */
		MAX_SPINS(new AchievementGrantFactory() {

			@Override
			boolean grantAchievement(Achievement achievement, Player player) {
				return player.getMaxSpins() >= achievement.getValue();
			} 
			
		}),
		/** based on achieving a certain # of coins */
		COIN_COUNT(new AchievementGrantFactory() {

			@Override
			boolean grantAchievement(Achievement achievement, Player player) {
				return player.getCoins() >= achievement.getValue();
			} 
			
		});
		
		private final AchievementGrantFactory factory;
		
		private Type(AchievementGrantFactory factory) {
			this.factory = factory;
		}
		
		/**
		 * Will grant achievements (updated cache & DB) and increase player's coins if any of the achievements given are newly granted
		 * @param achievements to check
		 * @param player to check
		 * @return list of granted achievements in order of achievements list given (empty if none are granted)
		 * @throws CacheStoreException for cache issue
		 * @throws DataStoreException for datastore issue
		 */
		protected static List<Achievement> grantAchievements(List<Achievement> achievements, Player player) throws CacheStoreException, DataStoreException {
			List<Achievement> result = new ArrayList<Achievement>();
			Set<Long> previouslyGrantedAchievementIDs = AchievementService.getInstance().getGrantedAchievementIDs(player);
			// fetch grantIds from cache if some are granted so that cache can be updated
			List<Long> grantIds = null;
			for (Achievement achievement : achievements) {
				if (!previouslyGrantedAchievementIDs.contains(achievement.getId()) && 
						achievement.getType().factory.grantAchievement(achievement, player)) {
					// create achievement grant object
					AchievementGrant grant = new AchievementGrant(player.getId(),achievement.getId());
					GAEDataManager.getInstance().store(grant);
					result.add(achievement);
					log.log(Level.INFO, "achievement|grant|"+achievement.getType()+"|"+achievement.getId()+"|"+achievement.getCoinsAwarded());
					// award coins to player
					player.setCoins(player.getCoins()+achievement.getCoinsAwarded());
					// update grant ids cache
					grantIds = GAECacheManager.getInstance().getIds(CACHE_REGION, Long.toString(player.getId()));
					if (grantIds != null) { grantIds.add(grant.getId()); }
				}				
			}
			if (!result.isEmpty()) {
				// update player as coins were awarded
				PlayerManager.getInstance().storePlayer(player);
				// update granted achievements cache as some were granted
				if (grantIds != null) {
					GAECacheManager.getInstance().putIds(CACHE_REGION, Long.toString(player.getId()), grantIds);
				}
			}
			return result;
		}
	}
	
	/** logger */
    private static final Logger log = Logger.getLogger(Achievement.class.getName());
	/** map of achievement id to inflated object */
	private static Map<Long,Achievement> idToAchievementMap = new HashMap<Long,Achievement>();
	/** map of achievement type to list of achievements of that type */
	private static Map<Type,List<Achievement>> typeToAchievementsMap = new HashMap<Type,List<Achievement>>();
	/** list of all achievements in order by id */
	private static List<Achievement> achievements = new ArrayList<Achievement>();
	
	static {
		long index = 0;
		try {			
			Properties properties = new Properties();
			properties.load(new FileReader("WEB-INF/achievement.properties"));
			String typeStr;
			while ((typeStr = properties.getProperty("achievement.type."+index)) != null) {
				Type type = Type.valueOf(typeStr);
				String title = properties.getProperty("achievement.title."+index);
				int coinsAwarded = Integer.parseInt(properties.getProperty("achievement.coins."+index)); 
				int value = Integer.parseInt(properties.getProperty("achievement.value."+index));
				Achievement achievement = new Achievement(index,type,title,coinsAwarded,value);
				achievements.add(achievement);
				idToAchievementMap.put(achievement.getId(), achievement);
				List<Achievement> typeAchievements = typeToAchievementsMap.get(type);
				if (typeAchievements == null) {
					typeAchievements = new ArrayList<Achievement>();
					typeToAchievementsMap.put(type, typeAchievements);
				}
				typeAchievements.add(achievement);
				index++;
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Error loading achievements at id: "+index, e);
		}
	}
	
	public boolean isEnabled() { return Boolean.getBoolean("achievements.enabled"); }
	
	/**
	 * @param player seeking list of all achievements
	 * @return list of pairs of achievement to whether player has earned it in order of achievement id
	 * @throws CacheStoreException for cache issue
	 * @throws DataStoreException for datastore issue
	 */
	public List<Pair<Achievement,Boolean>> getAchievements(Player player) throws CacheStoreException, DataStoreException {
		if (!isEnabled() && !player.hasAdminPriv()) return Collections.emptyList();
		List<Pair<Achievement,Boolean>> result = new ArrayList<Pair<Achievement,Boolean>>(achievements.size());
		Set<Long> grantedAchievementIDs = this.getGrantedAchievementIDs(player);
		for (Achievement achievement : achievements) {
			result.add(new Pair<Achievement,Boolean>(achievement, grantedAchievementIDs.contains(achievement.getId())));
		}
		return result;
	}
	
	/**
	 * Grant achievements to player
	 * @param type of achievements to check
	 * @param player to user
	 * @return list of newly granted achievements (empty if none are granted)
	 */
	public List<Achievement> grantAchievements(Type type, Player player) {
		if (!isEnabled() && !player.hasAdminPriv()) return Collections.emptyList();
		try {
			return Type.grantAchievements(typeToAchievementsMap.get(type), player);
		} catch (Exception e) {
			log.log(Level.SEVERE,"Error attempting to grant achievements of type: "+type+", for player: "+player,e);
			return Collections.emptyList();
		}
	}
	
	/**
	 * @param player seeking granted achievements
	 * @return set of achievement ids on achievements granted to the player
	 * @throws CacheStoreException on cache error 
	 * @throws DataStoreException on datastore error
	 */
	public Set<Long> getGrantedAchievementIDs(Player player) throws CacheStoreException, DataStoreException {
		if (!isEnabled() && !player.hasAdminPriv()) return Collections.emptySet();
		Set<Long> result;
		List<AchievementGrant> grants;
		// look in cache for GrantAchievement ids for the player
		final String cacheKey = Long.toString(player.getId());
		List<Long> grantIds = GAECacheManager.getInstance().getIds(CACHE_REGION, cacheKey);
		if (grantIds == null) {
			// not in cache so query
			Set<QueryCondition> conditions = new HashSet<QueryCondition>(2);
			conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY, false));
			conditions.add(new QueryCondition("playerId", player.getId()));
			grants = GAEDataManager.getInstance().query(AchievementGrant.class, conditions, null, false, 1000);
			// build grant achievement ids to store in cache
			grantIds = new ArrayList<Long>(grants.size());
			for (AchievementGrant grant : grants) {
				grantIds.add(grant.getId());
			}
			GAECacheManager.getInstance().putIds(CACHE_REGION, cacheKey, grantIds);
		} else {
			// in cache so load grant achievements
			grants = GAECacheManager.getInstance().getAll(grantIds, AchievementGrant.class, true);
		}
		// build result map
		result = new HashSet<Long>(grants.size());
		for (AchievementGrant grant : grants) {
			grantIds.add(grant.getId());
			result.add(grant.getAchievementId());
		}
		return result;
	}
	
	/**
	 * Determine if achievement should be granted to a user
	 * @author kwright
	 */
	private static abstract class AchievementGrantFactory {
		
		/**
		 * @param achievement to test
		 * @param player to test
		 * @return if achievement has been earned by the player
		 */
		abstract boolean grantAchievement(Achievement achievement, Player player);
	}
}