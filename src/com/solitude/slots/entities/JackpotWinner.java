package com.solitude.slots.entities;

import java.util.Map;

/**
 * Instance of player winning the jackpot
 * @author kwright
 */
public class JackpotWinner extends AbstractGAEPersistent {
	/** latest version */
	private static final int CURRENT_VERSION = 1;
	/** id of winner */
	private long playerId;
	/** @return id of player */
	public long getPlayerId() { return playerId; }
	/** @param playerId of winner */
	public void setPlayerId(long playerId) { this.playerId = playerId; }

	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.playerId = (Long)inputMap.get("playerId");
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String, Object> map = super.serialize();
		map.put("playerId", this.playerId);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }

	
}
