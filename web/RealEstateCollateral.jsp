<%-- 
    Document   : CarPricing
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : e.mustafayev
--%>

<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
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
        properties = rf.ReadConfigFile("RealEstateCollateral.properties");
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
                    <font face="Times new roman" size="5"> 
                    <%=properties.getProperty("RealEstInf")%>
                    </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <%=footer.lMenu(user_name, br)%>
                </td>
                <td valign="top">    
                    <!-- <div align="left" > -->
                    <form method="post" action="RealEstateCollateralRepForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <!-- <tr>
                                             <td width="150" height="33">Başlanğıc tarix:</td>
                                             <td width="110">
                                                 <select style="width: 150px">
                                                     <option value="1">equals</option>
                                                  </select>
                                             </td>
                                             <td width="130"> 
                                                 <input type="text" id="from" name="DateB" value="<%=s%>" />
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
                                                 <input type="text" id="to" name="DateE" value="<%--s--%>" />
                                             </td>
                                         </tr>-->
                                        <tr>
                                            <td height="27" ></td>
                                            <td colspan="2">
                                                <input type="radio" name="RepCheck" value="0" checked><%=properties.getProperty("All")%>
                                                <input type="radio" name="RepCheck" value="1" ><%=properties.getProperty("Closed")%>
                                                <input type="radio" name="RepCheck" value="2"><%=properties.getProperty("Active")%>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("City")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="city" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Region")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="region" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Municipal")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="municipal" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Village")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="village" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("ImmvType")%></td>
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
                                                    rstype = sttype.executeQuery("SELECT COLLATERAL_CODE_ID,GB_DESCRIPTION   FROM di_collateral_code     WHERE     date_until = '01-jan-3000'     AND collateral_types = 400" );
                                                %>
                                                <select name="call_type" style="width: 155px">
                                                    <option value="0">Bütün növlər</option> 

                                                    <%while (rstype.next()) {%>
                                                    <option value="<%=rstype.getInt("COLLATERAL_CODE_ID")%>"><%=rstype.getString("GB_DESCRIPTION")%>
                                                    </option>
                                                    <%}
                                                        rstype.close();
                                                        sttype.close();
                                                    %>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("BuildingType")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="building_type" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ImmvAssigment")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="assigment" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ImmvEstimator")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="estimator" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ImmvEstimAmtKvm")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="one_cost" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("AmmvAppraiser")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="appraiser" value="" />
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
                                                <%--
                                                    
                                                    Statement stfilial = null;
                                                    ResultSet rsfilial = null;
                                                    stfilial = connection.createStatement();
                                                    rsfilial = stfilial.executeQuery("SELECT branch_id,GB_DESCRIPTION      FROM di_branch db        WHERE  db.date_until = '01-jan-3000' " );
                                                --%>
                                                <select name="filial" style="width: 155px">

                                                    <%
                                                                               out.println(footer.SelFilial(Integer.parseInt(br),0));
                                                    %> 
                                                    </option>
                                                    <%--}
                                                        rsfilial.close();
                                                        stfilial.close();
                                                    --%>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("TypeReport")%></td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepType" value="0" checked><%=properties.getProperty("View")%><br> </font>
                                            </td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepType" value="1"><%=properties.getProperty("ExcelFile")%></font>
                                            </td>
                                        </tr>

                                        <input type="hidden" name="uname" value="<%=user_name%>" >
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
    <%connection.close(); %>
    <td height="40">
        <div align="right">

            <%=footer.ftSign()%>
        </div>
    </td>
</tr>

</table>
</body>
</html>
