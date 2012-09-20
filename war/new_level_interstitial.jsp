<%@ include file="/header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>

	<div class="instertitial-container" style="text-align:center">
		<div style="font-weight:bold">The new SlotMania is here!</div>
		<div>Embark on the new SlotMania adventure</div>
	</div>
	<div class="instertitial-container">
		<ul>
			<li>Start playing at The Fruit Garden</li>
			<li>Spin to gain XP and unlock new locations</li>
			<li>Each location has a new slot machine with new payout and betting tables</li>
			<li><span class="goldtext">Moco Gold JackPot</span> increase with each location: 150%, 200% , 250% - the sky is the limit</li>
			<li>Play now - the more you spin the quicker you level up and increase your <span class="goldtext">Gold JackPot</span></li>
		</ul>
		
		<div class="play">
			1. <a accessKey="1" href="<%= ServletUtils.buildUrl(player, "/locations.jsp?"+cacheBuster, response) %>">Next</a>
		</div>
		<% if (player.getXp() > Integer.getInteger("level.xp.min.2")) { %>
			<small>Based on your current XP you might already have unlocked more than 1 location</small>
		<% } %>
	</div>
  </body>
</html>