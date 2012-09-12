package com.solitude.slots.service;

import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.QueryCondition;
import com.solitude.slots.entities.AbstractGAEPersistent;
import com.solitude.slots.entities.JackpotWinner;
import com.solitude.slots.entities.Player;
import com.solitude.slots.entities.SpinResult;

/**
 * Create and manage slot machine behavior
 * @author kwright
 */
public class SlotMachineManager {
	
	/** singleton instance */
	private static final SlotMachineManager instance = new SlotMachineManager();
	/** @return singleton */
	public static SlotMachineManager getInstance() { return instance; }	
	/** logger */
    private static final Logger log = Logger.getLogger(instance.getClass().getName());
    /** cache region */
    private static final String CACHE_REGION = "slot.region";
    
	/** array of spin results */
	private static final SpinResult[] spinResults = new SpinResult[10000];
	static {
		/** Load table set into map for very quick look up.  Properties file should be in the following format 
		 * where min/max are from 0 to 9999 with no overlap:
		 * table.result.coins.0=
		 * table.result.symbols.0=<comma separated ints indexed from 0, i.e. 0,0,0>
		 * table.result.range.min.0=0
		 * table.result.range.max.0=100
		 * */
		try {			
			Properties properties = new Properties();
			properties.load(new FileReader("WEB-INF/pay-out-table.properties"));
			String coinsStr = null;
			int index = 0;
			while ((coinsStr = properties.getProperty("table.result.coins."+index)) != null) {
				try {
					int coins = Integer.parseInt(coinsStr);
					String[] symbolsStrArray = ((String)properties.get("table.result.symbols."+index)).split(",");
					int[] symbols = new int[symbolsStrArray.length];
					for (int i=0;i<symbolsStrArray.length;i++) {
						symbols[i] = Integer.parseInt(symbolsStrArray[i]);
					}
					int minRange = Integer.parseInt(properties.getProperty("table.result.range.min."+index));
					int maxRange = Integer.parseInt(properties.getProperty("table.result.range.max."+index));
					SpinResult sprinResult = new SpinResult(coins,symbols);
					for (int i=minRange;i<=maxRange;i++) {
						if (spinResults[i] != null) {
							log.log(Level.WARNING,"range "+i+" already filled?!");
							continue;
						}
						spinResults[i] = sprinResult;
						
					}
					log.log(Level.INFO,"Loaded table "+index+" min="+minRange+", max="+maxRange+" symbols="+(String)properties.get("table.result.symbols."+index));
				} catch (Exception e) {
					log.log(Level.WARNING,"Unable to load pay out table index: "+index,e);
				}
				index++;
			}
		} catch (IOException e) {
			log.log(Level.SEVERE,"Unable to load pay out table!");
		}
	}
	
	/** random generator (nextInt is thread-safe) */
	private static final Random random = new Random();
	
	/** private constructor to ensure singleton */
	private SlotMachineManager() { }
	
