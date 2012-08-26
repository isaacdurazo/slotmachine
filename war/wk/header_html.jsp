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
