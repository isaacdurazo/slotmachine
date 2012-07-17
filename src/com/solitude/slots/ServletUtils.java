package com.solitude.slots;

import javax.servlet.http.HttpServletRequest;

/**
 * Holds servlet utility methods
 * @author kwright
 */
public class ServletUtils {
	
	/** private constructor to ensure static only methods */
	private ServletUtils() {}
	
	/**
	 * @param request object
	 * @param paramName of parameter to extract
	 * @return parameter value as integer or -1 if missing or not valid integer
	 */
	public static int getInt(HttpServletRequest request, String paramName) {
		return getInt(request,paramName,-1);
	}

	/**
	 * @param request object
	 * @param paramName of parameter to extract
	 * @param defaultVal returned if parameter is missing or not a valid integer
	 * @return parameter value as integer or defaultVal
	 */
	public static int getInt(HttpServletRequest request, String paramName, int defaultVal) {
		try {
			return Integer.parseInt(request.getParameter(paramName));
		} catch (NumberFormatException e) {
			return defaultVal;
		}
	}
	
	/**
	 * @param request object
	 * @param paramName of parameter to extract
	 * @return parameter value as long or -1 if missing or not valid long
	 */
	public static long getLong(HttpServletRequest request, String paramName) {
		return getLong(request,paramName,-1L);
	}
	
	/**
	 * @param request object
	 * @param paramName of parameter to extract
	 * @param defaultVal returned if parameter is missing or not a valid long
	 * @return parameter value as long or defaultVal
	 */
	public static long getLong(HttpServletRequest request, String paramName, long defaultVal) {
		try {
			return Long.parseLong(request.getParameter(paramName));
		} catch (NumberFormatException e) {
			return defaultVal;
		}
	}
}
