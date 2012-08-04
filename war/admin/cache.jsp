<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player;
if (playerId == null || (player = PlayerManager.getInstance().getPlayer(playerId)) == null || !player.hasAdminPriv()) { 
	pageContext.forward("/");
	return;
}

java.util.Set<String> entityRegions = new java.util.HashSet<String>();
entityRegions.add(com.solitude.slots.data.GAEUtil.getEntityName(Player.class));
entityRegions.add(com.solitude.slots.data.GAEUtil.getEntityName(JackpotWinner.class));

java.util.List<String> regions = new java.util.ArrayList<String>();
regions.addAll(entityRegions);
regions.add("player.region");
regions.add("slot.region");

String region = request.getParameter("region");
String key = request.getParameter("key");
Object result = null;
if ("clear".equals(request.getParameter("action"))) {
	com.google.appengine.api.memcache.MemcacheServiceFactory.getMemcacheService(region).delete(key);
} else if (region != null && key != null) {
	if (entityRegions.contains(region)) {
//		result = com.google.appengine.api.memcache.MemcacheServiceFactory.getMemcacheService(region).get(Long.parseLong(key));
		result = com.google.appengine.api.memcache.MemcacheServiceFactory.getMemcacheService(region).get(key);
	} else {
		result = com.google.appengine.api.memcache.MemcacheServiceFactory.getMemcacheService(region).get(key);
	}
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Cache Utility</title>
	</head>
	<body>
		<h1>Cache Utility</h1>
		<% if ("clear".equals(request.getParameter("action"))) { %>
			Cleared!
		<% } else if (region != null && key != null) { %>
			<table border="1" style="margin:10px">
				<tr>
					<th>Region</th>
					<th>Key</th>
					<th>Value</th>
					<th></th>
				</tr>
				<tr>
					<td><%= region %></td>
					<td><%= key %></td>
					<td><%= result %></td>
					<td><a href="/admin/cache.jsp?action=clear&region=<%= region %>&key=<%= key %>">Clear</a></td>
				</tr>
			</table>
		<% } %>
		<form action="/admin/cache.jsp" method="GET">
			<label for="region">Region</label>
			<select name="region" id="region">
				<% for (String currRegion : regions) { %>
					<option value="<%= currRegion %>"><%= currRegion %></option>
				<% } %>
			</select>
			<label for="key">Key</label>
			<input type="text" name="key"></input>
			<input type="submit"></input>
		</form>
	</body>
</html>