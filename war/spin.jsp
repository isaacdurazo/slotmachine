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
<%@ include file="header_html.jsp" %>
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
			
			<div class="results">
			<% if (fSpinOK==true) {
				
				//only for maxspin give ability to win Moco Gold
				if ("maxspin".equals(action) && symbol[0]==0 && symbol[1]==0 && symbol[2]==0) {
			%>
				<div class="wonspin">
					You WON the Moco Gold JACKPOT!!!
				</div>	
			<%		
				} else if (spinResult.getCoins()>0) {
			%>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<div class="wonspin">
					You WON <%=spinResult.getCoins() %> coins!
				</div>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
				<img width="6" height="6" src="images/light-1.gif"/>
				<img width="6" height="6" src="images/light-2.gif"/>
					
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
			</div>
			
				<table>
					<tr align="center" >
						<td>
							<img width="38" height="64" src="<%=imageLocation+"comb-"+symbol[0] %>.gif"/>
						</td>
						<td>
							<img width="38" height="64" src="<%=imageLocation+"comb-"+symbol[1] %>.gif"/>
						</td>
						<td>
							<img width="38" height="64" src="<%=imageLocation+"comb-"+symbol[2] %>.gif"/>
						</td>
					</tr>
				</table>
			<% if (fSpinOK==true) { %>
			
			<table class="bets">
				<tr>
					<td class="bet-1">
						<%= key %>.<a accessKey="<%= key++ %>" class="bet" href="<%= response.encodeURL("/spin.jsp?action=spin&"+cacheBuster) %>"> Bet 1</a>
					</td>
					<td class="bet-2">
						<%= key %>.<a accessKey="<%= key++ %>" class="bet" href="<%= response.encodeURL("/spin.jsp?action=maxspin&"+cacheBuster) %>">Bet 3</a>
					</td>
				</tr>
			</table>
			<% } %>
				
		
			
		    
		     <div class="menu">
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a></div>
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= response.encodeURL("/") %>">Main</a></div>
		    </div>
		</div>
	</div>
  </body>
</html>
