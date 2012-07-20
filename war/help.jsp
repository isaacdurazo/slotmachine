<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>

<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Slot Mania</title>

</head>
<body>
<h1>About Slot Mania</h1>
<div>
<ul>
<li>Come back daily to get FREE coins and spin to win!</li>
<li>Weekly Coin Prize: Gain eXPerience as you play and become #1 on the weekly XP leaderboard to win <%=System.getProperty("weekly.coin.prize") %> coins.</li>
<li>Weekly Moco Gold JACKPOT: One player guaranteed to win the Gold jackpot. The more you spin the more likely you win!</li>
</ul>
</div>
<h1>Payout Table</h1>
<div>
List graphics</div>
<a href="index.jsp?uid=<%=(String)request.getParameter("uid")%>">My Moco Info</a><br/>

uid=<%=(String)request.getParameter("uid")%><br/> 
timestamp=<%=(String)request.getParameter("timestamp")%><br/> 
verify=<%=(String)request.getParameter("verify")%><br/> 
</body>
</html>