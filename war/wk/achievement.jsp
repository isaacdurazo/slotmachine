<%@ include file="/header.jsp" %>
<%
	if (!AchievementService.getInstance().isEnabled() && !player.hasAdminPriv()) {
		pageContext.forward("/");
		return;
	}

%>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="/wk/header_html.jsp" %>
  
		    <div class="content">
		    	<div class="title-wrapper">
		    		<div class="title-container">
						<span class="title">
							Achievements
						</span>
					</div>
				</div>
		  		<div class="achievement-container">
		  			<% for (Pair<Achievement,Boolean> pair : AchievementService.getInstance().getAchievements(player)) { %>
		  				<table id="achievement-entity" <%= pair.getElement2() ? "" : "class='disable'"%>>
		  					<tr>
		  						<td class="achievement-icon"><img width="30" height="30" src="<%= pair.getElement1().getType().getWebkitImage() %>"/></td>
		  						<td class="achievement"><%= pair.getElement1().getTitle() %> </td>
		  						<td class="achievement-coins"><%= pair.getElement1().getCoinsAwarded() %> coins</td>
		  					</tr>
		  				</table>
			   		<% } %>
		  		</div>
		  		
	  		</div>		   
	  		<div class="menu" style="margin-right: 16px;">
	  			<a href="<%= ServletUtils.buildUrl(player, "/wk/index.jsp", response) %>">Main</a>
	  		</div>
		</div>
	</div>
	<%@ include file="/wk/ga.jsp" %>
  </body>
</html>