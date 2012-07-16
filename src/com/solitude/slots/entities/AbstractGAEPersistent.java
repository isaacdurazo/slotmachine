package com.solitude.slots.entities;

import java.util.HashMap;
import java.util.Map;

/**
 * Allows for storing object as GAE entity using serialized map as content
 * @author keith
 */
public abstract class AbstractGAEPersistent implements MapSerializable {
	
	/** unique GAE id, creation time, & update time */
	private long id, creationtime = System.currentTimeMillis(), updatetime = creationtime;
	/** version for serialize/deserialize backwards compatibility */
	private int version;
	/** if entity has been deleted */
	private boolean deleted = false;
	/** serialized map reserved key values */
	public final static String SERIAL_VERSION_KEY = "version", ENTITY_ID_KEY = "id",
			ENTITY_CREATION_KEY = "creationtime", ENTITY_UPDATE_KEY = "updatetime",
			ENTITY_DELETED_KEY = "deleted";

	@Override
	public void deserialize(Map<String, Object> inputMap) {
		if (inputMap == null) throw new IllegalArgumentException("Null map?");
		Object keyObj = inputMap.get(ENTITY_ID_KEY);
		this.id = keyObj == null ? 0 : (Long)keyObj;
		Object versionObj = inputMap.get(SERIAL_VERSION_KEY);
		if (versionObj == null) this.version = this.getCurrentVersion();
		else if (versionObj instanceof Integer) this.version = (Integer)versionObj;
		else this.version = ((Long)versionObj).intValue();
		Object creationObj = inputMap.get(ENTITY_CREATION_KEY);
		if (creationObj != null) this.creationtime = (Long)creationObj;
		Object updateObj = inputMap.get(ENTITY_UPDATE_KEY);
		if (updateObj != null) this.updatetime = (Long)updateObj;
		this.deleted = (Boolean)inputMap.get(ENTITY_DELETED_KEY);
	}

	@Override
	public Map<String, Object> serialize() {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put(ENTITY_ID_KEY, this.getId());
		map.put(SERIAL_VERSION_KEY, this.getCurrentVersion());
		map.put(ENTITY_CREATION_KEY, this.creationtime);
		map.put(ENTITY_UPDATE_KEY, this.updatetime);
		map.put(ENTITY_DELETED_KEY, this.deleted);
		return map;
	}

	@Override
	public int getVersion() { return version; }
	@Override
	public long getCreationtime() {	return this.creationtime; }
	@Override
	public boolean isDeleted() { return this.deleted; }
	@Override
	public long getUpdatetime() { return this.updatetime; }
	@Override
	public long getId() { return this.id; }
	
	/** @param set id of persistent */
	public void setId(long id) { this.id = id; }
	@Override
	public void setDeleted() { this.deleted = true; }
	@Override
	public void setUpdatetime() { this.updatetime = System.currentTimeMillis(); }
	
	@Override
	public boolean equals(Object obj) { 
		return obj instanceof AbstractGAEPersistent && 
				((AbstractGAEPersistent)obj).getClass().getSimpleName().equals(this.getClass().getSimpleName()) &&
				((AbstractGAEPersistent)obj).getId() == this.getId(); 
	}
	
	@Override
	public int hashCode() { return (this.getClass().getSimpleName()+"_"+this.getId()).hashCode(); }
	
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder(this.getClass().getSimpleName());
		sb.append(" - ");
		for (Map.Entry<String, Object> entry : this.serialize().entrySet()) {
			sb.append(entry.getKey()).append(": ").append(entry.getValue()).append(", ");
		}
		return sb.toString();	
	}
}
