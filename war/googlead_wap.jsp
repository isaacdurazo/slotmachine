<%@ include file="/googlead_common.jsp" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException" %>

<%
Player currPlayer = (Player)request.getAttribute("player");
if (currPlayer != null && (currPlayer.getMocoId()%2==0 || currPlayer.hasAdminPriv())) {
%>
<!-- Ads on for this user-->
<% 
BufferedReader in = null;
try {

//for odd uid show ads
	
long googleDt = System.currentTimeMillis();
StringBuilder googleAdUrlStr = new StringBuilder(PAGEAD);
googleAdUrlStr.append("&client=ca-mb-pub-1639537201849581"); 
googleAdUrlStr.append("&dt=").append(googleDt);

googleAppendUrl(googleAdUrlStr, "ip", request.getRemoteAddr());
googleAdUrlStr.append("&markup=xhtml");
googleAdUrlStr.append("&output=xhtml");
googleAppendUrl(googleAdUrlStr, "ref", request.getHeader("Referer"));
String googleUrl = request.getRequestURL().toString();
if (request.getQueryString() != null) {
  googleUrl += "?" + request.getQueryString().toString();
}
googleAdUrlStr.append("&slotname=1697485011");
googleAppendUrl(googleAdUrlStr, "url", googleUrl);
String googleUserAgent = request.getHeader("User-Agent");
googleAppendUrl(googleAdUrlStr, "useragent", googleUserAgent);
googleAppendScreenRes(googleAdUrlStr, request.getHeader("UA-pixels"),
    request.getHeader("x-up-devcap-screenpixels"),
    request.getHeader("x-jphone-display"));
List<String> googleMuids = new ArrayList<String>();
googleMuids.add(request.getHeader("X-DCMGUID"));
googleMuids.add(request.getHeader("X-UP-SUBNO"));
googleMuids.add(request.getHeader("X-JPHONE_UID"));
googleMuids.add(request.getHeader("X-EM-UID"));
googleAppendMuid(googleAdUrlStr, googleMuids);
if (googleUserAgent == null || googleUserAgent.length() == 0) {
  googleAppendViaAndAccept(googleAdUrlStr, request.getHeader("Via"),
      request.getHeader("Accept"));
}


  Logger.getLogger(request.getRequestURI()).log(Level.INFO,"Attempting to get Adsense url="+googleAdUrlStr.toString());
	
  URL googleAdUrl = new URL(googleAdUrlStr.toString());
  HttpURLConnection c = (HttpURLConnection) googleAdUrl.openConnection();
  c.setConnectTimeout(100);
  c.setReadTimeout(100);
  c.setRequestMethod("GET");
  // Read the response
  in = new BufferedReader(new InputStreamReader(c.getInputStream()));
  String line;
  while ((line = in.readLine()) != null) {
	out.write(line);
  }
} catch (Exception e) {
	Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"Error showing ad",e);
} finally {
	if (in != null) try { in.close(); } catch (Exception e) {}
}
}

%>