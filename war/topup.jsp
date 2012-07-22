<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.cache.*,com.solitude.slots.opensocial.*,java.util.logging.*" %>
<%
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
if (playerId == null || (player = PlayerManager.getInstance().getPlayer(playerId)) == null) {
	response.sendRedirect(GameUtils.getVisitorHome());
	return;
}
// load random uuid
String topupAction = request.getParameter("topup");
String formValidation = (String)request.getSession().getAttribute("topUpValidation");
if (formValidation == null && topupAction == null) {
	formValidation = java.util.UUID.randomUUID().toString();
	request.setAttribute("topUpValidation",formValidation);
}
int coin = 0, gold = 0;
if ("Buy 10 Coins for 99 gold".equals(topupAction)) {
	coin = 10;
	gold = 99;
} else if ("Buy 50 Coins for 299 gold".equals(topupAction)) {
	coin = 50;
	gold = 299;
} else if ("Buy 100 Coins for 499 gold".equals(topupAction)) {
	coin = 100;
	gold = 499;
}
if (coin > 0 && gold > 0 && formValidation.equals((String)request.getSession().getAttribute("topUpValidation"))) {
	try {
		// valid transaction so debit and go back to main page
		OpenSocialService.getInstance().doDirectDebit(player.getMocoId(),gold,topupAction);
		player.setCoins(player.getCoins()+coin);
		PlayerManager.getInstance().storePlayer(player);
		pageContext.forward("/");
		return;
	} catch (OpenSocialService.GoldTopupRequiredException e) {
		// redirect 
		response.sendRedirect(e.getRedirectUrl());
		return;
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"error attempting to topup for player: "+player,e);
	}
}
String message = request.getParameter("message");
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
		    <% if (message != null) { %><div style="color:red"><%= message %></div><% } %>
			<form method="get">
				<input type="hidden" name="verify" value="<%= formValidation %>"/>
				<input type="submit" name="topup" value="Buy 10 Coins for 99 gold"/>
				<input type="submit" name="topup" value="Buy 50 Coins for 299 gold"/>
				<input type="submit" name="topup" value="Buy 100 Coins for 499 gold"/>
			</form>
			
			<div class="menu">
				<a href="<%= response.encodeURL("/") %>">Main</a>
			</div>
		</div>
	</div>
  </body>
</html>