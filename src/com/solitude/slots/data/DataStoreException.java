package com.solitude.slots.data;

/**
 * Indicates exception related to data store issues
 * @author keith
 */
@SuppressWarnings("serial")
public class DataStoreException extends Exception { 
	
	/** @param cause of the issue */
	public DataStoreException(Exception cause) { super(cause); }
}
