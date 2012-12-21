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
								<span class="location-name"><%= System.getProperty("level.name."+i) %></span>
								<span class="location-play">Play</span>
								<span class="location-buy">Buy</span>
								<div class="location-xp">
									<% if (locked) { %><%= Integer.getInteger("level.xp.min."+i)%> XP required
									<% } else { %><%= (int)(Double.parseDouble(System.getProperty("level.jackpot.multiplier."+i))*GameUtils.getGlobalProps().getMocoGoldPrize())%> Gold Jackpot<% } %>
								</div>
							</div>
							
						</a>

						
					</div>
				<% } %>
				
				<div class="location-wrapper coming-soon">
					<div href="#" class="location-container">
						<div class="location-icons">
							<span class="icon-location"></span>
							<span class="icon-lock"></span>
						</div>
						<div class="location">
							<span class="location-name">Coming Soon!</span>
						</div>
					</div>
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