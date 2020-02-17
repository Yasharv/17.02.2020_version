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
                String queryStatus = null;
                String condStatus = null;
                
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String ckReport = request.getParameter("report");
                String DateFrom = request.getParameter("DateFrom");
                String DateTo = request.getParameter("DateTo");
                String FilialCode = request.getParameter("FilialCode").equals("0") ? "" : request.getParameter("FilialCode");
                String RepUser = request.getParameter("RepUser").equals("0") ? "" : "'" + request.getParameter("RepUser") + "'";
                String PinCode = request.getParameter("PinCode").isEmpty() ? "" : "'" + request.getParameter("PinCode") + "'";
                String username = request.getParameter("uname");
                
                queryStatus = ckReport.equals("1") ? "1" : "2";
                condStatus = ckReport.equals("1") ? "1" : "2";
                        
                String ParamsValue = "pincode=" + PinCode.trim().toUpperCase() + "/"
                                   + "datesinterval=to_date('" + DateFrom.trim() + "','dd.mm.yyyy') and to_date('" + DateTo.trim() + "','dd.mm.yyyy')/"
                                   + "filial_code=" + FilialCode.trim() + "/"
                                   + "username=" + RepUser.trim();

                array[0] = 88;
                array[1] = queryStatus;
                array[2] = condStatus;
                array[3] = ParamsValue;
                array[4] = username;
        %>
        <%
            switch (RepType) {
                case 0:
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="88"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
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
