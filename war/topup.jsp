<%@ include file="/header.jsp" %>
<%@ page import="com.solitude.slots.opensocial.*,com.solitude.slots.cache.*" %>
<%
String topupAction = request.getParameter("topup");
String formValidation = request.getParameter("verify");
if (formValidation == null && topupAction == null) {
	formValidation = java.util.UUID.randomUUID().toString();
	request.getSession().setAttribute("topUpValidation",formValidation);
}
if (isWebkit) {
	if ("widget".equals(request.getParameter("action"))) {
		int gold = ServletUtils.getInt(request, "gold");
		String id = request.getParameter("id"), timestamp = request.getParameter("timestamp"), token = request.getParameter("token");
		// validate token
		String expectedToken = org.apache.commons.codec.digest.DigestUtils.md5Hex(
				id+
				gold+
				timestamp+
				GameUtils.getGameGoldSecret());
		if (expectedToken.equals(token)) {
			int coin = 0;
			switch (gold) {
				case 99:
					coin = 30;
					break;
				case 199:
					coin = 70;
					break;
				case 499:
					coin = 250+(new Random()).nextInt(150);
					break;
			}
			player.setCoins(player.getCoins()+coin);
			PlayerManager.getInstance().storePlayer(player);
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Completed buy "+coin+" coins.|uid|"+player.getMocoId()+"|trxid|webkit");
			pageContext.forward("/index.jsp?confirmmsg="+URLEncoder.encode("You bought "+coin+" coins. Play to win!","UTF-8"));
			return;
		} else {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"topup: error attempting to topup for player: "+player);

		}
	}
} else {
	// load random uuid
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
				pageContext.forward("/index.jsp?confirmmsg="+URLEncoder.encode("You bought "+coin+" coins. Play to win!","UTF-8"));
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
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
	<% if (isWebkit) { %>
		<script type="text/javascript">
			console.log('topup');
			document.addEventListener('DOMContentLoaded', function() {
				var goldButtons = document.querySelectorAll('input.input');
				var onClickFn = function(e) {
					e.preventDefault();
					var desc = this.value;
					var gold = 0;
					switch (desc) {
						case "30 Coins: 99 Gold":
							gold = 99;
							break;
						case "70 Coins: 199 Gold":
							gold = 199;
							break;
						case "MysteryBox: 499 Gold":
							gold = 499;
							break;
						default:
							throw 'unknown option: '+desc;
					}
					// TODO: image
					var image;
					MocoSpace.goldTransaction(gold,desc,{
							onSuccess: function(id,timestamp,token) {
								// redirect with those parameters
								window.location = '/topup.jsp?action=widget&id='+id+'&timestamp='+timestamp+'&token='+token+'&gold='+gold;
							},
							onError: function(error) {
								console.error(error);
							}
						},image);
				};
				for (var i=0;i<goldButtons.length;i++) {
					goldButtons[i].addEventListener('click',onClickFn,false);
				}
			}, false);
		</script>
	<% } %>
  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="112" height="34" src="images/logo.gif"/></div>
			<%@ include file="message.jsp" %>		    
		    <div>
		    Buy Coins:
		    </div>
			<form action="<%= ServletUtils.buildUrl(player, "/topup.jsp", response) %>" method="get">
				<div>
					<input class="input" type="hidden" name="verify" value="<%= formValidation %>"/>
				</div>
				<div>
					<input class="input" type="submit" name="topup" value="30 Coins: 99 Gold"/>
				</div>
				<div>
					<input class="input" type="submit" name="topup" value="70 Coins: 199 Gold"/>
				</div>
				<div>
					<input class="input" type="submit" name="topup" value="MysteryBox: 499 Gold"/>
				</div>
				
				<div class="subheader">(MysteryBox buys 200 - 400 Coins)</div>
			</form>
			
			<div class="menu">
				<div><a href="<%= ServletUtils.buildUrl(player, "/index.jsp", response) %>">Main</a></div>
			</div>
		</div>
	</div>
  </body>
</html>