<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <%
        ReadPropFile rf = new ReadPropFile();
        Properties properties = null;
        properties = rf.ReadConfigFile("StatementNew.properties");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
        <link rel="stylesheet" href="jqueryui191cust/development-bundle/themes/cupertino/jquery.ui.all.css">
        <link rel="stylesheet" href="jqueryui191cust/development-bundle/demos/demos.css">

        <script src="jqueryui191cust/development-bundle/jquery-1.8.2.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.core.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.widget.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.datepicker.js"></script>

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
                var z = document.forms["post"]["srcValue"].value;

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

                if (z == null || z == "")
                {
                    alert("Axtarış daxil edilmeyib!");
                    return false;
                }
            }
        </script>
        <title><%=properties.getProperty("DWHRep")%></title>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            Date d = new Date();
            Format formatter = new SimpleDateFormat("dd-MM-yyyy");
            String s;
            s = formatter.format(d);
            PrDict footer = new PrDict();

            String uname = request.getParameter("uname");
            String br = request.getParameter("br");

        %>  
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td width="246" height="60">  <font face="Times new roman" size="5"><%=properties.getProperty("StatNew")%></font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% out.println(footer.lMenu(uname, br));%>
                </td>
                <td valign="top"> 

                    <form method="post"  name="post" action="StatmRepForm_new.jsp" target="_blank" onsubmit="return validateForm()" >
                        <input type="hidden" name="uname" value="<%=uname%>">
                        <input type="hidden" name="br" value="<%=br%>">

                        <!-- </div> -->
                        <font size="4" face='Times New Roman'>
                        <table width="540"  border="1" >

                            <tr>
                                <td>
                                    <table width="535"  border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td width="150" height="33"><%=properties.getProperty("DateFrom")%></td>
                                            <td width="110">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130"> 
                                                <input type="text" id="from" name="DateB" value= <% out.print('"' + s + '"'); %> />
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
                                                <input type="text" id="to" name="DateE" value= <% out.print('"' + s + '"'); %> />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ParamsType")%></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td> <select name="forSrc" style="width: 150px">
                                                    <option value="1"><%=properties.getProperty("CustomersId")%></option>
                                                    <option value="2"><%=properties.getProperty("AccNum")%></option>
                                                    <option value="3"><%=properties.getProperty("GlAccNo")%></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Value")%></td>
                                            <td>
                                                <select style="width: 150px" name="repType">
                                                    <option value="2">matches</option>
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="srcValue"></td>
                                        </tr>
                                        <tr>
                                            <td height="27"> <%=properties.getProperty("FilialCode")%>  </td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="Filial" style="width: 150px">
                                                    <%
                                                        out.println(footer.SelFilial(Integer.parseInt(br), 0));
                                                    %>
                                                </select>
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td height="27"> <%=properties.getProperty("TypeReport")%>  </td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="RepForm" style="width: 150px">
                                                    <option value="1"><%=properties.getProperty("View")%></option>
                                                    <option value="2"><%=properties.getProperty("ExcelFile")%></option>
                                                    <option value="3"><%=properties.getProperty("PDF")%></option>
                                                </select>
                                            </td>
                                        </tr>   
                                        <tr>
                                            <td height="27"> <%=properties.getProperty("Currency")%>  </td>
                                            <td colspan="2">

                                                <font size="2" >
                                                <%=footer.CheckValuteDeb()%>
                                                </font>

                                            </td>
                                        </tr>   
                                        <tr>
                                            <td height="27">
                                                <input type="checkbox" name="closedaccs" value="1"> <font size="3"> <%=properties.getProperty("ClosedAcc")%></font>
                                            </td>
                                            <td>
                                                <input type="checkbox" name="turnover" value="1"> <font size="3"> <%=properties.getProperty("Turnover")%> </font>
                                            </td>
                                            <td> <input type="checkbox" name="reval" value="1"> <font size="3"> <%=properties.getProperty("Reval")%>  </font></td>
                                        </tr>
                                        <tr>
                                            <td height="27"> <%=properties.getProperty("SpecialForm")%>  </td>
                                            <td colspan="2">
                                                <input type="checkbox" name="sigorta" value="1"> <%=properties.getProperty("Sigorta")%>
                                            </td>
                                        </tr>   
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Submit")%>> </center></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table> 
                </td>
            </tr>

        </table>
        </font>
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
