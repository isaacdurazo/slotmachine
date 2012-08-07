<%@ page import="java.net.URLEncoder,java.net.URLDecoder,com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*,com.google.appengine.api.taskqueue.QueueFactory,com.google.appengine.api.taskqueue.TaskOptions" %>

<%
	Long playerId = (Long) request.getSession().getAttribute("playerId");
	Player player = null;
	if (request.getParameter("accessToken") != null)
		player = PlayerManager.getInstance().getPlayer(request.getParameter("accessToken"));
	else if (playerId != null)
		player = PlayerManager.getInstance().getPlayer(playerId);
	if (player == null || !player.hasAdminPriv()) {
		pageContext.forward("/");
		return;
	}

	//default values
	int days=3;
	int max=50000;

	String subject = request.getParameter("subject");
	String message = request.getParameter("message");
	String daysS = (request.getParameter("days")==null ? Integer.toString(days) : request.getParameter("days")) ;
	String maxS = (request.getParameter("max") ==null ? Integer.toString(max): request.getParameter("max"));


	String action = request.getParameter("action");
	if ("send".equals(action)) {
		if (subject == null || message == null || daysS == null || maxS==null) {
			out.write("Message, subject,x days and max recipients required!");
			return;
		} else if (request.getParameter("test")!=null) {
			out.write("<div style='color:red'>TEST: Not sending inbox - only counting recipients..: ");
			days = Integer.parseInt(daysS);
			max = Integer.parseInt(maxS);
			java.util.List<Player> players = PlayerManager.getInstance().getRecentPlayers(days * 24, max);
			out.write(players.size()+ " players match the inbox criteria.</div><br/>");
		} else {

			TaskOptions task = TaskOptions.Builder.withUrl("/admin/inbox.jsp");
			task.param("subject", subject);
			task.param("message", message);
			task.param("daysS", daysS);
			task.param("maxS", maxS);
			task.param("action", "queue");
			task.param("accessToken", GameUtils.getGameAdminToken());
			QueueFactory.getQueue("inbox").add(task);
			
			out.write("<div style='color:green'>Message queued! Inbox progress sent to slotmania account</div><br/>");
			out.write("Subject="+subject+"<br/>");
			out.write("Message="+message+"<br/>");
			out.write("daysS="+daysS+"<br/>");
			out.write("maxS="+maxS+"<br/>");
			out.write("action="+action+"<br/>");
			return;
		}

	} else if ("queue".equals(action)) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX: params days="+daysS+ " maxs="+maxS+", sub="+subject+", body="+message);
		days = Integer.parseInt(daysS);
		max = Integer.parseInt(maxS);
		max = Math.min(max, 50000);

		java.util.List<Player> players = PlayerManager.getInstance().getRecentPlayers(days * 24, max);
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX Start sending  to " + players.size() + " players");

		long idx = 0;
		for (Player currPlayer : players) {
			try {
//				OpenSocialService.getInstance().sendNotification(currPlayer.getMocoId(), subject, message);
				if (idx++ % 2500 == 0) {
					OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
							"Inbox " + idx + " of " + players.size()+ " sent.","Running background job");
				}
			} catch (Exception e) {
				Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error sending inbox to player: " + player, e);
			}
		}
		OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
				"Inbox to " + players.size()+ " players complete.","Running background job");
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX: Completed sending to "+players.size()+" players");
		
		return;
	}
	if (subject==null) subject = "";
	if (message==null) message = "";
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Inbox Utility</title>
	</head>
	<body>
		<h1>Inbox Utility</h1>	
		<p>Will send message to users who played in the last X days</p>	
		<form action="/admin/inbox.jsp" method="POST">
			<input type="hidden" name="action" value="send"></input>
			<label for="key">Subject:</label><br/>
			<input type="text" name="subject" maxlength="50" value="<%=subject%>"></input><br/>
			<label for="message">Message:</label><br/>
			<textarea rows="3" cols="80" name="message"><%=message%></textarea><br/>
			<small>(only plain text - no HTML!)</small><br/><br/>
			<label for="key">Played in last x days. x=:</label>
			<input type="number" name="days" value="<%=days%>"></input><br/>
			<label for="key">Max # of recipients:</label>
			<input type="number" name="max" value="<%=max%>"></input><br/>
			<small>(max 50000 recipients)</small><br/>
			<br/><br/>
			<label for="key">Test</label>
			<input type="checkbox" name="test" value="on" checked="checked"><br/>
			<input type="submit" value="send"></input>
		</form>		
	</body>
</html>