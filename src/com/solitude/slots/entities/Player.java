package com.solitude.slots.entities;

import java.util.Locale;
import java.util.Map;

/**
 * Player of the game
 * @author kwright
 */
public class Player extends AbstractGAEPersistent {
	
	/** current version of the object */
	private static final int CURRENT_VERSION = 1;
	
	/** default constructor */
	public Player() {}
	
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
	/** user's language locale (default english) */
	private Locale locale = Locale.ENGLISH;
	/** consecutive days of play */
	private int consecutiveDays = 0;
	/** timestamp of last play time for consecutive days calculation */
	private long consecutiveDaysTimestamp = System.currentTimeMillis();
	
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
	
	/** @return user's language locale */
	public Locale getLocale() { return this.locale; }
	/** @param locale for user's language in string form */
	public void setLocale(Locale locale) { this.locale = locale; }
	
	
	@Override
	public void setUpdatetime() {
		super.setUpdatetime();
		// see if consecutive days needs to be updated
		if (System.currentTimeMillis()-consecutiveDaysTimestamp > 24*60*60*1000) {
			if (System.currentTimeMillis()-consecutiveDaysTimestamp < 48*60*60*1000) {
				// it has been more than a day but less than 48 so increment
				this.consecutiveDays++;
			} else {
				// more than 48 hours so do nothing
				this.consecutiveDays=0;
			}
			this.consecutiveDaysTimestamp = System.currentTimeMillis();
		}
	}
	
	/** @return consecutive days of game play (0 indicating user did not play yesterday, 1 meaning they did...) */
	public int getConsecutiveDays() { return consecutiveDays; }
	/** @return timestamp of consecutive days */
	public long getConsecutiveDaysTimestamp() { return consecutiveDaysTimestamp; }
	
	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.accessToken = (String)inputMap.get("accessToken");
		this.birthday = (Long)inputMap.get("birthday");
		this.coins = ((Long)inputMap.get("coins")).intValue();
		this.image = (String)inputMap.get("image");
		this.isMale = (Boolean)inputMap.get("isMale");
		this.mocoId = ((Long)inputMap.get("mocoId")).intValue();
		this.name = (String)inputMap.get("name");
		this.xp = ((Long)inputMap.get("xp")).intValue();
		this.locale = createLocaleFromString((String)inputMap.get("locale"));
		this.consecutiveDays = ((Long)inputMap.get("consecutiveDays")).intValue();
		this.consecutiveDaysTimestamp = (Long)inputMap.get("consecutiveDaysTimestamp");
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
		map.put("locale", this.locale.getLanguage());
		map.put("consecutiveDays", this.consecutiveDays);
		map.put("consecutiveDaysTimestamp", this.consecutiveDaysTimestamp);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }
	
	/**
	 * Gets the locale for a string.
	 * @param localeString locale string
	 * @return locale object
	 */
	public static Locale createLocaleFromString(String localeString) {
		if (localeString == null) return null;

		Locale locale = null;
		String[] parts = localeString.split("_");
		switch (parts.length) {
			case 1:
				// Only language
				locale = new Locale(parts[0]);
				break;
			case 2:
				// Language and country
				locale = new Locale(parts[0], parts[1]);
				break;
			case 3:
				// Language, variant (could be blank), country
				locale = new Locale(parts[0], parts[1], parts[2]);
				break;
		}
		return locale;
	}
}
