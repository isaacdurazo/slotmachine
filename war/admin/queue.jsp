<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
Logger.getLogger(request.getRequestURI()).log(Level.INFO,request.getQueryString());
if (!System.getProperty("queue.token").equals(request.getParameter("accessToken"))) { 
	pageContext.forward("/");
	return;
}

String queue = request.getParameter("queue");
Logger.getLogger(request.getRequestURI()).log(Level.INFO,"processing queue: "+queue);

if ("flushDeltaPlayers".equals(queue)) {
	PlayerManager.getInstance().flushDeltaPlayers(false);	
}
%>