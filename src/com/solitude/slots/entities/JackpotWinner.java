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
	private long gold;
	
	
	
	/** @return id of player */
	public long getPlayerId() { return playerId; }
	/** @param playerId of winner */
	public void setPlayerId(long playerId) { this.playerId = playerId; }

	public long getGold(){return gold;}
	public void setGold(long gold){ this.gold=gold;}
	
	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		try {
		this.playerId = (Long)inputMap.get("playerId");
		this.gold = (Long)inputMap.get("gold");
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String, Object> map = super.serialize();
		map.put("playerId", this.playerId);
		map.put("gold", this.gold);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }

	
}
