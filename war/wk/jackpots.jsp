<%@ include file="header.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<%@ include file="header_html.jsp" %>
	  <body>
	  	<div id="container">
		  	<div class="wrapper">
				
				<div class="header-logo">
		    		<img width="154" height="48" src="/wk/images/logo.png"/>
				</div>
					
				<div class="content">
					
					<table class="stats">
						<tr>
							<td>
								Jackpot Hall Of Fame
							</td>
						</tr>
					</table>
					
				    <div class="subheader">
				    	Recent Moco Gold Jackpot winers
				    </div>
				    
					<div class="list-container">
				    
					    <div class="list">
					    	<%
					    	java.util.List<JackpotWinner> winners = SlotMachineManager.getInstance().getRecentJackpotWinners();
					    	if (winners == null || winners.isEmpty()) { %>
					    		<div>Be the first winner!</div>
		
								<div class="list-entity">
						    		<div class="profile-pic-frame"><img src="/wk/images/comb-1.jpg" height="45" width="45"/> </div>
						    		<div class="list-entry-content">NAME</div> 
								</div>
						    	
								<div class="list-entity">
						    		<div class="profile-pic-frame"><img src="/wk/images/comb-1.jpg" height="45" width="45"/> </div>
						    		<div class="list-entry-content">NAME</div> 
								</div>
						    	
								<div class="list-entity">
						    		<div class="profile-pic-frame"><img src="/wk/images/comb-1.jpg" height="45" width="45"/> </div>
						    		<div class="list-entry-content">NAME</div> 
								</div>
		
					    	<% } else {
						    	for (JackpotWinner winner : winners) { 
						    		Player winningPlayer = PlayerManager.getInstance().getPlayer(winner.getPlayerId()); %>
									<div class="list-entity">
						    			<img src="<%= winningPlayer.getImage() %>" height="45" width="45"/> <%= winningPlayer.getName() %> 
						    		</div>

						    	<% } 
					    	}%>
					    </div>
				    </div>
				    
				    <table class="menu">
				    	<tr>
				    		<td>
				        		<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/wk/index.jsp", response) %>">Main</a>
				    		</td>
				    		<td>
				        		<a accessKey="1" class="invite" href="<%= ServletUtils.buildUrl(player, "/wk/invite.jsp", response) %>">Invite Friends</a>
				    		</td>
				    	</tr>
				    </table>
			    </div>
			</div>
		</div>
	</body>
</html>