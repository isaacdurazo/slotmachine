<%@ include file="/mmad_common.jsp" %>
<%@ page import="java.util.logging.*" %>
<%@ page import="com.solitude.slots.*,com.solitude.slots.service.*,com.solitude.slots.entities.*,com.solitude.slots.service.SlotMachineManager.InsufficientFundsException" %>

<%
Player currPlayer = (Player)request.getAttribute("player");
if (currPlayer != null) {
%>
<!-- Ads on for this user--> 
<% 
String mm_ua = request.getHeader( "User-Agent" );
String mm_ip = request.getRemoteAddr();
String mm_id = request.getRemoteAddr();
if( request.getHeader( "x-up-subno" ) != null )
  mm_id = request.getHeader( "x-up-subno" );
if( request.getHeader( "clientid" ) != null )
  mm_id = request.getHeader( "clientid" );
else if( request.getHeader( "xid" ) != null )
  mm_id = request.getHeader( "xid" );

try {
  mm_ua = URLEncoder.encode( mm_ua, "UTF-8" );
  mm_id = URLEncoder.encode( mm_id, "UTF-8" );
  mm_ip = URLEncoder.encode( mm_ip, "UTF-8" );
} catch( Exception e ) { }

String mm_url = "http://" + mm_adserver + "/getAd.php5" + "?apid=" + mm_placementid+ "&auid=" + mm_id + "&ua=" + mm_ua + "&uip=" + mm_ip;

StringBuilder contents = new StringBuilder();
try {

  URL url = new URL( mm_url );

  // Set the connection timeout
  int timeout = 5000;
  URLConnection connection = url.openConnection();
  connection.setConnectTimeout( timeout );
  connection.setReadTimeout( timeout );

  InputStream in = connection.getInputStream();
  InputStreamReader isr = new InputStreamReader( in );
  BufferedReader br = new BufferedReader( isr );
  String line;

  while((line = br.readLine()) != null) {
    contents.append(line).append("\n");
  }

} catch( Exception e ) { 
	contents.append(mm_default_response);
	Logger.getLogger(request.getRequestURI()).log(Level.SEVERE,"Error showing MM ad",e);

}
out.println( contents );
}
%>