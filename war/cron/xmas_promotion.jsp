<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder,java.net.URLDecoder,com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*,com.google.appengine.api.taskqueue.QueueFactory,com.google.appengine.api.taskqueue.TaskOptions,java.util.*" %>
<%
if (!"true".equals(request.getHeader("X-AppEngine-Cron"))) {
	out.write("X-AppEngine-Cron header missing?!");
	Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"X-AppEngine-Cron header missing?!");
	return;
}
<<<<<<< HEAD
if (Boolean.getBoolean("xmas.promotion.enabled") && 
		System.currentTimeMillis() < new GregorianCalendar(2012,Calendar.DECEMBER,24).getTimeInMillis()) {
	int startHrsInt = 48;
	int endHrsInt = 20;
	StringBuilder sb = new StringBuilder();
	while (true) {
		if (endHrsInt>=startHrsInt) break;
		int currentStartHrsInt = Math.min(startHrsInt,endHrsInt+6);
		TaskOptions task = TaskOptions.Builder.withUrl("/admin/inbox.jsp");
		task.param("subject", "Play now to increase your Moco Gold Jackpot");
		task.param("message", "Remember to play Slotmania EVERY day to increase your progressive Jackpot. You your personal Gold Jackpot increase by 500 Gold every consecutive day you play!  Hurry up and Play Now to win the Jackpot before somebody else wins!");
		task.param("starthrsS", Integer.toString(currentStartHrsInt));
		task.param("endhrsS",Integer.toString(endHrsInt));
		task.param("maxS", "10000");
		task.param("action", "queue");
		task.param("accessToken", GameUtils.getGameAdminToken());
		sb.append(endHrsInt).append(" hrs to ").append(Integer.toString(currentStartHrsInt)).append(" hrs<br/>");
		QueueFactory.getQueue("inbox").add(task);
		endHrsInt +=6;
	}
	OpenSocialService.getInstance().sendNotification(Integer.parseInt(GameUtils.getGameAdminMocoId()), "Xmas message sent", sb.toString());
=======
int startHrsInt = 20;
int endHrsInt = 48;
StringBuilder sb = new StringBuilder();
while (true) {
	if (endHrsInt>=startHrsInt) break;
	int currentStartHrsInt = Math.min(startHrsInt,endHrsInt+6);
	TaskOptions task = TaskOptions.Builder.withUrl("/admin/inbox.jsp");
	task.param("subject", "Win more Moco Gold");
//	task.param("message", "Remember to play Slotmania EVERY day to increase your progressive Jackpot. You your personal Gold Jackpot increase by 500 Gold every consecutive day you play!  Hurry up and Play Now to win the Jackpot before somebody else wins!");
	task.param("message", "Play before midnight ET to increase your Moco Gold Jackpot. Play EVERY day to win increase your Jackpot to $150 in MocoGold!  Hurry up and Play Now to win the Jackpot before somebody else wins!");
	task.param("starthrsS", Integer.toString(currentStartHrsInt));
	task.param("endhrsS",Integer.toString(endHrsInt));
	task.param("maxS", "10000");
	task.param("action", "queue");
	task.param("accessToken", GameUtils.getGameAdminToken());
	sb.append(endHrsInt).append(" hrs to ").append(Integer.toString(currentStartHrsInt)).append(" hrs<br/>");
	QueueFactory.getQueue("inbox").add(task);
	endHrsInt +=6;
>>>>>>> 0c4d2e47c1af2782dee2b5852f9154e784fdbc93
}
%>