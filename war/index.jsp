<%@ include file="/header.jsp" %>
<%
	String action = request.getParameter("action");
	SpinResult spinResult = null;

	if (player.hasAdminPriv()) {
		if ("credit".equals(action)) {
			player.setCoins(player.getCoins() + 10);
			PlayerManager.getInstance().storePlayer(player);
		} else if ("debit".equals(action)) {
			player.setCoins(0);
			PlayerManager.getInstance().storePlayer(player);
		}
	}
	
	
	//@TODO add logic for 1) process/log invite requests using if=<mocoid> as senderID and 2) new users redirect to help
%>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="header_html.jsp" %>
  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="112" height="34" src="images/logo.gif"/></div>
		    
		    <table class="subheader">
				<tr>
					<td class="xp" style="red">
						<b>XP:</b><%= player.getXp() %>
					</td>
					<td class="coins">
						<b>Coins:</b><%= player.getCoins() %>
					</td>
				</tr>
			</table>
		    <h3>Hello <%= player.getName() %>!</h3>    
			<%@ include file="message.jsp" %>		    
		    <% if (coinsAwarded > 0) { %>
		    	<div class="bonus">
		    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
		    	</div> 
		    <% } %>
			<div class="jackpotteaser">
				<img width="112" height="14" src="images/jackpot.gif"/><br />
				<img class="icon" width="16" height="16" src="images/mocogold.png"/> <%=GameUtils.getGlobalProps().getMocoGoldPrize()%> MocoGold!
			</div>
			<div class="play">
				1. <a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
			</div>
		
		    <div class="menu">
		        <div>2. <a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/topup.jsp", response) %>">Buy Coins</a></div>
		        <div>3. <a class="invite" accessKey="3" href="<%= ServletUtils.buildUrl(player, "/invite.jsp", response) %>">Invite Friends</a></div>
		        <div>4. <a class="leaderboard" accessKey="4" href="<%= ServletUtils.buildUrl(player, "/leaderboard.jsp", response) %>">Leaderboard</a></div>
		        <div>5. <a accessKey="5" href="<%= ServletUtils.buildUrl(player, "/jackpots.jsp", response) %>">Jackpot Winners</a></div>
		    </div>
		    <br/>
			<div class="menu">
		        <div>6. <a accessKey="6" href="<%= ServletUtils.buildUrl(player, "/help.jsp", response) %>">Payout Table</a></div>
			</div>
			<%
				if (player.hasAdminPriv()) {
			%>
			<br/>Admin Tools<br/>
			<div class="menu">
		        <div><a href="<%=ServletUtils.buildUrl(player, "/?action=credit", response)%>">Credit 10 coins</a></div>
		        <div><a href="<%=ServletUtils.buildUrl(player, "/?action=debit", response)%>">Set Coins=0</a></div>
		        <div><a href="<%=ServletUtils.buildUrl(player, "/admin/cache.jsp", response)%>">Cache Manager</a></div>
		        <div><a href="<%=ServletUtils.buildUrl(player, "/admin/properties.jsp", response)%>">System Properties Manager</a></div>
				<div><a href="<%=ServletUtils.buildUrl(player, "/admin/inbox.jsp", response)%>">Inbox Utility</a></div>				       			
			</div>
			<%
				}
			%>
	    </div>
	</div>
	<%@ include file="footer.jsp" %>
  </body>
</html>
