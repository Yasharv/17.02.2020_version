<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
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
            if (request.getParameter("RepType") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                String FileNamePath = null;
                  
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
        
                
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String report = request.getParameter("report"); 
                String TarixB = request.getParameter("DateB");
                String TarixE = request.getParameter("DateE");
                String Filial = request.getParameter("Filial").equals("0") ? "" : request.getParameter("Filial");  
                String DRepVal = request.getParameter("DRepVal").isEmpty() ? "" : request.getParameter("DRepVal");  
                String CRepVal = request.getParameter("CRepVal").isEmpty() ? "" : request.getParameter("CRepVal");
                String username = request.getParameter("uname");
                
                String ParamsValue = "act_date=to_date('" + TarixB + "','dd.mm.yyyy') and " + "to_date('" + TarixE + "','dd.mm.yyyy')" + "/"
                                   + "filial_code=" + Filial + "/"
                                   + "teller_gl_ac_1=" + DRepVal + "/"
                                   + "teller_gl_ac_2=" + CRepVal;
                
                array[0] = 58;
                array[1] = report.equals("1") ? 1 : 2;
                array[2] = report.equals("1") ? 1 : 2;
                array[3] = ParamsValue;
                array[4] = username;
               
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="58"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1:  FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward> 
        <% break;    
                }
            }
        %>
    </body>
</html>
