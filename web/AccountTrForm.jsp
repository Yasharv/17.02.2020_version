<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
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
                String TarixB = request.getParameter("TrDateB");
                String TarixE = request.getParameter("TrDateE");
                String iban = request.getParameter("iban").isEmpty() ? "" : "'" + request.getParameter("iban") + "'";
                String custid = request.getParameter("custid").isEmpty() ? "" : request.getParameter("custid");
                String category = request.getParameter("category").isEmpty() ? "" : request.getParameter("category");
                String RepFil = request.getParameter("RepFil").equals("0") ? "" : request.getParameter("RepFil");
                String MonthCnt = request.getParameter("MonthCnt").isEmpty() ? "6" : request.getParameter("MonthCnt");
                String username = request.getParameter("uname");
                
                String ParamsValue = "monthcnt=" + MonthCnt.trim() +"/" 
                                   + "category=" + category.trim()+ "/"
                                   + "customer_id=" + custid.trim() + "/"
                                   + "acctnodt=" + iban.trim() + "/"
                                   + "acctnocr=" + iban.trim() + "/"
                                   + "filial_code=" + RepFil.trim() +"/"
                                   + "datesinterval=" + "to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')";
                
                array[0] = 62;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;

                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="62"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1: {
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
