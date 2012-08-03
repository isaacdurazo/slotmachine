<% if (request.getParameter("confirmmsg")!=null) { %>
<div class="confirm">
	<%=request.getParameter("confirmmsg") %>
</div>
<%} else if (request.getParameter("notifymsg")!=null) { %>
<div class="notify">
<%=request.getParameter("notifymsg") %>
</div>
<%} else  if (request.getParameter("errmsg")!=null) { %>
<div class="error">
<%=request.getParameter("errmsg") %>
</div>
<%} %>
