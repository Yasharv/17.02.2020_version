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
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String DateFrom = request.getParameter("DateFrom");
                String DateTo = request.getParameter("DateTo");
                String FilialCode = request.getParameter("FilialCode").equals("0") ? "" : request.getParameter("FilialCode");
                String product_id = request.getParameter("product_id").equals("0") ? "" : request.getParameter("product_id");
                String ExbCustMM = request.getParameter("ExbCustMM").equals("0") ? "" : "'" + request.getParameter("ExbCustMM") + "'";
                String RepUser = request.getParameter("RepUser").equals("0") ? "" : request.getParameter("RepUser");
                String contract_id = request.getParameter("contract_id").isEmpty() ? "" : "'" + request.getParameter("contract_id") + "'";
                String username = request.getParameter("uname");

                String ParamsValue = "contract_id=" + contract_id.trim() + "/"
                        + "date_from=to_date('" + DateFrom.trim() + "','dd.mm.yyyy')/"
                        + "date_to=to_date('" + DateTo.trim() + "','dd.mm.yyyy')/"
                        + "filial_code=" + FilialCode.trim() + "/"
                        + "product_id=" + product_id.trim() + "/"
                        + "exb_cus_mm=" + ExbCustMM.trim() + "/" 
                        + "portf_sort=" + RepUser.trim();

                array[0] = 69;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;
        %>
        <%
            switch (RepType) {
                case 0:
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="69"/> 
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
