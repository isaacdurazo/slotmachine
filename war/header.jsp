<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">

<!-- 
Misc general initialization, authentication, imports

 -->

<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>
<%
int coinsAwarded = 0;
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null;
if (playerId != null) {
	player = PlayerManager.getInstance().getPlayer(playerId);
} else {
	// verify and create player as needed
	try {
		Pair<Player,Integer> gameStartPair = PlayerManager.getInstance().startGamePlayer(
			ServletUtils.getInt(request,"uid"), 
			ServletUtils.getLong(request,"timestamp"), 
			request.getParameter("verify"));
		player = gameStartPair.getElement1();
		coinsAwarded = gameStartPair.getElement2();
		request.getSession().setAttribute("playerId",player.getId());
	} catch (PlayerManager.UnAuthorizedException e) { 
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Invalid verification: "+request.getQueryString());
		response.sendRedirect(GameUtils.getVisitorHome());
		return;
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Could not create/load player? params: "+request.getQueryString(),e);
		response.sendRedirect(GameUtils.getVisitorHome());
		return;
	}
}
%>
