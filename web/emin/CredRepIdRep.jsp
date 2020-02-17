<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>

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
        <script>
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
                });
            });
        </script>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->

        <%
            DB db = new DB();
            PrDict dict = new PrDict();

            String custid = request.getParameter("custid");
          
            String custidSQLLD = "";
            String custidSQLPC="";
            if ((request.getParameter("custid") != null) & (request.getParameter("custid") != "") & (!(request.getParameter("custid").trim().equals("")))) {
                custidSQLLD = " and slc.customer_id =" + custid;
                custidSQLPC=" and splc.customer_id =" + custid;
            }else{
            custidSQLLD = "";
                custidSQLPC="";
            }
            Connection conn = db.connect();
            ResultSet rs = null;
            Statement st = null;

            String Text = "  SELECT  * FROM sql_select  where id = 372 ";
            st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
              
            java.sql.Clob clob = (java.sql.Clob) rs.getClob(4);

            String SQLText = clob.getSubString(1, (int) clob.length());

            SQLText = SQLText.replaceAll("custidSQLLD", custidSQLLD);
               SQLText = SQLText.replaceAll("custidSQLPC", custidSQLPC);
            
   //  System.out.println(SQLText);
            Statement stmt = conn.createStatement();
            
            ResultSet sqlres = stmt.executeQuery(SQLText);

          //  session.setAttribute("sqlres", sqlres);
            System.out.println(SQLText);
        %>
        <jsp:include page="main.jsp" />
        <table  border='0' width="100%" cellspacing="1">
            <tr>
                <td align="right"  >
                    <p>
                        <%
                            out.println(dict.ftSign());
                            sqlres.close();
                            stmt.close();
                            conn.close();

                        %>
                    </p>
                </td></tr>
        </table>
    </body>
</html>