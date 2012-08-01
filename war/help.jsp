<%@ include file="header_static.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
<body>
	<div id="container">
			<div class="wrapper">
				 <div class="header-logo">
			    	<img width="103" height="18" src="images/logo.gif"/>
			   		<h3>The best way to WIN Moco Gold.</h3>
			    </div>
<%@ include file="message.jsp" %>		    
			    <div>Play slots, win coins and spin to win the <span class="goldtext">Moco Gold Jackpot</span></div>
				<ul  class="list">
					<li>Weekly <span class="goldtext">Gold Jackpot.</span> Value now: 333 Gold <img class="icon" alt="gold" src="/images/mocogold.gif"></li><br />
					<li> Mega Coin Prize: Build XP as you spin and become #1 on leaderboard. Every sunday midnight #1 wins <%=System.getProperty("weekly.coin.prize") %> coins.</li><br />
					<li>Daily free coins: Play daily and get extra free coins to spin.</li><br />
					<li>Payout: Check the payout table to see spin payouts.</li>
				</ul>
				<div class="menu">
			       	<div>1. <a accessKey="1" href="<%= response.encodeURL("/") %>">Start Play</a></div>
			    </div>
				<div class="payout-table">
					<div style="text-align: center">Payout Table<br/> Bet 1 Coin:</div>
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
				<div class="payout-table border-bottom">
					<div>
					<div style="text-align: center">Payout Table<br/> Bet Max Coins:</div>
						3x <img width="16" height="16" src="images/individual/diamond.gif"/>: <img class="icon"  alt="gold" src="/images/mocogold.gif"> <span class="goldtext">*Jackpot*</span><br/>
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