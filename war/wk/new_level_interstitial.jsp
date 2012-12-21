<%@ include file="/header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
	
	<div class="instertitial-container">
		<h2>The new SlotMania is here!</h2>
		<div>Embark on the new SlotMania adventure</div>
	</div>
	<div class="instertitial-container">

		<p>Start playing at The Fruit Garden.</p>
		<p>Spin to gain XP and unlock new locations.</p>
		<p>Each location has a new slot machine with new payout and betting tables.</p>
		<p><span class="goldtext">Moco Gold JackPot</span> increase with each location: 150%, 200% , 250% - the sky is the limit.</p>
		<p>PLAY NOW! The more you spin the quicker you level up and increase your <span class="goldtext">Gold JackPot.</span></p>

		<div class="play">
			<a href="<%= ServletUtils.buildUrl(player, "/wk/locations.jsp?"+cacheBuster, response) %>">Next</a>
		</div>
		<% if (player.getXp() > Integer.getInteger("level.xp.min.2")) { %>
			<small>Based on your current XP you might already have unlocked more than 1 location</small>
		<% } %>
	</div>
  </body>
</html>