package com.solitude.slots.entities;

import java.util.Map;

/** Holds global properties that can be updated dynamically via GAE DBViewer
 * 
 * @author niels
 *
 */

public class GlobalProps extends AbstractGAEPersistent {

	/** latest version */
	private static final int CURRENT_VERSION = 1;
	/** id of winner */
	private long mocoGoldPrize = Long.getLong("game.weekly.mocogold.min.prize");
	private long daysBetweenPrize = 5;

	/** @return current value of GoldPrize */
	public long getMocoGoldPrize() { return mocoGoldPrize; }

	/** @param g prize in gold */
	public void setMocoGoldPrize(long g) { this.mocoGoldPrize = g; }

	public long getDaysBetweenPrize() {return daysBetweenPrize;}
	public void setDaysBetweenPrize(long d) {this.daysBetweenPrize=d;}
	
	
	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);

		this.mocoGoldPrize = (inputMap.get("mocoGoldPrize")==null ? 
				Long.getLong("game.weekly.mocogold.min.prize") : (Long)inputMap.get("mocoGoldPrize"));

		this.daysBetweenPrize = (inputMap.get("daysBetweenPrize")==null ? 
				5 : (Long)inputMap.get("daysBetweenPrize"));
				
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String, Object> map = super.serialize();
		map.put("mocoGoldPrize", this.mocoGoldPrize);
		map.put("daysBetweenPrize", this.daysBetweenPrize);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }

}
