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
                String[] Currency = new String[8];
                String currencies = "";
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;

                int RepType = Integer.parseInt(request.getParameter("RepType"));

                String TarixB = request.getParameter("TrDateB");
                String TarixE = request.getParameter("TrDateE");

                /*
                String azn = request.getParameter("azn");
                String eur = request.getParameter("eur");
                String usd = request.getParameter("usd");
                String gbp = request.getParameter("gbp");
                String rub = request.getParameter("rub");
                String jpy = request.getParameter("jpy");
                String chf = request.getParameter("chf");
                String try1 = request.getParameter("try");
                Added by Ceyhun 26.12.2018
                */
                
                Currency[0] = request.getParameter("azn");
                Currency[1] = request.getParameter("eur");
                Currency[2] = request.getParameter("usd");
                Currency[3] = request.getParameter("gbp");
                Currency[4] = request.getParameter("rub");
                Currency[5] = request.getParameter("jpy");
                Currency[6] = request.getParameter("chf");
                Currency[7] = request.getParameter("try");
                
                String ArrValue = "";
                for (int i = 0; i < Currency.length; i++)
                {
                    ArrValue = Currency[i];
                    if(ArrValue != null)
                    {
                        currencies = currencies + "," + ArrValue;
                    }
                }
                if (currencies.length() > 0)
                {
                    currencies = currencies.substring(1);
                }
                String CredFilialCode = request.getParameter("RepFilial1").equals("0") ? "" : request.getParameter("RepFilial1");
                String DebFilialCode = request.getParameter("RepFilial").equals("0") ? "" : request.getParameter("RepFilial");
                String user_name = request.getParameter("uname"); 
                
                String ParamsValue = "datesinterval= to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('"+TarixE.trim() +"','dd.mm.yyyy')/"
                                   + "filialcodecr=" + CredFilialCode.trim() + "/"
                                   + "filialcodedp=" + DebFilialCode.trim() + "/"
                                   + "currencies= " + currencies.trim();
                
                array[0] = 56;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = user_name;

                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="56"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=user_name%>"/> 
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
