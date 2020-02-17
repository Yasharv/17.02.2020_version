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
            int RepType = 0;
            String input_authorise_date_inter = "";
            String inputstime = "";
            String authorisetimes = "";
            String inputerandauthorisetime = "";
            
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String Filial = request.getParameter("Filial");
            String user_name = request.getParameter("uname");
            
            if (request.getParameter("RepType") != null) 
            {
                String[] TypeArray = request.getParameterValues("RepType");
                if (TypeArray.length == 1) 
                {
                    RepType = Integer.parseInt(request.getParameter("RepType"));
                } 
                else 
                {
                    RepType = 3;
                }
            }
            
            if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
            {
                Filial = Filial.equals("0") ? "" : Filial; 
            }
            
            String TimeB = null;
            if (request.getParameter("TimeB") != null) 
            {
                TimeB = request.getParameter("TimeB");
            }
            
            String TimeE = null;
            if (request.getParameter("TimeE") != null) 
            {
                TimeE = request.getParameter("TimeE");
            }
            
            switch (RepType) 
            {
                case 0: 
                {
                    if ((TimeB != null) && (TimeE != null)) 
                    {
                        input_authorise_date_inter = "to_date('" + DateB.trim() + " " + TimeB.trim() + "','DD-MM-YYYY HH24:mi') and to_date('" + DateE.trim() + " " + TimeE.trim() + "','DD-MM-YYYY HH24:mi')"; 
                    }
                    break;
                }
                case 1: {
                    if ((TimeB != null) && (TimeE != null)) 
                    {
                        inputstime = "to_date('" + DateB.trim() + " " + TimeB.trim() + "','DD-MM-YYYY HH24:mi') and to_date('" + DateE.trim() + " " + TimeE.trim() + "','DD-MM-YYYY HH24:mi')";
                    }
                    break;
                }
                case 2: {
                    if ((TimeB != null) && (TimeE != null)) 
                    {
                        authorisetimes = "to_date('" + DateB.trim() + " " + TimeB.trim() + "','DD-MM-YYYY HH24:mi') and to_date('" + DateE.trim() + " " + TimeE.trim() + "','DD-MM-YYYY HH24:mi')"; 
                    }
                    break;
                }
                case 3: {
                    if ((TimeB != null) && (TimeE != null)) 
                    {
                        inputerandauthorisetime = "to_date('" + DateB.trim() + " " + TimeB.trim() + "','DD-MM-YYYY HH24:mi') and to_date('" + DateE.trim() + " " + TimeE.trim() + "','DD-MM-YYYY HH24:mi')";
                    }
                    break;
                }   
            }
            
            String ParamsValue = "datesinterval=" + "to_date('" + DateB.trim() + "','DD-MM-YYYY') and to_date('" + DateE.trim() + "','DD-MM-YYYY')/"
                               + "filialcode=" + Filial.trim() + "/"
                               + "input_authorise_date_inter=" + input_authorise_date_inter.trim() + "/"
                               + "inputstime=" + inputstime.trim() + "/"
                               + "authorisetimes=" + authorisetimes.trim() + "/"
                               + "inputerandauthorisetime=" + inputerandauthorisetime;

            array[0] = 25;
            array[1] = "1";
            array[2] = "1";
            array[3] = ParamsValue;
            array[4] = user_name;

            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
    %>
    <jsp:forward page="DownloadsFile">    
        <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
    </jsp:forward>
    </body>
</html>