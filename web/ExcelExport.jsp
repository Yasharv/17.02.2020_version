<%-- 
    Document   : newjsp
    Created on : Apr 2, 2013, 2:47:46 PM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%@ page language="java" import="java.io.*" %> 
        <% 
          response.setContentType("application/vnd.ms-excel"); 
          response.setHeader("Content-Disposition","inline;filename=" + "excel_sheet"+".xls"); 
          response.setHeader("Cache-Control","no-cache"); 
  
          PrintWriter pout = response.getWriter(); 

          pout.print("\nMAHMUD"); 
          pout.print("\tELGUN"); 
          pout.print("\tSHAHIN"); 
          pout.print("\tASLAN"); 
          pout.print("\tE"); 
          pout.print("\tF"); 

          pout.close(); 
          out.println(pout);
 
        %>

    </body>
</html>
