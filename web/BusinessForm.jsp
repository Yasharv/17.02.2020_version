<%-- 
    Document   : BusinessForm
    Created on : 11.05.2018
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
            String DateFrom = request.getParameter("TrDateB");
            String DateTo = request.getParameter("TrDateE");
            String FilialCode = request.getParameter("Filial").equals("0") ? "" : request.getParameter("Filial");
            String username = request.getParameter("uname");
                
            String ParamsValue = "dateopen=to_date('" + DateFrom.trim() + "','dd.mm.yyyy') and to_date('" + DateTo.trim() + "','dd.mm.yyyy')/"
                               + "filial_code=" + FilialCode.trim();

            array[0] = 64;
            array[1] = 1;
            array[2] = 1;
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
