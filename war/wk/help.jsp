<%@ include file="header_static.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page import="com.solitude.slots.*" %>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Slot Mania</title>
    <% 
    // @todo fix this hack - GAE will not compile the jsp if I just use isWebkit here...
    if (ServletUtils.isWebKitDevice(request)) {%>
    <link rel="stylesheet" href="/wk/css/webkit.css" />
    <link href='http://fonts.googleapis.com/css?family=Electrolize' rel='stylesheet' type='text/css'>
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
    					url_link:"if=<%= request.getSession().getAttribute("playerId") %>",
    					onSuccess: function(ids) {
    						<% String inviteToken = (String)request.getAttribute("invite_token");
    						if (inviteToken == null) {
    							inviteToken = java.util.UUID.randomUUID().toString();
    							request.setAttribute("invite_token",inviteToken);
    						}
    						%>
    						window.location = "/wk/index.jsp?action=inviteSent&count="+ids.length+"&token=<%= java.net.URLEncoder.encode(inviteToken,"UTF-8") %>"+ids.length;
    					}
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
    <link rel="stylesheet" href="css/webkit.css" />    
	<%} %>
</head>

<body>
	<div id="container">
		<div class="wrapper">
			<div class="header">
                <span class="logo">
                    <img width="123" height="16" src="/wk/images/logo.gif"/>
                </span>
        	</div>
        </div>

		<div class="content">
    		<div class="stats-container">
		   		<table class="stats">
		   			<tr>
		   				<td>
							<span class="stat">
		   						The best way to WIN <span class="goldtext">Moco Gold</span>
		   					</span>
		   				</td>
		   			</tr>
		   		</table>
	   		</div>
			<%@ include file="message.jsp" %>

		    <div class="subheader">Play slots, have fun and win prizes:</div>

			<div class="list-container">
				<ul  class="list">
					<li><b>Weekly</b> <span class="goldtext">Gold Jackpot.</span> Now: <span class="goldtext"><%=GameUtils.getGlobalProps().getMocoGoldPrize()%> Gold</span> <img class="icon" alt="gold" src="/images/mocogold.gif"></li><br />
					<li><b>Mega Coin Prize:</b> Gain XP with every spin and compete to be #1 on leaderboard. Every sunday midnight #1 wins <%=System.getProperty("game.weekly.coin.prize") %> coins.</li><br />
					<li><b>Daily free coins:</b> FREE coins on your <b>first</b> login each calendar day.</li><br />
					<li><b>Payout:</b> Check the payout table for spin payouts.</li>
				</ul>
			</div>

			<div class="play">
		       	<a accessKey="1" href="<%= response.encodeURL("/wk/spin.jsp") %>">Start Playing</a>
		    </div>

			<div class="payout-table">

				<div style="text-align: center">Payout Table Bet 1 Coin:</div>

				<table>
					<tr>
						<td>
							3x <img width="16" height="16" src="images/individual/diamond.gif"/>: 500 <br/>
						</td>
						<td>
							3x <img width="16" height="16" src="images/individual/seven.gif"/>: 150 <br/>
						</td>
						<td>
							3x <img width="16" height="16" src="images/individual/bar.gif"/>: 50 <br/> 
						</td>
						<td>
							3x <img width="16" height="16" src="images/individual/bell.gif"/>: 20 <br/>
						</td>
					</tr>
					<tr>
						<td>
							3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 15 <br/>
						</td>
						<td>
							3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 10 <br/>
						</td>
						<td>
							2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 5 <br/>
						</td>
						<td>
							1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 2 <br/> 
						</td>
					</tr>
				</table>

			</div>
		</div>

		<div class="payout-table border-bottom">

			<div style="text-align: center">Payout Table Bet Max Coins:</div>

			<table>
				<tr>
					<td>
						3x <img width="16" height="16" src="images/individual/diamond.gif"/>: <img class="icon"  alt="gold" src="/images/mocogold.gif"> <span class="goldtext">*Jackpot*</span><br/>
					</td>
					<td>
						3x <img width="16" height="16" src="images/individual/seven.gif"/>: 600 <br/>
					</td>
					<td>
						3x <img width="16" height="16" src="images/individual/bar.gif"/>: 200 <br/> 
					</td>
					<td>
						3x <img width="16" height="16" src="images/individual/bell.gif"/>: 80 <br/>
					</td>
				</tr>
				<tr>
					<td>
						3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 60 <br/>
					</td>
					<td>
						3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 40 <br/>
					</td>
					<td>
						2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 20 <br/>
					</td>
					<td>
						1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 8 <br/> 
					</td>
				</tr>
			</table>

		</div>


	    <div class="menu" style="margin-right: 16px;">
	       	<a href="<%= response.encodeURL("/wk/index.jsp") %>">Main</a>
  		</div>

	</div>


	<%@ include file="/wk/ga.jsp" %>
</body>
</html>