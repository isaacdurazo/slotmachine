<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Slot Mania</title>
    <% 
    // @todo fix this hack - GAE will not compile the jsp if I just use isWebkit here...
    if (ServletUtils.isWebKitDevice(request)) {%>
    <link rel="stylesheet" href="css/webkit.css" />    
	<% } else { %>
    <link rel="stylesheet" href="css/wap.css" />    
	<%} %>
  </head>
