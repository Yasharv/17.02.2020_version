<%-- 
    Document   : Gecikmədə olan kreditlərin təqibi
    Created on : Sep 25, 2017, 12:18:16 PM
    Author     : emin.mustafayev
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
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String Dates = request.getParameter("Dates");
                String Filial = request.getParameter("Filial").equals("0") ? "" : request.getParameter("Filial");    
                String custid = request.getParameter("custid").isEmpty() ? "" : request.getParameter("custid");   
                String contr = request.getParameter("contr").isEmpty() ? "" : "'" + request.getParameter("contr") + "'";
                String username = request.getParameter("uname");
                 
                String ParamsValue = "act_date=to_date('" + Dates.trim() + "','dd.mm.yyyy')" + "/"
                                   + "filial_code=" + Filial.trim() + "/"
                                   + "contract_id=" + contr.trim() + "/"
                                   + "customer_id=" + custid.trim() + "/"
                                   + "crdac=to_date('" + Dates.trim() + "','dd.mm.yyyy')";
                
                array[0] = 68;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="68"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1: 
            {
                     
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
