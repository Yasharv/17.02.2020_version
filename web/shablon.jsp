<%-- 
    Document   : shablon
    Created on : Apr 7, 2017, 1:51:10 PM
    Author     : x.dashdamirov
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%  
              
        String account =   request.getParameter("account");    
         System.out.println("account " + account);
        %> 

        <h1>Hello World! <%= account%>  </h1>
    </body>
</html>
