<%@ include file="/header.jsp" %>
<html>
	<head>
		<link rel="stylesheet" href="/wk/css/webkit.css" />
    	<link href='http://fonts.googleapis.com/css?family=Electrolize' rel='stylesheet' type='text/css'>
	</head>
	<body>
		<div class="wrapper">
			<div class="button-row" style="margin-top:25px;">		
				<script type="text/javascript">
					<!--
					google_ad_client = "ca-pub-1639537201849581";
					/* WebKit Interstitial */
					google_ad_slot = "8763282757";
					google_ad_width = 300;
					google_ad_height = 250;
					//-->
				</script>
				<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
			</div>
			<div class="menu">
				<div class="button-row">
					<a style="padding: 3px;margin-top: 15px;width: 30%;" href="<%= ServletUtils.buildUrl(player, "/wk/spin.jsp"+(request.getQueryString() == null ? "" : ("?"+request.getQueryString())), response) %>">
						Continue
					</a>
				</div>
			</div>
		</div>		
	</body>
</html>
