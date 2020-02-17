<%-- 
    Document   : GoldPricingRep
    Created on : Oct 9, 2014, 3:02:35 PM
    Author     : emin.mustafayev
--%>
<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <% 
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;
            
            String Filial = request.getParameter("Filial");
            String user_name = request.getParameter("uname");
            
            if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
            {
                Filial = Filial.equals("0") ? "" : Filial; 
            }
            
                        
            String ParamsValue = "filialcode=" + Filial.trim() ;

            array[0] = 16;
            array[1] = "1";
            array[2] = "1";
            array[3] = ParamsValue;
            array[4] = user_name;

            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
    %>
    <jsp:forward page="DownloadsFile">    
        <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
    </jsp:forward>
    </body>
</html>