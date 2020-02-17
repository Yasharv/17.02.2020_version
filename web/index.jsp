<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.*"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>

    </head>
    <body bgcolor=#E0EBEA > <!--  #E8E8E8 -->
        <%
            PrDict footer = new PrDict();
            DB db = new DB();
            Connection conn = db.connect();
            String user_name = request.getQueryString();
            // String br=request.getParameter("br");
            String user_branch = "";
            int all_filials = 0;
            int salary_acc = 0;

            Statement stmtUser = conn.createStatement();
            String SqlUserQuery = "select user_branch,all_filials,salary_acc from dwh_users where user_id='" + user_name + "'";
            ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
            while (sqlUserSel.next()) {
                user_branch = sqlUserSel.getString(1);
                all_filials = sqlUserSel.getInt(2);
                salary_acc = sqlUserSel.getInt(3);
            };
            sqlUserSel.close();
            stmtUser.close();
            conn.close();
            if (user_branch.equals("") || user_branch.isEmpty() || user_branch == null || all_filials == 1) {
                user_branch = "0";
            }
       //    session.setAttribute("usname", user_name);
            //    session.setAttribute("usfil", user_branch);

        %>   
        <table border="0" width="100%" cellpadding="0" cellspacing="0" height="100%"> 
            <col width="200">
            <tr>
                <td height="60">
                    <font face="Times new roman" size="5"> DWH Reports </font> 
                </td>
                <td>   
                </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">

                    <% out.println(footer.lMenu(user_name, user_branch)); %>

                </td>
                <td colspan="2">  </td>
            </tr>
            <tr>
                <td>  
                </td>
                <td colspan="2" height='40'>
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
