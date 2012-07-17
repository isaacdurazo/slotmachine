package com.solitude.slots.data;

import java.util.List;
import java.util.Set;

import com.solitude.slots.cache.CacheStoreException;

/**
 * Interface for backend agnostic data store access
 * @author keith
 */
public interface DataManager<T  extends Persistent> {

	/**
	 * @param persistent object to be stored
	 * @throws DataStoreException for access issues
	 * @throws CacheStoreException for cache issues
	 */
	public void store(T t) throws DataStoreException, CacheStoreException;
	
	/**
	 * @param persistent object to be marked as deleted
	 * @throws DataStoreException for access issues
	 * @throws CacheStoreException for cache issues
	 */
	public void delete(T t) throws DataStoreException, CacheStoreException;
	
	/**
	 * @param id of persistent to load
	 * @param persistentClass of object to be loaded
	 * @return persistent if it exists, null otherwise
	 * @throws DataStoreException for access issues
	 */
	public <K extends T> K load(long id, Class<?> persistentClass) throws DataStoreException;
	
	/**
	 * @param ids of persistents to load
	 * @param persistentClass of objects to be loaded
	 * @return list of persistents matching ids given in order given
	 * @throws DataStoreException for access issues
	 */
	public <K extends T> List<K> load(List<Long> ids, Class<?> persistentClass) throws DataStoreException;
	
	/**
	 * @param persistentClass of objects to be loaded
	 * @param offset from first result to return
	 * @param limit of objects per page (0 or lower will return ALL)
	 * @return all non-deleted objects of given type in descending order by creationtime
	 * @throws DataStoreException for access issues
	 */
	public <K extends T> List<K> loadAllByCreationtime(Class<?> persistentClass, int offset, int limit) throws DataStoreException;
	
	/**
	 * Execute query
	 * @param persistentClass of objects being queried
	 * @param conditions to be applied
	 * @param order by field
	 * @param if ascending or descending
	 * @return list of matching items
	 * @throws DataStoreException for back end issues
	 */
	public <K extends T> List<K> query(Class<?> persistentClass, Set<QueryCondition> conditions, String orderBy, boolean descending) throws DataStoreException;
}