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
                String QueryStatus = null;
                String CondStatus = null; 

                int RepType = Integer.parseInt(request.getParameter("RepType"));

                String TarixB = request.getParameter("TrDateB");
                String TarixE = request.getParameter("TrDateE");
                String cus1 = request.getParameter("cus1");
                String cus2 = request.getParameter("cus2");
                String cus3 = request.getParameter("cus3");
                String custid = request.getParameter("custid");
                String pincode = request.getParameter("pincode");
                String fname = request.getParameter("fname");
                String lname = request.getParameter("lname");
                String father = request.getParameter("father");
                String user_name = request.getParameter("uname");
                
                if (cus3 == null) 
                {
                    cus3 = "0";
                }
                if (cus1 == null) 
                {
                    cus1 = "0";
                }
                if (cus2 == null) 
                {
                    cus2 = "0";
                }
                
                if (custid != null && custid != "" && !custid.trim().equals(""))
                {
                    custid = custid.isEmpty() ? "" : custid; 
                    custid = custid.replace(" ", ",");
                }
                
                if (pincode != null && pincode != "" && !pincode.trim().equals(""))
                {
                    pincode = pincode.isEmpty() ? "" : "'%" + pincode.toUpperCase() + "%'"; 
                }
                
                if (fname != null && fname != "" && !fname.trim().equals(""))
                {
                    fname = fname.isEmpty() ? "" : "'%" + fname.toUpperCase() + "%'"; 
                }
                
                if (lname != null && lname != "" && !lname.trim().equals(""))
                {
                    lname = lname.isEmpty() ? "" : "'%" + lname.toUpperCase() + "%'"; 
                }
                
                if (father != null && father != "" && !father.trim().equals(""))
                {
                    father = father.isEmpty() ? "" : "'%" + father.toUpperCase() + "%'"; 
                }
                
                if ((cus1.equals("1")) && (cus2.equals("1")) && (cus3.equals("1"))) 
                {
                    QueryStatus = "5";
                    CondStatus = "5"; 
                   //FullSql = fiziki + "   union all  " + huquqi + "   union all  " + sahibkar;
                } 
                else if ((cus1.equals("1")) && (cus2.equals("1"))) 
                {
                    QueryStatus = "4";
                    CondStatus = "4";
                  //FullSql = fiziki + "  union all  " + huquqi;
                } 
                else if ((cus1.equals("1")) && (cus3.equals("1"))) 
                { 
                    QueryStatus = "7";
                    CondStatus = "7";
                    //FullSql = fiziki + "   union all  " + sahibkar;
                } 
                else if (!(cus1.equals("1")) && (cus3.equals("1"))) 
                {
                    QueryStatus = "6";
                    CondStatus = "6";
                    //FullSql = huquqi + "   union all  " + sahibkar;
                } 
                else if ((cus1.equals("1"))) 
                {
                    QueryStatus = "1";
                    CondStatus = "1";
                    //FullSql = fiziki;
                } else if ((cus2.equals("1"))) 
                {
                    QueryStatus = "2";
                    CondStatus = "2";
                    //FullSql = huquqi;
                } 
                else if ((cus3.equals("1"))) 
                {
                    QueryStatus = "1";
                    CondStatus = "1";
                    //FullSql = sahibkar;
                }
                else
                {
                    QueryStatus = "8";
                    CondStatus = "8";
                }
                
                
                String ParamsValue = "datesinterval=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')/"
                                   + "customersid=" + custid.trim() + "/"
                                   + "pincode=" + pincode.trim() + "/"
                                   + "namefirstaz=" + fname.trim() + "/"
                                   + "namelastaz=" + lname.trim() + "/"
                                   + "namecustaz=" + father.trim() + "/"
                                   + "nameshortaz=" + fname.trim();
                
                array[0] = 36;
                array[1] = QueryStatus;
                array[2] = CondStatus;
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="36"/> 
            <jsp:param name="QueryStatus" value="<%=QueryStatus%>"/>
            <jsp:param name="CondStatus" value="<%=CondStatus%>"/>
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
