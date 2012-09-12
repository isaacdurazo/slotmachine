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
        <div class="wrapper <%= request.getAttribute("wrapperClass") != null ? request.getAttribute("wrapperClass") : ""%>">
            <div class="header-logo">
                <table align="center">
                    <tr><td><img width="112" height="18" src="images/logosmall.gif"/></td></tr>
                </table>
                <% if (((com.solitude.slots.entities.Player)request.getAttribute("player")) != null) { %>
                <table class="subheader">
                    <tr>
                        <td class="coins">
                            <b>Coins:</b><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getCoins() %>
                        </td>
                        
                        <td class="xp" style="red">
                            <b>XP:</b><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getXp() %>
                        </td>

                        <td class="level">
                            <b>Level:</b> <%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getLevel() %>
                        </td>
                    </tr>
                </table>
                <% } %>
            </div>
            
            