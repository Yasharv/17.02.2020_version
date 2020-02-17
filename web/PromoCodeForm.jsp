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
            String RepType = request.getParameter("RepType");

            if (RepType != null) 
            {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                
                String TarixB = request.getParameter("DateFrom");
                String TarixE = request.getParameter("DateTo");
                String UserId = request.getParameter("userid").isEmpty() ? "" : "'" + request.getParameter("userid") + "'";
                String user_name = request.getParameter("uname");
                                
                String ParamsValue ="userid=" + UserId.trim() + "/"
                                   + "datesinterval=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')/";
                array[0] = 83;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = user_name;

                switch (Integer.parseInt(RepType)) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="83"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=user_name%>"/> 
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
        <% break;
                    }

                }
            }
        %>
    </body>
</html>
