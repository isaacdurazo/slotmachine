<%@ include file="header.jsp" %>
<% 
String action = request.getParameter("action");
SpinResult spinResult = null;
/*if ("credit".equals(action)) {
	player.setCoins(player.getCoins()+10);
	PlayerManager.getInstance().storePlayer(player);
} else if ("debit".equals(action)) {
	player.setCoins(0);
	PlayerManager.getInstance().storePlayer(player);
}*/
%>
 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Slot Mania</title>
    <link rel="stylesheet" href="css/style.css" />    
  </head>

  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo"><img width="103" height="18" src="images/logo.gif"/></div>
		    
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
		    <% if (coinsAwarded > 0) { %>
		    	<div class="bonus">
		    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
		    	</div> 
		    <% } %>
			<div class="jackpotteaser">
			Jackpot value: <%=System.getProperty("weekly.coin.prize")%> Moco Gold!
			</div>
			<div class="play">
				<a href="<%= response.encodeURL("spin.jsp") %>">Play Now</a>
			</div>
		
		    <div class="menu">
		        <a href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a>
		        <a href="<%= response.encodeURL("/leaderboard.jsp") %>">Leaderboard</a>
		        <a href="<%= response.encodeURL("/help.jsp") %>">Payout Table</a>
		        
		    </div>
			<!-- br/>Admin Tools<br/>
			<div class="menu">
		        <a href="<%= response.encodeURL("/?action=credit") %>">Credit 10 coins</a>
		        <a href="<%= response.encodeURL("/?action=debit") %>">Set Coins=0</a>
			</div-->
	    </div>
	</div>
  </body>
</html>
