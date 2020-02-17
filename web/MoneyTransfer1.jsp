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
        properties = rf.ReadConfigFile("MoneyTransfer1.properties");
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
                if (x == null || x == "")
                {
                    alert("Ba\u015flanğıc tarix daxil edilməlidir!");
                    return false;
                    z
                }
                if (y == null || y == "")
                {
                    alert("Son tarix daxil edilm\u0259lidir!");
                    return false;
                }
            }



        </script>


        <script>
            $(function () {
                $('.chkSelectAll').click(function () {
                    $('.transfer').prop('checked', $(this).is(':checked'));
                });
                $('.transfer').click(function () {
                    if ($('.transfer:checked').length === $('.transfer').length) {
                        $('.chkSelectAll').prop('checked', true);
                    } else {
                        $('.chkSelectAll').prop('checked', false);
                    }
                });
            });
        </script>
        <style>
            .container { border:2px solid #ccc; 
                         width:150px; 
                         height: 100px; 
                         overflow-y: scroll;
                         font-size: 10px;
            }
        </style> 
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
            <col width="300">
            <tr>
                <td width="300" height="60">  
                    <font face="Times new roman" size="5"> 
                    <%=properties.getProperty("MoneyTransfer1")%>
                    </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% out.println(footer.lMenu(user_name, br)); %>
                </td>
                <td valign="top">    

                    <!-- <div align="left" > --> 
                    <form method="post" action="MoneyTransferForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="300" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="300" height="100" border="0" bgcolor=#EBF9F9>


                                        <tr>
                                            <td height="27" ><%=properties.getProperty("TrRepType")%></td>
                                            <td colspan="2">

                                                <input type="radio" name="report" value="1" checked><%=properties.getProperty("ForOperation")%>
                                                <input type="radio" name="report" value="2"><%=properties.getProperty("ForIncome")%>

                                            </td>
                                        </tr>          


                                        <tr>

                                            <td>
                                                <input type="checkbox" value="1" name="type" class="type1" checked =true ><label><%=properties.getProperty("ckTransit")%></label><br>
                                            </td>
                                            <td>
                                                <input type="checkbox" value="1" name="type1" class="type"   > <label><%=properties.getProperty("ckPayment")%></label><br>
                                            </td>


                                        </tr>
                                        <tr>   
                                            <td width="50" height="33"><%=properties.getProperty("DateFrom")%></td>
                                            <td width="50">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130"> 
                                                <input type="text" id="from" name="TrDateB" value= <% out.print('"' + s + '"');%> />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="31"><%=properties.getProperty("DateTo")%></font></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130">
                                                <input type="text" id="to" name="TrDateE" value= <% out.print('"' + s + '"');%> />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Country")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="country" style="width: 155px">
                                                    <option value="0">Bütün ölkələr</option> 
                                                    <%=footer.Country()%>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("SendAndReceive")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="sender" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("DocumentNum")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="PASSP_NO" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  height="30" >
                                                <%=properties.getProperty("TransitName")%>       
                                                <div class="container"> 
                                                    <input type="checkbox" name="chktransfer" class="chkSelectAll"><label>Hamısı</label> <br>
                                                    <input type="checkbox" value="1" name="upt" class="transfer"><label>UPT</label><br>
                                                    <input type="checkbox" value="1" name="wunion" class="transfer"><label>W/Union</label><br>
                                                    <!--<input type="checkbox" value="1" name="cmt" class="transfer"><label>CMT</label><br> -->
                                                    <input type="checkbox" value="1" name="korona" class="transfer"><label>Z/Korona</label><br>
                                                    <input type="checkbox" value="1" name="contact" class="transfer"><label>Contact</label><br>
                                                    <input type="checkbox" value="1" name="lider" class="transfer"><label>Lider</label><br>
                                                    <input type="checkbox" value="1" name="monex" class="transfer"><label>Monex</label><br>
                                                    <!--<input type="checkbox" value="1" name="iba_express" class="transfer"><label>İba-Express</label><br>-->
                                                    <input type="checkbox" value="1" name="xezri" class="transfer"><label>Xəzri</label><br>
                                                </div>
                                            </td>
                                        </tr>



                                        <tr>
                                            <td height="27"><%=properties.getProperty("Currency")%></td>
                                            <td colspan="3">

                                                <font size="1" >
                                                <%=footer.CheckValute()%>
                                                </font>

                                            </td>

                                        </tr>


                                        <tr>
                                            <td height="27" ><%=properties.getProperty("Income")%></td>
                                            <td colspan="2">

                                                <input type="checkbox" name="rep" value="1" checked><%=properties.getProperty("ckYes")%>
                                                <input type="checkbox" name="rep1" value="2"><%=properties.getProperty("ckNo")%>

                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27"  ><%=properties.getProperty("FilialCode")%></td>
                                            <td align="right">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>   
                                                <select name="RepFilial" style="width: 150px">
                                                    <%=footer.SelFilial(Integer.parseInt(br), 0)%>
                                                </select> 
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="24"><%=properties.getProperty("ReportType")%></td>
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
