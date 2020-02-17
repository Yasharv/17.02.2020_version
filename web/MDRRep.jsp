<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>
<%@page import="main.MDRrep"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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
            String strDateB = request.getParameter("TrDateB");
            String uname = request.getParameter("uname");
            SimpleDateFormat dtformat = new SimpleDateFormat("dd-mm-yyyy"); 
            Date dateB ;
            dateB = dtformat.parse(strDateB);
            PrDict footer = new PrDict();
            MDRrep m = new MDRrep();
            m.createDepo(dateB);
           // m.createBalans(dateB);
           // m.createBankInfo(dateB);
          //  m.createKred(dateB);
           // m.createCust(dateB);
            
        %>     
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td> <font face="Times new roman" size="5"> MDR Hesabatı </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <%=footer.lAdminMenu(uname)%>
                </td>
                <td align="left" valign="top"> 
            <center>
                <!-- </div> -->

                <table width="400"  border="1" >

                    <tr>
                        <td>

                        </td>
                        <td>

                        </td>
                    </tr>

                </table> 
            </center>
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
