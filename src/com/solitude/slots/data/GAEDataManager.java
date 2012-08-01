package com.solitude.slots.data;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.appengine.api.datastore.DatastoreFailureException;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.solitude.slots.cache.CacheStoreException;
import com.solitude.slots.cache.GAECacheManager;
import com.solitude.slots.entities.AbstractGAEPersistent;

/**
 * Read/write access to GAE data store
 * @author keith
 */
public class GAEDataManager implements DataManager<AbstractGAEPersistent> {

	/** singleton instance */
	private static final GAEDataManager instance = new GAEDataManager();
	/** logger */
    private static final Logger log = Logger.getLogger(instance.getClass().getName());
	/** @return singleton */
	public static DataManager<AbstractGAEPersistent> getInstance() { return instance; }
	/** private constructor to ensure singleton */
	private GAEDataManager() { }
	
	/**
	 * Convert GAE entities to serialized map entities
	 * @param keyToEntityMap from GAE data store
	 * @param keys to ensure order (if not given, then random order returned)
	 * @param persistentClass extension of AbstractGAEPersistent
	 * @return list of serialized entities
	 */
	@SuppressWarnings("unchecked")
	private static <K extends AbstractGAEPersistent> List<K> convertEntityMap(Map<Key, Entity> keyToEntityMap, Collection<Key> keys, Class<?> persistentClass) {
		List<K> result = new ArrayList<K>(keyToEntityMap.size());
		// convert entity into GAEEntity skipping nulls if allowNull is false going in the order of ids given
		if (keys == null) keys = keyToEntityMap.keySet();
		for (Key key : keys) {
			if (key == null) continue;
			Entity entity = keyToEntityMap.get(key);
			if (entity == null) result.add(null);
			else result.add((K)GAEUtil.convertEntity(entity,persistentClass));
		}
		return result;
	}
	
	@Override
	public void delete(AbstractGAEPersistent persistent) throws DataStoreException, CacheStoreException {
		if (persistent == null) throw new IllegalArgumentException("persistent is null?!");
		persistent.setDeleted();
		try {
			this.store(persistent);
		} catch (DatastoreFailureException e) {
			throw new DataStoreException(e);
		}
		GAECacheManager.getInstance().removePeristent(persistent);
	}
	
	@Override
	public <K extends AbstractGAEPersistent> K load(long id, Class<?> persistentClass) throws DataStoreException {
		final String entityName = GAEUtil.getEntityName(persistentClass);
		try {
			return GAEUtil.convertEntity(DatastoreServiceFactory.getDatastoreService().get(KeyFactory.createKey(entityName, id)),persistentClass);
		} catch (EntityNotFoundException e) {
			return null;
		} catch (DatastoreFailureException e) {
			throw new DataStoreException(e);
		}
	}
	
	@Override
	public <K extends AbstractGAEPersistent> List<K> load(List<Long> ids, Class<?> persistentClass) throws DataStoreException {
		if (ids == null || ids.isEmpty()) return new ArrayList<K>();
		final String entityName = GAEUtil.getEntityName(persistentClass);
		// convert ids to GAE standardized Key object
		List<Key> keys = new ArrayList<Key>(ids.size());
		for (long id : ids) keys.add(KeyFactory.createKey(entityName, id));
		// fetch from GAE
		try {
			Map<Key, Entity> keyToEntityMap = DatastoreServiceFactory.getDatastoreService().get(keys);
			if (log.isLoggable(Level.FINEST)) log.finest(entityName+", ids: "+ids+" retrieved from GAE: "+keyToEntityMap.size());
			return convertEntityMap(keyToEntityMap, keys, persistentClass);
		} catch (DatastoreFailureException e) {
			throw new DataStoreException(e);
		}
	}
	
	@Override
	public void store(AbstractGAEPersistent persistent) throws DataStoreException, CacheStoreException {
		if (persistent == null) throw new IllegalArgumentException("persistent is null?!");
		persistent.setUpdatetime();
		persistent.setId(GAEUtil.getEntityKey(persistent));
		GAECacheManager.getInstance().put(persistent);
		Entity storedEntity = new Entity(GAEUtil.getEntityName(persistent.getClass()), persistent.getId());
		for (Map.Entry<String, Object> entry : persistent.serialize().entrySet()) {
			if (entry.getKey().equals(AbstractGAEPersistent.ENTITY_ID_KEY)) continue;
			storedEntity.setProperty(entry.getKey(), entry.getValue());
		}
		DatastoreServiceFactory.getDatastoreService().put(storedEntity);
	}
	
	@Override
	public <K extends AbstractGAEPersistent> List<K> loadAllByCreationtime(Class<?> persistentClass, int offset, int limit) throws DataStoreException {	
		final String entityName = GAEUtil.getEntityName(persistentClass);
		List<K> result;
		// not in cache so look up
		Query q = new Query(entityName);
		q.addFilter(AbstractGAEPersistent.ENTITY_DELETED_KEY, Query.FilterOperator.EQUAL, false);
		q.addSort(AbstractGAEPersistent.ENTITY_CREATION_KEY, Query.SortDirection.DESCENDING);
		PreparedQuery pq = DatastoreServiceFactory.getDatastoreService().prepare(q);
		FetchOptions fetchOptions = FetchOptions.Builder.withOffset(offset < 0 ? 0 : offset);
		if (limit > 0) fetchOptions = fetchOptions.limit(limit);
		List<Entity> entities = pq.asList(fetchOptions);
		result = new ArrayList<K>(entities.size());
		for (Entity entity : entities) {
			result.add(GAEUtil.<K>convertEntity(entity,persistentClass));
		}
		return result;
	}
	
	@Override
	public <K extends AbstractGAEPersistent> List<K> query(Class<?> persistentClass, Set<QueryCondition> conditions, String orderBy, boolean descending, int limit) throws DataStoreException {
		final String entityName = GAEUtil.getEntityName(persistentClass);
		List<K> result;
		// not in cache so look up
		Query q = new Query(entityName);
		if (conditions != null) {
			for (QueryCondition condition : conditions) {
				Query.FilterOperator operator;
				switch (condition.getOperator()) {
					case EQUALS: operator = Query.FilterOperator.EQUAL; break;
					case NOT_EQUALS: operator = Query.FilterOperator.NOT_EQUAL; break;
					case GREATER_THAN: operator = Query.FilterOperator.GREATER_THAN; break;
					case GREATER_THAN_EQUALS: operator = Query.FilterOperator.GREATER_THAN_OR_EQUAL; break;
					case LESS_THAN: operator = Query.FilterOperator.LESS_THAN; break;
					default:
						log.log(Level.SEVERE, "Unknown condition operator: "+condition.getOperator());
						continue;
				}
				q.addFilter(condition.getField(), operator, condition.getValue());
			}
		}
		if (orderBy != null) {
			q.addSort(orderBy, descending ? Query.SortDirection.DESCENDING : Query.SortDirection.ASCENDING);
		}
		PreparedQuery pq = DatastoreServiceFactory.getDatastoreService().prepare(q);
		List<Entity> entities = pq.asList(FetchOptions.Builder.withLimit(limit));
		if (log.isLoggable(Level.FINEST)) log.log(Level.FINEST, "query: "+pq);
		result = new ArrayList<K>(entities.size());
		for (Entity entity : entities) {
			result.add(GAEUtil.<K>convertEntity(entity,persistentClass));
		}
		return result;
	}
}