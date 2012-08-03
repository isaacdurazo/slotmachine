<%@ include file="header.jsp" %>
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

  <body>
  	<div id="container">
	  	<div class="wrapper">
		    
			<div class="header-logo"><img width="192" height="60" src="images/logo.png"/></div>
		    
		    <div class="content">
		    	
		    	<table class="stats">
					<tr>
						<td>
							Weekly <%= type == (short)1 ? "Xp" : "Coins Won" %> Leaderboard
			    			<div>(updated every 4 hrs)</div>
						</td>
					</tr>
				</table>
			    
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
							<a accessKey="1" href="<%= response.encodeURL("/wk/leaderboard.jsp?type="+(type == (short)1 ? 2 : 1)) %>"><%= type == (short)1 ? "Coins Won" : "XP" %> Leaderboard</a>
						</td>
						<td>
							<a accessKey="2" href="<%= response.encodeURL("/wk/invite.jsp") %>">Invite Friends</a>
						</td>
					</tr>
				</table>
				
				<table class="menu">
					<tr>
						<td>
							<a accessKey="3" href="<%= response.encodeURL("/wk/index.jsp") %>">Main</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
  </body>
</html>