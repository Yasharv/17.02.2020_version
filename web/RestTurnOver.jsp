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
<link rel="stylesheet" href="jqueryui191cust/development-bundle/themes/cupertino/jquery.ui.all.css">
<link rel="stylesheet" href="jqueryui191cust/development-bundle/demos/demos.css">
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <%
        ReadPropFile rf = new ReadPropFile();
        Properties properties = null;
        properties = rf.ReadConfigFile("RestTurnOver.properties");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
                    changeYear: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    showButtonPanel: true,
                    onClose: function (selectedDate) {
                        $("#to").datepicker("option", "minDate", selectedDate);
                    }
                });
                $("#to").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    showButtonPanel: true,
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
        <title><%=properties.getProperty("DWHRep")%></title>
    </head>               
    <%
               Date d = new Date(); 
               Format formatter;
               String s;
               formatter = new SimpleDateFormat("dd-MM-yyyy");
               s = formatter.format(d); 
               PrDict footer = new PrDict();
                
               String user_name = request.getParameter("uname");
               String br = request.getParameter("br");
                //out.println(session.getId());
    %> 
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <font size="4" face='Times New Roman'> 
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td width="246" height="60">  <font size="5"> <%=properties.getProperty("RestTurnOv")%> </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr >
                <td valign="top" >
                    <%=footer.lMenu(user_name,br)%>
                </td>
                <td valign="top"> 

                    <form method="post"  name="post" action="RestTurnOverRep.jsp<%out.println("?uname="+user_name+"&br="+br);%>" target="_blank" onsubmit="return validateForm()" >

                        <!-- </div> -->
                        <table width="700" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="100%" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td height="27" ><%=properties.getProperty("Operations")%></td>
                                            <td colspan="3"  align="center">
                                                <input type="radio" name="RepType" value="1" checked><%=properties.getProperty("InfBal")%>
                                                <input type="radio" name="RepType" value="2"><%=properties.getProperty("OfBalans")%>
                                                <input  type="checkbox" name="RepType1" value="3"><%=properties.getProperty("CurrDiffer")%>
                                                <br/>
                                                <input  type="checkbox" name="RepType2" value="4"><%=properties.getProperty("ClosedAcc")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="33"><%=properties.getProperty("DateFrom")%></td>
                                            <td align="right">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130"> 
                                                <input type="text" id="from" name="DateB" maxlength="10" value= <% out.print('"'+s+'"'); %> />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="31"><%=properties.getProperty("DateTo")%></td>
                                            <td align="right">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td width="130">
                                                <input type="text" id="to" name="DateE" maxlength="10" value= <% out.print('"'+s+'"'); %> />
                                            </td>
                                        </tr>
                                        <tr>

                                            <td height="27"><%=properties.getProperty("DisplayAmnt")%></td>
                                            <td colspan="2">
                                                <font size="3"> 
                                                <input type="radio" name="AmtForm" value="1" checked><%=properties.getProperty("Curr")%> 
                                                <input type="radio" name="AmtForm" value="0"><%=properties.getProperty("CurrL")%> 
                                                <input type='checkbox' name='AccName' value='1'><%=properties.getProperty("NameAcc")%>
                                                </font>
                                            </td>
                                        </tr>
                                        <tr>

                                            <td height="27"><%=properties.getProperty("ReplType")%></td>
                                            <td colspan="2">
                                                <font size="3"> 
                                                <input type="radio" name="RepForm" value="1" checked><%=properties.getProperty("GlAccount")%>
                                                <input type="radio" name="RepForm" value="2"><%=properties.getProperty("Acc")%>
                                                <input type="radio" name="RepForm" value="3"><%=properties.getProperty("Categ")%>
                                                </font>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>                       </td>
                                            <td align="right">  
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td> <input type="text" name="RepFormVal" value= "" /> </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("Currency")%></td>
                                            <td colspan="2">

                                                <font size="2" >
                                                <%=footer.CheckValuteDeb()%>
                                                </font>

                                            </td>

                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("FilialCode")%></td>
                                            <td align="right">
                                                <select style="width: 150px">
                                                    <option value="1">equals</option>
                                                </select>
                                            </td>
                                            <td>   
                                                <select name="RepFilial" style="width: 150px">
                                                    <%=footer.SelFilial(Integer.parseInt(br),0)%>
                                                </select> 
                                            </td>
                                        </tr>


                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Input")%>> </center></td>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                </td>
            </tr>
        </table>
        <%--  <font color="red" size="4"> QEYD: Hesabatda düzəliş aparılır..Dəqiq deyil!!</font>  --%>
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
</font>
</body>
</html>

