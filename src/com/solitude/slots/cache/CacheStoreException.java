package com.solitude.slots.cache;

/**
 * Represent general error accessing cache layer
 * @author keith
 */
@SuppressWarnings("serial")
public class CacheStoreException extends Exception {

	/** @param e cause of issue */
	public CacheStoreException(Exception e) {
		super(e);
	}
}
