<%--
    Document   : chklogin
    Created on : Feb 20, 2013, 3:38:40 PM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>E-Statement</title>
    </head>
    <body>
        <%
        String pwd = request.getParameter("pwd");
        if (pwd.equals("!!1q2w3e$$")) {
        %>
        <jsp:forward page="AdminMain.jsp"/>
        <%
                 }
        else
       {
        request.setAttribute("err_text", "Parol səhvdir!");
        %>
        <jsp:forward page="Admin.jsp"/>
        <% 
           }   
        %>
    </body>
</html>
