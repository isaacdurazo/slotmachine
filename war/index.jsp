<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>
<%
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
if (playerId != null) {
	player = PlayerManager.getInstance().getPlayer(playerId);
} else {
	// verify and create player as needed
	try {
		player = PlayerManager.getInstance().startGamePlayer(
			ServletUtils.getInt(request,"userId"), 
			ServletUtils.getLong(request,"timestamp"), 
			request.getParameter("verifier"));
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
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Solitude Slots</title>
  </head>

  <body>
    <h1>Hello <%= player.getName() %>!</h1>
    <h2>Coins: <%= player.getCoins() %></h2>
	
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
	</div>
    
    <div>
        <a href="<%= response.encodeURL("/?action=credit") %>">Credit 10 coins</a>
    </div>
    
  </body>
</html>
