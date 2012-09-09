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

				<div class="location-wrapper">
					<a href="#" class="location-container level-1">
						<div class="location-icons">
							<span class="icon-location"></span>
							<span class="icon-lock"></span>
						</div>
						<div class="location">
							<div class="location-name">Location 1</div>
						</div>
					</a>
				</div>

				<div class="location-wrapper locked">
					<a href="#" class="location-container level-2">
						<div class="location-icons">
							<span class="icon-location"></span>
							<span class="icon-lock"></span>
						</div>
						<div class="location">
							<div class="location-name">Old West</div>
							<div>
								<span class="icon-star-small"></span> 
								<span>2 required</span>
							</div>
						</div>
					</a>
				</div>

				<div class="location-wrapper locked">
					<a href="#" class="location-container level-3">
						<div class="location-icons">
							<span class="icon-location"></span>
							<span class="icon-lock"></span>
						</div>
						<div class="location">
							<div class="location-name">Under the Sea</div>
							<div>
								<span class="icon-star-small"></span> 
								<span>3 required</span>
							</div>
						</div>
					</a>
				</div>

				<div class="location-wrapper locked">
					<a href="#" class="location-container level-4">
						<div class="location-icons">
							<span class="icon-location"></span>
							<span class="icon-lock"></span>
						</div>
						<div class="location">
							<div class="location-name">Wild Jungle</div>
							<div>
								<span class="icon-star-small"></span> 
								<span>4 required</span>
							</div>
						</div>
					</a>
				</div>

	  		</div>		



	  		<div class="menu" style="margin-right: 16px;">
	  			<a href="<%= ServletUtils.buildUrl(player, "/", response) %>">Main</a>
	  		</div>
		</div>
	</div>
	<%@ include file="/wk/ga.jsp" %>
  </body>
</html>