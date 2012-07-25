<%@ include file="header.jsp" %>
<!-- 
invites sent with param if=<moco uid of sender> so we can grant coins when new players install from an invite

 -->

<%
String action = request.getParameter("action");
String res="";

if (!"success".equals(action)) {
	response.sendRedirect(OpenSocialService.getInstance().getInviteRedirectUrl("action=success","sub","body", null,
			"if="+player.getMocoId(), null));
	return;
} else {
	res="You sent x invites";
	
}

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Invite Friends</title>
<link rel="stylesheet" href="css/wap.css" />    
</head>
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