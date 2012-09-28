<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%>
<%final boolean isWebkit = ServletUtils.isWebKitDevice(request); 
if ("feature".equals(ServletUtils.getDevice(request))) {%><?xml version="1.0" encoding="utf-8"?><% } %>
<% if (request.getAttribute("hide_doctype") == null) { %>
	<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<% } %>
<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*" %>
<%
final boolean hasAnimGifSupport = ServletUtils.hasAnimGifSupport(request);
%>