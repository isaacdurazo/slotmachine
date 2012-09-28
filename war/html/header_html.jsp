<%@ page import="com.solitude.slots.*" %>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
    <meta name="keywords" content="slotmachine,casino,prize,chat,android games,iphone games,mobile games,games,free,pics,photos,myspace"/>
    <meta name="description" content="Play Casino Games on your mobile phone. FREE game with prizes and millions of people online."/>
    <title>Slot Mania</title>  
   	<link rel="stylesheet" href="/html/css/html.css" />
   	<script src="http://cdn-img.mocospace.com/wk/js/opensocial/opensocial.js"></script>    
  </head>
  <body>
    <div id="container">
        <div class="wrapper <%= request.getAttribute("wrapperClass") != null ? request.getAttribute("wrapperClass") : ""%>">
            <div class="header">

                <a class="coins" accessKey="2" href="<%= ServletUtils.buildUrl(((com.solitude.slots.entities.Player)request.getAttribute("player")), "/html/topup.jsp", response) %>">
                    <span class="icon-coin"></span>
                    <span id="player_coins" class="delay inline"><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getCoins() %></span>
                    <span class="plus">+</span>
                </a>   

                <span class="logo">
                    <img width="123" height="16" src="/html/images/logo.gif"/>
                </span>

                <span class="level-xp">
                    <%--<span class="level"><b>Level:</b> <span id='level'><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getLevel() %></span></span>--%>
                    <span class="xp"><b>XP:</b> <span id="player_xp"><%= ((com.solitude.slots.entities.Player)request.getAttribute("player")).getXp() %></span></span>
                </span>
            </div>
            
