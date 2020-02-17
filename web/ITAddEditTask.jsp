<%-- 
    Document   : ITDept
    Created on : Jul 4, 2013, 4:28:52 PM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="main.DB"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="styles/demos.css" />
<link href="css/ui-lightness/jquery-ui-1.10.2.custom.css" rel="stylesheet"> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>IT Tasks</title>
        <script src="js/jquery-1.9.1.js"></script>
        <script src="js/jquery-ui-1.10.2.custom.js"></script>
        <script>
            $(function () {
                $("#dtp1").datepicker({
                    dateFormat: "dd-mm-yy",
                    firstDay: 1,
                    changeMonth: true,
                    changeYear: true,
                    showAnim: "slideDown"}
                );

                $("#dtp2").datepicker({
                    dateFormat: "dd-mm-yy",
                    firstDay: 1,
                    changeMonth: true,
                    changeYear: true,
                    showAnim: "slideDown"}
                );

                $("#dtp3").datepicker({
                    dateFormat: "dd-mm-yy",
                    firstDay: 1,
                    changeMonth: true,
                    changeYear: true,
                    showAnim: "slideDown"}
                );


            });
            function validateForm()
            {
                var x = document.forms["post"]["dat"].value;
                var y = document.forms["post"]["deadline"].value;

                if (x == null || x == "")
                {
                    alert("Tarix daxil edilm\u0259lidir!");
                    return false;
                }
                if (y == null || y == "")
                {
                    alert("Deadline daxil edilm\u0259lidir!");
                    return false;
                }
            }
        </script>
    </head>
    <body background="images/indx_bg.jpg">
        <%
            PrDict dict = new PrDict();
            String action = request.getParameter("ACTION");
            String tskID = request.getParameter("tskID");
            SimpleDateFormat dtf = new SimpleDateFormat("dd-MM-yyyy");

            String tskname = "";
            String dat = "";
            String deadline = "";
            String complated = "";
            String username = "";
            String desc = "";

            DB db = new DB();
            Connection conn = db.connect();
            if (action.equals("EDIT")) {
                Statement stmt = conn.createStatement();
                String SqlQuery = "select * from ittasks where id=" + tskID
                        + " order by id";
                ResultSet sqlRes = stmt.executeQuery(SqlQuery);

                while (sqlRes.next()) {
                    tskname = sqlRes.getString(2);
                    dat = dtf.format(sqlRes.getDate(4));
                    deadline = dtf.format(sqlRes.getDate(5));
                    if (sqlRes.getObject(6) != null) {
                        complated = dtf.format(sqlRes.getDate(6));
                    }
                    username = sqlRes.getString(7);
                    desc = sqlRes.getString(8);
                }
                sqlRes.close();
                stmt.close();
                conn.close();
            }
        %>

        <table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0"> 
            <col width="200">
            <tr>
                <td> <font face="Times new roman" size="5" color="white"> IT Tasks </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">

                </td>
                <td align="left" valign="top"> 
                    <font color="white" size="4">
                    <form name="post" method="post" action="ITDeptAddEdit" onsubmit="return validateForm()">
                        <table border="0">
                            <tr><td> Taskname:</td><td><input size="35" type="text" name="tskname" value="<%out.print(tskname);%>"/> </td></tr>
                            <tr><td> Tarix:</td><td><input type="text" id="dtp1" name="dat" value="<%out.print(dat);%>"/> </td></tr>
                            <tr><td> Deadline:</td><td>  <input type="text" id="dtp2" name="deadline" value="<%out.print(deadline);%>"/></td></tr>
                                    <%
                                        if (action.equals("EDIT")) {
                                            out.println("<tr><td> Complated:</td><td> <input type='text' id='dtp3' name='complated' value=\"" + complated + "\"/></td></tr>");
                                            out.println("<tr><td> Status:</td><td>"
                                                    + " <select name=\"status\" >"
                                                    + " <option value=\"0\">New</option> "
                                                    + " <option value=\"1\">Processing</option> "
                                                    + " <option value=\"2\" >Paused</option> "
                                                    + " <option value=\"4\" >Cancelled</option> "
                                                    + " <option value=\"3\" >Completed</option> </select>"
                                                    + " </td></tr>");
                                        }
                                    %>
                            <tr><td> UserName:</td><td>  <input type="text" name="username" value="<%out.print(username);%>"/></td></tr>
                            <tr><td> Əlavə informasiya:</td><td> <input size="35" type="text" name="desc" value="<%out.print(desc);%>"/></td></tr>   

                            <tr><td align="right">
                                    <input type="hidden" name="ACTION" value="<%out.print(action);%>"/>
                                    <input type="hidden" name="tskID" value="<%out.print(tskID);%>"/>
                                    <input type="submit" name="ok"/></td>
                                <td align="left">
                                    <input type="reset" name="reset"/> 
                                </td>
                            </tr>   
                        </table>
                    </form>
                    </font>
                </td>
            </tr>
            <tr>

                <td height="40" colspan="2">
                    <div align="right">
                        <font color="white">
                        <%
                            out.println(dict.ftSign());
                        %>
                        </font>
                    </div>
                </td>
            </tr>

        </table>


    </body>
</html>
