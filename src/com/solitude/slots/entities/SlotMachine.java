package com.solitude.slots.entities;

import java.util.Map;

/**
 * Meta-data associated with a slot machine
 * @author kwright
 */
public class SlotMachine extends AbstractGAEPersistent {
	
	/** current version of the object */
	private static final int CURRENT_VERSION = 1;
	/** name of the machine */
	private String name;
	/** image associated with the machine */
	private String image;
	/** id of payout table object */
	private long payOutTableId = 0L;
	/** xp required to unlock machine */
	private int xpRequired = 0;
	
	/** default constructor */
	public SlotMachine() { }
	
	/** @return name of the machine */
	public String getName() { return name; }
	/** @param name of the machine */
	public void setName(String name) { this.name = name; }

	/** @return image associated with the machine */
	public String getImage() { return image; }
	/** @param image associated with the machine */
	public void setImage(String image) { this.image = image; }

	/** @param payOutTableId id of payout table object */
	public long getPayOutTableId() { return payOutTableId; }
	/** @return id of payout table object (0 if none set) */
	public void setPayOutTableId(long payOutTableId) { this.payOutTableId = payOutTableId; }

	/** @return xp required to unlock machine */
	public int getXpRequired() { return xpRequired; }
	/** @param xpRequired to unlock machine */
	public void setXpRequired(int xpRequired) { this.xpRequired = xpRequired; }

	@Override
	public void deserialize(Map<String, Object> inputMap) {
		super.deserialize(inputMap);
		this.name = (String)inputMap.get("name");
		this.image = (String)inputMap.get("image");
		this.payOutTableId = (Long)inputMap.get("payOutTableId");
		this.xpRequired = ((Long)inputMap.get("xpRequired")).intValue();
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String, Object> map = super.serialize();
		map.put("name", this.name);
		map.put("image", this.image);
		map.put("payOutTableId", this.payOutTableId);
		map.put("xpRequired", this.xpRequired);
		return map;
	}

	@Override
	public int getCurrentVersion() { return CURRENT_VERSION; }
}