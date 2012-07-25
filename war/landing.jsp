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
			   		<h3>Welcome to</h3>
			    	<img width="103" height="18" src="images/logo.gif"/>
			    </div>
				<h3>
					You must be logged in to MocoSpace to play this game!
				</h3>
				<div class="menu">
					<div><a href="<%=GameUtils.getMocoSpaceHome() %>">Login</a></div><br />
					<div><a href="<%=response.encodeURL("/")+"?uid=12534729" %>">Fake Login as niels</a></div><br />
					<div><a href="<%= response.encodeURL("/help.jsp") %>">What is Slot Mania?</a></div>
				</div>
			</div>
		</div>
	</body>
</html>