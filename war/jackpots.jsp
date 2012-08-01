<%@ include file="header.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<%@ include file="header_html.jsp" %>
	  <body>
	  	<div id="container">
		  	<div class="wrapper">
			    <div class="header-logo"><img width="112" height="34" src="images/logo.gif"/><br />
			    	<div class="secondary-header">Jackpot Hall Of Fame</div>
			    </div>
			    <div class="subheader">
			    	Recent Moco Gold Jackpot winers
			    </div>
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
			    <div class="menu">
			        <div>1. <a accessKey="1" href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a></div>
			        <div>2. <a accessKey="2" href="<%= response.encodeURL("/index.jsp") %>">Main</a></div>
			    </div>
			</div>
		</div>
	</body>
</html>