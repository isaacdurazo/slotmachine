package com.solitude.slots.cache;

import java.util.Collection;
import java.util.List;

import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.Persistent;

/**
 * Backend agnostic interface for retrieving/storing items in cache
 * @author keith
 */
public interface CacheManager <T  extends Persistent> {

	/** 
	 * @param persistent to be stored using its id and class name as key
	 * @throws CacheStoreException for low-level issues
	 */
	public void put(T t) throws CacheStoreException;
	
	/**
	 * @param id of item that is null
	 * @param persistentClass of item
	 * @throws CacheStoreException for low-level issues
	 */
	public void putNull(long id, Class<?> persistentClass) throws CacheStoreException;
	
	/**
	 * @param persistents to be stored using their id and class name as key
	 * @throws CacheStoreException for low-level issues
	 */
	public void putAll(Collection<T> persistents) throws CacheStoreException;
	
	/**
	 * @param persistent to be removed from cache
	 * @throws CacheStoreException
	 */
	public void removePeristent(T t) throws CacheStoreException;
		
	/**
	 * @param id of item to retrieve
	 * @param persistentClass of the object being retrieved
	 * @return persistent or null if not in cache
	 * @throws CacheStoreException for low-level issues
	 */
	public <K extends T> K get(long id, Class<?> persistentClass) throws CacheStoreException;
	
	/**
	 * @param ids of items to retrieve
	 * @param persistentClass of the object being retrieved
	 * @param fetchFromDB if true will fetch from DB layer if id results in miss in cache
	 * @return list of items in order of ids given, nulls included
	 * @throws CacheStoreException for low-level issues
	 * @throws DataStoreException if error occurs inflating from DB
	 */
	public <K extends T> List<K> getAll(List<Long> ids, Class<?> persistentClass, boolean fetchFromDB) throws CacheStoreException, DataStoreException;
	
	/**
	 * Allows for storing ids of items for queries
	 * @param region holding cache keys
	 * @param key of items to be returned
	 * @return list of entity ids
	 * @throws CacheStoreException for low-level issues
	 */
	public List<Long> getIds(String region, String key) throws CacheStoreException;
	
	/**
	 * @param region holding cache keys
	 * @param key of item to be removed
	 * @throws CacheStoreException for low-level issues
	 */
	public void remove(String region, String key) throws CacheStoreException;
	
	/**
	 * @param region holding cache keys
	 * @param key to uniquely identify in cache
	 * @param ids matching entities
	 * @throws CacheStoreException for low-level issues
	 */
	public void putIds(String region, String key, List<Long> ids) throws CacheStoreException;
}