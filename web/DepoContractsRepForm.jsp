<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
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
                String[] ParamValue = null;
                String parValue = "";
                
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                int srcType = Integer.parseInt(request.getParameter("srcType"));
                String RepValue = request.getParameter("RepValue");
                int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                String report_category = request.getParameter("RepCateg").equals("0") ? "" : request.getParameter("RepCateg");
                String BranchCode = request.getParameter("RepFil").equals("0") ? "" : request.getParameter("RepFil");
                String CurrencyId = request.getParameter("Valute").equals("0") ? "" : request.getParameter("Valute");
                String user_name = request.getParameter("uname");
                String user_branch = request.getParameter("br");
                
                String CondValue = "2";
                String paramsvalue = "1";
                if (!(RepValue.equals("")))
                {
                    //paramsvalue = RepValue.replace(",", "','");
                    if(!(RepValue.isEmpty()))
                    {
                        ParamValue  = RepValue.split(",");
                        for (int i=0; i < ParamValue.length; i++)
                        {
                            parValue = parValue + ",'" + ParamValue[i] + "'"; 
                        }
                        paramsvalue = parValue.substring(1);
                    }        
                    switch (srcType) 
                    {
                        case 0: {
                                  CondValue = "0";
                                  break;
                                }
                        case 1: { 
                                  CondValue = "1";
                                  break;
                                }
                         
                        default: {
                                   CondValue = "2";
                                   paramsvalue = "1";
                                   break;
                                 }
                     }
                }
                String rep0_form_sql = "";
                String matdatefrom = "";
                String matdateto = "";
                String date_from  = "";  
                String date_to  = "";
                String rep3_form_sql  = "";
                String rep4_form_sql = "";
                String rep5_form_sql = "";
                String rep6_form_sql  = "";
                
                switch (RepForm)
                {
                    case 0: {rep0_form_sql = "to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')"; break;}
                    case 1: {matdatefrom = "to_date('"+DateB+"','dd.mm.yyyy')"; matdateto = "to_date('"+DateE+"','dd.mm.yyyy')"; break;}
                    case 2: {date_from = "to_date('"+DateB+"','dd.mm.yyyy')"; date_to ="to_date('"+DateE+"','dd.mm.yyyy')"; break;}
                    case 3: {rep3_form_sql= "to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')"; break;}
                    case 4: {rep4_form_sql= "to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')"; break;}
                    case 5: {rep5_form_sql ="to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')"; break;} 
                    case 6: {rep6_form_sql= "to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')"; break;}
                }
                
                
                String ParamsValue = "condvalue=" + CondValue.trim()     + "/" 
                                   + "paramsvalue=" + paramsvalue.trim() + "/"
                                   + "branchcode=" + BranchCode.trim()   + "/"
                                   + "report_category=" + report_category.trim() + "/"
                                   + "currencyid=" + CurrencyId.trim() + "/"
                                   + "rep0_form_sql=" + rep0_form_sql.trim() + "/"
                                   + "matdatefrom=" + matdatefrom.trim() + "/"
                                   + "matdateto=" + matdateto.trim() + "/"
                                   + "date_from=" + date_from.trim() + "/"
                                   + "date_to=" + date_to.trim() + "/" 
                                   + "rep3_form_sql=" + rep3_form_sql.trim() + "/"
                                   + "rep4_form_sql=" + rep4_form_sql.trim() + "/"
                                   + "rep5_form_sql=" + rep5_form_sql.trim() + "/"
                                   + "rep6_form_sql=" + rep6_form_sql.trim() + "/"
                                   + "tarixend=to_date('" + DateE.trim() + "','dd.mm.yyyy')";
                
                array[0] = 18;
                array[1] = 2;
                array[2] = 2;
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="18"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
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
                }
            }
        %>
    </body>
</html>
