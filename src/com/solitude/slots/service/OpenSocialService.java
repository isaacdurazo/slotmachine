package com.solitude.slots.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.solitude.slots.opensocial.Person;
import com.solitude.slots.opensocial.RestfulCollection;

/**
 * Makes requests to the MocoSpace opensocial API
 * @author kwright
 */
public class OpenSocialService {
	/** logging level */
	private static final Level LOG_LEVEL = Level.INFO;
	
	/** moco opensocial api url */
	private static final String API_END_POINT = "https://apps.mocospace.com/social";
	
	/** singleton instance */
	private static final OpenSocialService instance = new OpenSocialService();
	/** @return singleton */
	public static OpenSocialService getInstance() { return instance; }	
	/** logger */
    private static final Logger log = Logger.getLogger(instance.getClass().getName());
	/** private constructor to ensure singleton */
	private OpenSocialService() { }
	
	/**
	 * Fetch access token's owner information
	 * @param accessToken from moco
	 * @param additionalFields to include in person response
	 * @return person for requesting user
	 * @throws ApiException on API error
	 * @throws IOException on connection error
	 * @throws ParseException for invalid JSON
	 */
	public Person fetchSelf(String accessToken, String... additionalFields) throws ApiException, IOException, ParseException {
		return this.fetchPerson(accessToken, -1, additionalFields);
	}
	
	/**
	 * Fetch a user's info
	 * @param accessToken from moco
	 * @param userId of user to return (-1 indicates self)
	 * @param additionalFields to include in person response
	 * @return person for requesting user
	 * @throws ApiException on API error
	 * @throws IOException on connection error
	 * @throws ParseException for invalid JSON
	 */
	public Person fetchPerson(String accessToken, int userId, String... additionalFields) throws ApiException, IOException, ParseException {
		RestfulCollection persons = this.fetchPeople(accessToken, new int[]{userId}, additionalFields);
		JSONObject entry = (JSONObject)persons.getFieldValue(RestfulCollection.Field.ENTRY.toString());
		return entry == null ? null : new Person(entry);
	}
	
	/**
	 * Fetch a users' info
	 * @param accessToken from moco
	 * @param userId of user(s) to return 
	 * @param additionalFields to include in person response
	 * @return person for requesting user
	 * @throws ApiException on API error
	 * @throws IOException on connection error
	 * @throws ParseException for invalid JSON
	 */
	public RestfulCollection fetchPeople(String accessToken, int[] userIds, String... additionalFields) throws ApiException, IOException, ParseException {
		if (userIds == null || userIds.length == 0) return new RestfulCollection();
		String url = API_END_POINT+"/people/";
		if (userIds.length == 0 || userIds[0] <= 0) {
			url += "@me";
		} else {
			for (int i=0;i<userIds.length;i++) {
				if (i != 0) url += ",";
				url += userIds[i];
			}
		}
		url += "/@self";
		Map<String,String> params = new HashMap<String,String>();
		params.put("oauth_token", accessToken);
		if (additionalFields != null && additionalFields.length > 0) {
			String fields = null;
			for (String field : additionalFields) {
				if (fields == null) fields = field;
				else fields += ","+field;
			}
			params.put("fields",fields);
		}
		String response = doHttpRequest(
				url,
				"GET",
				params,
				2000,	// connect timeout
				2000);
		if (log.isLoggable(LOG_LEVEL)) log.log(LOG_LEVEL,"url: "+url+", response: "+response);
		JSONObject responseObject = (JSONObject)new JSONParser().parse(response); 	// read timeout
		return new RestfulCollection(responseObject);
	}
	
	/**
	 * Fetch a user's friends
	 * 
	 * @param accessToken of requester
	 * @param index from first result to start returning
	 * @param resultsPerPage items to be returned
	 * @param additionalFields of person to inflate
	 * @return restful collection of person objects
	 * @throws ApiException on API error
	 * @throws IOException on connection error
	 * @throws ParseException for invalid JSON
	 */
	public RestfulCollection fetchFriends(String accessToken, int index, int resultsPerPage, String... additionalFields) throws ApiException, IOException, ParseException {
		String url = API_END_POINT+"/people/@me/@friends";
		Map<String,String> params = new HashMap<String,String>();
		params.put("oauth_token", accessToken);
		params.put("count",Integer.toString(resultsPerPage));
		params.put("startIndex",Integer.toString(index));
		if (additionalFields != null && additionalFields.length > 0) {
			String fields = null;
			for (String field : additionalFields) {
				if (fields == null) fields = field;
				else fields += ","+field;
			}
			params.put("fields",fields);
		}
		String response = doHttpRequest(
				url,
				"GET",
				params,
				2000,	// connect timeout
				2000);
		if (log.isLoggable(LOG_LEVEL)) log.log(LOG_LEVEL,"url: "+url+", response: "+response);
		JSONObject responseObject = (JSONObject)new JSONParser().parse(response); 	// read timeout
		return new RestfulCollection(responseObject);
	}
	
