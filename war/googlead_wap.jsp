<%@ include file="/googlead_common.jsp" %>
<%@ page import="java.util.logging.*" %>
<%
if (!(player.getMocoId()%2==0)) {
%>
<!-- Ads on for this user-->
<% 	
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

try {
  Logger.getLogger(request.getRequestURI()).log(Level.FINER,"Attempting to get Adsense url="+googleAdUrlStr.toString());
	
  URL googleAdUrl = new URL(googleAdUrlStr.toString());
  BufferedReader reader = new BufferedReader(
      new InputStreamReader(googleAdUrl.openStream(), "AUTO_DETECT"));
  for (String line; (line = reader.readLine()) != null;) {
    out.println(line);
  }
} catch (IOException e) {}
}

%>