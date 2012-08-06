<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player;
if (playerId == null || (player = PlayerManager.getInstance().getPlayer(playerId)) == null || !player.hasAdminPriv()) { 
	pageContext.forward("/");
	return;
}

String key = request.getParameter("key");
Object result = null;
if ("clear".equals(request.getParameter("action"))) {
	com.google.appengine.api.memcache.MemcacheServiceFactory.getMemcacheService().delete(key);
} else if (key != null) {
	result = com.google.appengine.api.memcache.MemcacheServiceFactory.getMemcacheService().get(key);
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
		<% } else if (key != null) { %>
			<table border="1" style="margin:10px">
				<tr>
					<th>Key</th>
					<th>Value</th>
					<th></th>
				</tr>
				<tr>
					<td><%= key %></td>
					<td><%= result %></td>
					<td><a href="/admin/cache.jsp?action=clear&key=<%= key %>">Clear</a></td>
				</tr>
			</table>
		<% } %>
		<form action="/admin/cache.jsp" method="GET">
			<label for="key">Key</label>
			<input type="text" name="key"></input>
			<input type="submit"></input>
		</form>		
	</body>
</html>