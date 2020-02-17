<%-- 
    Document   : MkrStatsForm
    Created on : Oct 3, 2018, 10:37:48 AM
    Author     : r.ganiyev
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
                int QueryStatus = 1;
                int CondStatus = 1;
                        
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                int Status = Integer.parseInt(request.getParameter("status"));
                String dateFrom = request.getParameter("DateFrom");
                String dateTo = request.getParameter("DateTo");
                String person_id = request.getParameter("PersonId").isEmpty() ? "" : "'" + request.getParameter("PersonId") + "'";
                String fin_code = request.getParameter("FinCode").isEmpty() ? "" : "'" + request.getParameter("FinCode") + "'";
                String username = request.getParameter("uname");
                
                
                String ParamsValue ="datinterval= to_date('"+dateFrom.trim()+"','dd.mm.yyyy') and  to_date('"+dateTo.trim()+"','dd.mm.yyyy')/"
                                   +"personid="+person_id.trim() + "/"
                                   +"fin="+ fin_code.trim() + "/";
                
                QueryStatus = Status;
                CondStatus = Status;

                array[0] = 77;          // page_id
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
            <jsp:param name="PageId" value="77"/> 
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

