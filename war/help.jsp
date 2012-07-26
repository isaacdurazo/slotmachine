<%@ include file="header_static.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
<body>
	<div id="container">
			<div class="wrapper">
				 <div class="header-logo">
			   		<h3>About</h3>
			    	<img width="103" height="18" src="images/logo.gif"/>
			    </div>
			    <div>Play Slots for FREE and win weekly prices:</div>
				<ul  class="list">
					<li>Return every day for <b>FREE</b> coins and spin to win!</li><br />
					<li><b>Weekly Coin Prize:</b> Gain XP as you play and become #1 on the weekly XP leaderboard to win <%=System.getProperty("weekly.coin.prize") %> coins.</li><br />
					<li><b>Weekly Moco Gold JACKPOT:</b>Every week chance to win the <b>Moco Gold jackpot</b>. The more you spin the more likely you win!</li><br />
				</ul>
				
				<div class="payout-table">
					<div>Payout Table</div>
					<div class="payout-table">
						3x <img width="16" height="16" src="images/individual/diamond.gif"/>: 500 <br/>
						3x <img width="16" height="16" src="images/individual/seven.gif"/>: 100 <br/>
						3x <img width="16" height="16" src="images/individual/bar.gif"/>: 50 <br/> 
						3x <img width="16" height="16" src="images/individual/bell.gif"/>: 20 <br/>
						3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 15 <br/>
						3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 10 <br/>
						2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 5 <br/>
						1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 2 <br/> 
					</div>
				</div>
				<div class="menu">
			    	<div>1. <a accessKey="1" href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a><br/></div>
			       	<div>2. <a accessKey="2" href="<%= response.encodeURL("/") %>">Main</a></div>
			    </div>
			</div>
	</div>
</body>
</html>