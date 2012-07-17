package com.solitude.slots.service;

/**
 * Create and manage slot machine behavior
 * @author kwright
 */
public class SlotMachineManager {
	
	/** singleton instance */
	private static final SlotMachineManager instance = new SlotMachineManager();
	/** @return singleton */
	public static SlotMachineManager getInstance() { return instance; }
	/** private constructor to ensure singleton */
	private SlotMachineManager() { }
}
