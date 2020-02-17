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
            if (request.getParameter("RepTypes") != null) {
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
                String FileNamePath = null;
                String currency = null;
                String TranType = null;
                
                int RepTypes = Integer.parseInt(request.getParameter("RepTypes"));
                int TrType = Integer.parseInt(request.getParameter("TrType"));
                String TrDateB = request.getParameter("TrDateB");
                String TrDateE = request.getParameter("TrDateE");
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String[] DebVal = null;
                request.setAttribute("DebVal", request.getParameterValues("DebVal"));
                String DFilial = request.getParameter("DebFil").equals("0") ? "" : request.getParameter("DebFil");
                String user_name = request.getParameter("uname");

                if (request.getParameterValues("DebVal") != null) {
                    DebVal = request.getParameterValues("DebVal");
                    for (int i = 0; i < DebVal.length; i++) {
                        currency = currency + "," + DebVal[i].trim();
                    }
                } else {
                    currency = "";
                }

                switch (TrType) {
                    case 1:
                        TranType = "'XOHKS'";
                        break;
                    case 2:
                        TranType = "'SWIFT'";
                        break;
                    case 3:
                        TranType = "'AZIPS'";
                        break;
                    default:
                        TranType = "";
                }

                String ParamsValue = "date_from=to_date('" + TrDateB.trim() + "','dd.mm.yyyy')/"
                        + "date_to=to_date('" + TrDateE.trim() + "','dd.mm.yyyy')/"
                        + "filial_code=" + DFilial.trim() + "/"
                        + "currency_id=" + currency + "/"
                        + "type_payment_system=" + TranType;

                array[0] = 9; /* page_id */
                array[1] = RepTypes == 0 ? 1 : 2; /* query_status */
                array[2] = RepTypes == 0 ? 1 : 2; /* cond_status */
                array[3] = ParamsValue; /*params*/
                array[4] = user_name;

                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="9"/> 
            <jsp:param name="QueryStatus" value="<%=RepTypes == 0 ? 1 : 2%>"/>
            <jsp:param name="CondStatus" value="<%=RepTypes == 0 ? 1 : 2%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=user_name%>"/> 
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

                    default: {
                        out.println("Hazırlanır!");
                        break;
                    }
                }
            }
        %>
    </body>
</html>
