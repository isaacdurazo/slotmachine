package com.solitude.slots.entities;

/**
 * Utility class for returning pairs of data
 * @author kwright
 *
 * @param <K> element 1
 * @param <V> element 2
 */
public class Pair<K,V> {
	/** element 1 */
	private final K k;
	/** element 2 */
	private final V v;

	/** 
	 * @param k element 1
	 * @param v element 2 
	 */
	public Pair(K k, V v) {
		this.k = k;
		this.v = v;
	}
	
	/** @return element 1 */
	public K getElement1() { return this.k; }
	/** @return element 2 */
	public V getElement2() { return this.v; }
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName()+" - element 1: "+k+", element 2: "+v;
	}
}
