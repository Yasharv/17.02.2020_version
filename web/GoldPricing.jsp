<%-- 
    Document   : GoldPricing
    Created on : Oct 9, 2014, 2:59:12 PM
    Author     : emin.mustafayev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.sql.Connection"%>
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
    <%
        ReadPropFile rf = new ReadPropFile();
        Properties properties = null;
        properties = rf.ReadConfigFile("GoldPricing.properties");
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
                var a = document.forms["post"]["DebFilial"].checked;
                var b = document.forms["post"]["KredFilial"].checked;
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

                if ((a == false) & (b == false))
                {
                    alert("Debt və ya Kredit filiallardan biri seçilməlidir!");
                    return false;
                }
            }

            function checkDebAll(field)
            {
                var z = document.forms["post"]["DebAllFilials"].checked;

                if (z == true)
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = true;
                } else
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = false;
                }

            }

            function checkKredAll(field)
            {
                var z = document.forms["post"]["KredAllFilials"].checked;

                if (z == true)
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = true;
                } else
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = false;
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
                    <%=properties.getProperty("GoldPriv")%>
                    </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% out.println(footer.lMenu(user_name, br));%>
                </td>
                <td valign="top">    

                    <!-- <div align="left" > -->

                    <form method="post" action="GoldPricingRepForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td height="27" ></td>
                                            <td colspan="2">
                                                <input type="radio" name="RepType" value="0" checked><%=properties.getProperty("All")%>
                                                <input type="radio" name="RepType" value="1" ><%=properties.getProperty("Closed")%>
                                                <input type="radio" name="RepType" value="2"><%=properties.getProperty("Active")%>

                                            </td>
                                        </tr>
                                        <!--  <tr>
                                              <td width="150" height="33">Başlanğıc tarix:</td>
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
                                      
                                    </select>
                                </td>
                                <td width="130"> 
                                    <input type="text" id="from" name="TrDateB" value= <% out.print('"' + s + '"');%> />
                                </td>
                            </tr>
                            <tr>
                                <td height="31">Son tarix:</td>
                                <td>
                                    <select style="width: 150px">
                                        <option value="1">equals</option>
                                    </select>
                                </td>
                                <td width="130">
                                    <input type="text" id="to" name="TrDateE" value= <%--out.print('"' + s + '"');--%> />
                                </td>
                            </tr>
                                        -->

                                        <tr>
                                            <td height="27"><%=properties.getProperty("CustId")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="RepCustomer"></td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ContrId")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="RepContract"></td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ColletType")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>

                                                <%
                                                    DB db = new DB();
                                                    Connection connection = db.connect();
                                                    Statement sttype = null;
                                                    ResultSet rstype = null;
                                                    sttype = connection.createStatement();
                                                    rstype = sttype.executeQuery(" select collateral_code_id,GB_description  from DI_COLLATERAL_CODE where collateral_types=100 and date_until='01-jan-3000'");
                                                %>
                                                <select name="ColletType" style="width: 155px">
                                                    <option value="0">Bütün növlər</option> 

                                                    <%while (rstype.next()) {%>
                                                    <option value="<%=rstype.getInt("collateral_code_id")%>"><%=rstype.getString("GB_description")%>
                                                    </option>
                                                    <%}
                                                        rstype.close();
                                                        sttype.close();

                                                    %>
                                                </select>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("PreciousProbe")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="RepProbe"></td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("PreciousWeight")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="RepWeight"></td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("PreciousAmt")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="RepAmt"></td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("FilialCode")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="filial" style="width: 155px">

                                                    <option value="0">Bütün filiallar</option> 
                                                    <%=footer.SelFilial(Integer.parseInt(br), 0)%>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("TypeReport")%></td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepCheck" value="0" checked><%=properties.getProperty("View")%><br> </font>
                                            </td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepCheck" value="1"><%=properties.getProperty("ExcelFile")%></font>
                                            </td>
                                        </tr>



                                        <input type="hidden" name="uname" value=<% out.print(user_name);%> >
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Submit")%>> </center></td>
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
