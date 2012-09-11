package com.solitude.slots.entities;

import java.util.Arrays;
 
/**
 * Meta data associated with the results of a spin
 * @author kwright
 */
public class SpinResult {
	/** coins awarded */
	private final int coins;
	/** symbols shown */
	private final int[] symbols;
	/** if spin resulted level up */
	private boolean levelUp = false;
	
	/**
	 * @param coins awarded
	 * @param symbols shown
	 */
	public SpinResult(int coins, int[] symbols) {
		this.coins = coins;
		this.symbols = symbols;
	}

	/** @return coins awarded */
	public int getCoins() { return coins; }
	/** @return int array of symbols to appear */
	public int[] getSymbols() { return symbols;	}
	/** set level up to true */
	public void setLevelUp() { this.levelUp = true; }
	/** @return if level up occurred */
	public boolean getLevelUp() { return this.levelUp; }
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName()+" - won: "+coins+", symbols: "+Arrays.toString(symbols);
	}
}
