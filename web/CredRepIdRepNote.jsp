<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>
<%@page import="main.MemorialRep"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
        <title>DWH Reports</title>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 10mm 10mm 10mm 10mm;  /* this affects the margin in the printer settings */
            }
            .NonPrintable
            {
                display: none;
            }
        </style>
        <style type="text/css">
            .repform.table { page-break-inside:auto}
            .repform.tr {page-break-inside:avoid; page-break-after:auto}
        </style>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            DB db = new DB();
            Connection conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            String srcValue = request.getParameter("srcValue").toString();
            String forSrc = "1";
            if (request.getParameter("forSrc") != null) {
                forSrc = request.getParameter("forSrc");
            }
            if (forSrc.equals("2")) {
                response.sendRedirect("LoanRePaySheduleExcel?srcValue=" + srcValue);

            } else {

                String contract_info = "select to_char(ACT_DATE,'dd-MON-yyyy')  \"Qeydin tarixi\","
                        + "CONTACT_NAME \"Əlaqə saxlanılan\","
                        + "CONTACT_REL \"Borcalanla əlaqəsi\","
                        + "CONTACT_PHONE \"Telefon nömrəsi\","
                        + "REASON \"Gecikmə səbəbi\","
                        + "  negative \" Neqativ \", "
                        + "   intention \" Intention\" ,"
                        + "NOTE \"Danışıq haqqında məlumat\" from si_loan_note where contract_id='" + srcValue + "'";
                
                Statement stmt_info = conn.createStatement();
                ResultSet sqlres_inf = stmt_info.executeQuery(contract_info);


        %>
        <table width="100%" border="0">
            <tr>
                <td valign="top" align="left">
                </td>
                <td>
                </td>
                <td valign="top" align="left">

                </td>
            </tr> 
            <tr>
                <td valign="top" align="left">  
                </td>
                <td valign="top" align="left">

                    <table bgcolor='white' border='1' width="100%" cellspacing="1">
                        <tr>
                            <td >
                                <table bgcolor='white' border='0' width="100%">                                                                                                                                                                                                                                                         
                                    <tr>
                                        <td align="left" colspan="2">
                                            <br>
                                            <table border="0">
                                                <tr>
                                                    <th>Qeydin tarixi</th> 
                                                    <th>Əlaqə saxlanılan</th>
                                                    <th>Borcalanla əlaqəsi</th>
                                                    <th>Telefon nömrəsi</th>
                                                    <th>Gecikmə səbəbi</th>
                                                    <th>Neqativ məqamlar</th>
                                                    <th>Ödəmə niyyəti/imkanı</th>
                                                    <th>Danışıq haqqında məlumat</th>

                                                </tr>
                                                <%                                                    String emps = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                    String emps2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                    Double cem_eb = 0.0;
                                                    Double cem_fb = 0.0;
                                                    Double cem_geb = 0.0;
                                                    Double cem_gfb = 0.0;
                                                    Double cem_cerime = 0.0;

                                                    while (sqlres_inf.next()) {
                                                        if (sqlres_inf.getString(8) != null) {
                                                            out.println("<tr>");
                                                            if (sqlres_inf.getString(1) != null) {
                                                                out.println("<td align='center' width=\"8%\">" + sqlres_inf.getString(1) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }
                                                            if (sqlres_inf.getString(2) != null) {
                                                                out.println("<td align='center'>" + sqlres_inf.getString(2) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }
                                                            if (sqlres_inf.getString(3) != null) {
                                                                out.println("<td align='center'>" + sqlres_inf.getString(3) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }

                                                            if (sqlres_inf.getString(4) != null) {
                                                                out.println("<td align='center'>" + sqlres_inf.getString(4) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }

                                                            if (sqlres_inf.getString(5) != null) {
                                                                out.println("<td align='center'>" + sqlres_inf.getString(5) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }

                                                            if (sqlres_inf.getString(6) != null) {
                                                                out.println("<td align='center'>" + sqlres_inf.getString(6) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }
                                                            if (sqlres_inf.getString(7) != null) {
                                                                out.println("<td align='center'>" + sqlres_inf.getString(7) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }

                                                            if (sqlres_inf.getString(8) != null) {
                                                                out.println("<td align='left'>" + sqlres_inf.getString(8) + "</td>");
                                                            } else {
                                                                out.println("<td align='center'></td>");
                                                            }

                                                            out.println("</tr>");
                                                        }

                                                        out.println("<tr>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("<td align='right'></td>");
                                                        out.println("</tr>");
                                                    }
                                                    sqlres_inf.close();
                                                    stmt_info.close();

                                                %>                                                                                                                                                                                                                                                                                                       
                                            </table>
                                        </td>
                                    </tr> 
                                </table>

                            </td>
                    </table> 

                </td>
                <td valign="top" align="right">   
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>

                </td>
            </tr>    
        </table>
    </body>
</html>
<%    }
%>