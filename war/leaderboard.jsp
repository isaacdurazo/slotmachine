<%@ include file="/header.jsp" %>
<%@ page import="com.solitude.slots.opensocial.*,com.solitude.slots.cache.*" %>

<%
short type = (short)ServletUtils.getInt(request, "type", 1);
String cacheRegion = "lb.cache", cacheKey = "global_"+type+"_"+player.getId();

// load global leaderboard first going to cache
RestfulCollection restfulCollection;
String json = GAECacheManager.getInstance().getCustom(cacheRegion, cacheKey);
if (json == null) {
	restfulCollection = OpenSocialService.getInstance().getLeaderboard(type, player.getMocoId(), 
		OpenSocialService.LEADERBOARD_DATE_RANGE.ALL, OpenSocialService.LEADERBOARD_FILTER.ALL, 0, 10);
	// cache for one day
	GAECacheManager.getInstance().putCustom(cacheRegion, cacheKey, restfulCollection.toJSONString(),Integer.parseInt(System.getProperty("game.leaderboardcached.sec")));
} else {
	restfulCollection = new RestfulCollection((org.json.simple.JSONObject)new org.json.simple.parser.JSONParser().parse(json));
}
org.json.simple.JSONArray jsonArray = restfulCollection.getEntries();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>

		    <h3>Weekly <%= type == (short)1 ? "Xp" : "Coins Won" %> Leaderboard</h3>
		    <h6>(updated every 4 hrs)</h6>
		    
		    <ul class="list">
		        <% for (int i=0;i<jsonArray.size();i++) { 
		        	org.json.simple.JSONObject entry = (org.json.simple.JSONObject)jsonArray.get(i); %>
		    	<li><%= entry.get("rank") %>. <%= entry.get("userName") %> - <%= entry.get("score") %> <%= type == (short)1 ? "XP" : "Coins" %></li>
		    	<% } %>
		    </ul>
			
			<div class="menu">
				<div>1. <a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/leaderboard.jsp?type="+(type == (short)1 ? 2 : 1), response) %>"><%= type == (short)1 ? "Coins Won" : "XP" %> Leaderboard</a></div>
				<div>2. <a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/invite.jsp", response) %>">Invite Friends</a></div>
				<div>3. <a accessKey="3" href="<%= ServletUtils.buildUrl(player, "/index.jsp", response) %>">Main</a></div>
			</div>
		</div>
	</div>
  </body>
</html>