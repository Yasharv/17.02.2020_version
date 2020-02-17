<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.Format"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
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
        <script>
            $(function () {
                $("#from").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    onClose: function (selectedDate) {
                        $("#to").datepicker("option", "minDate", selectedDate);
                    }
                });
            });

            function validateForm()
            {
                var x = document.forms["post"]["TrDateB"].value;

                if (x == null || x == "")
                {
                    alert("Başlanğıc tarix daxil edilməlidir!");
                    return false;
                }

            }

        </script>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            Date d = new Date();
            Format formatter;
            formatter = new SimpleDateFormat("dd-MM-yyyy");
            String s = formatter.format(d);

            PrDict footer = new PrDict();
             String uname=request.getParameter("uname"); 
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
                <form method="post" action="MDRRep.jsp" target="_blank" name="post">

                    <table width="400"  border="1" >

                        <tr>
                            <td width="210">
                                <font size="4" face='Times New Roman'> 
                                Tarix:  <input type="text" id="from" name="TrDateB" value= <% out.print('"' + s + '"');%> />    
                                </font>
                            </td>
                            <td width="190">
                                <input type="hidden" name="uname" value="<%=uname%>">
                                <input type="submit" name="go" value="Fayl yarat"> 
                            </td>
                        </tr>

                    </table> 

                </form>
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
