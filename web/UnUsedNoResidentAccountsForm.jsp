<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
--%>

<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="PDFUtility.WorkPDF"%>
<%@page import="main.PrDict"%>
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
            if (request.getParameter("RepForm") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel(); 
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                
                int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                String CustomerId = request.getParameter("CustomerId").isEmpty() ? "" : request.getParameter("CustomerId");
                String FilialCode = request.getParameter("FilialCode").equals("0") ? "" : request.getParameter("FilialCode");
                String username = request.getParameter("uname");
                
                String ParamsValue = "customersid=" + CustomerId.trim() + "/filialcode=" + FilialCode.trim();
                array[0] = 78;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;
                
                switch (RepForm) {
                    case 1: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="78"/> 
            <jsp:param name="QueryStatus" value="<%=1%>"/>
            <jsp:param name="CondStatus" value="<%=1%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 2: {
                     FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
                
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward> 
        <% break;
            }
            
                }
            }
        %>
    </body>
</html>