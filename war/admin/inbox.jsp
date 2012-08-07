<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*, com.google.appengine.api.taskqueue.QueueFactory, com.google.appengine.api.taskqueue.TaskOptions" %>

<% 
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
if (request.getParameter("accessToken") != null) player = PlayerManager.getInstance().getPlayer(request.getParameter("accessToken"));
else if (playerId != null) player = PlayerManager.getInstance().getPlayer(playerId);
if (player == null || !player.hasAdminPriv()) { 
	pageContext.forward("/");
	return;
}

String subject = request.getParameter("subject");
String message = request.getParameter("message");
String action = request.getParameter("action");
if ("send".equals(action)) {	
	if (subject == null || message == null) {
		out.write("Message and subject required!");
		return;
	}
	TaskOptions task = TaskOptions.Builder.withUrl("/admin/inbox.jsp");
	task.param("subject", subject);
	task.param("message", message);
	task.param("action", "queue");
	task.param("accessToken", GameUtils.getGameAdminToken());
	QueueFactory.getQueue("inbox").add(task);	
	out.write("Message queued!");
	return;
} else if ("queue".equals(action)) {
	java.util.List<Player> players = PlayerManager.getInstance().getRecentPlayers(3*24, 50000);
	Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Sending inbox to "+players.size()+" players");
	for (Player currPlayer : players) {
		try {
			OpenSocialService.getInstance().sendNotification(currPlayer.getMocoId(), subject, message);
		} catch (Exception e) {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error sending inbox to player: "+player,e);
		}
	}
	return;
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Inbox Utility</title>
	</head>
	<body>
		<h1>Inbox Utility</h1>	
		<p>Will send message to max 50,000 users who played in the last 3 days</p>	
		<form action="/admin/inbox.jsp" method="POST">
			<input type="hidden" name="action" value="send"></input>
			<label for="key">Subject</label>
			<input type="text" name="subject"></input><br/>
			<label for="message">Message</label>
			<textarea rows="3" cols="200" name="message"></textarea>
			<input type="submit" value="send"></input>
		</form>		
	</body>
</html>