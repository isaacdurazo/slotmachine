<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>

<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Slot Mania</title>
</head>
<body>
<h1>Welcome to SlotMania.</h1>
<div>
You must be logged in to MocoSpace to play this game!
</div>
    <div class="menu">
        <a href="<%=GameUtils.getMocoSpaceHome() %>">Login</a>
        <a href="<%=response.encodeURL("/")+"?uid=12534729" %>">Fake Login as niels</a>
        <a href="<%= response.encodeURL("/help.jsp") %>">What is Slot Mania?</a>
    </div>
</body>
</html>