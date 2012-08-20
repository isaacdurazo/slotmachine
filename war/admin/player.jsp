<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player;
if (playerId == null || (player = PlayerManager.getInstance().getPlayer(playerId)) == null || !player.hasAdminPriv()) { 
	pageContext.forward("/");
	return;
}

int mocoId = ServletUtils.getInt(request, "mocoId");
int coins = ServletUtils.getInt(request, "coins");
Player mocoPlayer = null;
if (mocoId > 0) {
	mocoPlayer = PlayerManager.getInstance().getPlayerByMocoId(mocoId);
}
if ("awardCoins".equals(request.getParameter("action")) && coins > 0 && player != null) {
	mocoPlayer.setCoins(mocoPlayer.getCoins()+coins);
	PlayerManager.getInstance().storePlayer(mocoPlayer);
} else if ("forceFlush".equals(request.getParameter("action"))) {
	PlayerManager.getInstance().setForceFlush(!PlayerManager.getInstance().isForceFlush());
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Player Utility</title>
	</head>
	<body>
		<div>
			Force flush is <%= PlayerManager.getInstance().isForceFlush() ? "Enabled" : "Disabled" %>
			<a href="/admin/player.jsp?action=forceFlush"><%= PlayerManager.getInstance().isForceFlush() ? "Disable" : "Enable" %></a>
		</div>
		<h1>Player Utility</h1>
		<% if (mocoPlayer != null) { %>
			<% if (coins > 0) { %><h3><%= coins %> Coin Awarded!</h3><% } %>
			<table border="1" style="margin:10px">
				<tr>
					<th>Player ID</th>
					<th>Info</th>
				</tr>
				<tr>
					<td><%= mocoId %></td>
					<td><%= mocoPlayer %></td>
				</tr>
			</table>
			<form action="/admin/player.jsp" method="GET">
				<input type="hidden" name="mocoId" value="<%= mocoId %>"/>
				<input type="hidden" name="action" value="awardCoins"/>
				<label for="coins">Coins to grant</label>
				<input type="text" name="coins" id="coins"></input>
				<input type="submit"></input>
			</form>
		<% } %>
		<form action="/admin/player.jsp" method="GET">
			<label for="mocoId">Moco ID</label>
			<input type="text" name="mocoId" id="mocoId"></input>
			<input type="submit"></input>
		</form>		
	</body>
</html>