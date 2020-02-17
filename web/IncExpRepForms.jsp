<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            if (request.getParameter("RepForm") != null) {

                int RepForm = Integer.parseInt(request.getParameter("RepForm"));

                String strDateB = request.getParameter("DateB");
                String strDateE = request.getParameter("DateE");
                String filial = request.getParameter("RepFil");

                String user_name = request.getParameter("uname");
                String user_branch = request.getParameter("br");
                switch (RepForm) {
                    case 1: {
        %>
        <jsp:forward page="IncExpRep.jsp">
            <jsp:param name="DateB" value="<%=strDateB%>"/>
            <jsp:param name="DateE" value="<%=strDateE%>"/>
            <jsp:param name="RepFil" value="<%=filial%>"/>
            <jsp:param name="uname" value="<%=user_name%>"/>
            <jsp:param name="br" value="<%=user_branch%>"/>
        </jsp:forward>
        <%
                break;
            }
            case 2: {
        %>
        <jsp:forward page="IncExpRep2.jsp">
            <jsp:param name="DateB" value="<%=strDateB%>"/>
            <jsp:param name="DateE" value="<%=strDateE%>"/>
            <jsp:param name="RepFil" value="<%=filial%>"/>
            <jsp:param name="uname" value="<%=user_name%>"/>
            <jsp:param name="br" value="<%=user_branch%>"/>
        </jsp:forward>
        <% break;
                    }
                }
            }
        %>
    </body>
</html>
