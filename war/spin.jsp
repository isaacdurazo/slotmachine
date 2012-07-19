<%@ include file="header.jsp" %>
 

<%
String action = request.getParameter("action");
SpinResult spinResult = new SpinResult(-1,new int[]{-1,-1,-1});
boolean fSpinOK = false;

try {
	if ("spin".equals(action)) {
		spinResult = SlotMachineManager.getInstance().spin(player, 1);
	} else if ("maxspin".equals(action)) {
		spinResult = SlotMachineManager.getInstance().spin(player, Integer.parseInt(System.getProperty("max.bet.coins")));
	}
	fSpinOK=true;
} catch (InsufficientFundsException ife) {
	fSpinOK=false;
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Slot Mania</title>
  </head>
  <body>

    <h2>XP: <%= player.getXp() %>, Coins: <%= player.getCoins() %></h2>
	
	<% if (fSpinOK==true) { 
			if (spinResult.getCoins()>0) {
	%>
		<div class="wonspin">
			You WON <%=spinResult.getCoins() %> coins!
		</div>
			
	<%		} else if (spinResult.getCoins()==0) { %>
		<div class="lostspin">
			Spin again!
		</div>
	<% 		}
		} else  { %>
		<div class="nofunds">
		You have no coins!
		</div>
	<% } %>
	
		<div>
			Symbols:
			<ul>
				<% for (int symbol : spinResult.getSymbols()) { %>
					<li><%= symbol %></li>
				<% } %>
			</ul>
		</div>
	<% if (fSpinOK==true) { %>
	<div class="menu">
		<a href="<%= response.encodeURL("/spin.jsp?action=spin") %>">Bet 1!</a>
		<a style="margin-left:5px;" href="<%= response.encodeURL("/spin.jsp?action=maxspin") %>">Bet Max (<%= System.getProperty("max.bet.coins") %> coins)!</a>
	</div>
	<%} %>
		

	
    
     <div class="menu">
        <a href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a>
        <a href="<%= response.encodeURL("/") %>">Main</a>
    </div>

    
  </body>
</html>
