<%@page import="com.sun.java_cup.internal.runtime.Symbol"%>
<%
String action = request.getParameter("action");
request.setAttribute("hide_doctype",action);
%>
<%@ include file="/header.jsp" %>
<%@ page import="com.solitude.slots.service.SlotMachineManager.InsufficientFundsException, java.util.Arrays, org.json.simple.*" %>
<%

boolean fMillenialAds=false;
int spinsPerAd=10;
if (Boolean.getBoolean("millenial.wk.ad.enabled") && System.currentTimeMillis() % 10 == 0) {
	fMillenialAds=true;
	spinsPerAd=5;
	}

int setPlayingLevel = ServletUtils.getInt(request, "playingLevel");
if (setPlayingLevel > 0 && (player.hasAdminPriv() || (setPlayingLevel <= Integer.getInteger("max.player.level") && player.getLevel() >= setPlayingLevel))) {
	player.setPlayingLevel(setPlayingLevel);
	PlayerManager.getInstance().storePlayer(player, true);
}

String lemonText="";
switch (player.getPlayingLevel()) {
	case 2: lemonText = "A whole bunch of needles for you :).<br/>";break;
	case 3: lemonText = "Don't you wish you went fishing instead :)<br/>";break;
	case 4: lemonText = "Playing in Wild Jungle is no monkey business :).<br/>";break;
	default: lemonText = "When life gives you lemons make lemonade :)<br/>";break;	
}

