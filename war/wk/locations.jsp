<%@ include file="/header.jsp" %>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="/wk/header_html.jsp" %>
  
		    <div class="content">
		    	<div class="title-wrapper">
		    		<div class="title-container">
						<span class="title">
							Locations
						</span>
					</div>
				</div>

				<% for (int i=1;i<=Integer.getInteger("max.player.level");i++) { 
					boolean locked = i > player.getLevel();%>
					<div class="location-wrapper<%= locked ? " locked" : ""%>">
						<a href="<%= ServletUtils.buildUrl(player, locked ? "/wk/topup.jsp" : ("/wk/spin.jsp?playingLevel="+i), response) %>" class="location-container level-<%=i%>">
							<div class="location-icons">
								<span class="icon-location"></span>
								<span class="icon-lock"></span>
							</div>
							<div class="location">
								<div class="location-name"><%= System.getProperty("level.name."+i) %></div>
							</div>
						</a>
					</div>
				<% } %>

	  		</div>		

	  		<div class="menu" style="margin-right: 16px;">
	  			<a href="<%= ServletUtils.buildUrl(player, "/", response) %>">Main</a>
	  		</div>
		</div>
	</div>
	<%@ include file="/wk/ga.jsp" %>
  </body>
</html>