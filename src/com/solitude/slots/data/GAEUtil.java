package com.solitude.slots.data;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.appengine.api.datastore.DatastoreFailureException;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.solitude.slots.entities.AbstractGAEPersistent;

/**
 * Utility methods related to GAE
 * @author keith
 */
public class GAEUtil {

	/** logger */
    private static final Logger log = Logger.getLogger(GAEUtil.class.getName());
    
    /** private constructor to ensure static methods only */
    private GAEUtil() {}
	
	/**
	 * Validates and returns entity name mapping for class given
	 * @param persistentClass which is assignable to AbstractGAEPersistent
	 * @return string
	 */
	public static String getEntityName(Class<?> persistentClass) {
		if (persistentClass == null) throw new IllegalArgumentException("persistentClass is null?");
		if (!AbstractGAEPersistent.class.isAssignableFrom(persistentClass)) {
			throw new IllegalArgumentException("Class does not extend AbstractGAEPersistent: "+persistentClass.getSimpleName());
		}
		return persistentClass.getSimpleName();
	}
	
	/** @return key to be used for entity type given */
	public static long getEntityKey(AbstractGAEPersistent persistent) throws DataStoreException {
		try {
			return persistent.getId() > 0 ? persistent.getId() : 
				DatastoreServiceFactory.getDatastoreService().allocateIds(
						getEntityName(persistent.getClass()), 1).getStart().getId();
		} catch (DatastoreFailureException e) {
			throw new DataStoreException(e);
		}
	}
	
	
	/**
	 * @param entity from GAE data store
	 * @param clazz extension of AbstractGAEPersistent
	 * @return serialized map based entity object
	 */
	@SuppressWarnings("unchecked")
	public static <T extends AbstractGAEPersistent> T convertEntity(Entity entity, Class<?> clazz) {
		try {
			T t = (T) clazz.newInstance();
			Map<String,Object> serializedMap = new HashMap<String,Object>(entity.getProperties().size());
			for (Map.Entry<String,Object> entry : entity.getProperties().entrySet()) {
				serializedMap.put(entry.getKey(), entry.getValue());
			}
			t.deserialize(serializedMap);
			t.setId(entity.getKey().getId());
			return t;
		} catch (SecurityException e) {
			log.log(Level.SEVERE, "Error inflating type: "+entity.getKind(),e);
		} catch (Exception e) {
			log.log(Level.WARNING, "Error inflating type: "+entity.getKind(),e);
		} 
		return null;
	}
}
