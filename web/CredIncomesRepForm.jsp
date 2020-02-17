<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
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
            
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;

            int RepType = Integer.parseInt(request.getParameter("RepType"));
                 
            String DateB =  request.getParameter("DateB");
            String DateE =  request.getParameter("DateE");
            String Filial = request.getParameter("Filial");
            String product_id = request.getParameter("product_id");
            String custid = request.getParameter("custid");
            String RepUser = request.getParameter("RepUser");
            String user_name = request.getParameter("uname");
            
            if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
            {
                Filial = Filial.equals("0") ? "" : Filial; 
            }

            if (product_id != null && product_id != "" && !product_id.trim().equals("")) 
            {
                product_id = product_id.equals("0") ? "" : product_id; 
            }

            if (custid != null && custid != "" && !custid.trim().equals(""))
            {
                custid = custid.isEmpty() ? "" : "'" + custid + "'";  
            }

            if (custid != null && custid != "" && !custid.trim().equals(""))
            {
                custid = custid.isEmpty() ? "" : custid;  
            }

            if (RepUser != null && RepUser != "" && !RepUser.trim().equals("")) 
            {
                RepUser = RepUser.equals("0") ? "" : RepUser; 
            }
            
            String ParamsValue = "datesinterval=to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() +"','dd.mm.yyyy')/"
                               + "productid=" + product_id.trim() + "/"
                               + "customerid=" + custid.trim() + "/"
                               + "filialcode=" + Filial.trim() + "/"
                               + "dateto=to_date('" + DateE.trim() +"','dd.mm.yyyy')/"
                               + "portfoliosort=" + RepUser.trim();

            array[0] = 20;
            array[1] = "1";
            array[2] = "1";
            array[3] = ParamsValue;
            array[4] = user_name;
            
            switch (RepType)
            {
                case 0:{
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="20"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=user_name%>"/> 
        </jsp:forward>
        <%
                       break;}
      case 1:{ FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
        <jsp:forward page="DownloadsFile">    
          <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
       </jsp:forward>
        <% break;}
              
               }
        }
        %>
    </body>
</html>
