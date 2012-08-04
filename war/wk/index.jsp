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
 <%@ include file="header_html.jsp" %>
  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="192" height="60" src="/wk/images/logo.png"/></div>
		    
		    <div class="content">
		    
			    <table class="stats">
					<tr>
						<td>
							<b>XP:</b> <%= player.getXp() %>
						</td>
						<td>
							<a href="<%=response.encodeURL("/wk/?action=credit")%>">
								<b>Coins:</b> <%= player.getCoins() %>
							</a>
						</td>
					</tr>
				</table>
			
				<div class="results-container">
					<div class="results">
					    <h3>Hello <%= player.getName() %>!</h3>    
						<%@ include file="message.jsp" %>		    
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
							Now: <%=System.getProperty("weekly.mocogold.min.prize")%> <img width="16" height="16" src="/wk/images/mocogold.png"/> MocoGold!
						</span>
					</div>
				</div>
				
				<div class="controls">
				
					<div class="play">
						<a accessKey="1" href="<%= response.encodeURL("/wk/spin.jsp?"+cacheBuster) %>">Play Now</a>
					</div>
					
					<table class="menu">
						<tr>
							<td>
				        		<a accessKey="2" href="<%= response.encodeURL("/wk/topup.jsp") %>">Buy Coins</a>
							</td>
							<td>
				        		<a class="invite" accessKey="3" href="<%= response.encodeURL("/wk/invite.jsp") %>">Invite Friends</a>
							</td>
						</tr>
						<tr>
							<td>
				        		<a class="leaderboard" accessKey="4" href="<%= response.encodeURL("/wk/leaderboard.jsp") %>">Leaderboard</a>
							</td>
							<td>
				        		<a accessKey="5" href="<%= response.encodeURL("/wk/jackpots.jsp") %>">Jackpot Winners</a>
							</td>
						</tr>
					</table>
					
					<table class="menu">
						<tr>
							<td align="center">
				        		<a accessKey="6" href="<%= response.encodeURL("/wk/help.jsp") %>">Payout Table</a>
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
				        		<a href="<%=response.encodeURL("/wk/?action=credit")%>">Credit 10 coins</a>
				        	</td>
				        	<td>
				       			<a href="<%=response.encodeURL("/wk/?action=debit")%>">Set Coins=0</a>
				        	</td>
				        	<td>
				       			<a href="<%=response.encodeURL("/admin/cache.jsp")%>">Cache Manager</a>
				        	</td>
				        	<td>
				       			<a href="<%=response.encodeURL("/admin/properties.jsp")%>">System Properties Manager</a>
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
