<%@ include file="header_static.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="header_html.jsp" %>
<body>
	<div id="container">
			<div class="wrapper">
				 <div class="header-logo">
			    	<img width="192" height="60" src="images/logo.png"/>
			    </div>
			    
				<div class="content">
			   		
			   		<table class="stats">
			   			<tr>
			   				<td>
			   					The best way to WIN <span class="goldtext">Moco Gold</span>
			   				</td>
			   			</tr>
			   		</table>

					<%@ include file="message.jsp" %>
		    
				    <div class="subheader">Play slots, have fun and win prizes:</div>
					
					<div class="list-container">
						<ul  class="list">
							<li><b>Weekly</b> <span class="goldtext">Gold Jackpot.</span> Now: <span class="goldtext"><%=System.getProperty("weekly.mocogold.min.prize")%> Gold</span> <img class="icon" alt="gold" src="/images/mocogold.gif"></li><br />
							<li><b>Mega Coin Prize:</b> Gain XP with every spin and compete to be #1 on leaderboard. Every sunday midnight #1 wins <%=System.getProperty("weekly.coin.prize") %> coins.</li><br />
							<li><b>Daily free coins:</b> Return <b>every day</b> and get FREE coins to spin.</li><br />
							<li><b>Payout:</b> Check the payout table for spin payouts.</li>
						</ul>
					</div>
					
					<table class="menu">
						<tr>
							<td>
				       			<a accessKey="1" href="<%= response.encodeURL("/wk/index.jsp") %>">Start Play</a>
				       		</td>
				       	</tr>
				    </table>
				    
					<div class="payout-table">
					
						<div style="text-align: center">Payout Table Bet 1 Coin:</div>
						
						<table>
							<tr>
								<td>
									3x <img width="16" height="16" src="images/individual/diamond.gif"/>: 500 <br/>
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/seven.gif"/>: 150 <br/>
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/bar.gif"/>: 50 <br/> 
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/bell.gif"/>: 20 <br/>
								</td>
							</tr>
							<tr>
								<td>
									3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 15 <br/>
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 10 <br/>
								</td>
								<td>
									2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 5 <br/>
								</td>
								<td>
									1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 2 <br/> 
								</td>
							</tr>
						</table>
						
						<div>
						</div>
					</div>
					<div class="payout-table border-bottom">
						
						<div style="text-align: center">Payout Table Bet Max Coins:</div>
					
						<table>
							<tr>
								<td>
									3x <img width="16" height="16" src="images/individual/diamond.gif"/>: <img class="icon"  alt="gold" src="/images/mocogold.gif"> <span class="goldtext">*Jackpot*</span><br/>
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/seven.gif"/>: 600 <br/>
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/bar.gif"/>: 200 <br/> 
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/bell.gif"/>: 80 <br/>
								</td>
							</tr>
							<tr>
								<td>
									3x <img width="16" height="16" src="images/individual/watermelon.gif"/>: 60 <br/>
								</td>
								<td>
									3x <img width="16" height="16" src="images/individual/cherry.gif"/>: 40 <br/>
								</td>
								<td>
									2x <img width="16" height="16" src="images/individual/cherry.gif"/>: 20 <br/>
								</td>
								<td>
									1x <img width="16" height="16" src="images/individual/cherry.gif"/>: 8 <br/> 
								</td>
							</tr>
						</table>
							
						</div>
					
						<table class="menu">
							<tr>
								<td>
					       			<a href="<%= response.encodeURL("/wk/index.jsp") %>">Main Page</a>
					       		</td>
					       	</tr>
					    </table>
				    
					
					</div>
					
					
					
				</div>
			</div>
	</div>
</body>
</html>