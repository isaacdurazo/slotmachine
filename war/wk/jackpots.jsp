<%@ include file="header.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<%@ include file="header_html.jsp" %>
	  <body>
	  	<div id="container">
		  	<div class="wrapper">
				
				<div class="header-logo"><img width="192" height="60" src="images/logo.png"/></div>
					
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
				    
					    <ul class="list">
					    	<%
					    	java.util.List<JackpotWinner> winners = SlotMachineManager.getInstance().getRecentJackpotWinners();
					    	if (winners == null || winners.isEmpty()) { %>
					    		<li>Be the first winner!</li>
		
					    	<% } else {
						    	for (JackpotWinner winner : winners) { 
						    		Player winningPlayer = PlayerManager.getInstance().getPlayer(winner.getPlayerId()); %>
						    		<li>
						    			<img src="<%= winningPlayer.getImage() %>" height="25" width="25"/> <%= winningPlayer.getName() %> 
						    		</li>
						    		
						    		<!-- Example of the structure I would like to use 
						    		
						    		<li>
						    			<img style="vertical-align:middle;" src="#" height="25" width="25"/> <a href="#">name</a> 
						    		</li>
						    		
						    		-->
						    	<% } 
					    	}%>
					    </ul>
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