<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : e.mustafayev
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
            if (request.getParameter("RepType") != null) {
                
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
            
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                String QueryStatus = null;
                String CondStatus = null;
                
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                
                String repcheck = request.getParameter("RepCheck");
                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                String custid = request.getParameter("custid");
                String user_name = request.getParameter("uname");
                
                if (repcheck.equals("0")) 
                {
                    QueryStatus = "1";
                    CondStatus = "1";
                } 
                else
                {
                    QueryStatus = "2";
                    CondStatus = "2";
                }
                
                if (custid != null && custid != "" && !custid.trim().equals(""))
                {
                    custid = custid.isEmpty() ? "" : custid; 
                }
                
                String ParamsValue = "datesinterval=to_date('"+ DateB.trim() +"','dd.mm.yyyy') and to_date('" + DateE.trim() +"','dd.mm.yyyy')/"
                                   + "customerid=" + custid.trim();
                
                array[0] = 29;
                array[1] = QueryStatus;
                array[2] = CondStatus;
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="29"/> 
            <jsp:param name="QueryStatus" value="<%=QueryStatus%>"/>
            <jsp:param name="CondStatus" value="<%=CondStatus%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=user_name%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1: { FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
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
