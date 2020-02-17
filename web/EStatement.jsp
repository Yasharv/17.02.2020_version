<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="main.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" title="currentStyle">
            @import "media/css/demo_page.css";
            @import "media/css/demo_table.css";
            @import "media/css/demo_table_jui.css";
            @import "media/examples_support/themes/smoothness/jquery-ui-1.8.4.custom.css";
        </style>
        <script type="text/javascript" language="javascript" src="media/js/jquery.js"></script>
        <script type="text/javascript" language="javascript" src="media/js/jquery.dataTables.js"></script>
        <script type="text/javascript" charset="utf-8">
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
                });
            });
            function newPopup(url) {
                window.open(
                        url, 'popUpWindow', 'height=300,width=300,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
            }
        </script>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            String uname = request.getParameter("uname");
            Date d = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String s = sdf.format(d);
            PrDict footer = new PrDict();

            DB db = new DB();
            Statement stmt = null;
            ResultSet rs = null;
            Connection conn = db.connect();
            CallableStatement cstmt = conn.prepareCall("{ call send_mail }");
            cstmt.execute();
            cstmt.close();
            String sqlText = "select id,to_char(mailsenddate,'dd-MM-YYYY') mailsenddate,descr"
                    + " from dwh_settings WHERE id = 0";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sqlText);
            String mailsenddate = "";
            String descr = "";
            if (rs.next()) {
                mailsenddate = rs.getString(2);
                descr = rs.getString(3);
            }
            sqlText = "select custid,e_mail,dateb,datee,periodmail,sendmail,id"
                    + " from custmaillist"
                    + " order by custid";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sqlText);

        %>     
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td> <font face="Times new roman" size="5"> Mail Statement </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <%=footer.lAdminMenu(uname)%>
                </td>
                <td align="left" valign="top"> 
                    <form method="post"  name="post" action="SendStatm.jsp" target="_blank">

                        <!-- </div> -->
                        <table width="540" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="535" height="101" border="0" bgcolor=#EBF9F9>
                                        <tr>
                                            <td> </td>
                                            <td height="27"> 
                                                <!----Cedvel bashligi-->
                                                <table cellpadding="0" cellspacing="0" border="0"  id="example" width="600">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>E-Mail</th>
                                                            <th>Period</th>
                                                            <th>B. Tarix</th>
                                                            <th>S. Tarix</th>
                                                            <th>Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            int Status = 0;
                                                            while (rs.next()) {
                                                                out.println("<tr>");
                                                                out.println("<td>" + rs.getInt(1) + "</td>");
                                                                out.println("<td>" + rs.getString(2) + "</td>");
                                                                out.println("<td>" + rs.getString(5) + "</td>");
                                                                out.println("<td>" + rs.getString(3).substring(0, 10) + "</td>");
                                                                out.println("<td>" + rs.getString(4).substring(0, 10) + "</td>");
                                                                Status = rs.getInt(6);
                                                                if (Status == 0) {
                                                                    out.println("<td align='center'> <img src='images/email-new-icon.png'></td>");
                                                                } else if (Status == 1) {
                                                                    out.println("<td align='center'> <img src='images/accept-icon.png'></td>");
                                                                } else if (Status == 2) {
                                                                    out.println("<td align='center'>"
                                                                            + " <a onclick=\"newPopup('EStatmError.jsp?errid="+rs.getInt(7)+"')\">"
                                                                            + " <img src='images/error-icon.png'>"
                                                                            + " </a>"
                                                                            + " </td>");
                                                                }
                                                                out.println("</tr>");
                                                            }
                                                            rs.close();
                                                            stmt.close();
                                                            conn.close();
                                                        %> 
                                                    </tbody>
                                                    <tfoot>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>E-Mail</th>
                                                            <th>Period</th>
                                                            <th>B. Tarix</th>
                                                            <th>S. Tarix</th>
                                                            <th>Status</th>
                                                        </tr>    
                                                    </tfoot>
                                                </table>
                                                <!----Cedvel sonu-->
                                            </td>

                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td height="27"> &nbsp;</td>
                                            <td>
                                        <center>  
                                            <input type="hidden" name="uname" value="<%=uname%>">
                                            <%
                                                if (descr.equals("OK")) {
                                            %>
                                            <input type="submit" name="go" value="E-Mail'ləri Göndər">
                                            <%
                                            } else if (descr.equals("BALANS YUKLENMEYIB!")) {
                                            %>
                                            <div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
                                                <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                                <div id="errortext"><%=descr%> Son gonderilme tarixi:  <%=mailsenddate%></div>
                                            </div>
                                            <%
                                                } else {
                                            %>
                                            <input type="submit" name="go" value="E-Mail'ləri Göndər">
                                            <div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
                                                <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                                <div id="errortext"><%=descr%> Son gonderilme tarixi:  <%=mailsenddate%></div>
                                            </div>
                                            <%
                                            }
                                            %>
                                        </center>
                                </td>
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
            <%=footer.ftSign()%>
        </div>
    </td>
</tr>

</table>
</body>
</html>
