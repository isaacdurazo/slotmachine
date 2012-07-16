package com.solitude.slots.data;

/**
 * Condition to be applied to a query
 * @author keith
 */
public class QueryCondition {

	/** query operators */
	public static enum QUERY_OPERATOR { EQUALS, NOT_EQUALS, GREATER_THAN, GREATER_THAN_EQUALS, LESS_THAN }
	
	/** field to which the condition is applied */
	private final String field;
	/** value which is compared against the field */
	private final Object value;
	/** operator to be applied */
	private final QUERY_OPERATOR operator;
	
	/**
	 * Create query condition with equals operator 
	 * @param field to which the condition is applied
	 * @param value which is compared against the field 
	 */
	public QueryCondition(String field, Object value) {
		this(field,value,QUERY_OPERATOR.EQUALS);
	}
	
	/**
	 * @param field to which the condition is applied
	 * @param value which is compared against the field 
	 * @param operator to be applied
	 */
	public QueryCondition(String field, Object value, QUERY_OPERATOR operator) {
		this.field = field;
		this.value = value;
		this.operator = operator;
	}
	
	/** @return field to which the condition is applied */
	public String getField() { return this.field; }
	/** @return value which is compared against the field */
	public Object getValue() { return this.value; }
	/** @return operator to be applied */
	public QUERY_OPERATOR getOperator() { return this.operator; }
}
