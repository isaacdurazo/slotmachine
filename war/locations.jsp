<%@ include file="/header.jsp" %>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- index.jsp -->
 <%@ include file="header_html.jsp" %>

				<div class="content">
					
					<div class="subheader">
			    		Locations
			    	</div>

			    	<table class="location-wrapper">
			    		<tr class="location-container">
			    			<td class="icon-location"><img width="24" height="24" src="images/icon-level1.gif"/></td>
			    			<td class="icon-lock"><img width="24" height="24" src="images/icon-lock.gif"/></td>
			    			<td>
			    				<div>Location 1</div>
			    				<small>20 XP required</small>
			    			</td>
			    			<td class="button-go"><a href="#">Go</a></td>
			    			<td class="button-go-disable">Go</td>
			    		</tr>

			    		<tr class="location-container locked">
			    			<td class="icon-location"><img width="24" height="24" src="images/icon-level2.gif"/></td>
			    			<td class="icon-lock"><img width="24" height="24" src="images/icon-lock.gif"/></td>
			    			<td>
			    				<div>Old West</div>
			    				<small>20 XP required</small>
			    			</td>
			    			<td class="button-go"><a href="#">Go</a></td>
			    			<td class="button-go-disable">Go</td>
			    		</tr>

			    		<tr class="location-container locked">
			    			<td class="icon-location"><img width="24" height="24" src="images/icon-level3.gif"/></td>
			    			<td class="icon-lock"><img width="24" height="24" src="images/icon-lock.gif"/></td>
			    			<td>
			    				<div>Under the Sea</div>
			    				<small>20 XP required</small>
			    			</td>
			    			<td class="button-go"><a href="#">Go</a></td>
			    			<td class="button-go-disable">Go</td>
			    		</tr>

			    		<tr class="location-container locked">
			    			<td class="icon-location"><img width="24" height="24" src="images/icon-level4.gif"/></td>
			    			<td class="icon-lock"><img width="24" height="24" src="images/icon-lock.gif"/></td>
			    			<td>
			    				<div>Wild Jungle</div>
			    				<small>20 XP required</small>
			    			</td>
			    			<td class="button-go"><a href="#">Go</a></td>
			    			<td class="button-go-disable">Go</td>
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