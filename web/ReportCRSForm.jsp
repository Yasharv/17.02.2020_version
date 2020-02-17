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
                int QueryStatus = 0;
                int CondStatus = 0;
                        
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                int CustomerType = Integer.parseInt(request.getParameter("CustomerType"));
                String DateFrom = request.getParameter("DateFrom");
                String DateTo = request.getParameter("DateTo");
                String CustomerId = request.getParameter("CustomerId").isEmpty() ? "" : request.getParameter("CustomerId");
                String PinCode = request.getParameter("PinCode").isEmpty() ? "" : "'" + request.getParameter("PinCode") + "'";
                String TaxPayId = request.getParameter("TaxPayId").isEmpty() ? "" : "'" + request.getParameter("TaxPayId") + "'";
                String Citizenship = request.getParameter("citizenship_id");
                String username = request.getParameter("uname");
                
                String Cit = null;
                
                if (Citizenship.trim().equals("ALL")) 
                {
                    Cit ="";
                }
                else if (Citizenship.trim().equals("ISNULL"))
                {
                    Cit = "'" +"NULL" + "'";
                }
                else
                {
                    Cit = "'" + Citizenship.trim() + "'";
                }
                
                String ParamsValue =   "date_from=to_date('" + DateFrom.trim() + "','dd.mm.yyyy')/"
                                     + "date_to=to_date('" + DateTo.trim() + "','dd.mm.yyyy')/"
                                     + "customer_id=" + CustomerId.trim() + "/"
                                     + "pin_code=" + PinCode.trim() + "/"
                                     + "tax_pay_id=" + TaxPayId.trim() + "/"
                                     + "citizenship=" + Cit;
                
                switch (CustomerType) 
                {
                    case 1:QueryStatus = 1;
                           CondStatus = 1;
                           break;   
                    case 2:QueryStatus = 3;
                           CondStatus = 3;
                           break;       
                    case 3:QueryStatus = 2;
                           CondStatus = 2;
                           break;
                    case 4:QueryStatus = 4;
                           CondStatus = 4;
                           break;
                }
                
                array[0] = 70;          // page_id
                array[1] = QueryStatus; // query_status
                array[2] = CondStatus;  // cond_status
                array[3] = ParamsValue;
                array[4] = username;
        %>
        <%
            switch (RepType) {
                case 0:
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="70"/> 
            <jsp:param name="QueryStatus" value="<%=QueryStatus%>"/>
            <jsp:param name="CondStatus" value="<%=CondStatus%>"/>
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
