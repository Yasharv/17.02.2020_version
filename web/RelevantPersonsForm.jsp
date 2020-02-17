<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
--%>

<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="PDFUtility.WorkPDF"%>
<%@page import="main.PrDict"%>
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
            if (request.getParameter("RepForm") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                WorkPDF wpdf = new WorkPDF();   
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                String QueryStatus = null;
                String CondStatus  = null;
                int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                String CustomerType = request.getParameter("CustomerType");
                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                String CustomerId = request.getParameter("CustomerId").isEmpty() ? "" : request.getParameter("CustomerId");
                String PinCode = request.getParameter("PinCode").isEmpty() ? "" : "'" + request.getParameter("PinCode") + "'"; 
                String BirthD = request.getParameter("BirthD").isEmpty() ? "" : "to_date('" + request.getParameter("BirthD").trim() + "','dd.mm.yyyy')";
                String CustName = request.getParameter("CustName").isEmpty() ? "" : "'%" + request.getParameter("CustName").trim() + "%'";
                String CustSurname = request.getParameter("CustSurname").isEmpty() ? "" : "'%" +request.getParameter("CustSurname") + "%'";
                String CustPatrName = request.getParameter("CustPatrName").isEmpty() ? "" : "'%" + request.getParameter("CustPatrName") + "%'";
                String RelationCode = request.getParameter("RelationCode").isEmpty() ? "" : request.getParameter("RelationCode");
                String RevRelCode = request.getParameter("RevRelCode").isEmpty() ? "" : request.getParameter("RevRelCode");
                String username = request.getParameter("uname");
                
                String type = CustomerType.equals("4") ? "1,2,3" : CustomerType;
                if (CustomerType.equals("4")) 
                {
                    QueryStatus = "2";
                    CondStatus  = "2";
                }
                else
                {
                    QueryStatus = "1";
                    CondStatus  = "1";
                }
                String ParamsValue = "customer_id=" + CustomerId.trim() + "/"
                                   + "pin_code=" + PinCode.trim() + "/"
                                   + "birth_date=" + BirthD + "/"
                                   + "customername=" + CustName + "/" 
                                   + "surname=" + CustSurname  + "/"  
                                   + "patronymic=" + CustPatrName + "/"  
                                   + "type=" + type.trim() + "/" 
                                   + "relation_code=" + RelationCode.trim() + "/"
                                   + "revers_rel_code=" + RevRelCode.trim() + "/"
                                   + "date_interval=to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')" + "/";
                array[0] = 73;
                array[1] = QueryStatus;
                array[2] = CondStatus;
                array[3] = ParamsValue;
                array[4] = username;
                
                switch (RepForm) {
                    case 1: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="73"/> 
            <jsp:param name="QueryStatus" value="<%=QueryStatus%>"/>
            <jsp:param name="CondStatus" value="<%=CondStatus%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/>
        </jsp:forward>
        <%
                break;
            }
            case 2: {
                     FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
                
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward> 
        <% break;
            }
            case 3: {
                     FileNamePath = wpdf.ExportDataToPDF(array, properties.getProperty("ProcName"),0); 
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