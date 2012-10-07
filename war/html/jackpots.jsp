<%@ include file="/header.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<%@ include file="header_html.jsp" %>
					
				<div class="content">
					<div class="title-wrapper">
			    		<div class="title-container">
							<span class="title">
					   			Jackpot Hall Of Fame
							</span>
						</div>
					</div>

				    <div class="subheader">
				    	Recent Moco Gold Jackpot winers
				    </div>
				    
					<div class="list-container">
				    
					    <div class="list">
					    	<%
					    	java.util.List<JackpotWinner> winners = SlotMachineManager.getInstance().getRecentJackpotWinners();
					    	if (winners == null || winners.isEmpty()) { %>
					    		<div>Be the first winner!</div>

					    	<% } else {
						    	for (JackpotWinner winner : winners) { 
						    		Player winningPlayer = PlayerManager.getInstance().getPlayer(winner.getPlayerId()); %>

						    		<div class="list-entity">
						    			<div class="profile-pic-frame"><img src="<%= winningPlayer.getImage() %>" height="45" width="45"/></div>
						    		<div class="list-entry-content">
						    			<span><%= winningPlayer.getName() %></span>
						    		</div> 
								</div>

						    	<% } 
					    	}%>
					    </div>
				    </div>
				    
				    <div id="footer" class="menu" style="margin-right: 16px;">
			    		<div class="block half-left">
  							<a href="<%= ServletUtils.buildUrl(player, "/html/index.jsp", response) %>">Main</a>
  						</div>
  						<div class="block half-right">
  							<a class="invite" accessKey="3" href="<%= ServletUtils.buildUrl(player, "/html/invite.jsp", response) %>">Invite Friends</a>
  						</div>
	  				</div>
			    </div>
			</div>
		</div>
		</div>
		<%@ include file="/html/ga.jsp" %>
	</body>
</html>