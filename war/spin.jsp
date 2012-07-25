<%@page import="com.sun.java_cup.internal.runtime.Symbol"%>
<%@ include file="header.jsp" %>
<%@ page import="com.solitude.slots.service.SlotMachineManager.InsufficientFundsException" %>
 

<%
String action = request.getParameter("action");
SpinResult spinResult = new SpinResult(-1,new int[]{-1,-1,-1});
int symbol[];
boolean fSpinOK = false;

try {
	if ("spin".equals(action)) {
		spinResult = SlotMachineManager.getInstance().spin(player, 1);
	} else if ("maxspin".equals(action)) {
		spinResult = SlotMachineManager.getInstance().spin(player, Integer.parseInt(System.getProperty("max.bet.coins")));
	}
	
	fSpinOK=true;
} catch (InsufficientFundsException ife) {
	pageContext.forward("/topup.jsp?message="+java.net.URLEncoder.encode("You need more coins!","UTF-8"));
	return;
}

symbol= spinResult.getSymbols(); //always initialize so if fSpinOK flase still get valid symbols to display
int key = 1;
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
				<table>
					<tr align="center" >
						<td>
							<img width="38" height="64" src="images/comb-<%=symbol[0] %>.gif"/>
							<br/>(<%=symbol[0] %>)
						</td>
						<td>
							<img width="38" height="64" src="images/comb-<%=symbol[1] %>.gif"/>
							<br/>(<%=symbol[1] %>)
						</td>
						<td>
							<img width="38" height="64" src="images/comb-<%=symbol[2] %>.gif"/>
							<br/>(<%=symbol[2] %>)
						</td>
					</tr>
				</table>
				</div>
			<% if (fSpinOK==true) { %>
			
			<div class="bets">
				<div>
					<%= key %>. <a accessKey="<%= key++ %>" class="bet" href="<%= response.encodeURL("/spin.jsp?action=spin") %>">Bet 1!</a>
				</div>
				<div>
					<%= key %>. <a accessKey="<%= key++ %>" class="bet" href="<%= response.encodeURL("/spin.jsp?action=maxspin") %>">Bet Max (<%= System.getProperty("max.bet.coins") %> coins)!</a>
				</div>
			</div>
			<%} %>
				
		
			
		    
		     <div class="menu">
		        <%= key %>. <a accessKey="<%= key++ %>" href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a><br/>
		        <%= key %>. <a accessKey="<%= key++ %>" href="<%= response.encodeURL("/") %>">Main</a>
		    </div>
		</div>
	</div>
  </body>
</html>