	/**
	 * 
	 * @param player
	 * @param maxBet
	 * @return
	 * @throws InsufficientFundsException
	 * @throws CacheStoreException 
	 * @throws DataStoreException 
	 */
	public SpinResult spin(final Player player, boolean maxBet) throws InsufficientFundsException, DataStoreException, CacheStoreException {
		int coins = maxBet ? (2+player.getPlayingLevel()) : 1;
		if (player.getCoins() < coins) throw new InsufficientFundsException();
		if (coins == Integer.getInteger("game.max.bet.coins", 3)) {
			player.incrementMaxSpins();
		}
		// spin!
		SpinResult spinResult = null;
		int attempts = 0;
		int idx=0;
		boolean fJackpot=false;

		int maxRnd = spinResults.length;
		boolean fCustomProbability = false;
		
		do {
			fCustomProbability = false;
			
			// players with more coins get a reduced probability of winning so to reduce coin inflation
			if (player.getCoins()>200 && Boolean.getBoolean("game.progressive.win.probability.enabled")) {
				maxRnd = spinResults.length+ 4000;
				fCustomProbability = true;
			} else if (player.getCoins()>100 && Boolean.getBoolean("game.progressive.win.probability.enabled")) {
				maxRnd = spinResults.length+ 2000;
				fCustomProbability = true;
			}
			
			idx=random.nextInt(maxRnd);
			if (idx>= spinResults.length) {
				//for spin result >=10000 map to payout table for idx between 0 and 4998 (=no payout)
				idx -= spinResults.length;
			}
				
			spinResult = spinResults[idx];

			// check if jackpot and if so that one hasn't been reached already this week
			if (!Boolean.getBoolean("jackpot.disabled") && spinResult != null && Arrays.equals(spinResult.getSymbols(), new int[]{0,0,0})) {
				// get recent jackpot winners
				List<JackpotWinner> winners = this.getRecentJackpotWinners();
				if (player.getXp()>200  &&  (winners == null || winners.isEmpty() || 
						System.currentTimeMillis() - winners.get(0).getCreationtime() > TimeUnit.MILLISECONDS.convert(5, TimeUnit.DAYS)) ) {
					// create winner entry only if XP>200 and >5days since last JP - otherwise respin					
					JackpotWinner newWinner = new JackpotWinner();
					newWinner.setPlayerId(player.getId());
					newWinner.setGold(GameUtils.getGlobalProps().getMocoGoldPrize());
					GAEDataManager.getInstance().store(newWinner);
					fJackpot=true;
					
					// update cache
					final String cacheKey = "jackpot_winners";
					List<Long> winnerIds = GAECacheManager.getInstance().getIds(CACHE_REGION, cacheKey);
					winnerIds.add(0, newWinner.getId());
					GAECacheManager.getInstance().putIds(CACHE_REGION, cacheKey, winnerIds);
					// we have a legit jackpot!!! send notifications to user and admin account
					String subject = "SlotMania Jackpot!", body = "Congratulations - you won the Moco Gold jackpot in Slot Mania! You will be credited "+GameUtils.getGlobalProps().getMocoGoldPrize() +" Gold within next 24hrs. You will receive a inbox message once Gold has been credited.";
					try {
						OpenSocialService.getInstance().sendNotification(player.getMocoId(), subject, body);
						body += " winner: player id: "+player.getId()+", moco id: "+player.getMocoId()+ 
								",  gold: "+(Integer.getInteger("level.jackpot.multiplier."+player.getPlayingLevel())*GameUtils.getGlobalProps().getMocoGoldPrize()) +", xp: "+player.getXp();
						OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()), subject, body);
						OpenSocialService.getInstance().sendNotification(12534729, subject, body); 
					} catch (Exception e) {
						log.log(Level.SEVERE,"Error sending jackpot notification, winner id: "+player.getId(),e);
					}
				} else {
					spinResult = null;
					if (Boolean.getBoolean("jackpot.miss.notification.enabled")) {
						try {
							OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
									"Jackpot miss", 
									"Jackpot candidate within 7days since last jackpot or XP<200 = miss. player id: "+player.getId()+", moco id: "+player.getMocoId()+ ", xp: "+player.getXp());
						} catch (Exception e) {
							log.log(Level.SEVERE,"Error sending jackpot miss notification, player id: "+player.getId(),e);
						}					
					}
				}
			}
		} while (spinResult==null && attempts++<10);

		// debit and credit player coins. Jackpot users only win gold; apply maxspin multiplies
//		int c = spinResult.getCoins();
//		if (fJackpot==true) {c=0;}
		
		if (maxBet && spinResult.getCoins() > 0 ) {
			int multiplier = Integer.getInteger("level.max.bet.multiplier."+player.getPlayingLevel());		
			spinResult = new SpinResult(spinResult.getCoins()*multiplier,spinResult.getSymbols());
		}
		if (!fJackpot) {
			player.setCoins(player.getCoins()-coins+spinResult.getCoins());
			player.setCoinsWon(player.getCoinsWon()+spinResult.getCoins());
		}
		
		// increment xp with spins and update leaderboard (do this with batching later?)
		if (PlayerManager.getInstance().incrementXp(player)) {
			log.log(Level.INFO,"player|level_up|"+player.getLevel());
			spinResult.setLevelUp();
		}
		PlayerManager.getInstance().storePlayer(player, true);
		
		log.log(Level.INFO,"spin|rnd="+idx+", cust="+fCustomProbability+", bet="+coins+", "+spinResult+", coins="+player.getCoins()+" |uid|"+player.getMocoId());
		return spinResult;
	}
	
	/** @return max bet for playing level */
	public int getMaxBet(Player player) {
		return Integer.getInteger("level.max.bet."+player.getPlayingLevel());
	}

	/**
	 * @return list of recent winners descending by when jackpot occurred
	 * @throws CacheStoreException for cache error
	 * @throws DataStoreException for data store error
	 */
	public List<JackpotWinner> getRecentJackpotWinners() throws CacheStoreException, DataStoreException {
		final String cacheKey = "jackpot_winners";
		List<Long> winnerIds = GAECacheManager.getInstance().getIds(CACHE_REGION, cacheKey);
		if (winnerIds == null) {
			// query for winners
			Set<QueryCondition> conditions = new HashSet<QueryCondition>();
			conditions.add(new QueryCondition(AbstractGAEPersistent.ENTITY_DELETED_KEY, false));
			List<JackpotWinner> winners = GAEDataManager.getInstance().query(JackpotWinner.class, conditions, AbstractGAEPersistent.ENTITY_CREATION_KEY, true, 20);
			winnerIds = new ArrayList<Long>(winners.size());
			for (JackpotWinner winner : winners) { winnerIds.add(winner.getId()); }
			GAECacheManager.getInstance().putIds(CACHE_REGION, cacheKey, winnerIds);
			return winners;
		}
		return GAECacheManager.getInstance().getAll(winnerIds, JackpotWinner.class, true);
	}
	
	/**
	 * Occurs when user does not have sufficient funds for spin
	 * @author kwright
	 */
	@SuppressWarnings("serial")
	public static class InsufficientFundsException extends Exception {}
}
