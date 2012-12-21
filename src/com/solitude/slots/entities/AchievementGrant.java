package com.solitude.slots.entities;

import java.util.Map;

/**
 * Tracks which achievements have been earned by a player
 * @author kwright
 */
public class AchievementGrant extends AbstractGAEPersistent {
	/** latest version */
	private static final int CURRENT_VERSION = 1;

	/** player id granted achievement */
	private long playerId;
	/** id of achievement granted */
	private long achievementId;
	
	/** default constructor */
	public AchievementGrant() {}
	
	/**
	 * @param playerId granted achievement
	 * @param achievementId granted
	 */
	public AchievementGrant(long playerId, long achievementId) {
		this.playerId = playerId;
		this.achievementId = achievementId;
	}
	
	/** @return id of player granted achievement */
	public long getPlayerId() { return this.playerId; }
	/** @return id of achievement granted */
	public long getAchievementId() { return this.achievementId; }

	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.playerId = (Long)inputMap.get("playerId");
		this.achievementId = (Long)inputMap.get("achievementId");
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String, Object> map =  super.serialize();
		map.put("playerId",this.playerId);
		map.put("achievementId",this.achievementId);
		return map;
	}
	
	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }

	@Override
	public boolean equals(Object obj) {
		return obj instanceof AchievementGrant && 
				((AchievementGrant)obj).playerId == this.playerId && 
				((AchievementGrant)obj).achievementId == this.achievementId;
	}

	@Override
	public int hashCode() {
		return (this.playerId+"_"+this.achievementId).hashCode();
	}
}
