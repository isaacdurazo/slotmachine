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
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName()+" - coins won: "+coins+", symbols: "+Arrays.toString(symbols);
	}
}
