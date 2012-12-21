package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Representation of a notification message to a player
 * @author kwright
 */
public class Message extends Model {

	/**
	 * An enumeration of field names in a message.
	 */
	public static enum Field {
		/** app url for the message */
		APP_URL("appUrl"),
		/** the field name for body. */
		BODY("body"),
		/** the field name for body id. */
		BODY_ID("bodyId"),
		/** the field name for the collection IDs */
		COLLECTION_IDS("collectionIds"),
		/** the field name for data */
		DATA("data"),
		/** the field name for the unique ID of this message. */
		ID("id"),
		/** the field name for the Parent Message Id for this message. */
		IN_REPLY_TO("inReplyTo"),
		/** the field name for replies to this message */
		REPLIES("replies"),
		/** the field name for recipient list. */
		RECIPIENTS("recipients"),
		/** the field name for the ID of the person who sent this message. */
		SENDER_ID("senderId"),
		/** the field name for the time this message was sent. */
		TIME_SENT("timeSent"),
		/** the field name for title. */
		TITLE("title"),
		/** the field name for title id. */
		TITLE_ID("titleId"),
		/** the field name for type. */
		TYPE("type"),
		/** the field name for status. */
		STATUS("status"),
		/** the field name for updated time stamp. */
		UPDATED("updated"),
		/** the field name for urls. */
		URLS("urls");

		/**
		 * the name of the field.
		 */
		private final String jsonString;

		/**
		 * Create a field based on a name.
		 * @param jsonString the name of the field
		 */
		private Field(String jsonString) {
			this.jsonString = jsonString;
		}

		/**
		 * @return a string representation of the enum.
		 */
		@Override
		public String toString() {
			return this.jsonString;
		}
	}

	/**
	 * The type of a message.
	 */
	public enum Type {
		/** An email. */
		EMAIL("email"),
		/** A short private message. */
		INVITE("invite"),
		/** A short private message. */
		NOTIFICATION("notification"),
		/** A message to a specific user that can be seen only by that user. */
		PRIVATE_MESSAGE("privateMessage"),
		/** A message to a specific user that can be seen by more than that user. */
		PUBLIC_MESSAGE("publicMessage"),
		/** Message sent to a native mobile app */
		NATIVE_MESSAGE("native_message");

		/**
		 * The type of message.
		 */
		private final String jsonString;

		/**
		 * Create a message type based on a string token.
		 * @param jsonString the type of message
		 */
		private Type(String jsonString) {
			this.jsonString = jsonString;
		}

		/**
		 * @return a string representation of the enum.
		 */
		@Override
		public String toString() {
			return this.jsonString;
		}
	}

	/**
	 * The Status of a message.
	 */
	public enum Status {
		/** newly created status */
		NEW("new"),
		/** deleted status */
		DELETED("deleted"),
		/** status flagged as read */
		FLAGGED("read");
		/**
		 * The type of message.
		 */
		private final String jsonString;

		/**
		 * Create a message type based on a string token.
		 * @param jsonString the type of message
		 */
		private Status(String jsonString) {
			this.jsonString = jsonString;
		}

		/**
		 * @return a string representation of the enum.
		 */
		@Override
		public String toString() {
			return this.jsonString;
		}
	}

	/** @param jsonObject data from opensocial api */
	public Message(JSONObject jsonObject) {
		super(jsonObject);
	}
}
