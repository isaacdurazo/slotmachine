package com.solitude.slots.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.QueryCondition;
import com.solitude.slots.entities.AbstractGAEPersistent;
import com.solitude.slots.entities.GlobalProps;
import com.solitude.slots.entities.JackpotWinner;
import com.solitude.slots.entities.Player;

/**
 * Holds utility methods or game level data
 * 
 * @author kwright
 */
public class GameUtils {
	private static final String CACHE_REGION = "slot.region";

	/** logger */
	private static final Logger log = Logger.getLogger(GameUtils.class
			.getName());

	/** @return game admin oauth token */
	public static String getGameAdminToken() {
		return System.getProperty("game.admin.token");
	}

	/** @return game admin's moco user id */
	public static String getGameAdminMocoId() {
		return System.getProperty("game.admin.user.id");
	}

	/** @return game gold secret */
	public static String getGameGoldSecret() {
		return System.getProperty("game.gold.secret");
	}

	/** @return id of game on mocospace */
	public static int getGameMocoId() {
		return Integer.parseInt(System.getProperty("game.moco.id"));
	}

	/** @return full path to mocospace home (use to redirect on error) */
	public static String getMocoSpaceHome() {
		return System.getProperty("mocospace.main.url");
	}

	/** @return full path to mocospace home (use to redirect on error) */
	public static String getVisitorHome() {
		return System.getProperty("game.visitor.url");
	}

	/** @return start path to mocospace opensocial API */
	public static String getMocoSpaceOpensocialAPIEndPoint() {
		return System.getProperty("mocospace.opensocial.api.endpoint");
	}

	public static GlobalProps getGlobalProps() {
		GlobalProps theOne; 
		try {
			theOne =  new GlobalProps();
			return (theOne);
/*
			List<Long> ids = GAECacheManager.getInstance().getIds("global.props", "singleton");
			if (ids!=null && !ids.isEmpty()) {
//				List<GlobalProps> all = GAECacheManager.getInstance().getAll(ids, GlobalProps.class, true);
//				theOne = (GlobalProps) (all.toArray())[0];
				theOne = GAECacheManager.getInstance().get(ids.get(0), GlobalProps.class);
			} else {
				// not in cache so try to get from DB

				Set<QueryCondition> conditions = new HashSet<QueryCondition>();
				conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY, false));
				List<GlobalProps> objs = GAEDataManager.getInstance().query(GlobalProps.class, conditions, AbstractGAEPersistent.ENTITY_CREATION_KEY, true, 1);

				if (!objs.isEmpty()) {
					theOne = objs.get(0);
				} else {
					// not in DB - create it.
					theOne = new GlobalProps();

					//and store in cache and DB
					List<Long> id = new ArrayList<Long>(1);
					id.add(theOne.getId());
					GAEDataManager.getInstance().store(theOne);
					GAECacheManager.getInstance().putIds("global.props","singleton", id);
				}		
			}
			*/
		} catch (Exception e) {
			// CacheStoreException, DataStoreException
			log.log(Level.SEVERE,
					"Error attempting initialize or get GlobalProps ", e);
			theOne =  new GlobalProps();// safeguard - always return a valid obj w default values
		}
		return (theOne);
	}

			
	/*			
	theOne = GAECacheManager.getInstance().get(1,GlobalProps.class);
	
	if (theOne == null) {
		Set<QueryCondition> conditions = new HashSet<QueryCondition>();
		conditions.add(new QueryCondition(
				AbstractGAEPersistent.ENTITY_DELETED_KEY, false));
		List<GlobalProps> objs = GAEDataManager.getInstance().query(
				GlobalProps.class, conditions,
				AbstractGAEPersistent.ENTITY_CREATION_KEY, true, 1);

		if (objs.size() == 0 || objs.get(0).isDeleted()) {
			// no valid obj in DB so create w defaults and save in cache
			theOne = new GlobalProps();
			GAEDataManager.getInstance().store(theOne);
			GAECacheManager.getInstance().put(theOne);
		} else {
			theOne = objs.get(0);
		}
	}
*/
			
			
			

}
