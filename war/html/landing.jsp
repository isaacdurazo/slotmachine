<%@ include file="header_static.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<title>Slot Mania</title>
    <link rel="stylesheet" href="css/webkit.css" />    

	</head>
	<body>
		
		<div id="container">
		  	<div class="wrapper">
				<div class="header-logo">
					<h3>Welcome to</h3>
					<img width="192" height="60" src="images/logo.png"/>
				</div>
				
				<div class="content">
		    		<div class="stats-container">
						<table class="stats">
				   			<tr>
				   				<td>
									<span class="stat">
										You must be logged in to MocoSpace to play this game!
									</span>
								</td>
							</tr>
						</table>
					</div>
					<table class="menu">
						<tr>
							<td>
								<a href="<%=GameUtils.getMocoSpaceHome() %>">Login</a>
							</td>
							<td>
								<a href="<%= response.encodeURL("/html/help.jsp") %>">What is Slot Mania?</a>
							</td>
						</tr>
					</table>
				
				</div>
			</div>
		</div>
		<%@ include file="/html/ga.jsp" %>
	</body>
</html>