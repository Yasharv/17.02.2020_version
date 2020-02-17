<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
--%>

<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="DBUtility.WorkDatabase"%>
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
                WorkDatabase wd = new WorkDatabase();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String repcheck = request.getParameter("RepCheck");
                String product_id = request.getParameter("product_id").equals("0") ? "" : request.getParameter("product_id");
                String RepCateg = request.getParameter("RepCateg").equals("0") ? "" : request.getParameter("RepCateg");
                String RepFil = request.getParameter("RepFil").equals("0") ? "" : request.getParameter("RepFil");
                String custid = request.getParameter("custid");
                String contr = request.getParameter("contr");
                String username = request.getParameter("uname");
                String RepCheck = "";
                if (repcheck.equals("1")) 
                {
                    RepCheck = "and nvl(biloan.borc,0) = 0";
                }
                else if(repcheck.equals("2"))
                {
                    RepCheck = "and nvl(biloan.borc,0) > 0";
                }
                
                String ParamsValue ="productid=" + product_id.trim() + "/"
                                   +"customerid=" + custid.trim() + "/"
                                   +"contractid=" + contr.trim() +"/"
                                   +"filialcode=" + RepFil.trim() +"/"
                                   +"category=" + RepCateg.trim() + "/"
                                   +"repcheck=" + RepCheck.trim();
                array[0] = 59;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="59"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
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
