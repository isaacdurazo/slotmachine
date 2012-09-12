<%@page import="com.sun.java_cup.internal.runtime.Symbol"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.solitude.slots.service.SlotMachineManager.InsufficientFundsException, java.util.Arrays" %>

<%
String action = request.getParameter("action");
SpinResult spinResult = new SpinResult(-1,new int[]{-1,-1,-1});
int symbol[];
boolean fSpinOK = false;
int setPlayingLevel = ServletUtils.getInt(request, "playingLevel");
if (setPlayingLevel > 0 && setPlayingLevel <= Integer.getInteger("max.player.level") && player.getLevel() >= setPlayingLevel) {
	player.setPlayingLevel(setPlayingLevel);
	PlayerManager.getInstance().storePlayer(player, true);
}
String reelImagePath = "/images/"+(player.getPlayingLevel() > 1 ? ("level-"+player.getPlayingLevel()+"/") : "");

try {
	if ("spin".equals(action)) {
		spinResult = SlotMachineManager.getInstance().spin(player, false);
	} else if ("maxspin".equals(action)) {
		spinResult = SlotMachineManager.getInstance().spin(player, true);
	}
	
	fSpinOK=true;
} catch (InsufficientFundsException ife) {
	//use redirect to ensure the logging works for topup impressions
	
	response.sendRedirect("/topup.jsp?notifymsg="+java.net.URLEncoder.encode("You need more coins to spin!","UTF-8"));
	return;
}
symbol= spinResult.getSymbols(); //always initialize so if fSpinOK flase still get valid symbols to display

java.util.List<Achievement> earnedAchievements = null;
if (action != null) {
	try {
		earnedAchievements = AchievementService.getInstance().grantAchievements(player, 
				AchievementService.Type.COIN_COUNT, AchievementService.Type.MAX_SPINS);	
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error granting achievements for "+player,e);
	}
}
int key = 1;

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>

		    <% if (coinsAwarded > 0) { %>
		    	<div class="bonus">
		    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
		    	</div> 
		    <% } %>

		    <% if (earnedAchievements != null && !earnedAchievements.isEmpty()) { %>
				<div class="achievements">
					<%
					int coinsEarned = 0;
					for (Achievement achievement : earnedAchievements) { coinsEarned += achievement.getCoinsAwarded(); }
					%>
					You earned <%= earnedAchievements.size() > 1 ? "an achievement" : "achievements" %> and <%= coinsEarned %> coins!
					<ul>
						<% for (Achievement achievement : earnedAchievements) { %>
						<li><%= achievement.getTitle() %></li>
						<% } %>
					</ul>
				</div>
			<% } %>

			<% if (spinResult.getLevelUp()) { %>
				<div class="level-up">
					<div class="goldtext">LEVEL UP!</div>
					<small>You unlocked a new slotmachine</small> <br/>
					<%= System.getProperty("level.name."+player.getLevel()) %> <br/>
					<div class="goldtext">Jackpot bonus 10%</div>
				</div>
			<% } %>
	
			<div class="location">
				<span><%= System.getProperty("level.name."+player.getPlayingLevel()) %></span>
				<a href="<%= ServletUtils.buildUrl(player, "/locations.jsp", response) %>">Change</a>
			</div>

			<div class="results">
			
				<% if (fSpinOK==true) {
					
					//only for maxspin give ability to win Moco Gold
					if ("maxspin".equals(action) && symbol[0]==0 && symbol[1]==0 && symbol[2]==0) {
				%>
					<div class="goldtext">
						You WON the Moco Gold<br />
						<img width="112" height="14" src="images/jackpot-winner.gif"/>
					</div>		
				<%		
					} else if (spinResult.getCoins()>0) {
				%>
					<div class="wonspin">
						<img width="13" height="11" src="images/animated-star.gif"/>WON <%=spinResult.getCoins() %> coins! <img width="13" height="11" src="images/animated-star.gif"/>
					</div>
						
				<%		} else if (spinResult.getCoins()==0) {
				String s = "Spin again!";	
				if (Arrays.equals(spinResult.getSymbols(), new int[]{6,6,6})) {
					s="Make lemonade :). Check the <a href=\"help.jsp\">payout table</a> for winnings!";
				}
				%>
					<div class="lostspin">
						<%=s %>
					</div>
				<% 		}
					} else  { %>
					<div class="nofunds">
					You have no coins!
					</div>
				<% } %>
			</div>
			
			<div class="spin-container">
				<table align="center" >
					<tr align="center" >
						<td>
							<img width="38" height="64" src="<%=reelImagePath+"comb-"+symbol[0] %>.gif"/>
						</td>
						<td>
							<img width="38" height="64" src="<%=reelImagePath+"comb-"+symbol[1] %>.gif"/>
						</td>
						<td>
							<img width="38" height="64" src="<%=reelImagePath+"comb-"+symbol[2] %>.gif"/>
						</td>
					</tr>
				</table>
			</div>	
			<% if (player.getGoldDebitted() == 0) { %>
				<div id="ad">
					<%@ include file="/mmad_wap.jsp" %>			
				</div>				
			<% } %>
			<% if (fSpinOK==true) { %>
			
			<table class="bets" align="center" >
				<tr>
					<td class="bet-1">
						<%= key %>.<a accessKey="<%= key++ %>" class="bet" href="<%= ServletUtils.buildUrl(player, "/spin.jsp?action=spin&"+cacheBuster, response) %>"> Bet 1</a>
					</td>
					<td class="bet-2">
						<%= key %>.<a accessKey="<%= key++ %>" class="bet" href="<%= ServletUtils.buildUrl(player, "/spin.jsp?action=maxspin&"+cacheBuster, response) %>"> Bet 3</a>
					</td>
				</tr>
			</table>
			<% } %>
		     <div class="menu">
		        <div><%= key %>. <a class="invite" accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/invite.jsp", response) %>">Invite Friends</a></div>
		        <div><%= key %>. <a accessKey="<%= key++ %>" href="<%= ServletUtils.buildUrl(player, "/index.jsp", response) %>">Main</a></div>
		    </div>
		</div>
	</div>
  </body>
</html>
