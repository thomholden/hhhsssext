<%@ taglib prefix="wf" uri="/WEB-INF/webfigures.tld" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
  <head><title>MATLAB WebFigures Demo</title></head>
  <body>
    <table border=0 cellspacing=2 cellpadding=0 style="width:100%;height:100%">
      <tr><td>
          Use the console below to interact with the surface plot.
      </td></tr>
      <tr><td height=100%>
          <wf:web-figure name="UserPlot" scope="session" root="WebFigures"
                         width="100%" height="100%"/>
      </td></tr>
    </table>
  </body>
</html>        