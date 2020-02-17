<%-- 
    Document   : InfoChannelForm
    Created on : Feb 15, 2018, 12:31:55 AM
    Author     : j.gazikhanov
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="ExcelUtility.WorkExcel"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
            
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
            String FileNamePath = null;
            int QueryStatus = 0;
            int CondStatus = 0;
            
            String status = request.getParameter("status"); 
            String report = request.getParameter("report");
            String Dates = request.getParameter("TrDateB");
            String Filial  = request.getParameter("Filial").equals("0") ? "" : request.getParameter("Filial");
            String product_id = request.getParameter("product_id").equals("0") ? "" : request.getParameter("product_id");
            String CustomerId = request.getParameter("custid").isEmpty() ? "" : request.getParameter("custid");
            String username = request.getParameter("uname");
                
            String ParamsValue = "dateinterval=to_date('" + Dates.trim() + "','dd.mm.yyyy') and to_date('" + Dates.trim() + "','dd.mm.yyyy')" + "/"
                               + "filial_code=" + Filial.trim() + "/"
                               + "product_id=" + product_id.trim() + "/"
                               + "customer_id=" + CustomerId.trim() + "/"
                               + "tarix=to_date('" + Dates.trim() + "','dd.mm.yyyy')";
            
            if (status.equals("1"))
            {
                if(report.equals("1"))
                {
                    QueryStatus = 1;
                    CondStatus = 1;
                } 
                else
                {
                    QueryStatus = 2;
                    CondStatus = 2;
                }
            }
            else if(status.equals("2"))
            {
                if(report.equals("1"))
                {
                    QueryStatus = 3;
                    CondStatus = 3;
                } 
                else
                {
                    QueryStatus = 4;
                    CondStatus = 4;
                }
            }
            else if(status.equals("3"))
            {
                if(report.equals("1"))
                {
                    QueryStatus = 5;
                    CondStatus = 5;
                } 
                else
                {
                    QueryStatus = 6;
                    CondStatus = 6;
                }
            }
                
            array[0] = 11;          // page_id
            array[1] = QueryStatus; // query_status
            array[2] = CondStatus;  // cond_status
            array[3] = ParamsValue;
            array[4] = username;
        %>
        <%
            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>                
    </body>
</html>
