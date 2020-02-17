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
                String queryStatus = null;
                String condStatus = null;
                        
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                int BSType = Integer.parseInt(request.getParameter("BSType"));
                String DateFrom = request.getParameter("DateFrom");
                String DateTo = request.getParameter("DateTo");
                String FilialCode = request.getParameter("FilialCode").equals("0") ? "" : request.getParameter("FilialCode");
                String OperType = request.getParameter("operType"); 
                String custCount = request.getParameter("custCount").isEmpty() ? "5" : request.getParameter("custCount");
                String username = request.getParameter("uname"); 
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
                
                String ParamsValue = "date_interval=to_date('" + DateFrom.trim() + "','dd.mm.yyyy') and to_date('" + DateTo.trim() + "','dd.mm.yyyy')/"
                                   + "branch_code=" + FilialCode.trim() + "/"
                                   + "currency_number=" + currency.trim() + "/"
                                   + "cus_counts=" + custCount.trim() + "/"
                                   + "currnumb=" + currency.trim();
                if (BSType == 1)
                {
                    if (OperType.equals("0"))
                    {
                        queryStatus = "1";
                        condStatus = "1";
                    }
                    else
                    {
                        queryStatus = "2";
                        condStatus = "2";
                    }
                }
                else
                {
                    if (OperType.equals("0"))
                    {
                        queryStatus = "3";
                        condStatus = "3";
                    }
                    else
                    {
                        queryStatus = "4";
                        condStatus = "4";
                    }
                }
                
                array[0] = 76;
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
            <jsp:param name="PageId" value="76"/> 
            <jsp:param name="QueryStatus" value="<%=queryStatus%>"/>
            <jsp:param name="CondStatus" value="<%=condStatus%>"/>
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
