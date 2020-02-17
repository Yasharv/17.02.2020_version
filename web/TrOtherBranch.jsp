<%-- 
    Document   : TransactAnalys
    Created on : Nov 8, 2012, 12:18:16 PM
    Author     : m.aliyev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
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
     <%
        ReadPropFile rf = new ReadPropFile();
        Properties properties = null;
        properties = rf.ReadConfigFile("TrOtherBranch.properties");
    %>
    <head>
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
                var a = document.forms["post"]["DebFil"].value;

                if (x == null || x == "")
                {
                    alert("Başlanğıc tarix daxil edilməlidir!");
                    return false;
                }
                if (y == null || y == "")
                {
                    alert("Son tarix daxil edilməlidir!");
                    return false;
                }
                if ((a == "") & (b == ""))
                {
                    alert("Digər filiallarda əməliyyatlar!");
                    return false;
                }
            }
        </script>
    </head>
    <body bgcolor=#E0EBEA>
        <%
        Date d = new Date(); 
        Format formatter;
        String s;
        formatter = new SimpleDateFormat("dd-MM-yyyy");
        s = formatter.format(d);
               
         PrDict footer = new PrDict();
                
         String user_name = request.getParameter("uname");
         String br = request.getParameter("br");
        %>  
        <table border="0" width="100%" height="100%"> 
            <col width="250">
            <tr>
                <td width="200" height="60">  <font face="Times new roman" size="5"><%=properties.getProperty("OtherBranch")%> </font> </td>
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

                    <!--<form method="post" action="TrOtherBranchRep.jsp<%out.println("?uname="+user_name+"&br="+br);%>" target="_blank" name="post" onsubmit="return validateForm()" >-->
                    <form method="post" action="TrOtherBranchForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td width="150" height="33"><%=properties.getProperty("DateFrom")%></td>
                                            <td width="110">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>

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
                                            <td height="27"><%=properties.getProperty("Cr")%></td>
                                            <td>
                                                <select style="width: 150px" name="CredForm">
                                                    <option value="2"><%=properties.getProperty("GlAccount")%></option>
                                                    <option value="1"><%=properties.getProperty("Acc")%></option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="CredValue">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("DbCurrency")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepValDeb" style="width: 155px">
                                                    <option value="">Bütün valyutalar</option>
                                                    <% 
                                                     out.println(footer.SelValute());
                                                    %>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("CrCurrency")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepValKred" style="width: 155px">
                                                    <option value="">Bütün valyutalar</option>
                                                    <% 
                                                     out.println(footer.SelValute());
                                                    %>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("DbFilialCode")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td> 
                                                <select name="DebFil" style="width: 155px">
                                                    <% 
                                                          out.println(footer.SelFilial1());
                                                    %> 
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("User")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepUser" style="width: 155px">
                                                    <option value="0">Bütün istifadəçilər</option>
                                                    <% 
                                                    out.println(footer.SelUsers());
                                                    %>
                                                </select>
                                            </td>
                                        </tr>
                                        <input type="hidden" name="uname" value="<%=user_name%>" >
                                        <input type="hidden" name="br" value="<%=br%>" >
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Input")%>> </center></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table> 
                </td>
            </tr>
        </table>
        <font>
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
