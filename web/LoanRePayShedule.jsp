<%-- 
    Document   : TransactAnalys
    Created on : Nov 8, 2012, 12:18:16 PM
    Author     : m.aliyev
--%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
<%
          PrDict footer = new PrDict();
          String s = footer.getDate();

          String user_name = request.getParameter("uname");
          String br = request.getParameter("br");
%>  
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
        properties = rf.ReadConfigFile("LoanRePayShedule.properties");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=properties.getProperty("DWHRep")%></title>
        <script>

            function validateForm()
            {
                var x = document.forms["post"]["srcValue"].value;
                if (x == null || x == "")
                {
                    alert("Müqavilə nömrəsi daxil edilməlidir!");
                    return false;
                }
            }

        </script>
    </head>
    <body bgcolor=#E0EBEA>

    <center>
        <table border="0" width="100%" height="100%"> 
            <col width="250">
            <tr>
                <td width="200" height="60">  
                    <font face="Times new roman" size="5"> 
                    <%=properties.getProperty("LoanRePaySh")%>
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
                    <form method="post" action="LoanRePaySheduleRep.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>

                                        <tr>
                                            <td height="27"><%=properties.getProperty("TypeReport")%></td>
                                            <td>

                                            </td>
                                            <td>
                                                <select name="forSrc" style="width: 150px">
                                                    <option value="1"><%=properties.getProperty("View")%></option>
                                                    <option value="2"><%=properties.getProperty("ExcelFile")%></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"><%=properties.getProperty("ContractId")%></td>
                                            <td>

                                            </td>
                                            <td><input type="text" name="srcValue"></td>
                                        </tr>
                                        <input type="hidden" name="uname" value="<%=user_name%>" >
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
</center>
</body>
</html>
