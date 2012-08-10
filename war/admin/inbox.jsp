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
	int max=5000;

	String subject = request.getParameter("subject");
	String message = request.getParameter("message");
	String daysS = (request.getParameter("daysS")==null ? Integer.toString(days) : request.getParameter("daysS")) ;
	String maxS = (request.getParameter("maxS") ==null ? Integer.toString(max): request.getParameter("maxS"));


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
		try {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX: params days="+daysS+ " maxs="+maxS+", sub="+subject+", body="+message);
			days = Integer.parseInt(daysS);
			max = Integer.parseInt(maxS);
			max = Math.min(max, 20000);
	
			java.util.List<Player> players = PlayerManager.getInstance().getRecentPlayers(days * 24, max);
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX Start sending  to " + players.size() + " players");
	
			long idx = 0;
			long err = 0;
			for (Player currPlayer : players) {
				try {
//					OpenSocialService.getInstance().sendNotification(currPlayer.getMocoId(), subject, message);
					if (idx++ % 1000 == 0) {
						OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
								"Inbox " + idx + " of " + players.size()+ " sent.","Background job");
					}
				} catch (Exception e) {
					Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error sending inbox to player: " + currPlayer, e);
					err++;
				}
			}
			OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
					"Inbox to " + players.size()+ " players complete.","Errors="+err+". Check server warning log for more details");
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX: Completed sending to "+players.size()+" players with "+err+" errors");
		} catch (Exception e) {
			Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"Error sending inbox message!");
		}
		response.setStatus(200);
		return;
	}
	if (subject==null) subject = "Jackpot Update";
	if (message==null) message = "Hi, we have a new <a href=\"http://www.mocospace.com/games?source=inbox&gid=1252&next=jackpots\">MocoGold Jackpot winner</a> in SlotMania.<br/>"+
			" The next Jackpot is waiting for you - hurry up and <a href=\"http://www.mocospace.com/games?source=inbox&gid=1252\">spin now</a> before somebody else wins! <br/><br/>The more you spin the more likely you win!";
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
			<input type="number" name="daysS" value="<%=days%>"></input><br/>
			<label for="key">Max # of recipients:</label>
			<input type="number" name="maxS" value="<%=max%>"></input><br/>
			<small>(max 20000 recipients)</small><br/>
			<br/><br/>
			<label for="key">Test</label>
			<input type="checkbox" name="test" value="on" checked="checked"><br/>
			<input type="submit" value="send"></input>
		</form>		
	</body>
</html>