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
if ("20 Coins: 99 Gold".equals(topupAction)) {
	coin = 20;
	gold = 99;
} else if ("50 Coins: 199 Gold".equals(topupAction)) {
	coin = 50;
	gold = 199;
} else if ("MysteryBox: 499 Gold".equals(topupAction)) {
	coin = 200+(new Random()).nextInt(150);
	gold = 499;
}
if (coin > 0 && gold > 0) {
	if (formValidation.equals((String)request.getSession().getAttribute("topUpValidation"))) {
		try {
			String s = topupAction.substring(0, topupAction.indexOf(':'));
			// valid transaction so debit and go back to main page
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup: Ready to buy "+coin+" coins. player: "+player);
			OpenSocialService.getInstance().doDirectDebit(player.getMocoId(),gold,s,player.getAccessToken());
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup: Completed buy "+coin+" coins. player: "+player);
			player.setCoins(player.getCoins()+coin);
			PlayerManager.getInstance().storePlayer(player);
			pageContext.forward("/");
			return;
		} catch (OpenSocialService.GoldTopupRequiredException e) {
			// redirect 
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup: Gold topup required: "+e.getRedirectUrl());

			//@TODO very TEMP Moco FIX
			String s = e.getRedirectUrl().replace("/link/", "/wap2/");
			response.sendRedirect(s);
			return;
		} catch (Exception e) {
			Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"topup: error attempting to topup for player: "+player,e);
		}
	} else {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"topup: invalid topup verification for player: "+player);
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
		    <div>
		    Buy Coins:
		    </div>
			<form action="<%= response.encodeURL("/topup.jsp") %>" method="get">
				<input class="input" type="hidden" name="verify" value="<%= formValidation %>"/>
				<input class="input" type="submit" name="topup" value="20 Coins: 99 Gold"/>
				<input class="input" type="submit" name="topup" value="50 Coins: 199 Gold"/>
				<input class="input" type="submit" name="topup" value="MysteryBox: 499 Gold"/>
				<div class="subheader">(MysteryBox buys 150 - 300 Coins)</div>
			</form>
			
			<div class="menu">
				<div><a href="<%= response.encodeURL("/") %>">Main</a></div>
			</div>
		</div>
	</div>
  </body>
</html>