package com.solitude.slots.cache;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.datanucleus.util.StringUtils;

import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.solitude.slots.data.DataStoreException;
import com.solitude.slots.data.GAEDataManager;
import com.solitude.slots.data.GAEUtil;
import com.solitude.slots.entities.AbstractGAEPersistent;

/**
 * Instance of CacheManager for GAE
 * @author keith
 */
public class GAECacheManager implements CacheManager<AbstractGAEPersistent> {
	
	/** singleton instance */
	private static final GAECacheManager instance = new GAECacheManager();
	/** logger */
    private static final Logger log = Logger.getLogger(instance.getClass().getName());
	/** @return singleton */
	public static CacheManager<AbstractGAEPersistent> getInstance() { return instance; }
	/** private constructor to ensure singleton */
	private GAECacheManager() { }

	@Override
	public void put(AbstractGAEPersistent persistent) throws CacheStoreException {
		if (persistent == null) throw new IllegalArgumentException("persistent is null?");
		String entityName = GAEUtil.getEntityName(persistent.getClass());
		MemcacheServiceFactory.getAsyncMemcacheService(entityName).put(persistent.getId(), persistent.serialize());
	}
	
	@Override
	public void putAll(Collection<AbstractGAEPersistent> persistents) throws CacheStoreException {
		// need to group by entityName to ensure region is consistent
		Map<String,Set<AbstractGAEPersistent>> entityNameToPersistents = new HashMap<String,Set<AbstractGAEPersistent>>();
		for (AbstractGAEPersistent persistent : persistents) {
			if (persistent == null) continue;
			String entityName = GAEUtil.getEntityName(persistent.getClass());
			Set<AbstractGAEPersistent> persistentSet = entityNameToPersistents.get(entityName);
			if (persistentSet == null) {
				persistentSet = new HashSet<AbstractGAEPersistent>();
				entityNameToPersistents.put(entityName, persistentSet);
			}
			persistentSet.add(persistent);
		}
		for (Map.Entry<String,Set<AbstractGAEPersistent>> entry : entityNameToPersistents.entrySet()) {
			Map<Object,Map<String,Object>> valuesToStore = new HashMap<Object,Map<String,Object>>(entry.getValue().size());
			for (AbstractGAEPersistent persistent : entry.getValue()) {
				try {
					valuesToStore.put(persistent.getId(), persistent.serialize());
				} catch (IllegalArgumentException e) {
					log.log(Level.WARNING, "Not an instance of AbstractGAEPersistent: "+persistent);
				}
			}
			MemcacheServiceFactory.getAsyncMemcacheService(entry.getKey()).putAll(valuesToStore);		
		}
	}

	@Override
	public void removePeristent(AbstractGAEPersistent persistent) throws CacheStoreException {
		if (persistent == null) throw new IllegalArgumentException("persistent is null?");
		String entityName = GAEUtil.getEntityName(persistent.getClass());
		MemcacheServiceFactory.getAsyncMemcacheService(entityName).delete(persistent.getId());
	}

	@Override
	public <K extends AbstractGAEPersistent> K get(long id, Class<?> persistentClass) throws CacheStoreException {
		try {
			return this.<K>getAll(Arrays.asList(id), persistentClass, false).get(0);
		} catch (DataStoreException e) {
			log.log(Level.SEVERE,"This should never happen!",e);
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public <K extends AbstractGAEPersistent> List<K> getAll(List<Long> ids, Class<?> persistentClass, boolean fetchFromDB) throws CacheStoreException, DataStoreException {
		if (log.isLoggable(Level.FINEST)) log.log(Level.FINEST, "getAll "+persistentClass.getSimpleName()+": "+StringUtils.collectionToString(ids));
		if (ids == null || ids.isEmpty()) return new ArrayList<K>();
		if (persistentClass == null) throw new IllegalArgumentException("persistentClass is null?");
		final String entityName = GAEUtil.getEntityName(persistentClass);
		List<Object> keys = new ArrayList<Object>(ids.size());
		for (long id : ids) {
			keys.add(id);
		}
		Map<Object,Object> keyToCachedObj = MemcacheServiceFactory.getMemcacheService(entityName).getAll(keys);
		List<K> result = new ArrayList<K>(keyToCachedObj.size());
		for (long id : ids) {
			final String key = entityName+"_"+id;
			Object cachedObject = keyToCachedObj.get(key);
			if (cachedObject == null) {
				if (fetchFromDB) {
					if (log.isLoggable(Level.FINEST)) log.log(Level.FINEST, "fetch from DB: "+id);
					AbstractGAEPersistent persistent = GAEDataManager.getInstance().load(id, persistentClass);
					if (persistent == null) this.putNull(id, persistentClass);
					else this.put(persistent);
					result.add((K)persistent);
				} else result.add(null);
			} else if (cachedObject instanceof Map) {
				try {
					AbstractGAEPersistent persistent = (AbstractGAEPersistent) persistentClass.newInstance();
					persistent.deserialize((Map<String,Object>)cachedObject);
					result.add((K)persistent);
				} catch (SecurityException e) {
					log.log(Level.SEVERE, "Error inflating type: "+entityName,e);
					break;
				} catch (Exception e) {
					log.log(Level.WARNING, "Error inflating type: "+entityName,e);
				} 
			} else {
				// item does not exist in data store
				result.add(null);
			}
		}
		if (log.isLoggable(Level.FINEST)) log.log(Level.FINEST, "end getAll "+persistentClass.getSimpleName()+": "+StringUtils.collectionToString(result));
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Long> getIds(String region, String key) throws CacheStoreException {
		if (key == null || key.trim().length() == 0) return null;
		return (List<Long>)MemcacheServiceFactory.getMemcacheService(region).get(key);
	}

	@Override
	public void remove(String region, String key) throws CacheStoreException {
		if (StringUtils.isEmpty(key) || StringUtils.isEmpty(region)) return;
		MemcacheServiceFactory.getAsyncMemcacheService(region).delete(key);
	}

	@Override
	public void putIds(String region, String key, List<Long> ids) throws CacheStoreException {
		if (StringUtils.isEmpty(key) || StringUtils.isEmpty(region) || ids == null) 
			throw new IllegalArgumentException("ids or key are null");
		MemcacheServiceFactory.getAsyncMemcacheService(region).put(key, ids);
	}
	
	@Override
	public void putNull(long id, Class<?> persistentClass) throws CacheStoreException {
		MemcacheServiceFactory.getAsyncMemcacheService().put(GAEUtil.getEntityName(persistentClass), "null");
	}
}
