<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>
<%
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
int coinsAwarded = 0;
if (playerId != null) {
	player = PlayerManager.getInstance().getPlayer(playerId);
} else {
	// verify and create player as needed
	try {
		Pair<Player,Integer> gameStartPair = PlayerManager.getInstance().startGamePlayer(
			ServletUtils.getInt(request,"uid"), 
			ServletUtils.getLong(request,"timestamp"), 
			request.getParameter("verify"));
		player = gameStartPair.getElement1();
		coinsAwarded = gameStartPair.getElement2();
		request.getSession().setAttribute("playerId",player.getId());
	} catch (PlayerManager.UnAuthorizedException e) { 
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Invalid verification: "+request.getQueryString());
		response.sendRedirect(GameUtils.getMocoSpaceHome());
		return;
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Could not create/load player? params: "+request.getQueryString(),e);
		response.sendRedirect(GameUtils.getMocoSpaceHome());
		return;
	}
}
String action = request.getParameter("action");
SpinResult spinResult = null;
if ("credit".equals(action)) {
	player.setCoins(player.getCoins()+10);
	PlayerManager.getInstance().storePlayer(player);
} else if ("spin".equals(action)) {
	spinResult = SlotMachineManager.getInstance().spin(player, 1);
} else if ("maxspin".equals(action)) {
	spinResult = SlotMachineManager.getInstance().spin(player, Integer.parseInt(System.getProperty("max.bet.coins")));
} else if ("invite".equals(action)) {
	response.sendRedirect(OpenSocialService.getInstance().getInviteRedirectUrl(null, null, null, null, null, null));
	return;
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Solitude Slots</title>
  </head>

  <body>
    <h1>Hello <%= player.getName() %>!</h1>
    <h2>XP: <%= player.getXp() %>, Coins: <%= player.getCoins() %></h2>
    <% if (coinsAwarded > 0) { %>
    	<div>
    		Welcome back, you've been awarded <%= coinsAwarded %><% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
    	</div>
    <% } %>
	
	<% if (spinResult != null) { %>
		<h3>You <%= spinResult.getCoins() > 0 ? ("WON "+spinResult.getCoins()+" COINS!") : "LOST" %></h3>
		<div>
			Symbols:
			<ul>
				<% for (int symbol : spinResult.getSymbols()) { %>
					<li><%= symbol %></li>
				<% } %>
			</ul>
		</div>
		
	<% } %>
	
	<div>
		<a href="<%= response.encodeURL("/?action=spin") %>">SPIN!</a>
		<a style="margin-left:5px;" href="<%= response.encodeURL("/?action=maxspin") %>">Max bet (<%= System.getProperty("max.bet.coins") %> coins)!</a>
	</div>
    
    <div>
        <a href="<%= response.encodeURL("/?action=credit") %>">Credit 10 coins</a>
        <a style="margin-left:5px;" href="<%= response.encodeURL("/?action=invite") %>">Invite Friends</a>
        <a style="margin-left:5px;" href="<%= response.encodeURL("/leaderboard.jsp") %>">Leaderboard</a>
    </div>
    
  </body>
</html>
