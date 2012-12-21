<%@ include file="/header.jsp" %>

<%
String action = request.getParameter("action");
String res="";

if (!"success".equals(action)) {
	request.getSession().setAttribute("invite", "true");
	response.sendRedirect(OpenSocialService.getInstance().getInviteRedirectUrl("confirmmsg=Invites%20Sent!",
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

		    <h1>Invite Friends</h1>
			<div>
				<%=res%>
			</div>
		    <div class="menu">
		        <div><a href="<%= ServletUtils.buildUrl(player, "/invite.jsp" ,response) %>">Invite More Friends</a></div>
		        <div><a href="<%= ServletUtils.buildUrl(player, "/index.jsp", response) %>">Main</a></div>
		    </div>
	    </div>
	</div>
</body>
</html>