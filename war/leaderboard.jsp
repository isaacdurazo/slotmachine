<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.cache.*,com.solitude.slots.opensocial.*,java.util.logging.*" %>
<%
String cacheRegion = "lb.cache", cacheKey = "global";
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
if (playerId == null || (player = PlayerManager.getInstance().getPlayer(playerId)) == null) {
	response.sendRedirect(GameUtils.getVisitorHome());
	return;
}
// load global leaderboard first going to cache
RestfulCollection restfulCollection;
String json = GAECacheManager.getInstance().getCustom(cacheRegion, cacheKey);
if (json == null) {
	restfulCollection = OpenSocialService.getInstance().getLeaderboard((short)1, player.getMocoId(), 
		OpenSocialService.LEADERBOARD_DATE_RANGE.ALL, OpenSocialService.LEADERBOARD_FILTER.ALL, 0, 5);
	// cache for one day
	GAECacheManager.getInstance().putCustom(cacheRegion, cacheKey, restfulCollection.toJSONString(),Integer.parseInt(System.getProperty("game.leaderboardcached.sec")));
} else {
	restfulCollection = new RestfulCollection((org.json.simple.JSONObject)new org.json.simple.parser.JSONParser().parse(json));
}
org.json.simple.JSONArray jsonArray = restfulCollection.getEntries();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Slot Mania</title>
    <link rel="stylesheet" href="css/style.css" />    
  </head>

  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="103" height="18" src="images/logo.gif"/></div>
		    <h3>Global Leaderboard</h3>
		    <h6>(updated every 4 hrs)</h6>
		    
		    <ul class="list">
		        <% for (int i=0;i<jsonArray.size();i++) { 
		        	org.json.simple.JSONObject entry = (org.json.simple.JSONObject)jsonArray.get(i); %>
		    	<li><%= entry.get("rank") %>. <%= entry.get("userName") %> - <%= entry.get("score") %> XP</li>
		    	<% } %>
		    </ul>
			
			<div class="menu">
				<a href="<%= response.encodeURL("/") %>">Main</a>
			</div>
		</div>
	</div>
  </body>
</html>