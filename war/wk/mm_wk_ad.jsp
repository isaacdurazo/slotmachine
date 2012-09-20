<!------------------------------------------------------------------>
<!--                                                              -->
<!-- Millennial Media JSP Ad Coding, v.7.4.20                     -->
<!-- Copyright Millennial Media, Inc. 2006                        -->
<!--                                                              -->
<!------------------------------------------------------------------>

<!------------------------------------------------------------------>
<!-- Import libraries necessary for ad calls.                     -->
<!------------------------------------------------------------------>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="java.net.URLEncoder" %>

<!------------------------------------------------------------------>
<!-- Publisher Specific Section.                                  -->
<!------------------------------------------------------------------>
<%
String mm_placementid      = "|||apid|||";
String mm_adserver         = "ads.mp.mydas.mobi";
String mm_default_response = "";
%>

<!------------------------------------------------------------------>
<!-- PLEASE DO NOT EDIT BELOW THIS LINE.                          -->
<!------------------------------------------------------------------>
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
} catch( Exception e ) { contents.append(mm_default_response); }

out.println( contents );
%>