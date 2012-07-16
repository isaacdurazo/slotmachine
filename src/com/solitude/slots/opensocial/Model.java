package com.solitude.slots.opensocial;

import org.json.simple.JSONObject;

/**
 * Opensocial API objects interface
 * @author kwright
 */
public abstract class Model {
		
	/** jsonObject holding content of the model object */
	protected final JSONObject jsonObject;
	
	/**
	 * @param jsonObject holding content of the model object
	 */
	public Model(JSONObject jsonObject) {
		this.jsonObject = jsonObject;
	}

	/**
	 * @param fieldName of field to return
	 * @return value for that field or null if not present
	 */
	public Object getFieldValue(String fieldName) {
		return this.jsonObject.get(fieldName);
	}
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName()+" - "+(this.jsonObject == null ? "null": this.jsonObject.toJSONString());
	}
}
