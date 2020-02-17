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
                
               String strDateB = request.getParameter("TrDateB");
               String RepValue = request.getParameter("RepVal");  
               String Filial = request.getParameter("Filial"); 
               String Valute  = request.getParameter("Valute");   
               String RepType = request.getParameter("RepType");
              
               String user_name = request.getParameter("uname");
               String user_branch = request.getParameter("br");
               switch (RepForm)
               {
                   case 0:{
        %>
        <jsp:forward page="ControlTapeRep.jsp">
            <jsp:param name="TrDateB" value="<%=strDateB%>"/>
            <jsp:param name="RepVal" value="<%=RepValue%>"/>
            <jsp:param name="Filial" value="<%=Filial%>"/>
            <jsp:param name="Valute" value="<%=Valute%>"/>
            <jsp:param name="RepType" value="<%=RepType%>"/>
            <jsp:param name="uname" value="<%=user_name%>"/>
            <jsp:param name="br" value="<%=user_branch%>"/>
        </jsp:forward>
        <%
                       break;}
                   case 1:{
        %>
        <jsp:forward page="ControlTapeExcelRep">
            <jsp:param name="TrDateB" value="<%=strDateB%>"/>
            <jsp:param name="RepVal" value="<%=RepValue%>"/>
            <jsp:param name="Filial" value="<%=Filial%>"/>
            <jsp:param name="Valute" value="<%=Valute%>"/>
            <jsp:param name="RepType" value="<%=RepType%>"/>
            <jsp:param name="uname" value="<%=user_name%>"/>
            <jsp:param name="br" value="<%=user_branch%>"/>
        </jsp:forward>
        <% break;}
                   case 2:{
        %>
        <jsp:forward page="ControlTapeRep2.jsp">
            <jsp:param name="TrDateB" value="<%=strDateB%>"/>
            <jsp:param name="RepVal" value="<%=RepValue%>"/>
            <jsp:param name="Filial" value="<%=Filial%>"/>
            <jsp:param name="Valute" value="<%=Valute%>"/>
            <jsp:param name="RepType" value="<%=RepType%>"/>
            <jsp:param name="uname" value="<%=user_name%>"/>
            <jsp:param name="br" value="<%=user_branch%>"/>
        </jsp:forward>
        <% 
                       break;}
               }
        }
        %>
    </body>
</html>
