<%@ include file="header_static.jsp" %>
<%@page import="java.util.Random"%>

<%

//used to postfix on spin hyperlinks to force OpenWave browser to fetch from server
final int rand = (new Random()).nextInt(999); 
String cacheBuster = "r="+rand; 

Player player = (Player)request.getAttribute("player"); 

// logic to do animated/static images based on browser support
String imageLocation = "images/";
if (!isWebkit) {
	imageLocation="images/animated-2/";
	if (!hasAnimGifSupport) {
		imageLocation="images/";
	}
}

if (player == null) {
	int uid = ServletUtils.getInt(request,"uid"); 
	String accessToken = request.getParameter("accessToken");
	Long playerId = (Long)request.getSession().getAttribute("playerId");
	
	if (playerId != null) {
		//player already has session - get her.
		player = PlayerManager.getInstance().getPlayer(playerId);
	
		// check that if uid is given, that it matches player's moco id to handle multiple login case
		if (player != null && ((uid > 0 && player.getMocoId() != uid) || 
			(accessToken != null && !accessToken.equals(player.getAccessToken())))) {
				player = null;
		}
	}
	
	if (player == null) {
		// No session - verify and create/fetch player as needed	
		try {
			if (accessToken != null) {
				// webkit case
				player = PlayerManager.getInstance().startGamePlayer(accessToken);
			} else {
				// feature phone
				player = PlayerManager.getInstance().startGamePlayer(
					ServletUtils.getInt(request,"uid"), 
					ServletUtils.getLong(request,"timestamp"), 
					request.getParameter("verify"));			
			}
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
	request.setAttribute("player",player);
}
// check if coins awarded
int coinsAwarded = PlayerManager.getInstance().getRetentionCoinAward(player);

if (isWebkit) {
	if (!player.hasAdminPriv() && Boolean.getBoolean("game.webkit.disabled")) {
		//only allow admins to play on webkit if game disabled for webkit
		%>
		<html xmlns="http://www.w3.org/1999/xhtml">
		 <%@ include file="header_html.jsp" %>
		  <body>
				<div id="container">
				  	<div class="wrapper">
					    <img style="margin-top:45px;" width="240" height="110" src="images/wk-landing-logo.png"/>
					</div>
				</div>
				<div align="center">Game is available on Feature Phones today.<br/>Coming to Smart Phones in early August!</div>
		</body>
		</html>		
			<% 
		return;
	} else if (!request.getRequestURI().startsWith("/wk/")) {
		pageContext.forward("/wk/index.jsp");
		return;
	}
}
	
%>
