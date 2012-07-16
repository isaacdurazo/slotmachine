package com.solitude.slots.data;

/**
 * Interface of objects to be persisted in a data store
 * @author keith
 */
public interface Persistent {

	/** @return unique id */
	public long getId();
	
	/** @return if deleted */
	public boolean isDeleted();
	
	/** mark as deleted */
	public void setDeleted();
	
	/** @return version of item returned */
	public int getVersion();
	
	/** @return latest version */
	public int getCurrentVersion();
	
	/** @return time item was persisted */
	public long getCreationtime();
	
	/** @return last time item was modified */
	public long getUpdatetime();
	
	/** set update time to now */
	public void setUpdatetime();
}
