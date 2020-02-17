<%-- 
    Document   : GoldPricingRep
    Created on : Oct 9, 2014, 3:02:35 PM
    Author     : emin.mustafayev
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
            if (request.getParameter("RepCheck") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
            
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                String equalInfBi = "";
                String greaterInfValue = "";
                
                int RepCheck = Integer.parseInt(request.getParameter("RepCheck"));
                String RepType = request.getParameter("RepType");
                String custid = request.getParameter("RepCustomer");
                String contrid = request.getParameter("RepContract");
                String ColletType = request.getParameter("ColletType");
                String PreciousProbe = request.getParameter("RepProbe");
                String PreciousWeight = request.getParameter("RepWeight");
                String PreciousAmt = request.getParameter("RepAmt");
                String Filial = request.getParameter("filial");
                String user_name = request.getParameter("uname");
                
                if (RepType.equals("0")) 
                {
                    equalInfBi = "";
                } 
                else if (RepType.equals("2")) 
                {
                    greaterInfValue = "0";
                } 
                else if (RepType.equals("1")) 
                {
                    equalInfBi = "0";
                }
                
                if (custid != null && custid != "" && !custid.trim().equals(""))
                {
                    custid = custid.isEmpty() ? "" : custid; 
                }
                
                if (contrid != null && contrid != "" && !contrid.trim().equals(""))
                {
                    contrid = contrid.isEmpty() ? "" : "'" + contrid + "'";  
                }
                
                if (ColletType != null && ColletType != "" && !ColletType.trim().equals(""))
                {
                    ColletType = ColletType.isEmpty() ? "" : ColletType; 
                }
                
                if (PreciousProbe != null && PreciousProbe != "" && !PreciousProbe.trim().equals(""))
                {
                    PreciousProbe = PreciousProbe.isEmpty() ? "" : "'" + PreciousProbe + "'"; 
                }
                
                if (PreciousWeight != null && PreciousWeight != "" && !PreciousWeight.trim().equals(""))
                {
                    PreciousWeight = PreciousWeight.isEmpty() ? "" : PreciousWeight; 
                }
                
                if (PreciousAmt != null && PreciousAmt != "" && !PreciousAmt.trim().equals(""))
                {
                    PreciousAmt = PreciousAmt.isEmpty() ? "" : PreciousAmt; 
                }
                
                if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
                {
                    Filial = Filial.equals("0") ? "" : Filial; 
                }
                
                String ParamsValue = "preciousprobe=" + PreciousProbe.trim() +"/"
                                   + "preciousamt=" + PreciousAmt.trim() +"/"
                                   + "preciousweight=" + PreciousWeight.trim() +"/"
                                   + "contractid=" + contrid.trim() + "/"
                                   + "customerid=" + custid.trim() +"/"
                                   + "filialcode=" + Filial.trim() +"/"
                                   + "equalinfbi=" + equalInfBi.trim() + "/"
                                   + "greaterinfvalue=" + greaterInfValue + "/"
                                   + "colletraltype=" + ColletType.trim();
                
                array[0] = 26;
                array[1] = "1";
                array[2] = "1";
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepCheck) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="26"/> 
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