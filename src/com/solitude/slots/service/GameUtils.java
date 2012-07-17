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
	
	/** @return full path to mocospace home (use to redirect on error) */
	public static String getMocoSpaceHome() { return System.getProperty("mocospace.main.url"); }
	
	/** @return start path to mocospace opensocial API */
	public static String getMocoSpaceOpensocialAPIEndPoint() { return System.getProperty("mocospace.opensocial.api.endpoint"); }
}
