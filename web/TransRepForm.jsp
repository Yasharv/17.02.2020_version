<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
    Alter      : emin.mustafayev  18.02.2015
--%>

<%@page import="DBUtility.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="DBUtility.WorkDatabase"%>
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
                DataSource dataSource = new DataSource();
                Connection dbConnection = null;

                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                ReadPropFile rf = new ReadPropFile();
                WorkDatabase wd = new WorkDatabase();
                Properties properties = null;
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                String categ_for_salary = " and nvl(vitranaccr.debt_category,0)<>1200 and nvl(vitranaccr.cred_category,0)<>1200";
                String DValue = "";
                String CValue = "";
                String DebCurrency = "";
                String CredCurrency = "";
                String[] DCurrency = null;
                String[] CCurrency = null;
                String DebFilial = "";
                String CredFilial = "";
                String[] DFilial = null;
                String[] CFilial = null;
                String[] dval = null;
                String[] cval = null;
                String user_branch = "";
                int all_filials = 0;
                int salary_acc = 0;

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                String RepTypeBal = request.getParameter("RepTypeBal");
                String DebValue = request.getParameter("DebValue").isEmpty() ? "4" : request.getParameter("DebValue");
                String DebType = DebValue.equals("4") ? "4" : request.getParameter("DebType");
                String CredValue = request.getParameter("CredValue").isEmpty() ? "4" : request.getParameter("CredValue");
                String KredType = CredValue.equals("4") ? "4" : request.getParameter("KredType");
                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                String RepUser = request.getParameter("RepUser").equals("0") ? "" : request.getParameter("RepUser");
                String username = request.getParameter("uname");

                dbConnection = dataSource.getConnection();
                if (!(request.getParameterValues("DebVal") == null)) {
                    DCurrency = request.getParameterValues("DebVal");
                    for (int i = 0; i < DCurrency.length; i++) {
                        DebCurrency = DebCurrency + "," + DCurrency[i];
                    }
                    DebCurrency = DebCurrency.substring(1);
                }

                if (!(request.getParameterValues("CredVal") == null)) {
                    CCurrency = request.getParameterValues("CredVal");
                    for (int i = 0; i < CCurrency.length; i++) {
                        CredCurrency = CredCurrency + "," + CCurrency[i];
                    }
                    CredCurrency = CredCurrency.substring(1);
                }

                if (!(request.getParameterValues("DebFilial") == null)) {
                    DFilial = request.getParameterValues("DebFilial");
                    for (int i = 0; i < DFilial.length; i++) {
                        DebFilial = DebFilial + "," + DFilial[i];
                    }
                    DebFilial = DebFilial.substring(1);
                }

                if (!(request.getParameterValues("KredFilial") == null)) {
                    CFilial = request.getParameterValues("KredFilial");
                    for (int i = 0; i < CFilial.length; i++) {
                        CredFilial = CredFilial + "," + CFilial[i];
                    }
                    CredFilial = CredFilial.substring(1);
                }

                ResultSet rs = wd.ReturnResultSet("select user_branch,all_filials,salary_acc from dwh_users where user_id='" + username.trim() + "'", 0, dbConnection);
                try {
                    while (rs.next()) {
                        user_branch = rs.getString(1);
                        all_filials = rs.getInt(2);
                        salary_acc = rs.getInt(3);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) {
                            rs.close();
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

                if (salary_acc == 1) {
                    categ_for_salary = "";
                }

                //DValue = DebValue.replace(",", "','");
                if (!(DebValue.isEmpty())) {
                    dval = DebValue.split(",");
                    for (int i = 0; i < dval.length; i++) {
                        DValue = DValue + ",'" + dval[i] + "'";
                    }
                    DValue = DValue.substring(1);
                }

                //CValue = CredValue.replace(",", "','");
                if (!(CredValue.isEmpty())) {
                    cval = CredValue.split(",");
                    for (int i = 0; i < cval.length; i++) {
                        CValue = CValue + ",'" + cval[i] + "'";
                    }
                    CValue = CValue.substring(1);
                }

                String ParamsValue = "datesinterval=" + "to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() + "','dd.mm.yyyy')" + "/"
                        + "debt_cond_type_value=" + DebType.trim() + "/"
                        + "debt_cond_type_params=" + DValue.trim() + "/"
                        + "cred_cond_type_value=" + KredType.trim() + "/"
                        + "cred_cond_type_params=" + CValue.trim() + "/"
                        + "debt_currency_id=" + DebCurrency.trim() + "/"
                        + "cred_currency_id=" + CredCurrency.trim() + "/"
                        + "debt_filial_code=" + DebFilial.trim() + "/"
                        + "cred_filial_code=" + CredFilial.trim() + "/"
                        + "user_filter=" + RepUser.trim() + "/"
                        + "categ_for_salary=" + categ_for_salary.trim();

                array[0] = 1;
                array[1] = RepTypeBal;
                array[2] = RepTypeBal;
                array[3] = ParamsValue;
                array[4] = username;

                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="1"/> 
            <jsp:param name="QueryStatus" value="<%=RepTypeBal%>"/>
            <jsp:param name="CondStatus" value="<%=RepTypeBal%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1: {
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"), 0);

                if (dbConnection != null) {
                    dbConnection.close();
                }


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
