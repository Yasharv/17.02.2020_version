<%-- 
    Document   : TransactAnalys
    Created on : Nov 8, 2012, 12:18:16 PM
    Author     : m.aliyev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Calendar"%>
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
        <%
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("InOutPayments.properties"); 
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=properties.getProperty("DWHRep")%></title>
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
                $("#to").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    onClose: function (selectedDate) {
                        $("#from").datepicker("option", "maxDate", selectedDate);
                    }
                });

            });
            function validateForm()
            {
                var x = document.forms["post"]["TrDateB"].value;
                var y = document.forms["post"]["TrDateE"].value;
                if (x == null || x == "")
                {
                    alert("Ba\u015flanğıc tarix daxil edilməlidir!");
                    return false;
                }
                if (y == null || y == "")
                {
                    alert("Son tarix daxil edilm\u0259lidir!");
                    return false;
                }
            }

        </script>
    </head>
    <body bgcolor=#E0EBEA>
        <%
             Date d = new Date();
             Format formatter;
             formatter = new SimpleDateFormat("dd-MM-yyyy");
            String s = formatter.format(d);
               
             String user_name = request.getParameter("uname");
             String br = request.getParameter("br"); 
             PrDict footer = new PrDict();
             
             
        %>  
        <table border="0" width="100%" height="100%"> 
            <col width="250">
            <tr>
                <td width="200" height="60">  
                    <font face="Times new roman" size="4"> 
                    <%=properties.getProperty("Transfer")%>
                    </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% out.println(footer.lMenu(user_name,br)); %>
                </td>
                <td valign="top">    

                    <!-- <div align="left" > -->

                    <form method="post" action="InOutPaymentsForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td height="27" ><%=properties.getProperty("Operations")%></td>
                                            <td colspan="2">
                                                <input type="radio" name="RepTypes" value="0" checked><%=properties.getProperty("OperationTransfer")%>
                                                <input type="radio" name="RepTypes" value="1"><%=properties.getProperty("OperationEnter")%>          
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27" ><%=properties.getProperty("OperType")%></td>
                                            <td colspan="2">
                                                <input type="radio" name="TrType" value="0" checked><%=properties.getProperty("OperTypeAll")%>
                                                <input type="radio" name="TrType" value="1"><%=properties.getProperty("OperTypeXOKS")%>
                                                <input type="radio" name="TrType" value="2"><%=properties.getProperty("OperTypeSwit")%>
                                                <input type="radio" name="TrType" value="3"><%=properties.getProperty("OperTypeAzips")%>                          
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="150" height="33"><%=properties.getProperty("DateFrom")%></td>
                                            <td width="110">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                    <!--  <option value="2">matches</option>
                                                          <option value="3">not equal to</option>
                                                          <option value="4">greater than</option>
                                                          <option value="5">greater than or equals</option>
                                                          <option value="6">less than</option>
                                                          <option value="7">less than or equals</option>
                                                          <option value="8">between</option>
                                                          <option value="9">not between</option>
                                                          <option value="10">contains</option>
                                                          <option value="11">not containing</option>
                                                          <option value="12">begins with</option>
                                                          <option value="13">ends with</option>
                                                          <option value="14">does not begin with</option>
                                                          <option value="15">does not end with</option>
                                                          <option value="16">sounds like</option>
                                                    -->
                                                </select>
                                            </td>
                                            <td width="130"> 
                                                <input type="text" id="from" name="TrDateB" value= <% out.print('"'+s+'"'); %> />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="31"><%=properties.getProperty("DateTo")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130">
                                                <input type="text" id="to" name="TrDateE" value= <% out.print('"'+s+'"'); %> />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("Currency")%></td>
                                            <td colspan="2">

                                                <font size="2" >
                                                <% 
                                                 out.println(footer.CheckValuteDeb());
                                                %>
                                                </font>

                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("FilialCode")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td> 
                                                <select name="DebFil" style="width: 155px">
                                                    <% 
                                                      out.println(footer.SelFilial(Integer.parseInt(br),0));
                                                    %> 
                                                </select>
                                            </td>
                                           </tr>
                                            <tr>
                                            <td height="27"><%=properties.getProperty("TypeOperations")%></td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepType" value="0" checked><%=properties.getProperty("View")%><br> </font>
                                            </td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepType" value="1"><%=properties.getProperty("ExcelF")%></font>
                                            </td>
                                        </tr>

                                        <input type="hidden" name="uname" value=<% out.print(user_name); %> >
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Input")%>> </center></td>
                                <td>&nbsp;</td>
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
        <div align="right">

            <%  
            out.println(footer.ftSign());
            %>
        </div>
    </td>
</tr>

</table>
</body>
</html>
