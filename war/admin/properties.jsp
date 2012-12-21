<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player;
if (playerId == null || (player = PlayerManager.getInstance().getPlayer(playerId)) == null || !player.hasAdminPriv()) { 
	pageContext.forward("/");
	return;
}
String key = request.getParameter("key");
String value = request.getParameter("value");
Object result = null;
if ("set".equals(request.getParameter("action")) && key != null && value != null) {
	System.setProperty(key, value);
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>System Property Utility</title>
	</head>
	<body>
		<h1>System Property Utility</h1>
		<% if ("set".equals(request.getParameter("action"))) { %>
			Set property <%= key %>
		<% } %>
		<table border="1" style="margin:10px">
			<tr>
				<th>Property</th>
				<th>Value</th>
			</tr>
			<% for (java.util.Map.Entry<Object,Object> entry : System.getProperties().entrySet()) {
				if (((String)entry.getKey()).indexOf("game.")==-1)
					continue;
				%>
				<tr>
					<td><%= entry.getKey() %></td>
					<td><%= entry.getValue() %></td>					
				</tr>
			<% } %>
		</table>
		<h3>Modify property</h3>
		<form action="/admin/properties.jsp" method="GET">
			<input type="hidden" name="action" value="set"></input>
			<label for="key">Key</label>
			<input type="text" name="key"></input>
			<label for="value">Value</label>
			<input type="text" name="value"></input>
			<input type="submit"></input>
		</form>
	</body>
</html>