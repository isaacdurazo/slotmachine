<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>

<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<title>Slot Mania</title>
    <link rel="stylesheet" href="css/wap.css" />    
</head>
<body>
	<div id="container">
			<div class="wrapper">
				 <div class="header-logo">
			   		<h3>About</h3>
			    	<img width="103" height="18" src="images/logo.gif"/>
			    </div>
				<ul  class="list">
					<li>Come back daily to get <b>FREE</b> coins and spin to win!</li><br />
					<li><b>Weekly Coin Prize:</b> Gain eXPerience as you play and become #1 on the weekly XP leaderboard to win <%=System.getProperty("weekly.coin.prize") %> coins.</li><br />
					<li><b>Weekly Moco Gold JACKPOT:</b> One player guaranteed to win the Gold jackpot. The more you spin the more likely you win!</li><br />
				</ul>
				
				<div class="payout-table">
					<div>Payout Table</div>
					<div class="payout-table">
						3x <img width="16" height="16" src="images/individual/diamond.gif"/>: 500 <br/>
						3x <img width="16" height="16" src="images/individual/seven.gif"/>: 100 <br/>
						3x <img width="16" height="16" src="images/individual/bar.gif"/>: 50 <br/> 
						3x <img width="16" height="16" src="images/individual/bell.gif"/>: 20 <br/>
						3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 15 <br/>
						3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 10 <br/>
						2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 5 <br/>
						1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 2 <br/> 
					</div>
				</div>
				<div class="menu">
			    	<div>1. <a accessKey="1" href="<%= response.encodeURL("/invite.jsp") %>">Invite Friends</a><br/></div>
			       	<div>2. <a accessKey="2" href="<%= response.encodeURL("/") %>">Main</a></div>
			    </div>
			</div>
	</div>
</body>
</html>