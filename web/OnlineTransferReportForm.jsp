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
            if (request.getParameter("RepType") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
                String FileNamePath = null;
                String currency = null;
                String[] CurrAr = null;
              
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                int ZKRepType = Integer.parseInt(request.getParameter("ZKRepType"));
                String DateFrom = request.getParameter("DateFrom");
                String DateTo = request.getParameter("DateTo");
                String fileName = request.getParameter("fileNames").isEmpty() ? "" : "'%" + request.getParameter("fileNames") + "%'";
                if (request.getParameterValues("DebVal") != null) 
                {
                    CurrAr = request.getParameterValues("DebVal");
                    for (int i = 0; i < CurrAr.length; i++) 
                    {
                        currency = currency + "," + CurrAr[i].trim();
                    }
                } 
                else 
                {
                    currency = "";
                }
                String country = request.getParameter("country").equals("0") ? "" : "'" + request.getParameter("country") + "'";
                String username = request.getParameter("uname");
                
                String ParamsValue = "interval=to_date('" + DateFrom.trim() + "','dd.mm.yyyy') and to_date('" + DateTo.trim() + "','dd.mm.yyyy')/"
                                   + "currency=" + currency.trim() + "/"
                                   + "country=" + country.trim() + "/"
                                   + "file_name=" + fileName.trim();
                
                array[0] = 75;
                array[1] = ZKRepType;
                array[2] = ZKRepType;
                array[3] = ParamsValue;
                array[4] = username;
        %>
        <%
            switch (RepType) {
                case 0:
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="75"/> 
            <jsp:param name="QueryStatus" value="<%=ZKRepType%>"/>
            <jsp:param name="CondStatus" value="<%=ZKRepType%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            case 1:
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);

        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>                

        <%

                    break;

            }
        %>

        <%
            }
        %>
    </body>
</html>
