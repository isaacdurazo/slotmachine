package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Opensocial representation of a user
 * @author kwright
 */
public class Person extends Model {

	/**
	 * The fields that represent the person object in json form.
	 */
	public static enum Field {	   
		/** the json field for areacode. */
		AREACODE("areaCode"),
		/** the json field for birthday. */
		BIRTHDAY("birthday"),
		/** the json field for display name. */
		DISPLAY_NAME("displayName"), /** Needed to support the RESTful api. */	   
		/** the json field for gender. */
		GENDER("gender"),	   
		/** the json field for hasApp. */
		HAS_APP("hasApp"),	   
		/** the json field for id. */
		ID("id"),	    
		/** the json field for updated. */
		LAST_UPDATED("updated"), /** Needed to support the RESTful api. */	    
		/** the json field for person's locale */
		LOCALE("locale"),	   
		/** the json field for name. */
		NAME("name"),
		/** Accountdomain where the user signed up */
		SIGNUP_DOMAIN("signup_domain"),
		/** the json field for networkPresence. */
		NETWORKPRESENCE("networkPresence"),	    
		/** the json field for profileUrl. */
		PROFILE_URL("profileUrl"),	   
		/** the json field for thumbnailUrl. */
		THUMBNAIL_URL("thumbnailUrl"),	  
		/** If the user has Facebook connect enabled */
		HAS_FACEBOOK("hasFacebook"),
		/** The user's MocoGold balance */
		GOLD_BALANCE("goldBalance");

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
	public Person(JSONObject jsonObject) {
		super(jsonObject);
	}
}
