<%@ include file="/header.jsp" %>
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
	<%}
    String reelImagePath = "images/individual/"+(player.getPlayingLevel() > 1 ? ("level-"+player.getPlayingLevel()+"/") : "");
    
    String icon[][] = {
    		{	
    			"images/individual/diamond.gif",
    			"images/individual/seven.gif",
    			"images/individual/bar.gif",
    			"images/individual/bell.gif",
    			"images/individual/watermelon.gif",
    			"images/individual/cherry.gif"
    		},
    		{
    			"images/individual/level-2/sack.gif",
    			"images/individual/level-2/badge.gif",
    			"images/individual/level-2/hat.gif",
    			"images/individual/level-2/boot.gif",
    			"images/individual/level-2/horseshoe.gif",
    			"images/individual/level-2/skull.gif"
    			
    		},
    		{
    			"images/individual/level-3/treasure.gif",
    			"images/individual/level-3/pearl.gif",
    			"images/individual/level-3/trident.gif",
    			"images/individual/level-3/pink-shell.gif",
    			"images/individual/level-3/star.gif",
    			"images/individual/level-3/orange-shell.gif"
    
    		},
    		{
    			"images/individual/level-4/coins.gif",
    			"images/individual/level-4/pyramid.gif",
    			"images/individual/level-4/parakeet.gif",
    			"images/individual/level-4/palm.gif",
    			"images/individual/level-4/flower.gif",
    			"images/individual/level-4/bananas.gif",
    		}
    };
    int winmax[][] = {
    		{ 500,150,50,20,15,10,5,2}
    };
    /*,
    		{ 3000,900,300,120,90,60,30,12},
    		{ 4000,1200,400,160,120,80,40,16},
    		{ 4500,1350,450,180,135,90,45,18}
    };*/
    int multiplier = Integer.getInteger("level.max.bet.multiplier."+player.getPlayingLevel());
    %>
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
					<li><b>Weekly</b> <span class="goldtext">Gold Jackpot.</span> Now: <span class="goldtext"><%=player.getMocoGoldPrize()%> Gold</span> <img class="icon" alt="gold" src="/images/mocogold.gif"></li><br />
					<li><b>Mega Coin Prize:</b> Gain XP with every spin and compete to be #1 on leaderboard. Every sunday midnight #1 wins <%=System.getProperty("game.weekly.coin.prize") %> coins.</li><br />
					<li><b>Daily free coins:</b> FREE coins award when you play daily.</li><br />
					<li><b>Payout:</b> Check the payout table for spin payouts.</li>
				</ul>
			</div>

			<div class="play">
		       	<a accessKey="1" href="<%= response.encodeURL("/wk/spin.jsp") %>">Start Playing</a>
		    </div>
			Location: <%= System.getProperty("level.name."+player.getPlayingLevel()) %>

			<div class="payout-table">
				<div style="text-align: center">Payout Table Bet 1 Coin:</div>
			<table>
				<tr>
					<td>
						3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][0] %>"/>: <%=winmax[0][0] %> <br/>
					</td>
					<td>
						3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][1] %>"/>:  <%=winmax[0][1] %> <br/>
					</td>
					<td>
						3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][2] %>"/>:  <%=winmax[0][2] %> <br/> 
					</td>
					<td>
						3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][3] %>"/>:  <%=winmax[0][3] %> <br/>
					</td>
				</tr>
				<tr>
					<td>
						3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][4] %>"/>:  <%=winmax[0][4] %> <br/>
					</td>
					<td>
						3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][5] %>"/>:  <%=winmax[0][5] %> <br/>
					</td>
					<td>
						2x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][5] %>"/>:  <%=winmax[0][6] %> <br/>
					</td>
					<td>
						1x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][5] %>"/>:  <%=winmax[0][7] %> <br/> 
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
							3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][0] %>"/>: <img class="icon"  alt="gold" src="/images/mocogold.gif"> <span class="goldtext">*Jackpot*</span> <br/>
						</td>
						<td>
							3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][1] %>"/>: <%=winmax[0][1]*multiplier %>  <br/>
						</td>
						<td>
							3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][2] %>"/>: <%=winmax[0][2]*multiplier %>  <br/> 
						</td>
						<td>
							3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][3] %>"/>: <%=winmax[0][3]*multiplier %>  <br/>
						</td>
					</tr>
					<tr>
						<td>
							3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][4] %>"/>: <%=winmax[0][4]*multiplier %>  <br/>
						</td>
						<td>
							3x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][5] %>"/>: <%=winmax[0][5]*multiplier %>  <br/>
						</td>
						<td>
							2x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][5] %>"/>: <%=winmax[0][6]*multiplier %>  <br/>
						</td>
						<td>
							1x <img width="16" height="16" src="<%=icon[player.getPlayingLevel()-1][5] %>"/>: <%=winmax[0][7]*multiplier %>  <br/> 
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