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
                WorkPDF wpdf = new WorkPDF();   
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                String emailName = request.getParameter("emailName").isEmpty() ? "'-'" : "lower('" + request.getParameter("emailName").trim() + "')";
                String username = request.getParameter("uname");
                
                String ParamsValue = "info_text=" + emailName.trim();
                array[0] = 74;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;
                
                switch (RepForm) {
                    case 1: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="74"/> 
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
            case 3: {
                     FileNamePath = wpdf.ExportDataToPDF(array, properties.getProperty("ProcName"),0); 
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