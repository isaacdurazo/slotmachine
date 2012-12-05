<%@ page import="java.net.URLEncoder,java.net.URLDecoder,com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*,com.google.appengine.api.taskqueue.QueueFactory,com.google.appengine.api.taskqueue.TaskOptions" %>

<%	
	try {
		if (Integer.parseInt(request.getHeader("X-AppEngine-TaskRetryCount")) > 0 && "inbox".equals(request.getHeader("X-AppEngine-QueueName"))) {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Ignoring inbox reattempt!");
		}
	} catch (Exception e) {}
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
	int starthrs=48;
	int endhrs=24;
	int max=15000;

	String subject = request.getParameter("subject");
	String message = request.getParameter("message");
	String starthrsS = (request.getParameter("starthrsS")==null ? Integer.toString(starthrs) : request.getParameter("starthrsS")) ;
	String endhrsS = (request.getParameter("endhrsS")==null ? Integer.toString(endhrs) : request.getParameter("endhrsS")) ;
	String maxS = (request.getParameter("maxS") ==null ? Integer.toString(max): request.getParameter("maxS"));

	String action = request.getParameter("action");
	if ("send".equals(action)) {
		if (subject == null || message == null || starthrsS == null || endhrsS == null ||maxS==null) {
			out.write("Message, subject,x starthrs and max recipients required!");
			return;
		} else if (request.getParameter("test")!=null) {
			out.write("<div style='color:red'>TEST: Not sending inbox - only counting recipients. Parameters:<br/>");
			starthrs = Integer.parseInt(starthrsS);
			endhrs = Integer.parseInt(endhrsS);
			max = Integer.parseInt(maxS);
			java.util.List<Player> players = PlayerManager.getInstance().getActiveHoursPlayers(starthrs, endhrs,max);
			out.write("starthrsS="+starthrsS+"<br/>");
			out.write("endhrsS="+endhrsS+"<br/>");
			out.write("maxS="+maxS+"<br/>");
			
			out.write(players.size()+ " players match the inbox criteria.</div><br/>");
		} else {
			// break into 10 hour chunks
			StringBuilder sb = new StringBuilder();
			int startHrsInt = Integer.parseInt(starthrsS);
			int endHrsInt = Integer.parseInt(endhrsS);
			while (true) {
				if (endHrsInt>=startHrsInt) break;
				int currentStartHrsInt = Math.min(startHrsInt,endHrsInt+6);
				TaskOptions task = TaskOptions.Builder.withUrl("/admin/inbox.jsp");
				task.param("subject", subject);
				task.param("message", message);
				task.param("starthrsS", Integer.toString(currentStartHrsInt));
				task.param("endhrsS",Integer.toString(endHrsInt));
				task.param("maxS", maxS);
				task.param("action", "queue");
				task.param("accessToken", GameUtils.getGameAdminToken());
				sb.append(endHrsInt).append(" hrs to ").append(Integer.toString(currentStartHrsInt)).append(" hrs<br/>");
				QueueFactory.getQueue("inbox").add(task);
				endHrsInt +=6;
			}
			
			out.write("<div style='color:green'>Message queued! Inbox progress sent to slotmania account</div><br/>");
			out.write("Subject="+subject+"<br/>");
			out.write("Message="+message+"<br/>");
			out.write("starthrsS="+starthrsS+"<br/>");
			out.write("endhrsS="+endhrsS+"<br/>");
			out.write("maxS="+maxS+"<br/>");
			out.write("action="+action+"<br/>");
			out.write(sb.toString());
			return;
		}

	} else if ("queue".equals(action)) {
		try {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX: params starthrsS="+starthrsS+ " endhrsS="+endhrsS+"  maxS="+maxS+", sub="+subject+", body="+message);
			starthrs = Integer.parseInt(starthrsS);
			endhrs = Integer.parseInt(endhrsS);
			max = Integer.parseInt(maxS);
			max = Math.min(max, 20000);
	
			java.util.List<Player> players = PlayerManager.getInstance().getActiveHoursPlayers(starthrs, endhrs,max);
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX Start sending  to " + players.size() + " players");
	
			long idx = 0;
			long err = 0;
			int BATCHSIZE=100,j=0;
			java.util.List<Integer> recipientUserIds = new java.util.ArrayList<Integer>(BATCHSIZE);
			for (Player currPlayer : players) {
				try {
					recipientUserIds.add(currPlayer.getMocoId());
					idx++; j++;
					if (j==BATCHSIZE || idx == players.size() ) {
						if (j<BATCHSIZE) {
							java.util.List<Integer> cpy = new java.util.ArrayList<Integer>(j);
							for (int k=0;k<j;k++) cpy.add(recipientUserIds.get(k));
							recipientUserIds=cpy;
						}
						j=0;
						Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Inbox " + idx + " of " + players.size()+ " sending....","Background job");
						OpenSocialService.getInstance().sendNotification(subject, message, recipientUserIds);

						recipientUserIds.clear();
//						OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
//								"Inbox " + idx + " of " + players.size()+ " sent.","Background job");
					}
				} catch (Exception e) {
					Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error sending inbox "+idx+" to list: "+
					recipientUserIds.toString(),e);
					recipientUserIds.clear();
					err++;
				}
			}
			OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()),
					"Inbox to " + players.size()+ " players complete.","Errors="+err+". Check server warning log for more details");
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"INBOX: Completed sending to "+players.size()+" players with "+err+" errors");
		} catch (Exception e) {
			Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"Error sending inbox message!",e);
		}
		response.setStatus(200);
		return;
	}
	if (subject==null) subject = "Jackpot Update";
	// below does not work - XML errors on WAP in resulting inbox msg...
	//	if (message==null) message = "Hi, we have a new <a href=\"http://www.mocospace.com/games?source=inbox&gid=1252&next=jackpots\">MocoGold Jackpot winner</a> in SlotMania.<br/>"+
	//	" The next Jackpot is waiting for you - hurry up and <a href=\"http://www.mocospace.com/games?source=inbox&gid=1252\">spin now</a> before somebody else wins! <br/><br/>The more you spin the more likely you win!";
	if (message==null) message = "Congratulations to our latest MocoGold Jackpot winner in SlotMania - check the Jackpot Winners List.<br/>The Jackpot is now 888 Gold - hurry up and Play Now to win the Jackpot before somebody else wins!<br/><br/>The more you spin the more likely you win!";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Inbox Utility</title>
	</head>
	<body>
		<h1>Inbox Utility</h1>	
		<p>Will send message to users who played in the given hour timeframe</p>	
		<form action="/admin/inbox.jsp" method="POST">
			<input type="hidden" name="action" value="send"></input>
			<label for="key">Subject:</label><br/>
			<input type="text" name="subject" maxlength="50" value="<%=subject%>"></input><br/>
			<label for="message">Message:</label><br/>
			<textarea rows="3" cols="80" name="message"><%=message%></textarea><br/>
			<small>(only plain text - no HTML!)</small><br/><br/>
			<label for="key">Played in timeframe from:</label>
			start: <input type="number" name="starthrsS" value="<%=starthrs%>"></input> hrs ago to 
			end: <input type="number" name="endhrsS" value="<%=endhrs%>"></input> hrs ago<br/>
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