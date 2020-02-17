<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
--%>

<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
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
                String TarixB = request.getParameter("DateB");
                String TarixE = request.getParameter("DateE");
                String Filial = request.getParameter("Filial");
                String time = request.getParameter("time");
                String transaction = request.getParameter("transaction");
                String user_name = request.getParameter("uname");
                
                if (Filial != null && Filial != "" && !Filial.trim().equals(""))
                {
                    Filial = Filial.equals("0") ? "" : Filial; 
                }
                
                if (time != null && time != "" && !time.trim().equals(""))
                {
                    time = time.isEmpty() ? "" : time; 
                }
                
                if (transaction != null && transaction != "" && !transaction.trim().equals(""))
                {
                    transaction = transaction.isEmpty() ? "" : transaction; 
                }
                
                String ParamsValue = "datesinterval=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE  + "','dd.mm.yyyy')/"
                                   + "filialcode=" + Filial.trim() +"/"
                                   + "transactioncode=" + transaction.trim() + "/" 
                                   + "times=" + time.trim();
                
                array[0] = 47;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="47"/> 
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
