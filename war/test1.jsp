<%@page language="java" buffer="64kb" pageEncoding="UTF-8"%><?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,java.util.logging.*" %>


<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <title>Solitude Slots</title>
    <style type="text/css">
    	body { 
			font-family: Arial;
			background-color: #000;
			color:#FFF;
		}
    	
    	a {
    		text-decoration: none;
    		text-weight:bold;
    	}
    </style>
    
  </head>

  <body>
    <div style="text-align: center;">
    	<div>Solitude Slot 1</div>
		
		<table style="margin:auto;">
			<tr align="center" >
				<td style="width: 20px; border: 1px solid grey;">
					<img height="16" width="16" src="images/img-1.gif"/>
				</td>
				<td style="width: 20px; border: 1px solid grey;">
					<img height="16" width="16" src="images/img-2.gif"/>
				</td>
				<td style="width: 20px; border: 1px solid grey;">
					<img height="16" width="16" src="images/img-3.gif"/>
				</td>
			</tr>
		</table>
		
		<div>
			<b><a href="test2.jsp" style="color:green">play</a></b>
		</div>
		
	</div>
	
	<div id="wrapper" style="border-top:1px solid white; margin-top:20px; text-align: center;">
		<div style="text-align:center; margin: 5px;">
			Solitude Slot 2
		</div>
		<p style="margin:0; ">
			<img height="20" width="55" src="images/3-images.gif"/>
		</p>
		<div>
			<b><a href="test2.jsp" style="color:green">play</a></b>
		</div>
	</div>
    
  </body>
</html>
