<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : e.mustafayev
--%>

<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
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
                String equalInfBi = "";
                String greaterInfValue = "";
                
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String repcheck = request.getParameter("RepCheck");
                String city = request.getParameter("city");
                String region = request.getParameter("region");
                String municipal = request.getParameter("municipal");
                String village = request.getParameter("village");
                String call_type = request.getParameter("call_type");
                String building_type = request.getParameter("building_type");
                String one_cost = request.getParameter("one_cost");
                String appraiser = request.getParameter("appraiser");
                String filial = request.getParameter("filial");
                String user_name = request.getParameter("uname");
                
                if (repcheck.equals("0")) 
                {
                    equalInfBi = "";
                } 
                else if (repcheck.equals("2")) 
                {
                    greaterInfValue = "0";
                } 
                else if (repcheck.equals("1")) 
                {
                    equalInfBi = "0";
                }
                
                if (city != null && city != "" && !city.trim().equals(""))
                {
                    city = city.isEmpty() ? "" : "'" + city.toUpperCase() + "'"; 
                }
                
                if (region != null && region != "" && !region.trim().equals(""))
                {
                    region = region.isEmpty() ? "" : "'" + region.toUpperCase() + "'"; 
                }
                
                if (municipal != null && municipal != "" && !municipal.trim().equals(""))
                {
                    municipal = municipal.isEmpty() ? "" : "'" + municipal.toUpperCase() + "'"; 
                }
                
                if (village != null && village != "" && !village.trim().equals(""))
                {
                    village = village.isEmpty() ? "" : "'" + village.toUpperCase() + "'"; 
                }
                
                if (filial != null && filial != "" && !filial.trim().equals(""))
                {
                    filial = filial.equals("0")? "" : filial; 
                }
                
                if (call_type != null && call_type != "" && !call_type.trim().equals(""))
                {
                    call_type = call_type.equals("0")? "" : "'" + call_type.toUpperCase() + "'"; 
                }
                
                if (one_cost != null && one_cost != "" && !one_cost.trim().equals(""))
                {
                    one_cost = one_cost.isEmpty() ? "" : "'" + one_cost.toUpperCase() + "'"; 
                }
                
                if (building_type != null && building_type != "" && !building_type.trim().equals(""))
                {
                    building_type = building_type.isEmpty() ? "" : "'" + building_type.toUpperCase() + "'"; 
                }
                
                 if (appraiser != null && appraiser != "" && !appraiser.trim().equals(""))
                 {
                    appraiser = appraiser.isEmpty() ? "" : "'" + appraiser.toUpperCase() + "'"; 
                 }
                 
                 String ParamsValue = "equalinfbi=" + equalInfBi +"/"
                                    + "greaterinfvalue=" + greaterInfValue.trim() +"/"
                                    + "immvtown=" + city.trim() +"/"
                                    + "immvarea=" + region.trim() +"/"
                                    + "immvvillage=" + village.trim() +"/"
                                    + "immvtype=" + call_type.trim() +"/"
                                    + "immvbuildingtype=" + building_type.trim() +"/"
                                    + "onecosts=" + one_cost.trim() + "/"
                                    + "immvassigment=" + appraiser.trim() + "/"
                                    + "filialcode=" + filial.trim();
                 
                array[0] = 28;
                array[1] = "1";
                array[2] = "1";
                array[3] = ParamsValue;
                array[4] = user_name;
                 
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="28"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
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
