<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
if (request.getParameter("accessToken") != null) player = PlayerManager.getInstance().getPlayer(request.getParameter("accessToken"));
else if (playerId != null) player = PlayerManager.getInstance().getPlayer(playerId);

if (player == null || !player.hasAdminPriv()) { 
	pageContext.forward("/");
	return;
}

String queue = request.getParameter("queue");
Logger.getLogger(request.getRequestURI()).log(Level.INFO,"processing queue: "+queue);

if ("flushDeltaPlayers".equals(queue)) {
	PlayerManager.getInstance().flushDeltaPlayers(false);	
}
%>