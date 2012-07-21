<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>


<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>SLOTMANIA</title>
    <link rel="stylesheet" href="css/style.css" />
    
  </head>

  <body>
    <div class="wrapper">
    	<div class="header-logo"><img width="103" height="18" src="images/logo.gif"/></div>
				
		<table class="subheader">
			<tr>
				<td class="xp" style="red">
					<b>XP:</b>10
				</td>
				<td class="coins">
					<b>COINS:</b>1000
				</td>
			</tr>
		</table>
		
		<table>
			<tr align="center" >
				<td>
					<img width="38" height="64" src="images/comb-1.gif"/>
				</td>
				<td>
					<img width="38" height="64" src="images/comb-1.gif"/>
				</td>
				<td>
					<img width="38" height="64" src="images/comb-1.gif"/>
				</td>
			</tr>
		</table>
		
		<div class="bets"><a href="test2.jsp" class="bet">BET ONE</a><a href="test2.jsp" class="bet">BET MAX</a></div>

		<div class="payout"><a href="#">Payout Table</a></div>
		<div class="menu"><a href="#">Menu</a></div>
	</div>

  </body>
</html>
