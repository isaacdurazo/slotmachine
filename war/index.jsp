<%@ include file="/header.jsp" %>
<%
	if (!player.seenLevelIntersistial()) {
		player.markSeenLevelIntersistial();
		PlayerManager.getInstance().storePlayer(player);
		pageContext.forward("/new_level_interstitial.jsp");
		return;
	}

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
	
	int key = 1;
	
	java.util.List<Achievement> earnedAchievements = null;
	if ("Invites Sent!".equals(request.getParameter("confirmmsg"))) {
		int invitesSent = 0;
		String token = request.getParameter("token");
		if ("true".equals(request.getSession().getAttribute("invite"))) {
			request.getSession().removeAttribute("invite");
			invitesSent = 1;		
		} else if (token != null && token.equals(request.getSession().getAttribute("force-invite-token"))) {
			request.getSession().removeAttribute("force-invite-token");
			invitesSent = 1;
			player.setCoins(player.getCoins()+20);
		}
		if (invitesSent > 0) {
			player.incrementNumInvitesSent(invitesSent);
			PlayerManager.getInstance().storePlayer(player);
			try {
				earnedAchievements = AchievementService.getInstance().grantAchievements(player, 
						AchievementService.Type.SESSION, AchievementService.Type.INVITE);	
			} catch (Exception e) {
				Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error granting achievements for "+player,e);
			}
		}
	}

	//@TODO add logic for 1) process/log invite requests using if=<mocoid> as senderID and 2) new users redirect to help
%>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="header_html.jsp" %>

 			<% if (coinsAwarded > 0) { %>
		    	<div class="bonus">
		    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
		    	</div> 
		    <% } %>

		    <% if (earnedAchievements != null && !earnedAchievements.isEmpty()) { %>
				<div class="achievements">
					<%
					int coinsEarned = 0;
					for (Achievement achievement : earnedAchievements) { coinsEarned += achievement.getCoinsAwarded(); }
					%>
					You earned <%= earnedAchievements.size() > 1 ? "an achievement" : "achievements" %> and <%= coinsEarned %> coins!
					<ul>
						<% for (Achievement achievement : earnedAchievements) { %>
						<li><%= achievement.getTitle() %></li>
						<% } %>
					</ul>
				</div>
			<% } %>

 			<div class="jackpotteaser">
				<img width="112" height="14" src="images/jackpot.gif"/><br />
				<img class="icon" width="16" height="16" src="images/mocogold.png"/> <%=player.getMocoGoldPrize()%> MocoGold!
			</div>

		    <h3>Hello <%= player.getName() %>!</h3>
		    <small>Next award: <%= readableUntilCoinAward %></small>
			<%@ include file="message.jsp" %>		    
		    
			
			<div class="play">
				<%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
			</div>
		
		    <div class="menu">
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/topup.jsp", response) %>">Get Coins</a></div>
		        <div><%= key %>. <a class="invite" accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/invite.jsp", response) %>">Invite Friends</a></div>
		        <div><%= key %>. <a class="leaderboard" accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/leaderboard.jsp", response) %>">Leaderboard</a></div>
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/jackpots.jsp", response) %>">Jackpot Winners</a></div>
		        <% if (AchievementService.getInstance().isEnabled() || player.hasAdminPriv()) { %>
		        	<div><%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/achievement.jsp", response) %>">Achievements</a></div>
		        <% } %>
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/locations.jsp", response) %>">Locations</a></div>
		    </div>
		    <br/>
			<div class="menu">
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/help.jsp", response) %>">Payout Table</a></div>
			</div>
			<%
				if (player.hasAdminPriv()) {
			%>
			<br/>Admin Tools<br/>
			<div class="menu">
		        <div><a href="<%=ServletUtils.buildUrl(player, "/?action=credit", response)%>">Credit 10 coins</a></div>
		        <div><a href="<%=ServletUtils.buildUrl(player, "/?action=debit", response)%>">Set Coins=0</a></div>
				<div><a href="<%=ServletUtils.buildUrl(player, "/admin/inbox.jsp", response)%>">Inbox Utility</a></div>				       			
				<div><a href="<%=ServletUtils.buildUrl(player, "/admin/player.jsp", response)%>">Player Utility</a></div>				       			
		        <div><a href="<%=ServletUtils.buildUrl(player, "/admin/cache.jsp", response)%>">Cache Manager</a></div>
		        <div><a href="<%=ServletUtils.buildUrl(player, "/admin/properties.jsp", response)%>">System Properties Manager</a></div>
			</div>
			<%
				}
			%>
	    </div>
	</div>
	<%@ include file="footer.jsp" %>
  </body>
</html>
