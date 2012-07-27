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
			    <% if (request.getParameter("msg")!=null) { %>
			    <div class="notify"> <%=request.getParameter("msg") %>
			    </div>
			    <%} %>
			    <div>Play Slots and WIN prices:</div>
				<ul  class="list">
					<li><b>FREE coins</b>: Return daily to get more free coins!</li><br />
					<li><b>Mega Coin Prize</b>: Gain XP as you spin. Become #1 on the weekly XP leaderboard to win <%=System.getProperty("weekly.coin.prize") %> coins.</li><br />
					<li><b>Gold JACKPOT</b>: Weekly progressive Moco Gold jackpot. Currently: <%=System.getProperty("weekly.mocogold.min.prize") %> <img alt="gold" src="/images/mocogold.gif">. The more you spin the more likely you win!</li><br />
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
			       	<div>1. <a accessKey="1" href="<%= response.encodeURL("/") %>">Main Page</a></div>
			    </div>
			</div>
	</div>
</body>
</html>