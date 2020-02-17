<%-- 
    Document   : DisplayReportsData
    Created on : Feb 15, 2018, 12:41:18 PM
    Author     : j.gazikhanov
--%>

<%@page import="java.sql.Connection"%>
<%@page import="DBUtility.DataSource"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <style>
           th,td {
           text-align: center;
         }
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
    <body bgcolor=#E0EBEA>
        <% 
            DataSource dataSource = new DataSource();
            Connection dbConnection = null;
            dbConnection = dataSource.getConnection();
            
            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            WorkDatabase wd = new WorkDatabase();
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
            ResultSet rs = null;
            Object[] array = new Object[5];

            array[0] = Integer.parseInt(request.getParameter("PageId"));
            array[1] = Integer.parseInt(request.getParameter("QueryStatus"));
            array[2] = Integer.parseInt(request.getParameter("CondStatus"));
            array[3] = request.getParameter("Params");
            array[4] = request.getParameter("UserName");
            

            rs = wd.callOracleStoredProcCURSORParameter(array,properties.getProperty("ProcName"),0, dbConnection);
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int numberOfColumns = rsMetaData.getColumnCount();
            String[] headers = new String[numberOfColumns];
            for (int i = 1; i <= numberOfColumns; i++) {
                headers[i - 1] = rsMetaData.getColumnName(i);
            }
        %>
        <table cellpadding="0" cellspacing="0" border="0"  width="100%" id="example">
            <thead>
                <tr>
                    <%
                        for (int i = 1; i <= numberOfColumns; i++) 
                        {
                    %>
                    <th><b><%= headers[i - 1]%></b></th>
                    <%
                        }
                    %>
                </tr>
            </thead>
            <tbody>
                <% 
                    
                    while (rs.next()) 
                    { /*1*/
                %>
                <tr>
                    <%
                     for (int i = 1; i <= numberOfColumns; i++) 
                     { /*2*/
                         
                         if ((rs.getMetaData().getColumnType(i) == -9) || 
                             (rs.getMetaData().getColumnType(i) == 12) || 
                             (rs.getMetaData().getColumnType(i) == 1)) 
                         {   
                   %>   
                       <td><b><%= rs.getString(i) == null || rs.getString(i).trim().isEmpty() ? "" : rs.getString(i)%></b></td>
                    <%
                        }
                        else if (rs.getMetaData().getColumnType(i) == 2)
                        {
                            if (rs.getObject(i) != null) 
                            {
                             %>
                               <td><b><%= rs.getString(i) == null || rs.getString(i).trim().isEmpty()  ? "" : rs.getString(i)%></b></td>
                             <%
                            }
                            else 
                            {
                            %>
                            <td><b><%= rs.getString(i) == null || rs.getString(i).trim().isEmpty() ? "" : rs.getString(i)%></b></td>
                            <%
                            }
                        }
                        else if (rs.getMetaData().getColumnType(i) == 93)
                        {
                           if (rs.getObject(i) != null) 
                           {
                              %>
                                <td><b><%= dateFormat.format(rs.getDate(i))%></b></td>
                              <%
                           } else {
                                %>
                                <td><b><%= ""%></b></td>
                                <%
                            }
                        }
                        else 
                        {
                        %>
                           <td><b><%= rs.getString(i) == null || rs.getString(i).trim().isEmpty() ? "" : rs.getString(i)%></b></td>
                        <%
                        }
                     } /*2*/
                   %>                   
                </tr>
                <%
                    } /*1*/
                    if (rs != null) 
                    {
                       rs.close();
                    }

                   if (dbConnection != null)
                    {
                       dbConnection.close();
                    } 
                %>

            </tbody>
            <tfoot>
                <tr>
                    <%
                        for (int i = 1; i <= numberOfColumns; i++) 
                        {
                    %>
                    <th><b><%= headers[i - 1]%></b></th>
                    <%
                        }
                    %>
                </tr>
            </tfoot>
        </table>

    </body>
</html>