request.setAttribute("wrapperClass","level-"+player.getPlayingLevel());
String reelImagePath = "/wk/images/"+(player.getPlayingLevel() > 1 ? ("level-"+player.getPlayingLevel()+"/") : "");
String reelAnimation = "/wk/images/"+(player.getPlayingLevel() > 1 ? ("level-"+player.getPlayingLevel()+"/") : "")+"spin-static-animation.jpg";
int maxBet = SlotMachineManager.getInstance().getMaxBet(player);
if ("true".equals(request.getParameter("reload")) && player.getGoldDebitted() == 0 && player.showInterstitialAd()) {
	// store player to save interstital ad state
	PlayerManager.getInstance().storePlayer(player,true);
	// redirect to interstitial page
	response.sendRedirect(ServletUtils.buildUrl(player, "/wk/interstitial_ad.jsp"+(request.getQueryString() == null ? "" : ("?"+request.getQueryString())), response));
	return;
}
if (action != null) {
	try {
		SpinResult spinResult = null;
		if ("spin".equals(action)) {
			spinResult = SlotMachineManager.getInstance().spin(player, false);
		} else if ("maxspin".equals(action)) {
			spinResult = SlotMachineManager.getInstance().spin(player, true);
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
		if (spinResult.getLevelUp() && player.getXp() == Integer.getInteger("level.xp.min."+player.getLevel()).intValue()) {
			JSONObject levelInfo = new JSONObject();
			levelInfo.put("name", System.getProperty("level.name."+player.getLevel()));
			levelInfo.put("jackpot", Double.parseDouble(System.getProperty("level.jackpot.multiplier."+player.getLevel()))*GameUtils.getGlobalProps().getMocoGoldPrize());
			levelInfo.put("num", player.getLevel());
			responseJSON.put("level",levelInfo);
		}
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
java.util.List<Achievement> earnedAchievements = null;
	try {
		earnedAchievements = AchievementService.getInstance().grantAchievements(player, 
				AchievementService.Type.SESSION, AchievementService.Type.INVITE);	
	} catch (Exception e) {
		Logger.getLogger(request.getRequestURI()).log(Level.WARNING,"Error granting achievements for "+player,e);
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
	<script>
		var xp = <%= player.getXp()%>;
		var currCoins = <%= player.getCoins() %>;
		var btnClicked = false;
		var spinsRemaining = <%= spinsPerAd %>;
		var accessToken = "<%= player.getAccessToken()%>";
		document.addEventListener('DOMContentLoaded', function() {
			var closeBtns = document.querySelectorAll(".achievements .close, .achievements .play a, .level-up a.close");
			for (var i=0;i<closeBtns.length;i++) {
				closeBtns[i].addEventListener('click', function(e) {
					document.querySelector('.achievements').style.display = 'none';	
					document.querySelector('.level-up').style.display = 'none';
					e.preventDefault();
					return false;
				},false);
			}
			document.querySelector('.max_spin_button').addEventListener('click', function(e) {
				e.preventDefault();
				spin(true);
			}, false);
			document.querySelector('.spin_button').addEventListener('click', function(e) {
				e.preventDefault();
				spin();
			}, false);
			<% if ("true".equals(request.getParameter("reload"))) { %>
				spin(<%= "true".equals(request.getParameter("maxBet")) %>);
			<% } %>
			function spin(isMax) {
				if (btnClicked) return;
				if (spinsRemaining-- <= 0) {
					window.location.href = "/wk/spin.jsp?accessToken="+encodeURIComponent(accessToken)+
							"&reload=true&maxBet="+isMax;
					return;
				}
				try {_gaq.push(['_trackEvent', 'Spin', isMax ? 'Max' : 'Min']);} catch (err) {console.error(err);}
				currCoins -= isMax ? <%= maxBet %> : 1;
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
				document.querySelector('.achievements').style.display = 'none';		
				document.getElementById('player_coins').style.display = 'none';
				document.querySelector('.level-up').style.display = 'none';
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
							try {_gaq.push(['_trackEvent', 'Spin', 'insufficient']);} catch (err) {console.error(err);}
							// insufficient funds so redirect
							window.location = data.topup;
						} else {
							var coins = data.coins;
							var symbol = data.symbols;
							var achievements = data.achievements;
							var levelUp = data.level;
							document.getElementById('player_xp').innerHTML = ++xp;
							try {_gaq.push(['_trackEvent', 'Spin', 'Result',coins ? 'Win' : 'Loss', coins]);} catch (err) {console.error(err);}
							
							if (levelUp) { 
								document.querySelector('.level-up').style.display = 'block';
								document.querySelector('.level-name').innerHTML = levelUp.name;
								document.querySelector('.level-bonus').innerHTML = levelUp.jackpot;
								document.querySelector('.level-up .play a').href = '<%= ServletUtils.buildUrl(player, "/wk/spin.jsp",response)%>&playingLevel='+levelUp.num;
								if (document.getElementById('level')) document.getElementById('level').innerHTML = levelUp.num;
								try {_gaq.push(['_trackEvent', 'Player', 'levelUp',undefined,levelUp.num]);} catch (err) {console.error(err);}
							} else if (achievements) {
								document.querySelector('.achievements').style.display = 'block';
								document.getElementById('achievement_title_text').innerHTML = 'achievement'+(achievements.length == 1 ? '' : 's');
								var coinsEarned = 0;
								var achievementText = '';
								for (var i=0;i<achievements.length;i++) {
									coinsEarned += achievements[i].coins;
									currCoins += achievements[i].coins;
									try {_gaq.push(['_trackEvent', 'Achievement', achievements[i].title.substring(0,9), achievements[i].coins]);} catch (err) {console.error(err);}
									achievementText += '<li><small>'+achievements[i].title+'<small></li>';
								}
								document.getElementById('achievement_title_coins').innerHTML = coinsEarned;
								document.querySelector(".achievements ul").innerHTML = achievementText;
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
									lossText = "<%=lemonText%>"+ "Check the "+
										"<a href='<%= ServletUtils.buildUrl(player, "/wk/help.jsp", response) %>'>payout table</a> !";
								}
								document.getElementById('lost_result').innerHTML = lossText;
							} else {
								document.getElementById('won_result').className = "wonspin delay";
								document.getElementById('won_result').innerHTML = 
									'<img width="13" height="11" src="images/animated-star.gif"/> WON '+coins+' coins! '+
									'<img width="13" height="11" src="images/animated-star.gif"/>';								
							}
							var s1="<%=reelImagePath%>comb-"+symbol[0]+".jpg";
							var s2="<%=reelImagePath%>comb-"+symbol[1]+".jpg";
							var s3="<%=reelImagePath%>comb-"+symbol[2]+".jpg";
							console.log("Spin AJAX s1="+s1+" s2="+s2+" s3="+s3);
							document.querySelector('table.spins').innerHTML =
								'<tr><td style="float: right;">'+
									'<div>'+
										'<span id="spin-animation-1">'+
										'<span class="shadows"></span>'+
										'<img src="<%=reelAnimation%>" alt="animacion" width="70" height="249"/>'+
									'</span>'+
									'<img width="70" height="102" src="'+s1+'"/>'+
									'</div>'+
								'</td>'+
								'<td>'+
									'<div>'+
										'<span id="spin-animation-2">'+
										'<span class="shadows"></span>'+
										'<img src="<%=reelAnimation%>" alt="animacion" width="70" height="249"/>'+
									'</span>'+
									'<img width="70" height="102" src="'+s2+'"/>'+
									'</div>'+
								'</td>'+
								'<td style="float: left;">'+
									'<div>'+
										'<span id="spin-animation-3">'+
										'<span class="shadows"></span>'+
										'<img src="<%=reelAnimation%>" alt="animacion" width="70" height="249"/>'+
									'</span>'+
									'<img width="70" height="102" src="'+s3+'"/>'+
									'</div>'+
								'</td></tr>';
							
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
						  		document.getElementById('lights').innerHTML = 
									'<div class="lights-'+(coins == 0 ? 'off' : 'win')+'">'+
										'<div class="lights left"></div>'+
										'<div class="lights right"></div>'+
										'<div class="lights top"></div>'+
										'<div class="lights bottom"></div>'+
									'</div>'+
									'<div class="lights-'+(coins == 0 ? 'off' : 'win')+'">'+
										'<div class="lights left"></div>'+
										'<div class="lights right"></div>'+
										'<div class="lights top"></div>'+
										'<div class="lights bottom"></div>'+
									'</div>';
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
   
		    <div class="content">
		    
			    <div class="achievements" style="display:none">
			    	<div class="dialog-container">
						<h1>CONGRATULATIONS!</h1>
						
						<h2>You completed <span id="achievement_title_text"></span> and won <span id="achievement_title_coins"></span> coins!</h2>
						
						<ul></ul>
						
						<a class="close" href="#" ></a>
						
						<div class="play">
							<a href="#">Continue</a>
						</div>
					</div>
					<div class="overlay"></div>	
				</div>

		    	<div class="level-up" style="display:none">
					<div class="dialog-container">
						<a class="close" href="#" ></a>

						<!--h1>LEVEL UP!</h1-->
						
						<h3>You unlocked a new slotmachine</h3>
						<h2 class='level-name'>Under the Sea</h2>
						
						<h3>Jackpot <span class='level-bonus'></span> Gold</h3>

						<div class="play">
							<a href="#">Play Now</a>
						</div>
					</div>
					<div class="overlay"></div>
				</div>
				
				<% if (coinsAwarded > 0) { %>
			    	<div class="bonus">
			    		Your daily bonus: <%= coinsAwarded %> coins <% if (player.getConsecutiveDays() > 0) { %> for <%= player.getConsecutiveDays() %> consecutive day<%= player.getConsecutiveDays() == 1 ? "" : "s" %> play<% } %>!
			    	</div> 
			    <% } %>

				<div class="spin-results">		
					
					<div class="location">
						<span><%= System.getProperty("level.name."+player.getPlayingLevel()) %></span>
						<a href="<%= ServletUtils.buildUrl(player, "/wk/locations.jsp", response) %>">change</a>
					</div>
					<div class="results">
						<div id="jackpot" class="goldtext delay" style="display:none;">
							You WON the Moco Gold Jackpot
						</div>		
						
						<div id='won_result' class="wonspin delay" ></div>
						
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
						</div>
						<table class="spins">
							<tr>
								<td style="float: right;">
									<div>									
										<span id="spin-animation-1" style="display: none; ">
											<span class="shadows"></span>
											<img src="<%=reelAnimation%>" alt="animacion" width="70" height="249">
										</span>
										
										<img width="70" height="102" src="/wk/images/comb--1.jpg">
									</div>
								</td>
								<td>
									<div>									
										<span id="spin-animation-2" style="display: none; ">
											<span class="shadows"></span>
											<img src="<%=reelAnimation%>" alt="animacion" width="70" height="249">
										</span>
										
										<img width="70" height="102" src="/wk/images/comb--1.jpg">
									</div>
								</td>
								<td  style="float: left;">
									<div>										
										<span id="spin-animation-3" style="display: none; ">
											<span class="shadows"></span>
											<img src="<%=reelAnimation%>" alt="animacion" width="70" height="249">
										</span>
										
										<img width="70" height="102" src="/wk/images/comb--1.jpg">
									</div>
								</td>
							</tr>
						</table>
					</div>					
				</div>	
				<% if (player.hasAdminPriv() || player.getGoldDebitted() == 0) { %>
					<% if (fMillenialAds) { %>
					<%@ include file="/wk/mm_wk_ad.jsp" %>
					<% } else { %>
					<script type="text/javascript">
						google_ad_client = "ca-pub-1639537201849581";
						/* wk spin */
						google_ad_slot = "1288785559";
						google_ad_width = 320;
						google_ad_height = 50;
					</script>
					<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
					<% } %>
				<% } %>
				<div class="spin-controls">
					<div class="controls">
						<div class="button-row bets">
							<div class="block half-left">
								<a class="bet spin_button" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?action=spin&"+cacheBuster, response) %>"> BET 1</a>
							</div>
							<div class="block half-right">
								<a class="bet max_spin_button" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp?action=maxspin&"+cacheBuster, response) %>"> BET <%= maxBet %></a>
							</div>
						</div>
					</div>
					<div class="menu">
						<div class="button-row">
							<div class="block half-left">
				        		<a href="<%= ServletUtils.buildUrl(player, "/wk/index.jsp", response) %>">Main</a>
				        	</div>
							<div class="block half-right">
				        		<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/wk/topup.jsp", response) %>">Buy Coins</a>
				        	</div>
				        </div>
				    </div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/wk/ga.jsp" %>
  </body>
</html>
