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
            if (request.getParameter("RepType") != null) {
                
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel(); 
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String terminal = request.getParameter("terminal").isEmpty() ? "" : request.getParameter("terminal"); // request.getParameter("terminal");
                terminal = terminal.replace(" ", ",");
                String iban = request.getParameter("iban").isEmpty() ? "" : request.getParameter("iban"); // request.getParameter("iban");
                String username = request.getParameter("uname");
                
                String ParamsValue = "terminalid=" + terminal.trim() + "/" + "terminaliban=" + iban.trim();
                
                array[0] = 57;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;

                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="57"/> 
            <jsp:param name="QueryStatus" value="<%=1%>"/>
            <jsp:param name="CondStatus" value="<%=1%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1: {
                      FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
                      <jsp:forward page="DownloadsFile">    
                          <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
                      </jsp:forward> 
        <%            break;
                    }

                    default: {
                        out.println("Hazırlanır!");
                        break;
                    }
                }
            }
        %>
    </body>
</html>
