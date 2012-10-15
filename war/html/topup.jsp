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
		boolean levelUnlock = "true".equals(request.getParameter("level"));
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
					if (levelUnlock) {
						player.setLevel(player.getLevel()+1);
						player.setPlayingLevel(player.getLevel());
						PlayerManager.getInstance().storePlayer(player);
						response.sendRedirect(ServletUtils.buildUrl(player, "/html/spin.jsp", response));
						return;
					} else coin = 250+(new Random()).nextInt(150);
					break;
			}
			player.setCoins(player.getCoins()+coin);
			player.setGoldDebitted(player.getGoldDebitted()+gold);
			PlayerManager.getInstance().storePlayer(player);
			Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Completed buy "+coin+" coins.|uid|"+player.getMocoId()+"|trxid|webkit");
			pageContext.forward("/html/index.jsp?accessToken="+java.net.URLEncoder.encode(player.getAccessToken(),"UTF-8")+"&confirmmsg="+URLEncoder.encode("You bought "+coin+" coins. Play to win!","UTF-8"));
			return;
		} else {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"topup: error attempting to topup for player: "+player);

		}
	}
} else {
	// load random uuid
	int coin = 0, gold = 0;
	boolean levelUp = false;
	if ("30 Coins: 99 Gold".equals(topupAction)) {
		coin = 30;
		gold = 99;
	} else if ("70 Coins: 199 Gold".equals(topupAction)) {
		coin = 70;
		gold = 199;
	} else if ("MysteryBox: 499 Gold".equals(topupAction)) {
		coin = 250+(new Random()).nextInt(150);
		gold = 499;
	} else if ("Unlock Next Level: 499 Gold".equals(topupAction)) {
		levelUp = true;
		gold = 499;
	}
	if (levelUp || (coin > 0 && gold > 0)) {
		if (formValidation.equals((String)request.getSession().getAttribute("topUpValidation"))) {
			try {
				String successMsg = "You bought "+coin+" coins. Play to win!";
				String s = topupAction.substring(0, topupAction.indexOf(':'));
				// valid transaction so debit and go back to main page
				Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Request buy "+coin+" coins.|uid|"+player.getMocoId());
				String ret=OpenSocialService.getInstance().doDirectDebit(player.getMocoId(),gold,s,player.getAccessToken());
				Logger.getLogger(request.getRequestURI()).log(Level.INFO,"topup|Completed buy "+coin+" coins.|uid|"+player.getMocoId()+"|trxid|"+ret);
				player.setCoins(player.getCoins()+coin);
				if (levelUp) {
					successMsg = "You have leveled up!";
					player.setLevel(player.getLevel()+1);
					player.setPlayingLevel(player.getLevel());
				}
				PlayerManager.getInstance().storePlayer(player);
				pageContext.forward("/html/index.jsp?confirmmsg="+URLEncoder.encode(successMsg,"UTF-8"));
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
				var goldButtons = document.querySelectorAll('input.gold');
				var onClickFn = function(e) {
					e.preventDefault();
					var desc = this.value;
					var gold = 0;
					var level = false;
					switch (desc) {
						case "30 Coins: 99 Gold":
							gold = 99;
							break;
						case "70 Coins: 199 Gold":
							gold = 199;
							break;
						case "Unlock Next Level: 499 Gold":
							level = true;
						case "MysteryBox: 499 Gold":
							gold = 499;
							break;
						default:
							throw 'unknown option: '+desc;
					}
					// TODO: image
					try {_gaq.push(['_trackEvent', 'Topup', 'start', desc, gold]);} catch (err) {console.error(err);}
					var image;
					MocoSpace.goldTransaction(gold,desc,{
							onSuccess: function(id,timestamp,token) {
								// redirect with those parameters
								try {_gaq.push(['_trackEvent', 'Topup', 'success', desc, gold]);} catch (err) {console.error(err);}
								window.location = '/html/topup.jsp?accessToken=<%= player.getAccessToken() %>&level='+level+'&action=widget&id='+id+'&timestamp='+timestamp+'&token='+token+'&gold='+gold;
							},
							onError: function(error) {
								console.error(error);
							},
							onAbort: function() {
								try {_gaq.push(['_trackEvent', 'Topup', 'cancel', desc, gold]);} catch (err) {console.error(err);}
							}
						},image);
				};
				for (var i=0;i<goldButtons.length;i++) {
					goldButtons[i].addEventListener('click',onClickFn,false);
				}
			}, false);
		</script>
	<% } %>

			<%@ include file="message.jsp" %>		    
		    
		    <div class="content">
			    <div class="title-wrapper">
		    		<div class="title-container">
						<span class="title">
				   			Increase your chance to win the Jackpot<br/>Buy Coins!
						</span>
					</div>
				</div>

				<div class="buy-container">
					<form action="<%= ServletUtils.buildUrl(player, "/html/topup.jsp", response) %>" method="get">
						<div class="buy-gold-btn">
							<input class="input gold" type="hidden" name="verify" value="<%= formValidation %>"/>
						</div>
						<div class="buy-gold-btn">
							<input class="input gold" type="submit" name="topup" value="MysteryBox: 499 Gold"/>
						</div>
						<div class="buy-gold-btn">
							<input class="input gold" type="submit" name="topup" value="30 Coins: 99 Gold"/>
						</div>
						<div class="buy-gold-btn">
							<input class="input gold" type="submit" name="topup" value="70 Coins: 199 Gold"/>
						</div>
						<% if (player.getLevel() < Integer.getInteger("max.player.level")) { %>
						<div class="buy-gold-btn">
							<input class="input gold" type="submit" name="topup" value="Unlock Next Level: 499 Gold"/>
						</div>
						<% } %>
						
						<div class="subheader">(MysteryBox buys 200 - 400 Coins)</div>
					</form>
				</div>
				
				<div id="footer" class="menu" style="margin-right: 16px;">
					<div class="block half-left">
		        		<a href="<%= ServletUtils.buildUrl(player, "/html/index.jsp", response) %>">Main</a>
		        	</div>
					<%-- div class="block half-right">
	  					<a class="invite" accessKey="3" href="<%= ServletUtils.buildUrl(player, "/html/invite.jsp", response) %>">Invite Friends</a>
		        	</div --%>
				</div>
				
			</div>
		</div>
	</div>
	</div>
	<%@ include file="/html/ga.jsp" %>
  </body>
</html>