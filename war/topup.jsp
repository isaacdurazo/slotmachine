<%@ include file="header.jsp" %>
<%@ page import="com.solitude.slots.opensocial.*,com.solitude.slots.cache.*" %>
<%

// load random uuid
String topupAction = request.getParameter("topup");
String formValidation = request.getParameter("verify");
if (formValidation == null && topupAction == null) {
	formValidation = java.util.UUID.randomUUID().toString();
	request.getSession().setAttribute("topUpValidation",formValidation);
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
if (coin > 0 && gold > 0) {
	if (formValidation.equals((String)request.getSession().getAttribute("topUpValidation"))) {
		try {
			// valid transaction so debit and go back to main page
			OpenSocialService.getInstance().doDirectDebit(player.getMocoId(),gold,coin+" coins");
			player.setCoins(player.getCoins()+coin);
			PlayerManager.getInstance().storePlayer(player);
			pageContext.forward("/");
			return;
		} catch (OpenSocialService.GoldTopupRequiredException e) {
			// redirect 
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup required: "+e.getRedirectUrl());
			response.sendRedirect(e.getRedirectUrl());
			return;
		} catch (Exception e) {
			Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"error attempting to topup for player: "+player,e);
		}
	} else {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"invalid topup verification for player: "+player);
	}
} 
String message = request.getParameter("message");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>

  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="103" height="18" src="images/logo.gif"/></div>
		    <% if (message != null) { %><div style="color:red"><%= message %></div><% } %>
			<form action="<%= response.encodeURL("/topup.jsp") %>" method="get">
				<input type="hidden" name="verify" value="<%= formValidation %>"/>
				<input type="submit" name="topup" value="Buy 10 Coins for 99 gold"/>
				<input type="submit" name="topup" value="Buy 50 Coins for 299 gold"/>
				<input type="submit" name="topup" value="Buy 100 Coins for 499 gold"/>
			</form>
			
			<div class="menu">
				<div><a href="<%= response.encodeURL("/") %>">Main</a></div>
			</div>
		</div>
	</div>
  </body>
</html>