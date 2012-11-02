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
    	<script src="http://cdn-img.mocospace.com/wk/js/opensocial/opensocial.js"></script>
    	<script type="text/javascript">
	    	document.addEventListener('DOMContentLoaded', function(e) {
	    		document.getElementById('invite').addEventListener('click', function(e) {
    				e.preventDefault();
    				try {_gaq.push(['_trackEvent', 'InviteInter', 'start']);} catch (err) {console.error(err);}
    				MocoSpace.inviteFriends({
    					subject:"Play SlotMania and win Moco Gold",
    					message:"Join me playing the new slot machine game on MocoSpace. I gave you 20 FREE coins to get started. Spin to win prices including Moco Gold!",
    					url_link:"if=<%= request.getSession().getAttribute("playerId") %>",
    					onSuccess: function(data) { 
    	    				try {
    	    					_gaq.push(['_trackEvent', 'InviteInter', 'sent', data.getData().length > 5 ? 'success' : 'failure', data.getData().length]);
    	    					console.error("InviteInter len="+data.getData().length+" ids=",data.getData());
    	    					} catch (err) {console.error(err);}
    						window.location = '<%=ServletUtils.buildUrl(player,"/wk/force_invite.jsp?action=inviteSent&token="+java.net.URLEncoder.encode(validationToken,"UTF-8"),response)%>&count='+data.getData().length;
    					},
    					uninstalledOnly : true});
    			}, false);
	    	});
    	</script>
	</head>
	<body>
		<div class="wrapper">
			<div class="dialog-container" style="padding: 25px 10px 5px;">
				
					<% if (message == null) { %>
						<h2>Get <span class="goldtext">50 coins</span> NOW by inviting 5 friends to SlotMania!</h2>
						<p>This limited offer is only valid for the next 1 min. You must invite friends to get coins.</p>
					<% } else { out.write(message); } %>
				
				<div class="menu">
					<div class="button-row">
						
						<table>
							<tr>
								<td></td>
								<td></td>
							</tr>	
						</table>

						<% if (!inviteSuccessful) { %>
						<a style="width: 45%; font-size: 1em;" href="#" id="invite">
							Invite Friends
						</a>
						<% } %>
						<a style="width: 45%; font-size: 1em;" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp"+(inviteSuccessful?"":((request.getQueryString() == null ? "" : ("?"+request.getQueryString())))), response) %>">
							Continue
						</a>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="/wk/ga.jsp" %>		
	</body>
</html>