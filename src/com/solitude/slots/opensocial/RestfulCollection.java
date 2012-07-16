package com.solitude.slots.opensocial;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Opensocial representation of a page of data
 * @author kwright
 */
public class RestfulCollection extends Model {

	/**
	 * The fields that represent the person object in json form.
	 */
	public static enum Field {	   
		/** offset from first result */
		START_INDEX("startIndex"),
		/** total number of results across all pages*/
		TOTAL_RESULT("totalResults"),
		/** data set for current page */
		ENTRY("entry");
		
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
	 * Create empty collection
	 */
	@SuppressWarnings("unchecked")
	public RestfulCollection() {
		super(new JSONObject());
		this.jsonObject.put(Field.START_INDEX.fieldName, 0);
		this.jsonObject.put(Field.TOTAL_RESULT.fieldName, 0);
		this.jsonObject.put(Field.ENTRY.fieldName, new JSONArray());
	}
	
	/** 
	 * @param jsonObject data from opensocial server
	 */
	public RestfulCollection(JSONObject jsonObject) {
		super(jsonObject);
	}
	
	/** @return total number of items across all pages */
	public int getTotalResults() { 		
		Object fieldValue = this.getFieldValue(Field.TOTAL_RESULT.fieldName);
		return fieldValue == null ? 0 : (Integer)fieldValue;
	}
	
	/** @return json array of entries for the page */
	public JSONArray getEntries() { return (JSONArray)this.getFieldValue(Field.ENTRY.fieldName); }
}
