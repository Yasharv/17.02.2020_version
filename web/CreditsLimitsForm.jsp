<%-- 
    Document   : ExpressoDebForm.jsp
    Created on : Jul 3, 2017, 10:53:05 PM
    Author     : emin.mustafayev
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
            if (request.getParameter("RepType") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();

                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                
                String strDateB = request.getParameter("TrDateB");
                String strDateE = request.getParameter("TrDateE");
                String Filial = request.getParameter("Filial");
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                int LimitType = Integer.parseInt(request.getParameter("LimitType"));
                String username = request.getParameter("uname");
                
                String limtypevalues = "";
                String limittype = "-2";
                String limit_types_sql = "4";
                if (LimitType != -2)
                {
                    if (LimitType == -1)
                    {
                        limtypevalues = "is null";
                    }
                    else
                    {
                        limittype = Integer.toString(LimitType);
                        limit_types_sql = Integer.toString(LimitType);
                    }
                }
                
                if (Filial != null && !Filial.trim().equals("")) 
                {
                    Filial = Filial.equals("0") ? "" : Filial; 
                }
                
                String ParamsValue = "filialcode=" + Filial.trim() + "/"
                                   + "datefrom=to_date('" + strDateB.trim() + "','dd.mm.yyyy')/"
                                   + "dateto=to_date('" + strDateE.trim() + "','dd.mm.yyyy')/"
                                   + "limtypevalues=" + limtypevalues.trim() + "/"
                                   + "limittype=" + limittype.trim() + "/"
                                   + "limit_types_sql=" + limit_types_sql.trim();
                array[0] = 14;
                array[1] = 1;
                array[2] = 1;
                array[3] = ParamsValue;
                array[4] = username;
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="14"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/>
        </jsp:forward>
        <%
                break;
            }
            case 1: {
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"), 0);
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
