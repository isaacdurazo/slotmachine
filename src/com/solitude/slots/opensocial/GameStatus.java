package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Opensocial representation for setting a user's game status
 * @author kwright
 */
public class GameStatus extends Model {

	/**
	 * The fields that represent the person object in json form.
	 */
	public static enum Field {
		/** custom string showing the user's status*/
		STATUS("status"),
		/** custom string of additional parameters */
		STATUS_URL("statusUrl"),
		/** custom string of the link URL text*/
		STATUS_URL_TEST("statusUrlText");

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
	public GameStatus(JSONObject jsonObject) {
		super(jsonObject);
	}
}
