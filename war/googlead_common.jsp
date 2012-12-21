<%@ page import="java.io.BufferedReader,
                 java.io.InputStreamReader,
                 java.io.IOException,
                 java.io.UnsupportedEncodingException,
                 java.net.URL,
                 java.net.HttpURLConnection,
                 java.net.URLEncoder,
                 java.util.ArrayList,
                 java.util.List" %> 


<%!
private static final String PAGEAD =
    "http://pagead2.googlesyndication.com/pagead/ads?";

private void googleAppendUrl(StringBuilder url, String param, String value)
    throws UnsupportedEncodingException {
  if (value != null) {
    String encodedValue = URLEncoder.encode(value, "UTF-8");
    url.append("&").append(param).append("=").append(encodedValue);
  }
}

private void googleAppendColor(StringBuilder url, String param, String value, long random) {
  String[] colorArray = value.split(",");
  url.append("&").append(param).append("=").append(
      colorArray[(int)(random % colorArray.length)]);
}

private void googleAppendScreenRes(StringBuilder url, String uaPixels,
    String xUpDevcapScreenpixels, String xJphoneDisplay) {
  String screenRes = uaPixels;
  if (screenRes == null) {
    screenRes = xUpDevcapScreenpixels;
  }
  if (screenRes == null) {
    screenRes = xJphoneDisplay;
  }
  if (screenRes != null) {
    String[] resArray = screenRes.split("[x,*]");
    if (resArray.length == 2) {
      url.append("&u_w=").append(resArray[0]);
      url.append("&u_h=").append(resArray[1]);
    }
  }
}

private void googleAppendMuid(StringBuilder url, List<String> muids) {
  for (String muid : muids) {
    if (muid != null) {
      url.append("&muid=").append(muid);
      return;
    }
  }
}

private void googleAppendViaAndAccept(StringBuilder url, String via,
    String accept) throws UnsupportedEncodingException {
  googleAppendUrl(url, "via", via);
  googleAppendUrl(url, "accept", accept);
}


%>
