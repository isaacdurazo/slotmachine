<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>
<%
Integer playerId = (Integer)request.getSession().getAttribute("playerId");
Player player = null;
if (playerId != null) {
	player = PlayerManager.getInstance().getPlayer(playerId);
} else {
	// verify and create player as needed
	try {
		player = PlayerManager.getInstance().startGamePlayer(
			ServletUtils.getInt(request,"userId"), 
			ServletUtils.getLong(request,"timestamp"), 
			request.getParameter("verifier"));
	} catch (PlayerManager.UnAuthorizedException e) { 
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Invalid verification: "+request.getQueryString());
		response.sendRedirect(GameUtils.getMocoSpaceHome());
		return;
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Could not create/load player? params: "+request.getQueryString(),e);
		response.sendRedirect(GameUtils.getMocoSpaceHome());
		return;
	}
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Solitude Slots</title>
  </head>

  <body>
    <h1>Hello App Engine!</h1>
	
	<h3>Self</h3>
    <%=
    		OpenSocialService.getInstance().fetchSelf(player.getAccessToken())
    %>
    
    <h3>Friends</h3>
    <%=
    		com.solitude.slots.service.OpenSocialService.getInstance().fetchFriends(player.getAccessToken(),0,10)
    %>
  </body>
</html>
