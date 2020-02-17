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
            String[] trafType =null;
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;
            
            String TrDateB = request.getParameter("TrDateB");
            String allCard = request.getParameter("ALLCARD");
            String cardType = request.getParameter("cardType");
            String traficType = request.getParameter("traficType");
            String Filial = request.getParameter("Filial");
            String user_name = request.getParameter("uname");
            
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
            
            String ParamsValue = "tarix=to_date('"+ TrDateB.trim() + "','dd.mm.yyyy')" + "/"
                               + "filialcode=" + Filial.trim() + "/"
                               + "cardtype=" + cardType.trim() + "/"
                               + "productid=" + tr_types.trim();
            array[0] = 49;
            array[1] = 1;
            array[2] = 1;
            array[3] = ParamsValue;
            array[4] = user_name;

        %>

        <%
            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>

        }
        }
        }
        %>
    </body>
</html>
