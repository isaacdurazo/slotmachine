<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%>
<% if (request.getAttribute("hide_doctype") == null) { %><!DOCTYPE html><% } %>
<%@ page import="java.net.URLEncoder, java.net.URLDecoder, com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException,java.util.logging.*,java.util.*" %>
<%
final boolean isWebkit = ServletUtils.isWebKitDevice(request);
final boolean hasAnimGifSupport = ServletUtils.hasAnimGifSupport(request);

%>
