package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Represents a player's score on a leaderboard
 * @author kwright
 */
public class Score extends Model {
	
	/**
	 * The fields that represent the gold debit object in json form.
	 */
	public static enum Field {
		/** user's id */
		USER_ID("userId"),
		/** user's name */
		USER_NAME("userName"),
		/** user's image */
		USER_IMAGE("userImage"),
		/** user's network presence */
		USER_NETWORKPRESENCE("userNetworkPresence"),
		/** score value */
		SCORE("score"),
		/** rank in the leaderboard*/
		RANK("rank"),
		/** name of the score */
		LABEL("label"),
		/** units of the score value */
		UNITS("units"),
		/** icon image associated with score */
		ICON("icon"),
		/** last time the score was updated as a long*/
		UPDATE_TIME("updateTime");
		
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

	/** @param jsonObject data from opensocial API */
	public Score(JSONObject jsonObject) {
		super(jsonObject);
	}
}
