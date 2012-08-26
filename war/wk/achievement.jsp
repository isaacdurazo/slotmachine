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
  <body>
  	<div id="container">
	  	<div class="wrapper">
	  		<div class="header-logo">
		    	<img width="154" height="48" src="/wk/images/logo.png"/>
		    </div>
		    <div class="content">
		    		
		    		<table class="stats">
						<tr>
							<td>
								<span class="stat">
									Achievements
								</span>
							</td>
						</tr>
					</table>
					
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
	  		<table class="menu">
	  			<tr>
	  				<td><a href="<%= ServletUtils.buildUrl(player, "/", response) %>">Main</a></td>
	  			</tr>
	  		</table>
		</div>
	</div>
	<%@ include file="/wk/footer.jsp" %>
  </body>
</html>