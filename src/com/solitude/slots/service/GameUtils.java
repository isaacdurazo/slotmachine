package com.solitude.slots.service;

/**
 * Holds utility methods or game level data
 * @author kwright
 */
public class GameUtils {

	/** @return game admin oauth token */
	public static String getGameAdminToken() { return System.getProperty("game.admin.token"); }
	
	/** @return game gold secret */
	public static String getGameGoldSecret() { return System.getProperty("game.gold.secret"); }
	
	/** @return id of game on mocospace */
	public static int getGameMocoId() { return Integer.parseInt(System.getProperty("game.moco.id")); }
}
