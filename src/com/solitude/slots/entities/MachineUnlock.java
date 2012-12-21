package com.solitude.slots.entities;

import java.util.Map;

/**
 * Represents a player's premium unlock of a slot machine prior to level-up
 * 
 * @author kwright
 */
public class MachineUnlock extends AbstractGAEPersistent {
	/** latest object version */
	private static final int CURRENT_VERSION = 1;
	
	/** id of player who has unlocked */
	private long playerId;
	/** level corresponding to unlocked machine */
	private int machineLevelUnlock;

	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.machineLevelUnlock = deserializeInt("machineLevelUnlock", inputMap, 0);
		this.playerId = (Long)inputMap.get("playerId");
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String,Object> map = super.serialize();
		map.put("machineLevelUnlock", this.machineLevelUnlock);
		map.put("playerId", this.playerId);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }

}
