<%@ include file="header.jsp" %>
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
<!-- wk/index.jsp -->
<%@ include file="header_html.jsp" %>
  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo">
		    	<img width="154" height="48" src="/wk/images/logo.png"/>
		    </div>
			<%@ include file="message.jsp" %>		    
		    <div class="content">
		    
			    <table class="stats">
					<tr>
						<td>
							<b>XP:</b> <%= player.getXp() %>
						</td>
						<td>

							<b>Coins:</b> <%= player.getCoins() %>
							</a>
						</td>
					</tr>
				</table>
			
				<div class="results-container">
					<div class="results">
					    <h3>Hello <%= player.getName() %>!</h3>    
					    <% if (coinsAwarded > 0) { %>
					    	<div class="bonus">
					    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
					    	</div> 
					    <% } %>
			    	</div>
			    </div>
			    
				<div class="jackpotteaser-container">
					<div class="jackpotteaser goldtext">
						<span class="jackpot">
							<img width="120" height="26" src="/wk/images/jackpot.png"/>
						</span>
						<span class="jackpot-text">
							Now: <%=GameUtils.getGlobalProps().getMocoGoldPrize()%> <img width="16" height="16" src="/wk/images/mocogold.png"/> MocoGold!
						</span>
					</div>
				</div>
				
				<div class="controls">
				
					<div class="play">
						<a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
					</div>
					
					<table class="menu">
						<tr>
							<td>
				        		<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/wk/topup.jsp", response) %>">Buy Coins</a>
							</td>
							<td>
				        		<a class="invite" accessKey="3" href="<%= ServletUtils.buildUrl(player, "/wk/invite.jsp", response) %>">Invite Friends</a>
							</td>
						</tr>
						<tr>
							<td>
				        		<a class="leaderboard" accessKey="4" href="<%= ServletUtils.buildUrl(player, "/wk/leaderboard.jsp", response) %>">Leaderboard</a>
							</td>
							<td>
				        		<a accessKey="5" href="<%= ServletUtils.buildUrl(player, "/wk/jackpots.jsp", response) %>">Jackpot Winners</a>
							</td>
						</tr>
					</table>
					
					<table class="menu">
						<tr>
							<td align="center">
				        		<a accessKey="6" href="<%= ServletUtils.buildUrl(player, "/wk/help.jsp", response) %>">Payout Table</a>
							</td>
						</tr>
					</table>

					<%
						if (player.hasAdminPriv()) {
					%>
					<br/>Admin Tools<br/>
					<table class="menu">
				    	<tr>   
				        	<td>
				        		<a href="<%=ServletUtils.buildUrl(player, "/wk/index.jsp?action=credit", response)%>">Credit 10 coins</a>
				        	</td>
				        	<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/wk/index.jsp?action=debit", response)%>">Set Coins=0</a>
				        	</td>
				        	<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/admin/cache.jsp", response)%>">Cache Manager</a>
				        	</td>
				        	<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/admin/properties.jsp", response)%>">System Properties Manager</a>
				        	</td>
				        	<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/admin/inbox.jsp", response)%>">Inbox Utility</a>
				        	</td>
				        </tr>
					</table>
					<%
						}
					%>
				
				</div>
			
			</div>
			
	    </div>
	</div>
  </body>
</html>
