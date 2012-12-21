package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Object used for setting game status
 * @author kwright
 */
public class Activity extends Model {

	/**
	 * Fields for the object
	 * @author kwright
	 */
	public static enum Field {
		/** the json field for appId. */
		APP_ID("appId"),
		/** the json field for body. */
		BODY("body"),
		/** the json field for bodyId. */
		BODY_ID("bodyId"),
		/** the json field for externalId. */
		EXTERNAL_ID("externalId"),
		/** the json field for id. */
		ID("id"),
		/** the json field for updated. */
		LAST_UPDATED("updated"), /* Needed to support the RESTful api */
		/** the json field for mediaItems. */
		MEDIA_ITEMS("mediaItems"),
		/** the json field for postedTime. */
		POSTED_TIME("postedTime"),
		/** the json field for priority. */
		PRIORITY("priority"),
		/** the json field for streamFaviconUrl. */
		STREAM_FAVICON_URL("streamFaviconUrl"),
		/** the json field for streamSourceUrl. */
		STREAM_SOURCE_URL("streamSourceUrl"),
		/** the json field for streamTitle. */
		STREAM_TITLE("streamTitle"),
		/** the json field for streamUrl. */
		STREAM_URL("streamUrl"),
		/** the json field for templateParams. */
		TEMPLATE_PARAMS("templateParams"),
		/** the json field for title. */
		TITLE("title"),
		/** the json field for titleId. */
		TITLE_ID("titleId"),
		/** the json field for url. */
		URL("url"),
		/** the json field for userId. */
		USER_ID("userId");

		/**
		 * The json field that the instance represents.
		 */
		private final String jsonString;

		/**
		 * create a field base on the a json element.
		 *
		 * @param jsonString the name of the element
		 */
		private Field(String jsonString) {
			this.jsonString = jsonString;
		}

		/**
		 * emit the field as a json element.
		 *
		 * @return the field name
		 */
		@Override
		public String toString() {
			return jsonString;
		}
	}

	/** @param jsonObject from opensocial server */
	public Activity(JSONObject jsonObject) {
		super(jsonObject);
	}
}