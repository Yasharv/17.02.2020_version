<%-- 
    Document   : CredRepIdRep.jsp
    Created on : Jun 7, 2017, 11:16:34 AM
    Author     : emin.mustafayev
--%>


<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page import="DBUtility.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" title="currentStyle">
            @import "media/css/demo_page.css";
            @import "media/css/demo_table.css";
            @import "media/css/demo_table_jui.css";
            @import "media/examples_support/themes/smoothness/jquery-ui-1.8.4.custom.css";
        </style>
        <script type="text/javascript" language="javascript" src="media/js/jquery.js"></script>
        <script type="text/javascript" language="javascript" src="media/js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
                });
            });
        </script>
        <script>
            function newPopup(url) {
                window.open(
                        url, 'popUpWindow', 'height=300,width=300,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes');
            }
        </script>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->

        <%
            DataSource dataSource = new DataSource();
            Connection conn = dataSource.getConnection();
            WorkDatabase wd = new WorkDatabase();
            PrDict dict = new PrDict();

            Object[] array = new Object[5];
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
             
            String custid = request.getParameter("custid");
            String user_name = request.getParameter("uname");
            
            String customerId = null;
            if ((request.getParameter("custid") != null) & (request.getParameter("custid") != "") & (!(request.getParameter("custid").trim().equals("")))) {
                customerId = custid;
            } else {
                customerId = "";
            }
            
            String ParamsValue = "customerid=" + customerId;

            array[0] = 65;
            array[1] = "2";
            array[2] = "2";
            array[3] = ParamsValue;
            array[4] = user_name;
            
            ResultSet sqlres = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, conn);
            
            array[0] = 65;
            array[1] = "3";
            array[2] = "3";
            array[3] = ParamsValue;
            array[4] = user_name;

            ResultSet sqlresCustomer = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, conn);

        %>
        <!----Cedvel bashligi-->
        <%            while (sqlresCustomer.next()) {
        %>
        <h2><%= sqlresCustomer.getString(1)%></h2>
        <% } %>
        <table cellpadding="0" cellspacing="0" border="0"  width="100%" id="example" >
            <thead>
                <tr>
                    <th><b>Müqavilə</b></th>
                    <th><b>İlkin məbləğ</b></th>
                    <th><b>Valyuta</b></th>
                    <th><b>Faiz</b></th>
                    <th><b>Məhsul №</b></th>
                    <th><b>Filial</b></th>
                    <th><b>Verilmə tarixi</b></th>
                    <th><b>Bağlanma tarixi</b></th>
                    <!-- <th><b>MKR Report Id</b></th>-->
                    <th><b>MKR Time</b></th> 
                    <th><b>Status<b></th>
                                <th><b>MKRÇ-yə bax </b></th>
                                <th><b>Ödənişə bax</b> </th>
                                <th><b>Təqib qeydi</b> </th>
                                </tr>
                                </thead>
                                <tbody>
                                    <%
                                        while (sqlres.next()) {
                                            out.println("<tr>");
                                            if (sqlres.getString(1) != null) {
                                                out.println("<td align='center' width='9%'>" + sqlres.getString(1) + "</td>");
                                            } else {
                                                out.println("<td align='center'></td>");
                                            }
                                            if (sqlres.getString(2) != null) {
                                                out.println("<td align='center' width='9%'>" + sqlres.getString(2) + "</td>");
                                            } else {
                                                out.println("<td align='center'></td>");
                                            }
                                            if (sqlres.getString(3) != null) {
                                                out.println("<td align='center' width='5%'>" + sqlres.getString(3) + "</td>");
                                            } else {
                                                out.println("<td align='center'></td>");
                                            }
                                            out.println("<td align='center' width='5%'>" + sqlres.getString(4) + "</td>");
                                            out.println("<td align='center' width='8%'>" + sqlres.getString(5) + "</td>");
                                            out.println("<td align='center' width='9%'>" + sqlres.getString(6) + "</td>");
                                            out.println("<td align='center' width='8%'>" + sqlres.getString(7) + "</td>");
                                            if (sqlres.getString(8) != null) {
                                                out.println("<td align='center' width='8%'>" + sqlres.getString(8) + "</td>");
                                            } else {
                                                out.println("<td></td>");
                                            }
                                            if (sqlres.getString(9) != null) {
                                                out.println("<td align='center' width='6%'>" + sqlres.getString(9) + "</td>");
                                            } else {
                                                out.println("<td></td>");
                                            }
                                            if (sqlres.getString(10) != null) {
                                                out.println("<td align='center' width='6%'>" + sqlres.getString(10) + "</td>");
                                            } else {
                                                out.println("<td></td>");
                                            }

                                            if (sqlres.getString(11) != null) {
                                                out.println("<td align='center' width='7%'>"
                                                        + " <a onclick=\"newPopup('CredRepIdTemp.jsp?repid=" + sqlres.getString(11) + "')\">"
                                                        + " <img src='images/analytics.png'>"
                                                        + " </a>"
                                                        + " </td>");
                                                /*out.println("<td align='center'>"
                                                 + " <a onclick=\"newPopup('CredRepIdTemp.jsp?repid=" + sqlres.getString(7) + "')\">"
                                                 +"    "
                                                 + " <img src='images/email-new-icon.png'>"
                                                 + " </a>"
                                                 + " </td>");*/
                                            } else {
                                                out.println("<td></td>");
                                            }
                                            if (sqlres.getString(1) == null) {
                                                out.println("<td align='center' width='8%'> </td>");
                                            } else if (sqlres.getString(1) != null) {
                                                out.println("<td align='center' width='7%'>"
                                                        + " <a onclick=\"newPopup('LoanRePaySheduleRep.jsp?srcValue=" + sqlres.getString(1) + "&uname=" + user_name + "+')\">"
                                                        + " <img src='images/cash.png'>"
                                                        + " </a>"
                                                        + " </td>");
                                            }
                                            String loanNote = "select count(contract_id) from si_loan_note  where contract_id='" + sqlres.getString(1) + "'";
                                            Statement stLoan = conn.createStatement();
                                            ResultSet rsLoan = stLoan.executeQuery(loanNote);
                                            while (rsLoan.next()) {
                                                if (rsLoan.getInt(1) == 0) {
                                                    out.println("<td align='center' width='7%'> </td>");
                                                } else if (rsLoan.getInt(1) > 0) {
                                                    out.println("<td align='center' width='7%'>"
                                                            + " <a onclick=\"newPopup('CredRepIdRepNote.jsp?srcValue=" + sqlres.getString(1) + "')\">"
                                                            + " <img src='images/phone.png'>"
                                                            + " </a>"
                                                            + " </td>");
                                                }
                                            }

                                            out.println("</tr>");
                                        }
                                        sqlres.close();
                                        sqlresCustomer.close();
                                        conn.close();
                                    %> 
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th><b>Müqavilə</b></th>
                                        <th><b>İlkin məbləğ</b></th>
                                        <th><b>Valyuta</b></th>
                                        <th><b>Faiz</b></th>
                                        <th><b>Məhsul №</b></th>
                                        <th><b>Filial</b></th>
                                        <th><b>Verilmə tarixi</b></th>
                                        <th><b>Bağlanma tarixi</b></th>
                                        <!--<th><b>MKR Report Id</b></th>-->
                                        <th><b>MKR Time</b></th> 
                                        <th><b>Status<b></th>
                                                    <th><b>MKRÇ-yə bax </b></th>
                                                    <th><b>Ödənişə bax</b> </th>
                                                    <th><b>Təqib qeydi</b> </th>
                                                    </tr>    
                                                    </tfoot>
                                                    </table>
                                                    <!----Cedvel sonu-->
                                                    <table  border='0' width="100%" cellspacing="1">
                                                        <tr>
                                                            <td align="right"  >
                                                                <p>
                                                                    <%
                                                                        out.println(dict.ftSign());
                                                                        sqlres.close();
                                                                        sqlresCustomer.close();
                                                                        conn.close();

                                                                    %>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    </body>
                                                    </html>