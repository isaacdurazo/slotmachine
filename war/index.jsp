<%@ include file="header.jsp" %>
<% 
String action = request.getParameter("action");
SpinResult spinResult = null;
if ("credit".equals(action)) {
	player.setCoins(player.getCoins()+10);
	PlayerManager.getInstance().storePlayer(player);
} else if ("debit".equals(action)) {
	player.setCoins(0);
	PlayerManager.getInstance().storePlayer(player);
}
//coinsAwarded=2;
%>
 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Slot Mania</title>
  </head>

  <body>
    <h1>Slot Mania</h1>
    <h2>XP: <%= player.getXp() %>, Coins: <%= player.getCoins() %></h2>
    <h3>Hello <%= player.getName() %>!</h3>    
    <% if (coinsAwarded > 0) { %>
    	<div class="bonus">
    		Your daily bonus: <%= coinsAwarded %> <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %> coins!
    	</div>
    <% } %>
	
	<div class="sponmenu">
		<a href="<%= response.encodeURL("spin.jsp") %>">Play Now</a>
	</div>

    <div class="menu">
        <a href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a>
        <a href="<%= response.encodeURL("/leaderboard.jsp") %>">Leaderboard</a>
    </div>
	<br/>Admin Tools<br/>
	<div class="menu">
        <a href="<%= response.encodeURL("/?action=credit") %>">Credit 10 coins</a>
        <a href="<%= response.encodeURL("/?action=debit") %>">Set Coins=0</a>
	</div>
    
  </body>
</html>
