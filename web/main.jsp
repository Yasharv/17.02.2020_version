<%@page import="java.sql.ResultSet"%>
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



    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            ResultSet sqlres = (ResultSet) session.getAttribute("sqlres");           %>

        <table cellpadding="0" cellspacing="0" border="0"  id="example" width="100%" >
            <thead>
                <tr>
                    <%        int count = sqlres.getMetaData().getColumnCount();
                        for (int i = 1; i <= count; i++) {
                            out.println("<th>" + sqlres.getMetaData().getColumnName(i) + "</th>");
                            System.out.println("type  " + sqlres.getMetaData().getColumnName(i) + "  " + sqlres.getMetaData().getColumnType(i));
                        };
                    %>

                </tr>
            </thead>
            <tbody>
                <%
                    while (sqlres.next()) {
                        out.println("<tr>");
                        System.out.println("<tr>");
                        for (int i = 1; i <= count; i++) {
                            if ((sqlres.getMetaData().getColumnType(i) == -9) | (sqlres.getMetaData().getColumnType(i) == 12) | (sqlres.getMetaData().getColumnType(i) == 1)) {
                                if (sqlres.getObject(i) != null) {System.out.println(sqlres.getMetaData().getColumnName(i));
                                    
                                    
                                    out.println("<td  width = '100' align=\"center\">" + sqlres.getString(i) + " </td>");
                                    System.out.println("<td  width = '100' align=\"center\">" + sqlres.getString(i) + " </td>");
                                    
                                } else {
                                    out.println("<td  width = '100' align=\"center\"></td>");
                                      System.out.println("<td  width = '100' align=\"center\"> </td>");
                                }
                            } else if (sqlres.getMetaData().getColumnType(i) == 2) {
                                if (sqlres.getObject(i) != null) {
                                    out.println("<td  width = '100' align=\"center\">" + sqlres.getDouble(i) + " </td>");
                                      System.out.println("<td  width = '100' align=\"center\">" + sqlres.getString(i) + " </td>");
                                } else {
                                    out.println("<td  width = '100' align=\"center\"></td>");
                                      System.out.println("<td  width = '100' align=\"center\"> </td>");
                                }
                            } else if (sqlres.getMetaData().getColumnType(i) == 93) {
                                if (sqlres.getObject(i) != null) {
                                    out.println("<td  width = '100' align=\"center\">" + sqlres.getDate(i) + " </td>");
                                      System.out.println("<td  width = '100' align=\"center\">" + sqlres.getString(i) + " </td>");
                                } else {
                                    out.println("<td  width = '100' align=\"center\"></td>");
                                      System.out.println("<td  width = '100' align=\"center\"> </td>");
                                }
                            }
                        }
                        out.println("</tr>");
                        System.out.println("</tr>");
                    };
                %>
            </tbody>
            <tfoot>
                <tr>
                    <%
                        for (int i = 1; i <= count; i++) {
                            out.println("<th>" + sqlres.getMetaData().getColumnName(i) + "</th>");
                            System.out.println("<th>" + sqlres.getMetaData().getColumnName(i) + "</th>");
                        };
                    %>
                </tr>
            </tfoot>
        </table> 

    </body>
</html>
