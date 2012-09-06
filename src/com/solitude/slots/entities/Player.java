package com.solitude.slots.entities;

import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.TimeUnit;

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
	/** coins won */
	private long coinsWon = 0L;
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
	/** number of game sessions */
	private long numSessions = 0;
	/** number of invites sent */
	private int invitesSent;
	/** number of max spin bets placed */
	private int maxSpins;
	/** amount of gold spent on the game by this player */
	private int goldDebitted;
	/** player's level */
	private int level = 1;
	/** level at which the player is currently playing */
	private int playingLevel = 1;

	/** NOTE this is only stored in memory and set/deleted by PlayerManager **/
	private boolean isNewPlayer = false;
	
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
	
	/** @return coins won since player created (does not include daily grant coins) */
	public long getCoinsWon() { return coinsWon; }
	/** @param coinsWon since player created (does not include daily grant coins)*/
	public void setCoinsWon(long coinsWon) { this.coinsWon = coinsWon; }

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
	
	/** @return number of game sessions for player */
	public long getSessions() {return this.numSessions;}	
	/** @param numSessions number of game sessions for player */
	public void setSessions(long numSessions) {this.numSessions=numSessions;};
	
	/** @return number of invites sent by the player */
	public int getNumInvitesSent() { return this.invitesSent; }
	/** @param count of invites to increment total number by */
	public void incrementNumInvitesSent(int count) { this.invitesSent += count; }
	
	/** @return number of max spins placed by the player */
	public int getMaxSpins() { return this.maxSpins; }
	/** increment number of max spins by 1 */
	public void incrementMaxSpins() { this.maxSpins++; }

	public boolean hasAdminPriv() {
		String[] mocoIds = ((String)System.getProperty("game.adminpriv.ids")).split(",");
		if (Arrays.asList(mocoIds).contains(Integer.toString(this.mocoId)))
			return (true);
		else 
			return(false);
	}

	/**
	 * @return if player should get consecutive days award (or new player)
	 */
	public boolean awardConsecutiveDays() {
		// see if consecutive days needs to be updated (if last timestamp was for the previous day)
		boolean setToMidnight = false;
		if (consecutiveDaysTimestamp == 0L) {
			// never called before so set to today at midnight
			setToMidnight = true;
		} else if (System.currentTimeMillis()-consecutiveDaysTimestamp > 24*60*60*1000) {
			if (System.currentTimeMillis()-consecutiveDaysTimestamp < 48*60*60*1000) {
				// it has been more than a day but less than 48 so increment
				this.consecutiveDays++;
			} else {
				// more than 48 hours so do nothing
				this.consecutiveDays=0;
			}
			// to ensure midnight is roll-over set next timestamp accordingly
			setToMidnight = true;
		}
		if (setToMidnight) {
			Calendar cal = new GregorianCalendar();
			cal.set(Calendar.HOUR_OF_DAY, 0);
			cal.set(Calendar.MINUTE, 0);
			cal.set(Calendar.SECOND, 1);
			cal.setTimeZone(java.util.TimeZone.getTimeZone("EST"));
			this.consecutiveDaysTimestamp = cal.getTimeInMillis();
		}
		return setToMidnight;
	}
	
	/** @return consecutive days of game play (0 indicating user did not play yesterday, 1 meaning they did...) */
	public int getConsecutiveDays() { return consecutiveDays; }
	/** @return timestamp of consecutive days */
	public long getConsecutiveDaysTimestamp() { return consecutiveDaysTimestamp; }
	
	/** @return if new player */
	public boolean getIsNewPlayer() {return isNewPlayer;}
	
	/** @param flag if true user is a new player */
	public void setIsNewPlayer(boolean flag) { this.isNewPlayer=flag;}
	
	/** @return number of game sessions */
	public long getNumSessions() { return this.numSessions; }
	/** @param numSessions number of game sessions */
	public void setNumSessions(long numSessions) { this.numSessions = numSessions; }
		
	@Override
	public void setUpdatetime() {
		// update numSessions  
		if (System.currentTimeMillis() - this.getUpdatetime() > TimeUnit.MICROSECONDS.convert(13, TimeUnit.MINUTES)) {
			this.numSessions += 1;
		}
		super.setUpdatetime();
	}
	
	/** @return amount of gold spent on the game by this player */
	public int getGoldDebitted() { return this.goldDebitted; }
	/** @param goldDebitted amount of gold spent on the game by this player */
	public void setGoldDebitted(int goldDebitted) { this.goldDebitted = goldDebitted; }
	/** @return level of the user */
	public int getLevel() { return this.level; }
	/** @param level to set for the user */
	public void setLevel(int level) { this.level = level; }
	/** @return level which the user is currently playing */
	public int getPlayingLevel() { return this.playingLevel; }
	/** @param playingLevel to set when a user changes playing levels */
	public void setPlayingLevel(int playingLevel) { this.playingLevel = playingLevel; }
	
	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.accessToken = (String)inputMap.get("accessToken");
		this.birthday = (Long)inputMap.get("birthday");
		this.coins = deserializeInt("coins", inputMap, 20);
		this.image = (String)inputMap.get("image");
		this.isMale = (Boolean)inputMap.get("isMale");
		this.mocoId = deserializeInt("mocoId", inputMap, -1);
		this.name = (String)inputMap.get("name");
		this.xp = deserializeInt("xp", inputMap, 0);
		this.locale = createLocaleFromString((String)inputMap.get("locale"));
		this.consecutiveDays = deserializeInt("consecutiveDays", inputMap, 0);
		this.consecutiveDaysTimestamp = (Long)inputMap.get("consecutiveDaysTimestamp");
		this.coinsWon = deserializeInt("coinsWon",inputMap, 0);
		this.numSessions = deserializeInt("numSessions", inputMap, 0);
		this.invitesSent = deserializeInt("invitesSent", inputMap, 0);
		this.maxSpins = deserializeInt("maxSpins", inputMap, 0);
		this.goldDebitted = deserializeInt("goldDebitted", inputMap, 0);
		this.level = deserializeInt("level", inputMap, 1);
		this.playingLevel = deserializeInt("playingLevel", inputMap, 1);
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
		map.put("coinsWon", this.coinsWon);
		map.put("numSessions", this.numSessions);
		map.put("invitesSent", this.invitesSent);
		map.put("maxSpins", this.maxSpins);
		map.put("goldDebitted", this.goldDebitted);
		map.put("level", this.level);
		map.put("playingLevel", this.playingLevel);
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
