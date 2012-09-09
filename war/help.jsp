<%@ include file="header_static.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page import="com.solitude.slots.*" %>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<meta name="keywords" content="slotmachine,casino,prize,chat,android games,iphone games,mobile games,games,free,pics,photos,myspace"/>
	<meta name="description" content="Play Casino Games on your mobile phone. FREE game with prizes and millions of people online."/>

    
    <title>Slot Mania</title>
    <% 
    // @todo fix this hack - GAE will not compile the jsp if I just use isWebkit here...
    if (ServletUtils.isWebKitDevice(request)) {%>
    <link rel="stylesheet" href="/wk/css/webkit.css" />
    <script src="http://cdn-img.mocospace.com/wk/js/opensocial/opensocial.js"></script>
    <script type="text/javascript">
    	document.addEventListener('DOMContentLoaded', function(e) {
    		var inviteLink = document.querySelector('.invite'),
    			leaderboardLink = document.querySelector('.leaderboard');
    		if (inviteLink) {
    			inviteLink.addEventListener('click', function(e) {
    				e.preventDefault();
    				
    				MocoSpace.inviteFriends({
    					subject:"Play SlotMania and win Moco Gold",
    					message:"Join me playing the new slot machine game on MocoSpace. I gave you 20 FREE coins to get started. Spin to win prices including Moco Gold!",
    					url_link:"if=<%= request.getSession().getAttribute("playerId") %>"
    				});
    			}, false);
    		}
    		if (leaderboardLink) {
    			leaderboardLink.addEventListener('click', function(e) {
    				e.preventDefault();
    				MocoSpace.showLeaderboardList();
    			}, false);
    		}
    	}, false);
    </script>    
	<% } else { %>
    <link rel="stylesheet" href="css/wap.css" />    
	<%} %>
  </head>
  <body>
    <div id="container">
        <div class="wrapper">
            <div class="header-logo"><img width="112" height="18" src="images/logosmall.gif"/></div>
   
			   		<div class="secondary-header">The best way to WIN <span class="goldtext">Moco Gold</span>.</div>
			    </div>
				<%@ include file="message.jsp" %>		    
			    <div>Play slots, have fun and win prizes:</div><br />
				<ul  class="list">
					<li><b>Weekly</b> <span class="goldtext">Gold Jackpot.</span> Now: <span class="goldtext"><%=GameUtils.getGlobalProps().getMocoGoldPrize()%> Gold</span> <img class="icon" alt="gold" src="/images/mocogold.gif"></li><br />
					<li><b>Mega Coin Prize:</b> Gain XP with every spin and compete to be #1 on leaderboard. Every sunday midnight #1 wins <%=System.getProperty("game.weekly.coin.prize") %> coins.</li><br />
					<li><b>Daily free coins:</b> FREE coins on your <b>first</b> login each calendar day.</li><br />
					<li><b>Payout:</b> Check the payout table for spin payouts.</li>
				</ul>
				<div class="menu">
			       	<div>1. <a accessKey="1" href="<%= ServletUtils.buildUrl(null, "/index.jsp", response) %>">Start Play</a></div>
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
			       	<div><a href="<%= ServletUtils.buildUrl(null, "/index.jsp", response) %>">Main Page</a></div>
			    </div>
			</div>
	</div>
</body>
</html>