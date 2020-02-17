<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
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
        properties = rf.ReadConfigFile("Skoring.properties");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=properties.getProperty("DWHRep")%></title>

        <script>
            function validateForm()
            {
                var x = document.forms["post"]["TrDateB"].value;
                var y = document.forms["post"]["TrDateE"].value;
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
                    <%=properties.getProperty("SkoringInfo")%>
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
                    <form method="post" action="SkoringForm.jsp" target="_blank" name="post" onsubmit="return validateForm()" >
                        <font size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td align="center">
                                    <table width="400" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td height="27"> <%=properties.getProperty("FilialCode")%> </td>
                                            <td style="width: 160px;">
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
                                        <!--
                                         <tr>
                                          <td height="27">Hesabat forması:</td>
                                          <td>
                                            <font size="3"> <input type="radio" name="RepType" value="0" checked>Görüntü<br> </font>
                                          </td>
                                          <td>
                                             <font size="3"> <input type="radio" name="RepType" value="1">Excel</font>
                                          </td>
                                        </tr>
                                        -->             

                                        <input type="hidden" name="uname" value="<%=user_name%>" >
                                        <input type="hidden" name="br" value="<%=br%>" >
                                        <tr>
                                            <td height="27">&nbsp;</td>
                                            <td><center> <input type="submit" name="go" value=<%=properties.getProperty("Submit")%> > </center></td>
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
