package com.solitude.slots.entities;

import java.util.Map;

/**
 * Meta-data associated with a slot machine
 * @author kwright
 */
public class SlotMachine extends AbstractGAEPersistent {
	
	/** current version of the object */
	private static final int CURRENT_VERSION = 1;
	
	private String name;
	
	private String image;
	
	private int payOutTableId;
	
	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
	}

	@Override
	public Map<String, Object> serialize() {
		return super.serialize();
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }
}