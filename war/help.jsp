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
<%@ include file="message.jsp" %>		    
			    <h2>Play Slots and WIN prices:</h2>
				<ul  class="list">
					<li><div class="goldtext">Moco Gold Prize:</div> Weekly progressive <img alt="gold" src="/images/mocogold.gif"> Gold jackpot. The more you spin the higher chance you win!</li><br />
					<li><b>Mega Coin Prize</b>: Build XP as you spin. Every Sunday midnight #1 on XP leaderboard wins <%=System.getProperty("weekly.coin.prize") %> coins.</li><br />
					<li><b>FREE coins</b>: Play every day and get free coins!</li>
				</ul>
				<div class="menu">
			       	<div>1. <a accessKey="1" href="<%= response.encodeURL("/") %>">Start Play</a></div>
			    </div>
				<div class="payout-table">
					<h2 style="text-align: center">Payout Table<br/> Bet 1 Coin:</h2>
					<div>
						3x <img width="16" height="16" src="images/individual/diamond.gif"/>: 500 <br/>
						3x <img width="16" height="16" src="images/individual/seven.gif"/>: 150 <br/>
						3x <img width="16" height="16" src="images/individual/bar.gif"/>: 50 <br/> 
						3x <img width="16" height="16" src="images/individual/bell.gif"/>: 20 <br/>
						3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 15 <br/>
						3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 10 <br/>
						2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 5 <br/>
						1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 2 <br/> 
					</div>
				</div>
				<div class="payout-table">
					<div>
					<h2 style="text-align: center">Payout Table<br/> Bet Max Coins:</h2>
						3x <img width="16" height="16" src="images/individual/diamond.gif"/>:
						 <div class="goldtext"><img alt="gold" src="/images/mocogold.gif"> *Jackpot*</div>
						3x <img width="16" height="16" src="images/individual/seven.gif"/>: 600 <br/>
						3x <img width="16" height="16" src="images/individual/bar.gif"/>: 200 <br/> 
						3x <img width="16" height="16" src="images/individual/bell.gif"/>: 80 <br/>
						3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 60 <br/>
						3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 40 <br/>
						2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 20 <br/>
						1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 8 <br/> 
					</div>
				</div>
				<div class="menu">
			       	<div><a href="<%= response.encodeURL("/") %>">Main Page</a></div>
			    </div>
			</div>
	</div>
</body>
</html>