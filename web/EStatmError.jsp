<%-- 
    Document   : EStatmError
    Created on : Apr 5, 2013, 2:16:11 PM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="main.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error Page</title>

    </head>
    <body>
        <%
        DB db = new DB();
        int errID =Integer.parseInt(request.getParameter("errid"));
        Connection conn = db.connect();
          Statement stmt = conn.createStatement();
       ResultSet sqlres = stmt.executeQuery("select error from custmaillist where id="+errID);
       while (sqlres.next())
       {  
        out.println(sqlres.getString(1));
       }
       sqlres.close();
       stmt.close();
       conn.close();
        %>

    </body>
</html>
