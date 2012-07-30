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
if ("30 Coins: 99 Gold".equals(topupAction)) {
	coin = 30;
	gold = 99;
} else if ("70 Coins: 199 Gold".equals(topupAction)) {
	coin = 70;
	gold = 199;
} else if ("MysteryBox: 499 Gold".equals(topupAction)) {
	coin = 250+(new Random()).nextInt(150);
	gold = 499;
}
if (coin > 0 && gold > 0) {
	if (formValidation.equals((String)request.getSession().getAttribute("topUpValidation"))) {
		try {
			String s = topupAction.substring(0, topupAction.indexOf(':'));
			// valid transaction so debit and go back to main page
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Request buy "+coin+" coins.|uid|"+player.getMocoId());
			String ret=OpenSocialService.getInstance().doDirectDebit(player.getMocoId(),gold,s,player.getAccessToken());
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Completed buy "+coin+" coins.|uid|"+player.getMocoId()+"|trxid|"+ret);
			player.setCoins(player.getCoins()+coin);
			PlayerManager.getInstance().storePlayer(player);
			response.sendRedirect("/index.jsp?confirmmsg="+URLEncoder.encode("You bought "+coin+" coins. Play to win!","UTF-8"));
			return;
		} catch (OpenSocialService.GoldTopupRequiredException e) {
			// redirect 
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Failed - Gold topup required.|uid|"+player.getMocoId()+" - url="+e.getRedirectUrl());

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
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>

  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="103" height="18" src="images/logo.gif"/></div>
			<%@ include file="message.jsp" %>		    
		    <div>
		    Buy Coins:
		    </div>
			<form action="<%= response.encodeURL("/topup.jsp") %>" method="get">
				<input class="input" type="hidden" name="verify" value="<%= formValidation %>"/>
				<input class="input" type="submit" name="topup" value="30 Coins: 99 Gold"/>
				<input class="input" type="submit" name="topup" value="70 Coins: 199 Gold"/>
				<input class="input" type="submit" name="topup" value="MysteryBox: 499 Gold"/>
				<div class="subheader">(MysteryBox buys 200 - 400 Coins)</div>
			</form>
			
			<div class="menu">
				<div><a href="<%= response.encodeURL("/") %>">Main</a></div>
			</div>
		</div>
	</div>
  </body>
</html>