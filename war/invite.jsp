<%@ include file="header.jsp" %>
<!-- 
invites sent with param if=<moco uid of sender> so we can grant coins when new players install from an invite

 -->

<%
String action = request.getParameter("action");
String res="";

if (!"success".equals(action)) {
	response.sendRedirect(OpenSocialService.getInstance().getInviteRedirectUrl("confirmmsg=Sent%20Invites",
			"Play SlotMania and win Moco Gold",
			"Join me playing the new slot machine game on MocoSpace. I gave you 20 FREE coins to get started. Spin to win prices including Moco Gold!", null,
			"if="+player.getMocoId(), null));
	return;
} else {
	res="You sent x invites";
	
}

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
<body>
    <h1>Invite Friends</h1>
	<div>
		<%=res%>
	</div>
    <div class="menu">
        <div><a href="<%= response.encodeURL("/invite.jsp") %>">Invite More Friends</a></div>
        <div><a href="<%= response.encodeURL("/") %>">Main</a></div>
    </div>
</body>
</html>