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
3x diamonds: 500 <br/>
3x 7: 100 <br/>
3x bars: 50 <br/> 
3x bells: 20 <br/>
3x watermelon: 15 <br/>
3x chrry: 10 <br/>
2x cherry: 5 <br/>
1x cherry: 2 <br/>
</div>
</body>
</html>