	/**
	 * Retrieves player's moco oauth token.  Must use game admin oauth token
	 * 
	 * @param userId of user
	 * @param oauthToken of game admin
	 * @return user's oauth token
	 * @throws ApiException on API error
	 * @throws IOException on connection error
	 * @throws ParseException for invalid JSON
	 */
	public String fetchOAuthToken(int userId, String accessToken) throws ApiException, IOException, ParseException {
		String url = API_END_POINT+"/featureOAuth/"+userId;
		Map<String,String> params = new HashMap<String,String>();
		params.put("oauth_token", accessToken);
		String response = doHttpRequest(
				url,
				"GET",
				params,
				2000,	// connect timeout
				2000);
		if (log.isLoggable(LOG_LEVEL)) log.log(LOG_LEVEL,"url: "+url+", response: "+response);
		JSONObject responseObject = (JSONObject)new JSONParser().parse(response); 	// read timeout
		return (String)responseObject.get("entry");
	}
	
	/**
	 * Sends an HTTP request to a URL. The URL may contain a port number and parameters
	 * @param url URL that may contain a port number and parameters
	 * @param method HTTP method (currently supported: GET, POST, DELETE)
	 * @param params parameters to be appended to the URL or header for POST
	 * @param connectTimeout timeout for estabilishing a TCP connection
	 * @param readTimeout timeout for reading input
	 * @return response content
	 * @throws IOException exception that may be thrown during connection
	 * @throws ApiException on API error
	 */
	private static String doHttpRequest(String url, String method, Map<?,?> params, int connectTimeout, int readTimeout) throws IOException, ApiException {		
		BufferedReader in = null;
		Writer out = null;
		try {			
			if(!"post".equalsIgnoreCase(method) && params != null && !params.isEmpty()) {				
				StringBuilder s = new StringBuilder(url);				
				if(url.contains("?")) s.append('&');
				else s.append('?');
				
				boolean amp = false;
				for(Map.Entry<?, ?> entry : params.entrySet()){
					
					if(amp) s.append('&');
					s.append(entry.getKey().toString());
					s.append('=');
					s.append(entry.getValue().toString());
					
					if(!amp) amp = true;
				}
				
				url = s.toString();
				
			}			
			URL urlObj = new URL(url);
			HttpURLConnection c = (HttpURLConnection) urlObj.openConnection();
			if (connectTimeout > -1)
				c.setConnectTimeout(connectTimeout);
			if (readTimeout > -1)
				c.setReadTimeout(readTimeout);
			
			if ("post".equalsIgnoreCase(method) && params != null && !params.isEmpty()) {
				c.setDoOutput(true);
				c.setUseCaches(false);
			}			
			if (method != null) {
				c.setRequestMethod(method);
			}

			if ("post".equalsIgnoreCase(method) && params != null && !params.isEmpty()) {
				out = new BufferedWriter(new OutputStreamWriter(c.getOutputStream()));
				
				boolean amp = false;
				for(Map.Entry<?,?> entry : params.entrySet()){
					
					if(amp) out.write('&');
					
					
					if(entry.getValue() != null){
					
						out.write(entry.getKey().toString());
						out.write('=');
						out.write(entry.getValue().toString());
						
						if(!amp) amp = true;
					
					}
				}				
				out.flush();
				out.close();
			}

			StringBuilder response = new StringBuilder();			
			try {
				// Read the response
				in = new BufferedReader(new InputStreamReader(c.getInputStream()));

				String line;
				while ((line = in.readLine()) != null) {
					response.append(line);
					response.append('\n');
				}
			} catch(IOException e) {
				// we got an error, let's try to extract the actual server response
				String errResponse = "";
				try {
					in = new BufferedReader(new InputStreamReader(c.getErrorStream()));
					String line;
					while ((line = in.readLine()) != null) {
						errResponse += line;
					}
				} catch(Throwable t) {
					// we can't do anything in this case, throw original exception
					throw e;
				}
				// duplicate current exception and add the server response
				IOException e2 = new IOException(e.getMessage() + " server_response:" + errResponse);
				e2.setStackTrace(e.getStackTrace());
				throw e2;
			}

			if (c.getResponseCode() != HttpServletResponse.SC_OK) {
				throw new ApiException(c.getResponseCode(),response.toString());
			}
			return response.toString();
		} finally {
			try { out.close(); }
			catch (Exception e) {} // ignore
			try { in.close(); }
			catch (Exception e) {} // ignore
		}
	}
	
	/**
	 * Occurs when request to opensocial server returns non-500 response
	 * @author kwright
	 */
	@SuppressWarnings("serial")
	static class ApiException extends Exception {
		/** response status code */
		private int statusCode;
		
		/**
		 * @param statusCode from response
		 * @param errorMessage from response
		 */
		public ApiException(int statusCode, String errorMessage) {
			super(errorMessage);
			this.statusCode = statusCode;
		}
		
		/** @return response status code from server */
		public int getStatusCode() { return this.statusCode; }
	}
} 
