<%-- 
    Document   : CarPricing
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : e.mustafayev
--%>

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
                    Avto qiymətləndirmə reyestri
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
                    <form method="post" action="CarPricingRepForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
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
                                                <input type="radio" name="RepCheck" value="0" checked>Hamısı
                                                <input type="radio" name="RepCheck" value="1" >Bağlı
                                                <input type="radio" name="RepCheck" value="2">Aktiv

                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Müştəri İD:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="custid" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Müqavilə nömrəsi:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="contract" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Rəng:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="color" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Avtomobil markası:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="automark" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Avtomobil modeli:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="automodel" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Sürət qutusu:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" name="transmission" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Filial:</td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="filial" style="width: 155px">
                                                    <%=footer.SelFilial(Integer.parseInt(br), 0)%>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27">Hesabat forması:</td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepType" value="0" checked>Görüntü<br> </font>
                                            </td>
                                            <td>
                                                <font size="3"> <input type="radio" name="RepType" value="1">Excel</font>
                                            </td>
                                        </tr>

                                        <input type="hidden" name="uname" value="<%=user_name%>" >
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value="Qəbul"> </center></td>
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

            <%=footer.ftSign()%>
        </div>
    </td>
</tr>

</table>
</body>
</html>
