<%@ include file="/header.jsp" %>
<%
String validationToken = request.getParameter("token");
if (!player.hasAdminPriv() && (validationToken == null || !validationToken.equals(request.getSession().getAttribute("force-invite-token")))) {
	response.sendRedirect(ServletUtils.buildUrl(player,"/",response));
	return;
}
if (validationToken == null && player.hasAdminPriv()) {
	// for testing
	request.getSession().setAttribute("seenInvite",true);
	validationToken = java.util.UUID.randomUUID().toString();
	request.getSession().setAttribute("force-invite-token",validationToken);
}
String message = null;
boolean inviteSuccessful = false;
if ("inviteSent".equals(request.getParameter("action"))) {
	int invitedCount = ServletUtils.getInt(request,"count");
	if (invitedCount < 5) {
		message = "You must select more than 5 friends!  Please try again.";
	} else {
		request.getSession().removeAttribute("force-invite-token");
		inviteSuccessful = true;
		message = "You have been awarded 50 coins!  Click continue to spin";
		player.setCoins(player.getCoins()+50);
		PlayerManager.getInstance().storePlayer(player);
	}
}
%>
<html>
	<head>
		<link rel="stylesheet" href="/wk/css/webkit.css" />
    	<link href='http://fonts.googleapis.com/css?family=Electrolize' rel='stylesheet' type='text/css'>
    	<script type="text/javascript">
	    	document.addEventListener('DOMContentLoaded', function(e) {
	    		document.getElementById('invite').addEventListener('click', function(e) {
    				e.preventDefault();
    				try {_gaq.push(['_trackEvent', 'InviteInter', 'start']);} catch (err) {console.error(err);}
    				MocoSpace.inviteFriends({
    					subject:"Play SlotMania and win Moco Gold",
    					message:"Join me playing the new slot machine game on MocoSpace. I gave you 20 FREE coins to get started. Spin to win prices including Moco Gold!",
    					url_link:"if=<%= request.getSession().getAttribute("playerId") %>",
    					onSuccess: function(ids) { 
    	    				try {_gaq.push(['_trackEvent', 'InviteInter', 'sent', ids.length > 5 ? 'success' : 'failure', ids.length]);} catch (err) {console.error(err);}
    						window.location = '<%=ServletUtils.buildUrl(player,"/wk/force_invite.jsp?action=inviteSent&token="+java.net.URLEncoder.encode(validationToken,"UTF-8"),response)%>&count='+ids.length;
    					}
    				});
    			}, false);
	    	});
    	</script>
	</head>
	<body>
		<div class="wrapper">
			<div>
				<% if (message == null) { %>
					Get 50coins NOW by inviting 5 friends to SlotMania!
					<small>This limited offer only valid next 1min. You must invite friends to get coins</small>
				<% } else { out.write(message); } %>
			</div>
			<div class="menu">
				<div class="button-row">
					<% if (!inviteSuccessful) { %>
					<a style="padding: 3px;margin-top: 100px;width: 30%;" href="#" id="invite">
						Invite Friends
					</a>
					<% } %>
					<a style="padding: 3px;margin-top: 100px;width: 30%;" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp"+(request.getQueryString() == null ? "" : ("?"+request.getQueryString())), response) %>">
						Continue
					</a>
				</div>
			</div>
		</div>
		<%@ include file="/wk/ga.jsp" %>		
	</body>
</html>