<%@ include file="/header.jsp" %>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="header_html.jsp" %>

				<div class="content">
					
					<div class="subheader">
			    		Locations
			    	</div>

			    	<table class="location-wrapper">
				    	<% for (int i=1;i<=Integer.getInteger("max.player.level");i++) { 
							boolean locked = i > player.getLevel();	
							int xpRequired = Integer.getInteger("level.xp.min."+i);%>
				    		<tr class="location-container<%= locked ? " locked" : ""%>">
				    			<td class="icon-location"><img width="24" height="24" src="images/icon-level<%=i%>.gif"/></td>
				    			<td class="icon-lock"><img width="24" height="24" src="images/icon-lock.gif"/></td>
				    			<td>
				    				<div><%= System.getProperty("level.name."+i) %></div>
				    				<small>
				    					<% if (locked) { %><%= Integer.getInteger("level.xp.min."+i)%> XP required
										<% } else { %><%= player.getMocoGoldPrize(i) %> Gold Jackpot<% } %>				    				
				    				</small>
				    			</td>
				    			<td class="button-go"><a href="<%= ServletUtils.buildUrl(player, "/spin.jsp?playingLevel="+i, response) %>">Go</a></td>
				    			<td class="button-go-disable"><a href="<%= ServletUtils.buildUrl(player, "/topup.jsp", response) %>">Buy</a></td>
				    		</tr>
				    	<% } %>
				    	<tr class="location-container">
			    			<td></td>
			    			<td>
			    				New Location Coming soon!
			    			</td>
			    		</tr>
			    	</table>

			  		<div class="menu">
			  			<div><a href="<%= ServletUtils.buildUrl(player, "/", response) %>">Main</a></div>
			  		</div>
	  		
	  			</div>
	  		
		</div>
	</div>
	<%@ include file="footer.jsp" %>
  </body>
</html>