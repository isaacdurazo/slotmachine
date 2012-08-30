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

	String token = request.getParameter("token");
	int count = ServletUtils.getInt(request, "count");
	if ("sent".equals(request.getParameter("action")) && token != null && count > 0 && 
			token.equals((String)request.getSession().getAttribute("invite_token")+count)) {
		request.getSession().removeAttribute("invite_token");
		player.incrementNumInvitesSent(1);
		PlayerManager.getInstance().storePlayer(player);
	}
	java.util.List<Achievement> earnedAchievements = null;
	try {
		earnedAchievements = AchievementService.getInstance().grantAchievements(player, 
				AchievementService.Type.SESSION, AchievementService.Type.INVITE);	
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error granting achievements for "+player,e);
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
		    	<div class="stats-container">
			    	<div class="stats">
					    <table>
							<tr>
								<td> 
									<span class="stat xp">
										<b>XP:</b> <%= player.getXp() %>
									</span>
								</td>
								<td>
									<span class="stat coins">
										<b>Coins:</b> <%= player.getCoins() %></a></br>
									<span>
								</td>
							</tr>
							
						</table>

						<table>
							<tr >
								<td>
									<span class="stat award">
										<small>Next award: <%= readableUntilCoinAward %></small>
									</span>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div class="results-container">
					<div class="results">
						
					    <h3>Hello <%= player.getName() %>!</h3>    
					    <% if (coinsAwarded > 0) { %>
					    	<div class="bonus">
					    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
					    	</div> 
					    <% } %>
					    
			    	</div>

			    	<% if (earnedAchievements != null && !earnedAchievements.isEmpty()) { %>
						<div class="achievements">
							<h1>CONGRATULATIONS!</h1>
							
							<%
							int coinsEarned = 0;
							for (Achievement achievement : earnedAchievements) { coinsEarned += achievement.getCoinsAwarded(); }
							%>
							
							<h2>You completed <%= earnedAchievements.size() > 1 ? "an achievement" : "achievements" %> and won <%= coinsEarned %> coins!</h2>
							
							<ul style="display: none">
								<% for (Achievement achievement : earnedAchievements) { %>
								<li><%= achievement.getTitle() %></li>
								<% } %>
							</ul>
							
							<a class="close" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?"+cacheBuster, response) %>" ></a>
							
							<div class="play">
								<a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
							</div>
							
						</div>
						
						<div class="overlay"></div>
						
					<% } %>

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
				        		<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/wk/topup.jsp", response) %>">Get Coins</a>
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
						<% boolean achievementsEnabled = AchievementService.getInstance().isEnabled() || player.hasAdminPriv(); %>
						<tr>
							<td <% if (!achievementsEnabled) { %>align="center"<% } %>>
				        		<a accessKey="6" href="<%= ServletUtils.buildUrl(player, "/wk/help.jsp", response) %>">Payout Table</a>
							</td>
							<% if (achievementsEnabled) { %>
							<td>
								<a accessKey="7" href="<%= ServletUtils.buildUrl(player, "/wk/achievement.jsp", response) %>">Achievements</a>
							</td>
							<% } %>
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
