<%@ include file="header_static.jsp" %>
<%@page import="java.util.Random"%>

<%
int rand = (new Random()).nextInt(999); 
String cacheBuster = "r="+rand; //used to postfix on spin hyperlinks to force OpenWave browser to fetch from server

int coinsAwarded = 0;
Long playerId = (Long)request.getSession().getAttribute("playerId");
Player player = null; 
int uid = ServletUtils.getInt(request,"uid"); 
String accessToken = request.getParameter("accessToken");
if (playerId != null) {
	player = PlayerManager.getInstance().getPlayer(playerId);
	// check that if uid is given, that it matches player's moco id to handle multiple login case
	if (player != null && uid > 0 && player.getMocoId() != uid) player = null;
} 
if (player == null) {
	// verify and create player as needed	
	try {
		Pair<Player,Integer> gameStartPair;
		if (accessToken != null && isWebkit) {
			// webkit case
			gameStartPair = PlayerManager.getInstance().startGamePlayer(accessToken);
		} else {
			// feature phone
			gameStartPair = PlayerManager.getInstance().startGamePlayer(
				ServletUtils.getInt(request,"uid"), 
				ServletUtils.getLong(request,"timestamp"), 
				request.getParameter("verify"));			
		}
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
