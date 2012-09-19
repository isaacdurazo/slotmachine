<%@ include file="/header.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
	<h2>The new SlotMania is here!</h2>
	<div>
		<p>Embark on the new SlotMania adventure</p>
		<ul>
			<li>Start playing at The Fruit Garden</li>
			<li>Spin to gain XP and unlock new locations</li>
			<li>Each location has a new slot machine with new payout and betting tables</li>
			<li>Moco Gold JackPot increase with each location: 150%, 200% , 250% - the sky is the limit</li>
		</ul>
		<p>Play now - the more you spin the quicker you level up and increase your Gold JackPot</p>
		<div class="play">
			1. <a accessKey="1 href="<%= ServletUtils.buildUrl(player, "/spin.jsp?"+cacheBuster, response) %>">Play Now</a>
		</div>
		<% if (player.getXp() > Integer.getInteger("level.xp.min.2")) { %>
			<small>Based on your current XP you might already have unlocked >1 location</small>
		<% } %>
	</div>
  </body>
</html>