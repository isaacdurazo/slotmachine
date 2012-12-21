package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Opensocial representation of a user's name
 * @author kwright
 */
public class Name extends Model {

	/**
	 * An enumeration of fields in the json name object.
	 */
	public static enum Field {
		/**
		 * The additional name.
		 */
		ADDITIONAL_NAME("additionalName"),
		/**
		 * The family name.
		 */
		FAMILY_NAME("familyName"),
		/**
		 * The given name.
		 */
		GIVEN_NAME("givenName"),
		/**
		 * The honorific prefix.
		 */
		HONORIFIC_PREFIX("honorificPrefix"),
		/**
		 * The honorific suffix.
		 */
		HONORIFIC_SUFFIX("honorificSuffix"),
		/**
		 * The formatted name.
		 */
		FORMATTED("formatted");

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
	public Name(JSONObject jsonObject) {
		super(jsonObject);
	}
}
