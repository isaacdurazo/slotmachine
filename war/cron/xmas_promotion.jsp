<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%>
<%@ page import="com.solitude.slots.*,com.google.appengine.api.utils.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.cache.*,com.solitude.slots.opensocial.*,java.util.logging.*" %>
<%
if (!"true".equals(request.getHeader("X-AppEngine-Cron"))) {
	out.write("X-AppEngine-Cron header missing?!");
	Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"X-AppEngine-Cron header missing?!");
	return;
}
int startHrsInt = 20;
int endHrsInt = 48;
while (true) {
	if (startHrsInt>=endHrsInt) break;
	int currentEndHrs = Math.min(startHrsInt+6,endHrsInt);
	TaskOptions task = TaskOptions.Builder.withUrl("/admin/inbox.jsp");
	task.param("subject", "Play now to increase your Moco Gold Jackpot");
	task.param("message", "Remember to play Slotmania EVERY day to increase your progressive Jackpot. You your personal Gold Jackpot increase by 500 Gold every consecutive day you play!  Hurry up and Play Now to win the Jackpot before somebody else wins!");
	task.param("starthrsS", starthrsS);
	task.param("endhrsS",Integer.toString(currentEndHrs));
	task.param("maxS", maxS);
	task.param("action", "queue");
	task.param("accessToken", GameUtils.getGameAdminToken());
	QueueFactory.getQueue("inbox").add(task);
	Logger.getLogger(request.getRequestURI()).log(Level.INFO,"sending xmas promotion for hours "+startHrsInt+" to "+currentEndHrs);
	startHrsInt +=6;
}
%>