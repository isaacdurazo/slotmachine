<%@page import="com.sun.java_cup.internal.runtime.Symbol"%>
<%
String action = request.getParameter("action");
request.setAttribute("hide_doctype",action);
%>
<%@ include file="/header.jsp" %>
<%@ page import="com.solitude.slots.service.SlotMachineManager.InsufficientFundsException, java.util.Arrays, org.json.simple.*" %>
<%

boolean fMillenialAds=false;
int spinsPerAd=8;
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
	case 3: lemonText = "Don't you wish you went fishing instead ? :)<br/>";break;
	case 4: lemonText = "Playing in Wild Jungle is no monkey business :).<br/>";break;
	default: lemonText = "When life gives you lemons make lemonade :)<br/>";break;	
}

request.setAttribute("wrapperClass","level-"+player.getPlayingLevel());
String reelImagePath = "/html/images/"+(player.getPlayingLevel() > 1 ? ("level-"+player.getPlayingLevel()+"/") : "");
String reelAnimation = "/html/images/"+(player.getPlayingLevel() > 1 ? ("level-"+player.getPlayingLevel()+"/") : "")+"spin-static-animation.jpg";
int maxBet = SlotMachineManager.getInstance().getMaxBet(player);
/*if ("true".equals(request.getParameter("reload")) && player.getGoldDebitted() == 0 && player.showInterstitialAd()) {
	// store player to save interstital ad state
	PlayerManager.getInstance().storePlayer(player,true);
	// redirect to interstitial page
	response.sendRedirect(ServletUtils.buildUrl(player, "/html/interstitial_ad.jsp"+(request.getQueryString() == null ? "" : ("?"+request.getQueryString())), response));
	return;
}*/
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
			levelInfo.put("jackpot", player.getMocoGoldPrize());
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
		responseJSON.put("topup","/html/topup.jsp?notifymsg="+java.net.URLEncoder.encode("You need more coins to spin!","UTF-8")+
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
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<script>
		var xp = <%= player.getXp()%>;
		var currCoins = <%= player.getCoins() %>;
		var btnClicked = false;
		var spinsRemaining = <%= spinsPerAd %>;
		var accessToken = "<%= player.getAccessToken()%>";
		$(document).ready(function() {
			$(".achievements .close, .achievements .play a, .level-up a.close").click(function(e) {
					e.preventDefault();
					$('.achievements').css({display:'none'});	
					$('.level-up').css({style:'none'});					
					return false;
				});
			$('.max_spin_button').click(function(e) {
				e.preventDefault();
				spin(true);
			});
			$('.spin_button').click(function(e) {
				e.preventDefault();
				spin();
			});
			<% if ("true".equals(request.getParameter("reload"))) { %>
				spin(<%= "true".equals(request.getParameter("maxBet")) %>);
			<% } %>
			function spin(isMax) {
				if (btnClicked) return;
				if (spinsRemaining-- <= 0) {
					window.location.href = "/html/spin.jsp?accessToken="+encodeURIComponent(accessToken)+
							"&reload=true&maxBet="+isMax;
					return;
				}
				
				try {_gaq.push(['_trackEvent', 'Spin', isMax ? 'Max' : 'Min']);} catch (err) {if (console && console.err) {console.error(err);}}
				currCoins -= isMax ? <%= maxBet %> : 1;
				btnClicked = true;
				// reset set
				$('.bets a').css({opacity:'0.5'});
				$('#jackpot').css({display:'none'});
				$('#jackpot').removeClass('goldtext').removeClass('delay');
				$('#lost_result').css({display:'none'});
				$('#lost_result').removeClass('lostspin').removeClass('delay');
				$('#won_result').css({display:'none'});
				$('#won_result').removeClass('wonspin').removeClass('delay');
				$('.achievements').css({display:'none'});		
				$('#player_coins').css({display:'none'});
				$('.level-up').css({display:'none'});
				$('lights').html('<div class="lights-off">'+
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
					'</div>');
				// make AJAX request
				$.ajax({
					url:'/html/spin.jsp',
					data: {accessToken:"<%= player.getAccessToken() %>",action:(isMax ? "max" : "")+"spin"},
					dataType:'json',
					success: function(data) {
						if (data.topup) {
							try {_gaq.push(['_trackEvent', 'Spin', 'insufficient']);} catch (err) {if (console && console.error) { console.error(err);} }
							// insufficient funds so redirect
							window.location = data.topup;
						} else {
							var coins = data.coins;
							var symbol = data.symbols;
							var achievements = data.achievements;
							var levelUp = data.level;
							$('#player_xp').html(++xp);
							try {_gaq.push(['_trackEvent', 'Spin', 'Result',coins ? 'Win' : 'Loss', coins]);} catch (err) {if (console && console.error) { console.error(err);} }
							
							if (levelUp) {
								$('.level-up').css({display:'block'});
								$('.level-name').html(levelUp.name);
								$('.level-bonus').html(levelUp.jackpot);
								$('.level-up .play a').attr('href','<%= ServletUtils.buildUrl(player, "/html/spin.jsp",response)%>&playingLevel='+levelUp.num);
								$('#level').html(levelUp.num);
								try {_gaq.push(['_trackEvent', 'Player', 'levelUp',undefined,levelUp.num]);} catch (err) {if (console && console.error) { console.error(err);}}
							} else if (achievements) {
								$('.achievements').css({display:'block'});
								$('#achievement_title_text').html('achievement'+(achievements.length == 1 ? '' : 's'));
								var coinsEarned = 0;
								var achievementText = '';
								for (var i=0;i<achievements.length;i++) {
									coinsEarned += achievements[i].coins;
									currCoins += achievements[i].coins;
									try {_gaq.push(['_trackEvent', 'Achievement', achievements[i].title.substring(0,9), achievements[i].coins]);} catch (err) {console.error(err);}
									achievementText += '<li><small>'+achievements[i].title+'<small></li>';
								}
								$('#achievement_title_coins').html(coinsEarned);
								$(".achievements ul").html(achievementText);
							}
							
							currCoins += coins;
							$('#player_coins').html(currCoins);		
							
							if (isMax && symbol[0]==0 && symbol[1]==0 && symbol[2]==0) {
								// JACKPOT!
								$('#jackpot').addClass("goldtext").addClass("delay");
							} else if (coins == 0) {
								$('#lost_result').addClass("lostspin").addClass("delay");
								var lossText = 'Spin Again';
								if (symbol[0] == 6 && symbol[1] == 6 && symbol[2] == 6) {
									lossText = "<%=lemonText%>"+ "How to win check "+
										"<a href='<%= ServletUtils.buildUrl(player, "/html/help.jsp", response) %>'>payout table</a> !";
								}
								$('#lost_result').html(lossText);
							} else {
								$('#won_result').addClass("wonspin").addClass("delay");
								$('#won_result').html( 
									'<img width="13" height="13" src="images/animated-star.gif"/> WON '+coins+' coins! '+
									'<img width="13" height="13" src="images/animated-star.gif"/>');								
							}
							var s1="<%=reelImagePath%>comb-"+symbol[0]+".jpg";
							var s2="<%=reelImagePath%>comb-"+symbol[1]+".jpg";
							var s3="<%=reelImagePath%>comb-"+symbol[2]+".jpg";
							$('table.spins').html(
								'<tr><td>'+
									'<div>'+
										'<span id="spin-animation-1">'+
										'<span class="shadows"></span>'+
										'<img src="<%=reelAnimation%>" alt="animacion" width="161" height="573"/>'+
									'</span>'+
									'<img width="161" height="230" src="'+s1+'"/>'+
									'</div>'+
								'</td>'+
								'<td>'+
									'<div>'+
										'<span id="spin-animation-2">'+
										'<span class="shadows"></span>'+
										'<img src="<%=reelAnimation%>" alt="animacion" width="161" height="573"/>'+
									'</span>'+
									'<img width="161" height="230" src="'+s2+'"/>'+
									'</div>'+
								'</td>'+
								'<td>'+
									'<div>'+
										'<span id="spin-animation-3">'+
										'<span class="shadows"></span>'+
										'<img src="<%=reelAnimation%>" alt="animacion" width="161" height="573"/>'+
									'</span>'+
									'<img width="161" height="230" src="'+s3+'"/>'+
									'</div>'+
								'</td></tr>');
							
							// show animations
							setTimeout(function() {
						  		$('#spin-animation-1').css({display:'none'});
						  	}, 750);  					  	
						  	setTimeout(function() {
						 	   	$('#spin-animation-2').css({display:'none'});
						  	}, 1250);  					  	
						  	setTimeout(function() {
						 	   	$('#spin-animation-3').css({display:'none'});
							 	btnClicked = false;
							 	$('.bets a').css({opacity:'1'});
						  	}, 1500);
						  	setTimeout(function() {
						  		$('.delay').css({display:'inline-block'});
						  		$('#lights').html( 
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
									'</div>');
					  		}, 1800); 	
						}
					},
					error: function(errorMsg) {
						alert('Reload page, error: '+errorMsg);
						window.location.reload();
					}
				});
			}
		});
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
						<a href="<%= ServletUtils.buildUrl(player, "/html/locations.jsp", response) %>">change</a>
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
								<td>
									<div>									
										<span id="spin-animation-1" style="display: none; ">
											<span class="shadows"></span>
											<img src="<%=reelAnimation%>" alt="animacion" width="161" height="573">
										</span>
										
										<img width="161" height="230" src="/html/images/comb--1.jpg">
									</div>
								</td>
								<td>
									<div>									
										<span id="spin-animation-2" style="display: none; ">
											<span class="shadows"></span>
											<img src="<%=reelAnimation%>" alt="animacion" width="161" height="573">
										</span>
										
										<img width="161" height="230" src="/html/images/comb--1.jpg">
									</div>
								</td>
								<td>
									<div>										
										<span id="spin-animation-3" style="display: none; ">
											<span class="shadows"></span>
											<img src="<%=reelAnimation%>" alt="animacion" width="161" height="573">
										</span>
										
										<img width="161" height="230" src="/html/images/comb--1.jpg">
									</div>
								</td>
							</tr>
						</table>
					</div>					
				</div>	
				<div class="ad">
					<% 
					boolean swapAd = false;
					if (!(swapAd = player.swapAds())) { %>
						<script type="text/javascript">
						google_ad_client = "ca-pub-1639537201849581";
						/* HTMLBetButton */ 
						google_ad_slot = "0207515525"; 
						google_ad_width = 468;
						google_ad_height = 60;
						</script>
						<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
						<% } %>
				</div>
				<div class="spin-controls">
					<div class="controls">
						<div class="button-row bets">
							<div class="block half-left">
								<a class="bet spin_button" href="<%= ServletUtils.buildUrl(player, "/html/spin.jsp?action=spin&"+cacheBuster, response) %>"> BET 1</a>
							</div>
							<div class="block half-right">
								<a class="bet max_spin_button" href="<%= ServletUtils.buildUrl(player, "/html/spin.jsp?action=maxspin&"+cacheBuster, response) %>"> BET <%= maxBet %></a>
							</div>
						</div>
					</div>
				</div>
				<% if (swapAd) { PlayerManager.getInstance().storePlayer(player,true); %>
					<script type="text/javascript">
					google_ad_client = "ca-pub-1639537201849581";
					/* HTMLBetButton */ 
					google_ad_slot = "0207515525"; 
					google_ad_width = 468;
					google_ad_height = 60;
					</script>
					<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
				<% } %>
				<div id="footer" class="menu">
					<div class="block half-left">
		        		<a href="<%= ServletUtils.buildUrl(player, "/html/index.jsp", response) %>">Main</a>
		        	</div>
					<div class="block half-right">
		        		<a accessKey="2" href="<%= ServletUtils.buildUrl(player, "/html/topup.jsp", response) %>">Buy Coins</a>
		        	</div>
			    </div>
			</div>
		</div>
	</div>
	</div>
	<%@ include file="/html/ga.jsp" %>
  </body>
</html>
