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
        properties = rf.ReadConfigFile("DepoContracts.properties");
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
                $("#from1").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    firstDay: 1
                });
            });

            function validateForm()
            {
                var x = document.forms["post"]["DateB"].value;
                var y = document.forms["post"]["DateE"].value;

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
               
             String user_name = request.getParameter("uname");
              String br = request.getParameter("br"); 
             PrDict footer = new PrDict();
               
        %>  
        <table border="0" width="100%" height="100%"> 
            <col width="250">
            <tr>
                <td width="200" height="60">  
                    <font face="Times new roman" size="5"> 
                    <%=properties.getProperty("DepContr")%>
                    </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% 
                    out.println(footer.lMenu(user_name,br)); 
                    String addlink="?uname="+user_name+"&br="+br;
                    %>
                </td>
                <td valign="top">    

                    <!-- <div align="left" > --> 
                    <form method="post" action="DepoContractsRepForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Search")%></td>
                                            <td>

                                                <select style="width: 150px" name="srcType">
                                                    <option value="0"><%=properties.getProperty("CustomerId")%></option>
                                                    <option value="1"><%=properties.getProperty("ContractId")%></option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="RepValue" id="RepValue"></td>
                                        </tr>

                                        <tr>
                                            <td width="150" height="33"><%=properties.getProperty("DateFrom")%></td>
                                            <td width="110">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130"> 
                                                <input type="text" id="from" name="DateB" value= <% out.print('"'+s+'"'); %> />

                                            </td>
                                        </tr>


                                        <tr>
                                            <td width="150" height="33"><%=properties.getProperty("DateTo")%></td>
                                            <td width="110">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130"> 
                                                <input type="text" id="to" name="DateE" value= <% out.print('"'+s+'"'); %> />

                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"> <%=properties.getProperty("ReportForms")%> </td>
                                            <td>
                                                <select style="width: 150px" name="RepType">
                                                    <option value="0"><%=properties.getProperty("View")%></option>
                                                    <option value="1"><%=properties.getProperty("ExcelFile")%></option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepForm" style="width: 150px" onchange="chngSelect();">

                                                    <option value="0"><%=properties.getProperty("AllContract")%></option>
                                                    <option value="1"><%=properties.getProperty("ExistsAct")%></option>
                                                    <option value="2"><%=properties.getProperty("Pronq")%></option>
                                                    <option value="3"><%=properties.getProperty("ClosedAndDeleted")%></option>
                                                    <option value="4"><%=properties.getProperty("ClosedTime")%></option>
                                                    <option value="5"><%=properties.getProperty("Deleted")%></option> 
                                                    <option value="6"><%=properties.getProperty("DepoWillBeClosed")%></option> 
                                                </select>
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Category")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepCateg" style="width: 150px">
                                                    <option value="0"><%=properties.getProperty("All")%></option>
                                                    <option value="21003"><%=properties.getProperty("Mucru")%></option> 
                                                    <option value="21001"><%=properties.getProperty("Classic")%></option> 
                                                    <option value="21002"><%=properties.getProperty("LegalClassic")%></option> 
                                                    <option value="21004,21005"><%=properties.getProperty("OptionalStan")%></option>
                                                    <option value="21006"><%=properties.getProperty("Prize")%></option> 
                                                    <option value="21007"><%=properties.getProperty("AdditionalOpport")%></option> 
                                                    <option value="21008"><%=properties.getProperty("DamlaDep1")%></option> 
                                                    <option value="21010"><%=properties.getProperty("DamlaDep5")%></option>
                                                </select>
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td height="27"> <%=properties.getProperty("FilialCode")%> </td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepFil" style="width: 150px">
                                                    <%  
                                                    out.println(footer.SelFilial(Integer.parseInt(br),0));
                                                    %>
                                                </select>
                                            </td>
                                        </tr> 

                                        <tr>
                                            <td height="27"><%=properties.getProperty("Currency")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="Valute" style="width: 155px">
                                                    <option value="0">Bütün valyutalar</option>
                                                    <% 
                                                     out.println(footer.SelValute());
                                                    %>
                                                </select>
                                            </td>
                                        </tr>


                                        <!-- 
                                         <tr>
                                          <td height="27">Balans alınsın:</td>
                                          <td>
                                            <font size="3"> <input type="radio" name="BalType" value="0" checked>Seçilmiş valyuta ilə<br> </font>
                                          </td>
                                          <td>
                                             <font size="3"> <input type="radio" name="BalType" value="1">Milli valyuta ekvivalentində </font>
                                          </td>
                                        </tr>
                                        -->                   

                                        <input type="hidden" name="uname" value="<%=user_name%>" >
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Submit")%>> </center></td>
                                <td> &nbsp;</td>
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
