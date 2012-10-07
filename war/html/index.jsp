<%@ include file="/header.jsp" %>
<%
	if (!player.seenLevelIntersistial()) {
		player.markSeenLevelIntersistial();
		PlayerManager.getInstance().storePlayer(player);
		pageContext.forward("/html/new_level_interstitial.jsp");
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
<!-- html/index.jsp -->
<%@ include file="header_html.jsp" %>
  
			<%@ include file="message.jsp" %>		    
		    <div class="content">

				<div class="jackpotteaser">
					<span class="jackpot">
						JACKPOT
					</span>

					<span class="jackpot-text">
						<img width="16" height="16" src="/html/images/mocogold.png"/> <%=player.getMocoGoldPrize()%>  MocoGold!
					</span>

				</div>

				<div class="intro-message">
				    
				    <% if (coinsAwarded > 0) { %>
				    	<script>
				    		document.addEventListener('DOMContentLoaded', function() {
								try {_gaq.push(['_trackEvent', 'Player','coinAward','<%= java.util.concurrent.TimeUnit.MILLISECONDS.toDays(System.currentTimeMillis()-player.getCreationtime()) %> days',<%= player.getCoins() %>]); } catch (err) {console.log(err);}
				    		},false);
				    	</script>
				    	<div class="bonus">
				    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
				    	</div> 
				    <% } %>

				    <p class="hello">Hello <%= player.getName() %>!</p> 

					<p>Next award: <%= readableUntilCoinAward %></p>

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
							
							<a class="close" href="<%= ServletUtils.buildUrl(player, "/html/spin.jsp?"+cacheBuster, response) %>" ></a>
							
							<div class="play">
								<a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/html/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
							</div>
							
						</div>
						
						<div class="overlay"></div>
						<script>
							document.addEventListener('DOMContentLoaded', function() {
								<% for (Achievement achievement : earnedAchievements) { %> 
								try {_gaq.push(['_trackEvent', 'Achievement', 
					                "<%= achievement.getTitle().length() > 9 ? achievement.getTitle().substring(0,9) : achievement.getTitle() %>", 
					               <%= achievement.getCoinsAwarded() %>);} catch (err) {console.error(err);}
								<% } %>	
							},false);
						</script>
					<% } %>

			    </div>
			    				
				<div class="play">
					<a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/html/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
				</div>
				<div class="menu">

					<div class="button-row">

						<% boolean achievementsEnabled = AchievementService.getInstance().isEnabled() || player.hasAdminPriv(); %>

						<div class="block half-left" <% if (!achievementsEnabled) { %>align="center"<% } %>>
				        	<a accessKey="6" href="<%= ServletUtils.buildUrl(player, "/html/locations.jsp", response) %>">SlotMachines</a>
						</div>

						<% if (achievementsEnabled) { %>
							<div class="block half-right">
								<a accessKey="7" href="<%= ServletUtils.buildUrl(player, "/html/achievement.jsp", response) %>">Achievements</a>
							</div>
						<% } %>

					</div>

					<div class="button-row">

						<div class="block half-left">
				        	<a accessKey="6" href="<%= ServletUtils.buildUrl(((com.solitude.slots.entities.Player)request.getAttribute("player")), "/html/topup.jsp", response) %>">Buy Coins</a>
						</div>
						
						<div class="block half-right">
			        		<a accessKey="5" href="<%= ServletUtils.buildUrl(player, "/html/invite.jsp", response) %>">Invite Friends</a>
						</div>

					</div>

					<div class="button-row">

						<div class="block half-left" <% if (!achievementsEnabled) { %>align="center"<% } %>>
				        	<a accessKey="6" href="<%= ServletUtils.buildUrl(player, "/html/help.jsp", response) %>">PayoutTable </a>
						</div>
						
						<div class="block half-right">
			        		<a accessKey="5" href="<%= ServletUtils.buildUrl(player, "/html/jackpots.jsp", response) %>">Jackpot Winners</a>
						</div>

					</div>

					<%
						if (player.hasAdminPriv()) {
					%>
					<div>Admin Tools</div>
					<table>
				    	<tr>   
				        	<td>
				        		<a href="<%=ServletUtils.buildUrl(player, "/html/index.jsp?action=credit", response)%>">Credit 10 coins</a>
				        	</td>
				        	<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/html/index.jsp?action=debit", response)%>">Set Coins=0</a>
				        	</td>
				        </tr>
						<tr>
							<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/admin/cache.jsp", response)%>">Cache Manager</a>
				        	</td>
				        	<td>
				       			<a href="<%=ServletUtils.buildUrl(player, "/admin/properties.jsp", response)%>">System Properties Manager</a>
				        	</td>
						</tr>
						<tr>			        	
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
	</div>
	<%@ include file="/html/ga.jsp" %>
  </body>
</html>
