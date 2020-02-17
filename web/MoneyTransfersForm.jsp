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
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
            
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;
            
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String firstname = request.getParameter("Firstname");
            String surname = request.getParameter("surname");
            String patronymic = request.getParameter("patronymic");
            String cardnum = request.getParameter("cardnum");
            String user_name = request.getParameter("uname");
            
            if (firstname != null && firstname != "" && !firstname.trim().equals("")) 
            {
                firstname = firstname.isEmpty() ? "" : "'%" + firstname + "%'"; 
            }
            
            if (surname != null && surname != "" && !surname.trim().equals("")) 
            {
                surname = surname.isEmpty() ? "" : "'%" + surname + "%'"; 
            }
            
            if (patronymic != null && patronymic != "" && !patronymic.trim().equals("")) 
            {
                patronymic = patronymic.isEmpty() ? "" : "'%" + patronymic + "%'"; 
            }
            
            if (cardnum != null && cardnum != "" && !cardnum.trim().equals("")) 
            {
                cardnum = cardnum.isEmpty() ? "" : "'%" + cardnum + "%'"; 
            }
            
            String ParamsValue = "cardsid=" + cardnum + "/"
                               + "datefrom=to_date('" + DateB + "','dd.mm.yyyy')/"
                               + "dateto=to_date('" + DateE + "','dd.mm.yyyy')/"
                               + "namefirstaz=" + firstname.trim() + "/"
                               + "namecustaz=" + patronymic.trim() + "/"
                               + "namelastaz=" + surname.trim() + "/"
                               + "datesinterval=" + "to_date('" + DateB.trim() + "','DD-MM-YYYY') and to_date('" + DateE.trim() + "','DD-MM-YYYY')";

            array[0] = 23;
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