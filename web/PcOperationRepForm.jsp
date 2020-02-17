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
            if (request.getParameter("RepType") != null) {
                
                String[] trafType =null;
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
            
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;

                int RepType = Integer.parseInt(request.getParameter("RepType"));

                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                String cardType = request.getParameter("cardType");
                String allCard = request.getParameter("ALLCARD");
                String traficType = request.getParameter("traficType");
                String Filial = request.getParameter("Filial");
                String user_name = request.getParameter("uname");
                String portfolio_sort = "";
                if ((request.getParameter("portfolio_sort") != null) & (request.getParameter("portfolio_sort") != "") & (!(request.getParameter("portfolio_sort").trim().equals("")))) 
                {
                    portfolio_sort = request.getParameter("portfolio_sort").replace(" ", "','");
                }
                
                if (cardType != null && cardType != "" && ! cardType.trim().equals("")) 
                {
                    cardType = cardType.equals("0") ? "" : "'" + cardType.trim() + "'";
                }
                
                String tr_types="'0'";
                if (allCard != null && !allCard.isEmpty() && !allCard.trim().equals("")) 
                {
                     if (allCard.equals("0"))
                     {
                         tr_types = "";
                     }
                } 
                else 
                {
                    if (!(request.getParameterValues("DebFilial") == null)) 
                    {
                        trafType = request.getParameterValues("DebFilial");
                        for (int i = 0; i < trafType.length; i++) 
                        {
                            tr_types = tr_types + "," + "'" + trafType[i] + "'";
                        }
                        //tr_types = tr_types.substring(1);
                    }
                }
                
                if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
                {
                    Filial = Filial.equals("0") ? "" : Filial; 
                }
                
                String ParamsValue = "datesinterval=to_date('"+ DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() +"','dd.mm.yyyy')/"
                                   + "tarix=to_date('"+ DateE.trim() + "','dd.mm.yyyy')" + "/"
                                   + "filialcode=" + Filial.trim() + "/"
                                   + "cardtype=" + cardType.trim() + "/"
                                   + "inputtervalue=" + portfolio_sort.trim() + "/"
                                   + "productsid=" + tr_types.trim();
                array[0] = 31;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = user_name;
            
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="31"/> 
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
