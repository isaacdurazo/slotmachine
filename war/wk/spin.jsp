<%@page import="com.sun.java_cup.internal.runtime.Symbol"%>
<%
String action = request.getParameter("action");
request.setAttribute("hide_doctype",action);
%>
<%@ include file="/header.jsp" %>
<%@ page import="com.solitude.slots.service.SlotMachineManager.InsufficientFundsException, java.util.Arrays, org.json.simple.*" %>
<%
if (action != null) {
	try {
		SpinResult spinResult = null;
		if ("spin".equals(action)) {
			spinResult = SlotMachineManager.getInstance().spin(player, 1);
		} else if ("maxspin".equals(action)) {
			spinResult = SlotMachineManager.getInstance().spin(player, Integer.parseInt(System.getProperty("game.max.bet.coins")));
		}
		JSONObject responseJSON = new JSONObject();
		try {
			java.util.List<Achievement> earnedAchievements = AchievementService.getInstance().grantAchievements(player, 
					AchievementService.Type.COIN_COUNT, AchievementService.Type.MAX_SPINS);	
			if (earnedAchievements != null && !earnedAchievements.isEmpty()) {
				JSONArray achievementArray = new JSONArray();
				for (Achievement achievement : earnedAchievements) {
					JSONObject achievementJSON = new JSONObject();
					achievementJSON.put("coins",achievement.getCoinsAwarded());
					achievementJSON.put("title",achievement.getTitle());
					achievementArray.add(achievementJSON);
				}
				responseJSON.put("achievements",achievementArray);
			}
		} catch (Exception e) {
			Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error granting achievements for "+player,e);
		}
		responseJSON.put("coins", spinResult.getCoins());
		JSONArray symbolsArray = new JSONArray();
		for (int i=0;i<spinResult.getSymbols().length;i++) {
			symbolsArray.add(spinResult.getSymbols()[i]);
		}
		responseJSON.put("symbols",symbolsArray);
		out.write(responseJSON.toJSONString());
		return;
	} catch (InsufficientFundsException ife) {
		//use redirect to ensure the logging works for topup impressions
		JSONObject responseJSON = new JSONObject();
		responseJSON.put("topup","/wk/topup.jsp?notifymsg="+java.net.URLEncoder.encode("You need more coins to spin!","UTF-8")+
				"&accessToken="+player.getAccessToken());
		out.write(responseJSON.toJSONString());
		return;
	}
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
	<script>
		var xp = <%= player.getXp()%>;
		var currCoins = <%= player.getCoins() %>;
		var btnClicked = false;
		document.addEventListener('DOMContentLoaded', function() {
			document.querySelector('.max_spin_button').addEventListener('click', function(e) {
				e.preventDefault();
				spin(true);
			}, false);
			document.querySelector('.spin_button').addEventListener('click', function(e) {
				e.preventDefault();
				spin();
			}, false);
			function spin(isMax) {
				if (btnClicked) return;
				currCoins -= isMax ? 3 : 1;
				btnClicked = true;
				// reset set
				var betButtons = document.querySelectorAll('.bets td');
				for (var i=0; i<betButtons.length;i++) {
					betButtons[i].style.opacity = '0.5';
				}
				document.getElementById('jackpot').style.display = 'none';
				document.getElementById('jackpot').className = '';
				document.getElementById('lost_result').style.display = 'none';
				document.getElementById('lost_result').className = '';
				document.getElementById('won_result').style.display = 'none';
				document.getElementById('won_result').className = '';
				document.getElementById('achievements').style.display = 'none';		
				document.getElementById('player_coins').style.display = 'none';
				document.getElementById('lights').innerHTML = 
					'<div class="lights-off">'+
						'<div class="lights left"></div>'+
						'<div class="lights right"></div>'+
						'<div class="lights top"></div>'+
						'<div class="lights bottom"></div>'+
					'</div>'+
					'<div class="lights-off">'+
						'<div class="lights left"></div>'+
						'<div class="lights right"></div>'+
						'<div class="lights top"></div>'+
						'<div class="lights bottom"></div>'+
					'</div>';
				
				// make AJAX request
				opensocial.ajax({
					url:'/wk/spin.jsp',
					data: {accessToken:"<%= player.getAccessToken() %>",
						action:(isMax ? "max" : "")+"spin"},
					success: function(data) {
						if (data.topup) {
							// insufficient funds so redirect
							window.location = data.topup;
						} else {
							var coins = data.coins;
							var symbol = data.symbols;
							var achievements = data.achievements;
							document.getElementById('player_xp').innerHTML = ++xp;
							
							if (achievements) {
								document.getElementById('achievements').style.display = 'block';
								document.getElementById('achievement_title_text').innerHTML = 'achievement'+(achievements.length == 1 ? '' : 's');
								var coinsEarned = 0;
								var achievementText = '';
								for (var i=0;i<achievements.length;i++) {
									coinsEarned += achievements[i].coins;
									currCoins += achievements[i].coins;;
									achievementText += '<li>'+achievements[i].title+'</li>';
								}
								document.getElementById('achievement_title_coins').innerHTML = coinsEarned;
								document.querySelector('#achievements ul').innerHTML = achievementText;
							}
							
							currCoins += coins;
							document.getElementById('player_coins').innerHTML = currCoins;		
							
							if (isMax && symbol[0]==0 && symbol[1]==0 && symbol[2]==0) {
								// JACKPOT!
								document.getElementById('jackpot').className = "goldtext delay";
							} else if (coins == 0) {
								document.getElementById('lost_result').className = "lostspin delay";
								var lossText = 'Spin Again';
								if (symbol[0] == 6 && symbol[1] == 6 && symbol[2] == 6) {
									lossText = "When you get all lemons make lemonade :).<br/> Check the "+
										"<a href='<%= ServletUtils.buildUrl(player, "/wk/help.jsp", response) %>'>payout table</a> !";
								}
								document.getElementById('lost_result').innerHTML = lossText;
							} else {
								document.getElementById('won_result').className = "wonspin delay";
								document.getElementById('won_result').innerHTML = 
									'<img width="13" height="11" src="images/animated-star.gif"/>WON '+coins+' coins! '+
									'<img width="13" height="11" src="images/animated-star.gif"/>';								
							}
							document.getElementById('lights').innerHTML = 
								'<div class="lights-'+(coins == 0 ? 'off' : 'win')+' delay" style="display:none;">'+
									'<div class="lights left"></div>'+
									'<div class="lights right"></div>'+
									'<div class="lights top"></div>'+
									'<div class="lights bottom"></div>'+
								'</div>'+
								'<div class="lights-'+(coins == 0 ? 'off' : 'win')+' delay" style="display:none;">'+
									'<div class="lights left"></div>'+
									'<div class="lights right"></div>'+
									'<div class="lights top"></div>'+
									'<div class="lights bottom"></div>'+
								'</div>';
							document.querySelector('table.spins tr').innerHTML =
								'<td>'+
									'<div>'+
										'<span id="spin-animation-1">'+
										'<span class="shadows"></span>'+
										'<img src="/wk/images/spin-static-animation.jpg" alt="animacion" width="70" height="249"/>'+
									'</span>'+
									'<img width="70" height="102" src="/wk/<%=imageLocation%>comb-'+symbol[0]+'.jpg"/>'+
									'</div>'+
								'</td>'+
								'<td>'+
									'<div>'+
										'<span id="spin-animation-2">'+
										'<span class="shadows"></span>'+
										'<img src="/wk/images/spin-static-animation.jpg" alt="animacion" width="70" height="249"/>'+
									'</span>'+
									'<img width="70" height="102" src="/wk/<%=imageLocation%>comb-'+symbol[1]+'.jpg"/>'+
									'</div>'+
								'</td>'+
								'<td>'+
									'<div>'+
										'<span id="spin-animation-3">'+
										'<span class="shadows"></span>'+
										'<img src="/wk/images/spin-static-animation.jpg" alt="animacion" width="70" height="249"/>'+
									'</span>'+
									'<img width="70" height="102" src="/wk/<%=imageLocation%>comb-'+symbol[2]+'.jpg"/>'+
									'</div>'+
								'</td>';
							
							// show animations
							setTimeout(function() {
						  		document.getElementById('spin-animation-1').style.display = 'none';
						  	}, 750);  					  	
						  	setTimeout(function() {
						 	   	document.getElementById('spin-animation-2').style.display = 'none';
						  	}, 1250);  					  	
						  	setTimeout(function() {
						 	   	document.getElementById('spin-animation-3').style.display = 'none';
							 	btnClicked = false;
								for (var i=0; i<betButtons.length;i++) {
									betButtons[i].style.opacity = '1';
								}
						  	}, 1500);
						  	setTimeout(function() {
						  		var elems = document.querySelectorAll('.delay');
						  		if (elems) {
						  			for (var i=0;i<elems.length;i++) {
						  				elems[i].style.display = elems[i].className.indexOf('inline') == -1 ? 'block' : 'inline-block';
						  			}
						  		}
					  		}, 1800); 	
						}
					},
					error: function(errorMsg) {
						alert('Reload page, error: '+errorMsg);
						window.location.reload();
					}
				});
			}
		}, false);
	</script>
  <body>
  	<div id="container">
	  	<div class="wrapper">
		    <div class="header-logo">
		    	<img width="154" height="48" src="/wk/images/logo.png"/>
		    </div>
		    
		    <div class="content">
			    <table class="stats">
			    	<tr>
						<td>
							<span class="stat xp">
								<b>XP:</b> <span id="player_xp"><%= player.getXp() %></span>
							</span>
						</td>
						<td>
							<span class="stat coins">
								<b>Coins:</b> <span id="player_coins" class="delay inline"><%= player.getCoins() %></span>
							</span>
						</td>
					</tr>
				</table>
				
				<div class="results-container">
					<div class="results">
						<% if (coinsAwarded > 0) { %>
					    	<div class="bonus">
					    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
					    	</div> 
					    <% } %>
						<div id="achievements" class="achievements" style='display:none'>							
							You earned <span id="achievement_title_text"></span> and <span id="achievement_title_coins"></span> coins!
							
						</div>
						
						<div id="jackpot" class="goldtext delay" style="display:none;">
							You WON the Moco Gold Jackpot<br />
							<img width="112" height="14" src="images/jackpot-winner.gif"/>
						</div>		
						
						<div id='won_result' class="wonspin delay" style="display:none;"></div>
						
						<div id='lost_result' class="lostspin delay" style="display:none;"></div>
					</div>
				</div>
				
				<div class="spin-container">
					<div class="spin-content">
						<div id="lights">
							<div class="lights-off">
								<div class="lights left"></div>
								<div class="lights right"></div>
								<div class="lights top"></div>
								<div class="lights bottom"></div>
							</div>
							<div class="lights-off">
								<div class="lights left"></div>
								<div class="lights right"></div>
								<div class="lights top"></div>
								<div class="lights bottom"></div>
							</div>
						</div>
						<table class="spins">
							<tr>
								<td style="float: right;">
									<div>									
										<span id="spin-animation-1" style="display: none; ">
											<span class="shadows"></span>
											<img src="/wk/images/spin-static-animation.jpg" alt="animacion" width="70" height="249">
										</span>
										
										<img width="70" height="102" src="/wk/images/comb--1.jpg">
									</div>
								</td>
								<td>
									<div>									
										<span id="spin-animation-2" style="display: none; ">
											<span class="shadows"></span>
											<img src="/wk/images/spin-static-animation.jpg" alt="animacion" width="70" height="249">
										</span>
										
										<img width="70" height="102" src="/wk/images/comb--1.jpg">
									</div>
								</td>
								<td  style="float: left;">
									<div>										
										<span id="spin-animation-3" style="display: none; ">
											<span class="shadows"></span>
											<img src="/wk/images/spin-static-animation.jpg" alt="animacion" width="70" height="249">
										</span>
										
										<img width="70" height="102" src="/wk/images/comb--1.jpg">
									</div>
								</td>
							</tr>
						</table>
					</div>					
				</div>	
				
				<div class="spin-controls">
										
					<table class="bets" align="center" >
						<tr>
							<td class="bet-1">
								<a class="bet spin_button" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?action=spin&"+cacheBuster, response) %>"> BET 1</a>
							</td>
							<td class="bet-2">
								<a class="bet max_spin_button" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?action=maxspin&"+cacheBuster, response) %>"> BET 3</a>
							</td>
						</tr>
					</table>
	
				     <table class="menu">
				        <tr>
				        	<td>
				        		<a href="<%= ServletUtils.buildUrl(player, "/wk/index.jsp", response) %>">Main</a>
				        	</td>
				        	<td>
				        		<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/wk/topup.jsp", response) %>">Buy Coins</a>
				        	</td>
				        </tr>
				    </table>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
