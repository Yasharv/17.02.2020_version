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
                String equalInfBi = "";
                String greaterInfValue = "";

                int RepType = Integer.parseInt(request.getParameter("RepType"));

                String repcheck = request.getParameter("RepCheck");
                String custid = request.getParameter("custid");
                String contract = request.getParameter("contract");
                String color = request.getParameter("color");
                String automark = request.getParameter("automark");
                String automodel = request.getParameter("automodel");
                String transmission = request.getParameter("transmission");
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
                
                if (custid != null && custid != "" && !custid.trim().equals(""))
                {
                    custid = custid.isEmpty() ? "" : custid; 
                }
                
                if (contract != null && contract != "" && !contract.trim().equals(""))
                {
                    contract = contract.isEmpty() ? "" : "'" + contract + "'"; 
                }
                
                if (color != null && color != "" && !color.trim().equals(""))
                {
                    color = color.isEmpty() ? "" : "'" + color.toUpperCase() + "'"; 
                }
                
                if (automark != null && automark != "" && !automark.trim().equals(""))
                {
                    automark = automark.isEmpty() ? "" : "'" + automark.toUpperCase() + "'"; 
                }
                
                if (automodel != null && automodel != "" && !automodel.trim().equals(""))
                {
                    automodel = automodel.isEmpty() ? "" : "'" + automodel.toUpperCase() + "'"; 
                }
                
                if (transmission != null && transmission != "" && !transmission.trim().equals(""))
                {
                    transmission = transmission.isEmpty() ? "" : "'" + transmission.toUpperCase() + "'"; 
                }
                
                if (filial != null && filial != "" && !filial.trim().equals("")) 
                {
                    filial = filial.equals("0") ? "" : filial; 
                }
                
                String ParamsValue = "avtcolour=" + color.trim() +"/"
                                   + "avtmarka=" + automark.trim() + "/"
                                   + "avtmodel=" + automodel.trim() +"/"
                                   + "avttransmissionmode=" + transmission.trim() +"/"
                                   + "contractid=" + contract.trim() + "/"
                                   + "customerid=" + custid.trim() + "/"
                                   + "filialcode=" + filial.trim() +"/"
                                   + "equalinfbi=" + equalInfBi.trim() + "/"
                                   + "greaterinfvalue=" + greaterInfValue.trim() +"/"
                                   + "custidlegal=" + custid.trim() + "/"
                                   + "legalfilcode=" + filial.trim() + "/"
                                   + "pccontrid=" + contract.trim();
                
                array[0] = 27;
                array[1] = "1";
                array[2] = "1";
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="27"/> 
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
