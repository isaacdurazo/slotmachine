package com.solitude.slots.entities;

import java.util.Map;

/**
 * Player of the game
 * @author kwright
 */
public class Player extends AbstractGAEPersistent {
	
	/** current version of the object */
	private static final int CURRENT_VERSION = 1;
	
	/** moco access token */
	private String accessToken;
	/** moco user name */
	private String name;
	/** moco profile photo */
	private String image;
	/** coins available */
	private int coins = 0;
	/** xp accumulated */
	private int xp = 0;
	/** id of moco profile */
	private int mocoId;
	/** if user is male or female*/
	private boolean isMale = false;
	/** birthday as a timestamp */
	private long birthday = 0L;
	
	/** @return moco access token */
	public String getAccessToken() { return accessToken; }
	/** @param accessToken of moco player */
	public void setAccessToken(String accessToken) { this.accessToken = accessToken;}

	/** @return moco user name */
	public String getName() { return name; }
	/** @param name of moco user */
	public void setName(String name) { this.name = name; }

	/** @return full path to moco profile photo */
	public String getImage() { return image; }
	/** @param image path for moco profile photo */
	public void setImage(String image) { this.image = image; }

	/** @return coins available */
	public int getCoins() { return coins; }
	/** @param coins available */
	public void setCoins(int coins) { this.coins = coins; }

	/** @return xp accumulated */
	public int getXp() { return xp; }
	/** @param xp accumulated */
	public void setXp(int xp) {	this.xp = xp; }

	/** @return id of moco profile */
	public int getMocoId() { return mocoId;	}
	/** @param mocoId of moco profile */
	public void setMocoId(int mocoId) { this.mocoId = mocoId; }

	/** @return if player is male */
	public boolean isMale() { return isMale; }
	/** @param isMale if player is male */
	public void setMale(boolean isMale) { this.isMale = isMale; }

	/** @return birthday of the user as a long timestamp */
	public long getBirthday() {	return birthday; }
	/** param birthday of the user as a long timestamp */
	public void setBirthday(long birthday) { this.birthday = birthday; }

	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.accessToken = (String)inputMap.get("accessToken");
		this.birthday = (Long)inputMap.get("birthday");
		this.coins = (Integer)inputMap.get("coins");
		this.image = (String)inputMap.get("image");
		this.isMale = (Boolean)inputMap.get("isMale");
		this.mocoId = (Integer)inputMap.get("mocoId");
		this.name = (String)inputMap.get("name");
		this.xp = (Integer)inputMap.get("xp");
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String, Object> map = super.serialize();
		map.put("accessToken", this.accessToken);
		map.put("birthday", this.birthday);
		map.put("coins", this.coins);
		map.put("image", this.image);
		map.put("isMale", this.isMale);
		map.put("mocoId", this.mocoId);
		map.put("name", this.name);
		map.put("xp", this.xp);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }
}
