package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Object used to direct debit gold
 * @author kwright
 */
public class GoldDebit extends Model {

	/**
	 * The fields that represent the person object in json form.
	 */
	public static enum Field {
		/** the json field for amount to be debitted. */
		AMOUNT("amount"),
		/** the json field for the name of the item purchased */
		NAME("name"),
		/** the app's secret for verification */
		SECRET("secret"),
		/** the "standardized" name of the item purchased - similar to name, but always in English. */
		STANDARD_NAME("standardName");
		
		/** field name matching opensocial spec */
		private String fieldName;

		/**
		 * @param fieldName matching opensocial spec
		 */
		private Field(String fieldName) {
			this.fieldName = fieldName;
		}

		@Override
		public String toString() {
			return this.fieldName;
		}
	}
	
	/** 
	 * @param jsonObject data from opensocial server
	 */
	public GoldDebit(JSONObject jsonObject) {
		super(jsonObject);
	}
}
