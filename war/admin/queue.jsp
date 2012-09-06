<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>

<% 
if (!System.getProperty("queue.token").equals(request.getParameter("accessToken"))) { 
	pageContext.forward("/");
	return;
}

String queue = request.getParameter("queue");
Logger.getLogger(request.getRequestURI()).log(Level.INFO,"processing queue: "+queue);

if ("flushDeltaPlayers".equals(queue)) {
	PlayerManager.getInstance().flushDeltaPlayers(false);	
} else if ("flushPlayer".equals(queue)) {
	long playerId = ServletUtils.getLong(request, "playerId");
	if (playerId < 0) Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Invalid player id for flush");
	else {
		Player flushPlayer = com.solitude.slots.cache.GAECacheManager.getInstance().get(playerId, Player.class);
		if (flushPlayer == null) Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Flush player not in cache with id: "+playerId);
		else PlayerManager.getInstance().storePlayer(flushPlayer);
	}
}
%>