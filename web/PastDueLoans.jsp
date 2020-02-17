<%-- 
    Document   : TransactAnalys
    Created on : Nov 8, 2012, 12:18:16 PM
    Author     : m.aliyev
--%>

<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
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
        properties = rf.ReadConfigFile("PastDueLoans.properties");
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

                $("#f").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    onClose: function (selectedDate) {
                        $("#f").datepicker("option", "minDate", selectedDate);
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


            function chngSelect()
            {
                var x = document.forms["post"]["XX"].value;
                if (x == 1)
                {
                    document.getElementById('f').disabled = true;
                    document.getElementById('to').disabled = false;
                    document.getElementById('from').disabled = false;
                }
                else
                {
                    document.getElementById('f').disabled = false;
                    document.getElementById('to').disabled = true;
                    document.getElementById('from').disabled = true;
                }
                return false;

            }

        </script>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            PrDict footer = new PrDict();
            String s=footer.getDate();
              
             String user_name = request.getParameter("uname");
              String br = request.getParameter("br"); 
        %>  
        <table border="0" width="100%" height="100%"> 
            <col width="250">
            <tr>
                <td width="200" height="60">  
                    <font face="Times new roman" size="5"> 
                    <%=properties.getProperty("PastDueLoan")%>
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
                    <form method="post" action="PastDueLoansForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->



                        <table width="535" height="101" border="0" bgcolor=#EBF9F9>



                            <td  colspan="2">

                                <input type="radio" name="XX" value="1" onchange="chngSelect();" checked><%=properties.getProperty("Period")%>
                                <input type="radio" name="XX" value="2" onchange="chngSelect();"  ><%=properties.getProperty("Port")%>
                            </td>

                            <tr>
                                <td height="27" ><%=properties.getProperty("CreditLine")%></td>
                                <td colspan="2">

                                    <input type="radio" name="report" value="1" checked><%=properties.getProperty("Total")%>
                                    <input type="radio" name="report" value="2"><%=properties.getProperty("Trans")%>

                                </td>
                            </tr> 
                            <tr>
                                <td width="150" height="33"><%=properties.getProperty("Date")%></td>
                                <td width="110">
                                    <select style="width: 150px">
                                        <option value="1">equals</option>
                                    </select>
                                </td>
                                <td width="130"> 
                                    <input type="text"   id="f" name="TrDate" disabled value= <% out.print('"'+s+'"'); %> />
                                </td>
                            </tr>  

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
                                <td height="27"><%=properties.getProperty("Search")%></td>
                                <td>
                                    <select name="forSrc" style="width: 150px">
                                        <option value="1"><%=properties.getProperty("CustId")%></option>
                                        <option value="2"><%=properties.getProperty("Contr")%></option>
                                    </select>
                                </td>
                                <td><input type="text" name="srcValue"></td>
                            </tr>
                            <tr>
                                <td height="27"> <%=properties.getProperty("Branch")%> </td>
                                <td>
                                    <select style="width: 150px">
                                        <option value="1">equals</option>
                                    </select>
                                </td>
                                <td>
                                    <select name="Filial" style="width: 150px">
                                        <%  
                                        out.println(footer.SelFilial(Integer.parseInt(br),0));
                                        %>
                                    </select>
                                </td>
                            </tr> 
                            <input type="hidden" name="uname" value=<% out.print(user_name);%> > 
                            <tr>
                                <td height="27">&nbsp;</td>
                                <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Submit")%>> </center></td>
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
