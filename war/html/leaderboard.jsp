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
		OpenSocialService.LEADERBOARD_DATE_RANGE.WEEK, OpenSocialService.LEADERBOARD_FILTER.ALL, 0, 10);
	// cache for one day
	GAECacheManager.getInstance().putCustom(cacheRegion, cacheKey, restfulCollection.toJSONString(),Integer.parseInt(System.getProperty("game.leaderboardcached.sec")));
} else {
	restfulCollection = new RestfulCollection((org.json.simple.JSONObject)new org.json.simple.parser.JSONParser().parse(json));
}
org.json.simple.JSONArray jsonArray = restfulCollection.getEntries();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
		    
		    <div class="content">
			    <div class="title-wrapper">
		    		<div class="title-container">
						<span class="title">
				   			Weekly <%= type == (short)1 ? "Xp" : "Coins Won" %> Leaderboard
			    			<span>(updated every 4 hrs)</span>
						</span>
					</div>
				</div>
				<div class="list-container">
			    
				    <ul class="list">
				        <% for (int i=0;i<jsonArray.size();i++) { 
				        	org.json.simple.JSONObject entry = (org.json.simple.JSONObject)jsonArray.get(i); %>
				    	<li><%= entry.get("rank") %>. <%= entry.get("userName") %> - <%= entry.get("score") %> <%= type == (short)1 ? "XP" : "Coins" %></li>
				    	<% } %>
				    </ul>
				
				</div>
				
				<table class="menu">
					<tr>
						<td>
							<a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/html/leaderboard.jsp?type="+(type == (short)1 ? 2 : 1), response) %>"><%= type == (short)1 ? "Coins Won" : "XP" %> Leaderboard</a>
						</td>
						<td>
							<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/html/invite.jsp", response) %>">Invite Friends</a>
						</td>
					</tr>
				</table>
				
				<div id="footer" class="menu" style="margin-right: 16px;">
					<a href="<%= ServletUtils.buildUrl(player, "/html/index.jsp", response) %>">Main</a>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>