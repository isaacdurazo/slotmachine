<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Solitude Slots</title>
  </head>

  <body>
    <h1>Hello App Engine!</h1>
	
	<h3>Self</h3>
    <%=
    		com.solitude.slots.service.OpenSocialService.getInstance().fetchSelf("m1mnjpru2k7o")
    %>
    
    <h3>Friends</h3>
    <%=
    		com.solitude.slots.service.OpenSocialService.getInstance().fetchFriends("m1mnjpru2k7o",0,10)
    %>
  </body>
</html>
