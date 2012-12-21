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
%>
<html>
	<head>
		<link rel="stylesheet" href="/css/wap.css" />
	</head>
	<body>
		<div class="wrapper">
			<div class="dialog-container" style="padding: 25px 10px 5px;">
				
				<h2>SlotMania offer: Get <span class="goldtext">20 coins</span> NOW!</h2>
				<p>You must invite 5 or more friends *now* to get your 20 coins.</p>
				
				<div class="menu">
					<div class="button-row">
						
						<table>
							<tr>
								<td></td>
								<td></td>
							</tr>	
						</table>

						1. <a accessKey="1" style="width: 45%; font-size: 1em;" href="<%= OpenSocialService.getInstance().getInviteRedirectUrl("confirmmsg=Invites%20Sent!",
								"Play SlotMania and win Moco Gold",
								"I gave you 20 FREE coins to get started. Claim then NOW and join me to win prices including Moco Gold!", null,
								java.net.URLEncoder.encode("if="+player.getMocoId()+"&token="+java.net.URLEncoder.encode(validationToken,"UTF-8"),"UTF-8"), null) %>" id="invite">
							Get coins
						</a><br/>
						2. <a accessKey="2" style="width: 45%; font-size: 1em;" href="<%= ServletUtils.buildUrl(player, "/spin.jsp"+(request.getQueryString() == null ? "" : ("?"+request.getQueryString())), response) %>">
							Continue
						</a>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="/wk/ga.jsp" %>		
	</body>
</html>