package com.solitude.slots.entities;

import java.util.Map;

import com.solitude.slots.data.Persistent;

/**
 * Serialize objects in/out of map of string key to string values to allow backward/forward 
 * compatibility.
 * NOTE: requires public, empty constructor
 * @author keith
 */
public interface MapSerializable extends Persistent {
	
	/** @return version of object retrieved */
	int getVersion();
	
	/** @return current version of object */
	int getCurrentVersion();

	/** @param inputMap from which object is inflated */
	void deserialize(Map<String,Object> inputMap);
	
	/** @return string key to string value mapping representing object */
	Map<String,Object> serialize();
}
