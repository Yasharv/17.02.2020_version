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
            String[] srcValueArr = null;
            String srcVal = "";
            String contrOrCustidCondVal = "3";
            String queryStatus = null;
            String condStatus = null;
            
            String xx = request.getParameter("XX");
            String Tarix = request.getParameter("TrDate");
            String Tarix1 = request.getParameter("TrDateB");
            String Tarix2 = request.getParameter("TrDateE");
            String Filial = request.getParameter("Filial");
            String report = request.getParameter("report");
            int forSrc = Integer.parseInt(request.getParameter("forSrc"));
            String srcValue = request.getParameter("srcValue");
            String user_name = request.getParameter("uname");
            
            if (Filial != null && !Filial.trim().equals("")) 
            {
                Filial = Filial.equals("0") ? "" : Filial; 
            }
            
            if (Tarix == null)
            {
                Tarix = "";
            }
            
            if (Tarix1 == null)
            {
                Tarix1 = "";
            }
            
            if (Tarix2 == null)
            {
                Tarix2 = "";
            }
            
            if (srcValue != null)
            {
                if (srcValue.trim().isEmpty())
                {
                    srcValue = "'1'";
                }
                else
                {
                    srcValueArr  = srcValue.split(",");
                    for (int i=0; i < srcValueArr.length; i++)
                    {
                        srcVal = srcVal + ",'" + srcValueArr[i] + "'"; 
                    }
                    srcValue = srcVal.substring(1);
                }
            }
            
            switch (forSrc) {
                case 1:
                    if (!srcValue.isEmpty()) {
                        if (!srcValue.equals("'1'"))
                        {
                            contrOrCustidCondVal = "1";
                        }
                    }
                    break;
                case 2:
                    if (!srcValue.isEmpty()) {
                        if (!srcValue.equals("'1'"))
                        {
                            contrOrCustidCondVal = "2";
                        }
                    }
                    break;
            }
            
            if (xx.equals("1") && report.equals("1")) 
            {
                queryStatus = "1";
                condStatus = "1";
            }
            else if (xx.equals("1") && report.equals("2"))
            {
                queryStatus = "2";
                condStatus = "2";
            }
            else if (xx.equals("2") && report.equals("1"))
            {
                queryStatus = "3";
                condStatus = "3";
            }
            else if (xx.equals("2") && report.equals("2"))
            {
                queryStatus = "4";
                condStatus = "4";
            }
            
            String ParamsValue = "filialcode= " + Filial.trim() +"/"
                               + "contract_or_cust_id_value=" + srcValue.trim() + "/"
                               + "contr_or_custid_cond_val=" + contrOrCustidCondVal.trim() + "/" 
                               + "tarix=to_date('" + Tarix.trim()+ "','dd.mm.yyyy')/"
                               + "tarix1=to_date('" + Tarix1.trim()+ "','dd.mm.yyyy')/"
                               + "tarix2=to_date('" + Tarix2.trim()+ "','dd.mm.yyyy')";

            array[0] = 12;
            array[1] = queryStatus;
            array[2] = condStatus;
            array[3] = ParamsValue;
            array[4] = user_name;

            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
    %>
    <jsp:forward page="DownloadsFile">    
        <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
    </jsp:forward>
    </body>
</html>