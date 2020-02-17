<%-- 
    Document   : PostfacktumForm
    Created on : Feb 1, 2019, 6:08:04 PM
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
                String paramsValue = "";

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                  String dates = request.getParameter("TrDate");
                  String branchId = request.getParameter("Filial").equals("0") ? "" : "'" + request.getParameter("Filial") + "'";   
                  String userId = request.getParameter("RepUser").equals("0") ? "" : "'" + request.getParameter("RepUser") + "'"; 
                  String contractId = request.getParameter("Contr").isEmpty() ? "" : "'" + request.getParameter("Contr") + "'";
                  String postStatus = request.getParameter("PstStat").isEmpty() ? "" : "'" + request.getParameter("PstStat") + "'";
                  String сorrStatus = request.getParameter("CorrStat").isEmpty() ? "" : "'" + request.getParameter("CorrStat") + "'";
                  String errType = request.getParameter("ErrTyp").isEmpty() ? "" : "'" + request.getParameter("ErrTyp") + "'";
                  String username = request.getParameter("uname");
                  
                  
                     paramsValue = "tarix= to_date('"+dates.trim()+"','dd.mm.yyyy')/"
                                   +"filial_code="+branchId.trim() + "/"
                                   +"portfolio_sort="+userId.trim() + "/"
                                   +"contract_id="+contractId.trim() + "/"
                                   +"status_postfaktum="+postStatus.trim() + "/"
                                   +"corr_status="+сorrStatus.trim() + "/"
                                   +"error_type="+errType.trim() + "/";
                                  
                     
                     
                     array[0] = 84;          // page_id
                     array[1] = 1;          // query_status
                     array[2] = 1;         // cond_status
                     array[3] = paramsValue;
                     array[4] = username;
                  
                  
               
    switch (RepType) {
                    case 0: 
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="<%=array[0]%>"/> 
            <jsp:param name="QueryStatus" value="<%=array[1]%>"/>
            <jsp:param name="CondStatus" value="<%=array[2]%>"/>
            <jsp:param name="Params" value="<%=array[3]%>"/> 
            <jsp:param name="UserName" value="<%=array[4]%>"/>
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