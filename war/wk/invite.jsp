<%@ include file="/header.jsp" %>

<%
String res="";
String validationToken = request.getParameter("token");
if (!player.hasAdminPriv() && (validationToken == null || !validationToken.equals(request.getSession().getAttribute("invite_token")))) {
	response.sendRedirect(ServletUtils.buildUrl(player,"/",response));
	return;
}
String message = null;
boolean inviteSuccessful = false;
if ("inviteSent".equals(request.getParameter("action"))) {
	int invitedCount = ServletUtils.getInt(request,"count");
	request.getSession().removeAttribute("invite_token");
	inviteSuccessful = true;
	res = "Invite sent";
	player.incrementNumInvitesSent(invitedCount);
	PlayerManager.getInstance().storePlayer(player);
	java.util.List<Achievement> earnedAchievements = AchievementService.getInstance().grantAchievements(player,AchievementService.Type.INVITE);
	if (earnedAchievements != null && !earnedAchievements.isEmpty()) {
		int earnedCoins = 0;
		for (Achievement achievement : earnedAchievements) {
			earnedCoins += achievement.getCoinsAwarded();
		}
		res += ". You completed "+earnedAchievements.size()+" invite achievement"+
			(earnedAchievements.size()==1?"":"s")+" and earned "+earnedCoins+" coins!";
	}
}

String action = request.getParameter("action");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
<body>
    <h1>Invite Friends</h1>
	<div>
		<%=res%>
	</div>
    <div class="menu">
        <div><a href="<%= ServletUtils.buildUrl(player, "/invite.jsp", response) %>">Invite More Friends</a></div>
        <div><a href="<%= ServletUtils.buildUrl(player, "/index.jsp", response) %>">Main</a></div>
    </div>
</body>
</html>