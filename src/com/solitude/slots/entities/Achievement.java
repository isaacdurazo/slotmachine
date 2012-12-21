package com.solitude.slots.entities;

import com.solitude.slots.service.AchievementService;

/**
 * Meta data associated with an achievement
 * @author kwright
 */
public class Achievement {
	
	/** unique id */
	private final long id;
	/** type used to determine how granted */
	private final AchievementService.Type type;
	/** user readable title */
	private final String title;
	/** coins awarded for earning achievement */
	private final int coinsAwarded;
	/** value to exceed or equal to get achievement */
	private final int value;
	
	/**
	 * @param id unique id
	 * @param type used to determine how granted
	 * @param title user readable
	 * @param coinsAwarded for earning achievement
	 * @param value to exceed or equal to get achievement
	 */
	public Achievement(long id, AchievementService.Type type, String title, int coinsAwarded, int value) {
		this.id = id;
		this.type = type;
		this.title = title;
		this.coinsAwarded = coinsAwarded;
		this.value = value;
	}

	/** @return unique id */
	public long getId() { return id;	}

	/** @return type used to determine how granted */
	public AchievementService.Type getType() { return type;	}

	/** @return user readable title */
	public String getTitle() { return title; }

	/** @return coins awarded for earning achievement */
	public int getCoinsAwarded() { return coinsAwarded;	}
	
	/** @param value to exceed or equal to get achievement */
	public int getValue() { return value; }
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName()+" - id: "+this.id+", type: "+
				this.type+", title: "+this.title+", coins: "+this.coinsAwarded+
				", value: "+this.value;
	}

	@Override
	public int hashCode() {
		return new Long(this.id).hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof Achievement && ((Achievement)obj).id == this.id;
	}
}
