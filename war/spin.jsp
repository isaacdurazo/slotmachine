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
	fSpinOK=false;
}

symbol= spinResult.getSymbols(); //always initialize so if fSpinOK flase still get valid symbols to display


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
