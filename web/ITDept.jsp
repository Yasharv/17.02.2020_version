<%-- 
    Document   : TransactAnalys
    Created on : Nov 8, 2012, 12:18:16 PM
    Author     : m.aliyev
--%>

<%@page import="java.sql.ResultSet"%> 
<%@page import="java.sql.Statement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <link rel="stylesheet" href="jqueryui191cust/development-bundle/themes/cupertino/jquery.ui.all.css">
        <script src="jqueryui191cust/development-bundle/jquery-1.8.2.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.core.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.widget.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jqueryui191cust/development-bundle/demos/demos.css">

    </head>
    <body bgcolor=#E0EBEA>

        <table border="0" width="100%" height="100%"> 
            <col width="250">



            <tr>
                <td width="200" height="60">  
                    <font face="Times new roman" size="5"> 
                    Parol
                    </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>

                <td valign="top">    

                    <!-- <div align="left" > --> 
                    <form method="post" action="Text.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="200" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="200" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td height="27">User:</td>

                                            <td>
                                                <select name="product_id" >
                                                    <option value="Exbank">Exbank</option> 
                                                    <option value="CallCenter">CallCenter</option> 
                                                    <option value="QualityControl">QualityControl</option>

                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Parol:</td>

                                            <td>
                                                <input type="text" name="custid" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value="Qəbul"> </center></td>
                                <td>  </td>
                            </tr>

                        </table> 
                </td>
            </tr>
        </table>
        </font >
    </form>
</td>
</tr>
<tr>
    <td>  
    </td>
    <td height="40">

    </td>
</tr>

</table>
</body>
</html>
