<%-- 
    Document   : LoanGuaranteeForm
    Created on : Dec 10, 2018, 3:23:49 PM
    Author     : r.ganiyev
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
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
                String FileNamePath = null;
                int QueryStatus = 1;
                int CondStatus = 1;
                        
                String dates = request.getParameter("TrDateB");
                String status = request.getParameter("status");
                String filial  = request.getParameter("Filial").equals("0") ? "" : request.getParameter("Filial");
                String productid = request.getParameter("product_id").equals("0") ? "" : request.getParameter("product_id");
                String customerId = request.getParameter("custid").isEmpty() ? "" : request.getParameter("custid");
                
                String username = request.getParameter("uname");
                
                String credStatus="";
                if (status.equals("1"))
                {
                  credStatus="'CURR'";  
                }
                else if (status.equals("2"))
                {
                   credStatus="'FWOF'"; 
                }
                
                String ParamsValue ="tarix= to_date('"+dates.trim()+"','dd.mm.yyyy')/"
                                   + "status_balans=" + credStatus + "/"
                                   + "filial_code=" + filial.trim() + "/"
                                   + "product_id=" + productid.trim() + "/"
                                  + "customer_id=" + customerId.trim() + "/";

                array[0] = 81;          // page_id
                array[1] = 1; // query_status
                array[2] = 1;  // cond_status
                array[3] = ParamsValue;
                array[4] = username;
        
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);

        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>                
       

    </body>
</html>
