<%@ include file="/header.jsp" %>
<%
	if (!AchievementService.getInstance().isEnabled() && !player.hasAdminPriv()) {
		pageContext.forward("/");
		return;
	}
%>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="header_html.jsp" %>
  <body>
  	<div id="container">
	  	<div class="wrapper">
	  		<table>
	  			<tr>
	  				<th>Name</th>
	  				<th>Reward</th>
	  				<th>Granted</th>
	  			</tr>
	  			<% for (Pair<Achievement,Boolean> pair : AchievementService.getInstance().getAchievements(player)) { %>
	  			<tr>
	  				<td><%= pair.getElement1().getTitle() %></td>
	  				<td><%= pair.getElement1().getCoinsAwarded() %> coins</td>
	  				<td><%= pair.getElement2() %></td>
	  			</tr>
		   		<% } %>
	  		</table>		   
	  		<div class="menu">
	  			<div><a href="<%= ServletUtils.buildUrl(player, "/", response) %>">Main</a></div>
	  		</div>
		</div>
	</div>
	<%@ include file="footer.jsp" %>
  </body>
</html>