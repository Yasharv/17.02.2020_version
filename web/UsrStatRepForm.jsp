<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
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
        
        if (request.getParameter("RepType") != null) 
        {
            
            Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
                String FileNamePath = null;
                int QueryStatus = 1;
                int CondStatus = 1;

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                 
               String DateB =  request.getParameter("DateB");
               String DateE =  request.getParameter("DateE");
               String RepUser = request.getParameter("RepUser").equals("0") ? "" : "'" + request.getParameter("RepUser") + "'";;
               String Filial = request.getParameter("Filial").equals("0") ? "" : "'" + request.getParameter("Filial") + "'";
               String username = request.getParameter("uname");
               
               String ParamsValue ="interval= to_date('"+DateB.trim()+"','dd.mm.yyyy') and  to_date('"+DateE.trim()+"','dd.mm.yyyy')/"
                                   +"branch_id="+Filial.trim() + "/"
                                   +"user_id="+ RepUser.trim().toLowerCase() + "/";
               
               array[0] = 17;          // page_id
                array[1] = QueryStatus; // query_status
                array[2] = CondStatus;  // cond_status
                array[3] = ParamsValue;
                array[4] = username;

                
            switch (RepType) {
                case 0:
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="17"/> 
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
