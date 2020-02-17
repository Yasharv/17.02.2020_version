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
                String paramsValue = "";

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                  String TarixB = request.getParameter("TrDateB");
                  String TarixE = request.getParameter("TrDateE");
                  String Filial = request.getParameter("Filial").equals("0") ? "" : "'" + request.getParameter("Filial") + "'";   
                  String product_id = request.getParameter("product_id").equals("0") ? "" : "'" + request.getParameter("product_id") + "'";   
                  String RepUser = request.getParameter("RepUser").equals("0") ? "" : "'" + request.getParameter("RepUser") + "'"; 
                  String custid = request.getParameter("custid");   
                  String contr = request.getParameter("contr").isEmpty() ? "" : "'" + request.getParameter("contr") + "'";
                  String lawDat = request.getParameter("courtd1").isEmpty() ? "" : "to_date('" + request.getParameter("courtd1") + "','dd.mm.yyyy')";
                  String lawDat2 = request.getParameter("courtd2").isEmpty() ? "" : "to_date('" + request.getParameter("courtd2") + "','dd.mm.yyyy')";
                  String lawDat3 =request.getParameter("courtd3").isEmpty() ? "" : "to_date('" + request.getParameter("courtd3") + "','dd.mm.yyyy')";
                  String report = request.getParameter("report");
                  String username = request.getParameter("uname");
                  
                  if (report.equals("1")) 
                  {
                     paramsValue = "claim_date= to_date('"+TarixB.trim()+"','dd.mm.yyyy') and  to_date('"+TarixE.trim()+"','dd.mm.yyyy')/"
                                   +"filial_code="+Filial.trim() + "/"
                                   +"product_id="+product_id.trim() + "/"
                                   +"port="+RepUser.trim() + "/"
                                   +"customer_id="+custid.trim() + "/"
                                   +"contract_id="+contr.trim() + "/"
                                   +"lwfirst="+lawDat.trim() + "/"
                                   +"lwsecond="+lawDat2.trim() + "/"
                                   +"lwthird="+lawDat3.trim() + "/";
                     
                     
                     array[0] = 72;          // page_id
                     array[1] = 1;          // query_status
                     array[2] = 1;         // cond_status
                     array[3] = paramsValue;
                     array[4] = username;
                  }
                  else
                  { 
                    paramsValue = "act_date= to_date('"+TarixB.trim()+"','dd.mm.yyyy') and  to_date('"+TarixE.trim()+"','dd.mm.yyyy')/"
                                   +"filial_code="+Filial.trim() + "/"
                                   +"product_id="+product_id.trim() + "/"
                                   +"port="+RepUser.trim() + "/"
                                   +"customer_id="+custid.trim() + "/"
                                   +"contract_id="+contr.trim() + "/"
                                   +"lwfirst="+lawDat.trim() + "/"
                                   +"lwsecond="+lawDat2.trim() + "/"
                                   +"lwthird="+lawDat3.trim() + "/";
                     
                     
                     array[0] = 72;          // page_id
                     array[1] = 2;          // query_status
                     array[2] = 2;         // cond_status
                     array[3] = paramsValue;
                     array[4] = username;
                  }
               
    switch (RepType) {
                    case 0: 
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="<%=array[0]%>"/> 
            <jsp:param name="QueryStatus" value="<%=array[1]%>"/>
            <jsp:param name="CondStatus" value="<%=array[2]%>"/>
            <jsp:param name="Params" value="<%=array[3]%>"/> 
            <jsp:param name="UserName" value="<%=array[4]%>"/>
        </jsp:forward>
        
         
        <%
                break;
                case 1:
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);

        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>                
        <%

                    break;

            }
        %>

        <%
            }
        %>
    </body>
</html>
