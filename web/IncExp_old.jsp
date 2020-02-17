<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
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
            <col width="200">
            <tr>
                <td width="246">  <font face="Times new roman" size="5">  Gəlir-Xərc hesabatı </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% out.println(footer.lMenu(user_name,br)); %>
                </td>
                <td valign="top"> 

                    <form method="post"  name="post" action="IncExpRep.jsp<%out.print("?uname="+user_name+"&br="+br);%>" onsubmit="return validateForm()" >

                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td width="150" height="33"><font size="4">Başlanğıc tarix:</font></td>
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
                                            <td height="31"><font size="4" >Son tarix:</font></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130">
                                                <input type="text" id="to" name="DateE" value= <% out.print('"'+s+'"'); %> />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><font size="4" >Hesabat forması:</font></td>
                                            <td>
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>   
                                                <select name="RepForm" style="width: 150px">
                                                    <option value="1">Balans Hesabları</option>
                                                    <option value="2">Hesab nömrələri</option>
                                                </select> 
                                            </td>
                                        </tr>

                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value="Qəbul"> </center></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table> 
                </td>
            </tr>
        </table>
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

