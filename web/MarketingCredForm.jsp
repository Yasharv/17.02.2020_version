<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
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
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
            Object[] array = new Object[5];
               
            WorkExcel we = new WorkExcel(); 
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;
            
            String Date = request.getParameter("TrDateB");
            String valueB = request.getParameter("valueB");
            String valueE = request.getParameter("valueE");
            String matB = request.getParameter("matB");
            String matE = request.getParameter("matE");
            String FilialCode = request.getParameter("Filial").equals("0") ? "" : request.getParameter("Filial");
            String productId = request.getParameter("product_id").equals("0") ? "" : request.getParameter("product_id");
            String username = request.getParameter("uname");
            
            String ParamsValue = "filialcode=" + FilialCode.trim() + "/" + 
                                 "productid=" + productId.trim() + "/" + 
                                 "valuedateinterval=to_date('" + valueB.trim() + "','dd.mm.yyyy') and to_date('" + valueE.trim() + "','dd.mm.yyyy')" + "/" + 
                                 "maturitydateinterval=to_date('" + matB.trim() + "','dd.mm.yyyy') and to_date('" + matE.trim() + "','dd.mm.yyyy')" + "/" + 
                                 "tarix=to_date('" + Date.trim()+ "','dd.mm.yyyy')";
                
            array[0] = 33;
            array[1] = 1;
            array[2] = 1;
            array[3] = ParamsValue;
            array[4] = username;
            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>
                       
    </body>
</html>
