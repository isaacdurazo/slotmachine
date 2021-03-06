<%@ page import="com.solitude.slots.*" %>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <meta name="keywords" content="slotmachine,casino,prize,chat,android games,iphone games,mobile games,games,free,pics,photos,myspace"/>
    <meta name="description" content="Play Casino Games on your mobile phone. FREE game with prizes and millions of people online."/>
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
    					onSuccess: function(data) {
    						<% String inviteToken = (String)request.getSession().getAttribute("invite_token");
    						if (inviteToken == null) {
    							inviteToken = java.util.UUID.randomUUID().toString();
    							request.getSession().setAttribute("invite_token",inviteToken);
    						}
    						%>
    						window.location = '<%=ServletUtils.buildUrl(((com.solitude.slots.entities.Player)request.getAttribute("player")),"/wk/invite.jsp?action=inviteSent&token="+java.net.URLEncoder.encode(inviteToken,"UTF-8"),response)%>&count='+data.getData().length;
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
        <div class="wrapper <%= request.getAttribute("wrapperClass") != null ? request.getAttribute("wrapperClass") : ""%>">
            <div class="header">

                <a class="coins" accessKey="2" href="<%= ServletUtils.buildUrl(((com.solitude.slots.entities.Player)request.getAttribute("player")), "/wk/topup.jsp", response) %>">
                    <span class="icon-coin"></span>
                    <span id="player_coins" class="delay inline"><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getCoins() %></span>
                    <span class="plus">+</span>
                </a>   

                <span class="logo">
                    <img width="123" height="16" src="/wk/images/logo.gif"/>
                </span>

                <span class="level-xp">
                    <%--<span class="level"><b>Level:</b> <span id='level'><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getLevel() %></span></span>--%>
                    <span class="xp"><b>XP:</b> <span id="player_xp"><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getXp() %></span></span>
                </span>
            </div>
            
