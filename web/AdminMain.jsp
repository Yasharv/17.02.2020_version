<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
           PrDict footer = new PrDict();
           String uname=request.getParameter("uname");
        %>     
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td> <font face="Times new roman" size="5"> Administration </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <%=footer.lAdminMenu(uname)%>
                </td>
                <td align="left" valign="top"> 

                    <form method="post"  name="AdminLogin" action="AdminLogin.jsp">

                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>

                                </td>
                            </tr>
                        </table> 
                    </form>    
                </td>
            </tr>
            <tr>
                <td>  
                </td>
                <td height="40">
                    <div align="right">
                        <%=footer.ftSign()%>
                    </div>
                </td>
            </tr>

        </table>
    </body>
</html>
