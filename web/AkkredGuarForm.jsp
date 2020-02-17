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
                String Filial = request.getParameter("Filial");
                String RepUser = request.getParameter("RepUser");
                String custid = request.getParameter("custid");
                String contr = request.getParameter("contr");
                String status = request.getParameter("status");
                String user_name = request.getParameter("uname");
                
                if (Filial != null && !Filial.isEmpty()  && !Filial.trim().equals("")) 
                {
                    Filial = Filial.equals("0") ? "" : Filial; 
                }
                 
                if (RepUser != null && RepUser != "" && !RepUser.trim().equals("")) 
                {
                    RepUser = RepUser.equals("0") ? "" : RepUser; 
                }
                
                if (custid != null && !custid.isEmpty()  && !custid.equals(""))
                {
                    custid = custid.isEmpty() ? "" : custid; 
                }
                
                if (contr != null && !contr.isEmpty() && !contr.trim().equals("")) 
                {
                    contr = contr.isEmpty() ? "" : "'" + contr + "'"; 
                }
                
                String ParamsValue = "tarix=to_date('"+ TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                   + "datesinterval=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')/"
                                   + "filialcode=" + Filial.trim() + "/"
                                   + "customerid=" + custid.trim() + "/"
                                   + "contractid=" + contr.trim();
                array[0] = 48;
                array[1] = status;
                array[2] = status;
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="48"/> 
            <jsp:param name="QueryStatus" value="<%=status%>"/>
            <jsp:param name="CondStatus" value="<%=status%>"/>
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
