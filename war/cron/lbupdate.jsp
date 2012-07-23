<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%>
<%@ page import="com.solitude.slots.*,com.google.appengine.api.utils.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.cache.*,com.solitude.slots.opensocial.*,java.util.logging.*" %>
<%
if (!"true".equals(request.getHeader("X-AppEngine-Cron")) && SystemProperty.environment.get().equals(SystemProperty.Environment.Value.Production)) {
	out.write("ERROR!");
	return;
}
java.util.List<Player> players = PlayerManager.getInstance().getRecentPlayers(4);
Logger.getLogger(request.getRequestURI()).log(Level.INFO,"update leaderboard for "+players.size()+" players");
for (Player player : players) {
	try {
		OpenSocialService.getInstance().setScore(
			(short)1,
			player.getMocoId(),
			player.getXp(),
			false);
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"error updating leaderboard for: "+player,e);
	}
}
%>