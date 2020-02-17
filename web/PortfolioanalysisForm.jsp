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
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;
            String[] contractArr = null;
            String contractId = "";
            
            String DateB = request.getParameter("DateB");
            String Filial = request.getParameter("Filial");
            String productId = request.getParameter("product_id");
            String custid = request.getParameter("custid");
            String contrid = request.getParameter("contract_id");
            String user_name = request.getParameter("uname");
            
            if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
            {
                Filial = Filial.equals("0") ? "" : Filial; 
            }
            
            if (productId != null && productId != "" && !productId.trim().equals("")) 
            {
                productId = productId.equals("0") ? "" : productId; 
            }
            
            if (custid != null && custid != "" && !custid.trim().equals(""))
            {
                custid = custid.isEmpty() ? "" : custid;  
            }

            if (contrid != null && contrid != "" && !contrid.trim().equals(""))
            {
                if (contrid.isEmpty())
                {
                    contrid = "";
                }
                else
                {
                    contractArr  = contrid.split(",");
                    for (int i=0; i < contractArr.length; i++)
                    {
                        contractId = contractId + ",'" + contractArr[i] + "'"; 
                    }
                    contrid = contractId.substring(1);
                }
            }

            String[] DVal1 = null;
            String DVal = "";
            if (!(request.getParameterValues("DebVal") == null)) {
                DVal1 = request.getParameterValues("DebVal");
            }
            if (!(DVal1 == null)) {
                for (int i = 0; i < DVal1.length; i++) {
                    DVal = DVal + "," + DVal1[i];
                };
                DVal = DVal.substring(1);
            }            

            String ParamsValue = "datefrom=to_date('" + DateB.trim() + "','dd.mm.yyyy')/"
                               + "productid=" + productId.trim() + "/"
                               + "customerid=" + custid.trim() + "/"
                               + "filialcode=" + Filial.trim() + "/"
                               + "contractsid=" + contrid.trim() + "/"
                               + "currencysid=" + DVal.trim();

            array[0] = 22;
            array[1] = "1";
            array[2] = "1";
            array[3] = ParamsValue;
            array[4] = user_name;

            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
    %>
    <jsp:forward page="DownloadsFile">    
        <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
    </jsp:forward>
    </body>
</html>