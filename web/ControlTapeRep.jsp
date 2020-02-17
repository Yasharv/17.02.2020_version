<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="javax.sound.midi.Soundbank"%>
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
        <title>DWH Reports</title>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 15mm 10mm 15mm 10mm;  /* this affects the margin in the printer settings */
            }
            .NonPrintable
            {
                display: none;
            }

        </style>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->


        <%
            Date d = new Date();
            DB db = new DB();

            DecimalFormat df = new DecimalFormat("0.00");
            PrDict dict = new PrDict();

            SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
            String s = format.format(d);

            String strDateB = request.getParameter("TrDateB");
            String RepValue = request.getParameter("RepVal");
            // int RepForm = Integer.parseInt(request.getParameter("RepForm"));
            String Filial = request.getParameter("Filial");
            String Valute = request.getParameter("Valute");
            int RepType = Integer.parseInt(request.getParameter("RepType"));

            String RepValueSql = "";

            if (!(RepValue.equals(""))) {
                RepValueSql = " and ml.gl_acct_no in (" + RepValue + ")";
            } else {
                RepValueSql = "";
            }

            String user_name = request.getParameter("uname");
            String user_branch = request.getParameter("br");
            Connection conn = db.connect();
            int salary_acc = 0;
            Statement stmtUser = conn.createStatement();
            String SqlUserQuery = "select user_branch,all_filials,salary_acc from dwh_users where user_id='" + user_name + "'";
            ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
            while (sqlUserSel.next()) {
                salary_acc = sqlUserSel.getInt(3);
            };
            sqlUserSel.close();
            stmtUser.close();

            String CategForSalary = " AND nvl(category,0)<>1200 ";
            if (salary_acc == 1) {
                CategForSalary = "";
            }

            Date dateB = format.parse(strDateB);
            strDateB = format2.format(dateB);
            String ValuteSql = "";
            int RepForm = 0;
            if (!(Valute.equals("0"))) {
                ValuteSql = " and ml.currency_id=" + Valute;
            } else {
                RepForm = 1;
            }

            String SqlPart1 = "  SELECT   ml.gl_acct_no,"
                    + " ABS (SUM (NVL (dt_dovriye, 0))) dt_dovriye, ABS (SUM (NVL (dt_dovriye_val, 0))) dt_dovriye_val,"
                    + " ABS (SUM (NVL (cr_dovriye, 0))) cr_dovriye,ABS (SUM (NVL (cr_dovriye_val, 0))) cr_dovriye_val";
            String SqlPart2 = "  FROM (SELECT * FROM   si_account_inf_bal"
                    + "  WHERE  date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + " AND date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + "          AND closure_date IS NULL) ml,"
                    + " (SELECT   k.alt_acct_id,"
                    + "  NVL (m.dt_dovriye, 0) dt_dovriye,"
                    + "  NVL (m.cr_dovriye, 0) cr_dovriye,"
                    + "  NVL (m.dt_dovriye_val, 0) dt_dovriye_val,"
                    + "  NVL (m.cr_dovriye_val, 0) cr_dovriye_val"
                    + "   FROM   (  SELECT   alt_acct_id,"
                    + "  SUM (operation_acct_amount_lcy_dt) dt_dovriye,"
                    + "  SUM (operation_acct_amount_lcy_cr) cr_dovriye,"
                    + "  SUM (operation_acct_amount_dt) dt_dovriye_val,"
                    + "  SUM (operation_acct_amount_cr) cr_dovriye_val "
                    + "  FROM   si_account_operation_bal"
                    + "  WHERE   (act_date BETWEEN TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + "  AND  TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')) GROUP BY   alt_acct_id) m,"
                    + " (SELECT   DISTINCT alt_acct_id FROM   si_account_operation_bal) k"
                    + " WHERE   m.alt_acct_id(+) = k.alt_acct_id) dv"
                    + " WHERE  ml.alt_acct_id = dv.alt_acct_id(+)"
                    + "      AND (dt_dovriye <> 0 OR cr_dovriye <> 0 or dt_dovriye_val<>0 or cr_dovriye_val<>0)"
                    + " AND ml.filial_code like ('%" + Filial + "%') " + RepValueSql + ValuteSql + CategForSalary;

            String SqlPart2Off = "  FROM (SELECT * FROM   si_account_inf_OFF_bal"
                    + "  WHERE  date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + " AND date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + "          AND closure_date IS NULL) ml,"
                    + " (SELECT   k.alt_acct_id,"
                    + "  NVL (m.dt_dovriye, 0) dt_dovriye,"
                    + "  NVL (m.cr_dovriye, 0) cr_dovriye,"
                    + "  NVL (m.dt_dovriye_val, 0) dt_dovriye_val,"
                    + "  NVL (m.cr_dovriye_val, 0) cr_dovriye_val"
                    + "   FROM   (  SELECT   alt_acct_id,"
                    + "  SUM (operation_acct_amount_lcy_dt) dt_dovriye,"
                    + "  SUM (operation_acct_amount_lcy_cr) cr_dovriye,"
                    + "  SUM (operation_acct_amount_dt) dt_dovriye_val,"
                    + "  SUM (operation_acct_amount_cr) cr_dovriye_val "
                    + "  FROM   si_account_operation_off_bal"
                    + "  WHERE   (act_date BETWEEN TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + "  AND  TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')) GROUP BY   alt_acct_id) m,"
                    + " (SELECT   DISTINCT alt_acct_id FROM   si_account_operation_off_bal) k"
                    + " WHERE   m.alt_acct_id(+) = k.alt_acct_id) dv"
                    + " WHERE  ml.alt_acct_id = dv.alt_acct_id(+)"
                    + "      AND (dt_dovriye <> 0 OR cr_dovriye <> 0 or dt_dovriye_val<>0 or cr_dovriye_val<>0)"
                    + " AND ml.filial_code like ('%" + Filial + "%') " + RepValueSql + ValuteSql;

            String SqlPart3 = " group by ml.gl_acct_no  ORDER BY   ml.gl_acct_no";

            String SqlSumPart = "SELECT ABS (SUM (NVL (dt_dovriye, 0))) dt_dovriye,ABS (SUM (NVL (dt_dovriye_val, 0))) dt_dovriye_val,"
                    + " ABS (SUM (NVL (cr_dovriye, 0))) cr_dovriye, ABS (SUM (NVL (cr_dovriye_val, 0))) cr_dovriye_val";

            String SQLText = "";
            String SqlSumText = "";
            if (RepType == 1) {
                SQLText = SqlPart1 + SqlPart2 + SqlPart3;
                SqlSumText = SqlSumPart + SqlPart2;
            } else {
                SQLText = SqlPart1 + SqlPart2Off + SqlPart3;
                SqlSumText = SqlSumPart + SqlPart2Off;
            }
            //  System.out.println(SQLText);

            Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SQLText);
        %>
        <table width="100%" border="0">
            <tr>
                <td valign="top" align="left">
                </td>
                <td>
                </td>
                <td valign="top" align="right">

                </td>
            </tr> 
            <tr>
                <td valign="top" align="left">  
                </td>
                <td valign="top" align="center">
                    <font size="4">  
                    <table bgcolor='white' border='1' width="900" cellspacing="1">
                        <tr>
                            <td>
                                <table border="0" width="100%" >
                                    <tr>
                                        <td width="270"><font size="5"> <b>Nəzarət lenti</b></font> </td>
                                        <td>
                                            <%
                                                out.println(dict.getValute(Integer.parseInt(Valute)));
                                            %> 
                                        </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                    </tr>   
                                    <tr>
                                        <td>"Expressbank" ASC <% out.println(dict.getFililal4Statm(Integer.parseInt(Filial)));%></td>
                                        <td> Tarix  
                                            <%
                                                String strDateB2 = format.format(dateB);
                                                out.println(strDateB2);
                                            %>
                                        </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                    </tr> 
                                    <tr>
                                        <td> &nbsp; </td>
                                        <td> </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                    </tr> 
                                    <tr>
                                        <td>  </td>
                                        <%
                                            out.print("<th align='right'>Debet Məbləğ </th>");
                                            if (RepForm != 1) {
                                                out.print("<th align='right'>Debit Ekvivalent</th>");
                                            }
                                            out.print("<th align='right'>Kredit Məbləğ  </th>");
                                            if (RepForm != 1) {
                                                out.print("<th align='right'>Kredit Ekvivalent</th>");
                                            }
                                        %>
                                    </tr> 
                                    <tr>
                                        <td colspan="5">
                                            <table border="1" width="100%" cellspacing="0" >

                                                <%
                                                    if (RepForm == 1) {
                                                        while (sqlres.next()) {
                                                            out.print("<tr>");
                                                            out.print("<td align='center' width=\"260\">" + sqlres.getString(1) + "</td>");
                                                            out.print("<td align='right'>" + df.format(sqlres.getDouble(2)) + "&nbsp;</td>");
                                                            out.print("<td align='right'>" + df.format(sqlres.getDouble(4)) + "&nbsp;</td>");
                                                            out.println("</tr>");
                                                        }
                                                    } else {
                                                        while (sqlres.next()) {
                                                            out.print("<tr>");
                                                            out.print("<td align='center' width=\"270\">" + sqlres.getString(1) + "</td>");
                                                            out.print("<td align='right'>" + df.format(sqlres.getDouble(3)) + "&nbsp;</td>");
                                                            out.print("<td align='right'>" + df.format(sqlres.getDouble(2)) + "&nbsp;</td>");
                                                            out.print("<td align='right'>" + df.format(sqlres.getDouble(5)) + "&nbsp;</td>");
                                                            out.print("<td align='right'>" + df.format(sqlres.getDouble(4)) + "&nbsp;</td>");
                                                            out.println("</tr>");
                                                        }
                                                    }

                                                    sqlres.close();
                                                    sqlres = stmt.executeQuery(SqlSumText);
                                                    if (RepForm != 1) {
                                                        while (sqlres.next()) {
                                                            out.print("<tr>");
                                                            out.print("<td align='left'><b>Cəm:</b></td>");
                                                            out.print("<td align='right'><b>" + df.format(sqlres.getDouble(2)) + "&nbsp;</b></td>");
                                                            out.print("<td align='right'><b>" + df.format(sqlres.getDouble(1)) + "&nbsp;</b></td>");
                                                            out.print("<td align='right'><b>" + df.format(sqlres.getDouble(4)) + "&nbsp;</b></td>");
                                                            out.print("<td align='right'><b>" + df.format(sqlres.getDouble(3)) + "&nbsp;</b></td>");
                                                            out.println("</tr>");
                                                        }
                                                    } else {
                                                        while (sqlres.next()) {
                                                            out.print("<tr>");
                                                            out.print("<th align='left'>Cəm:</th>");
                                                            out.print("<th align='right'>" + df.format(sqlres.getDouble(1)) + "&nbsp;</th>");
                                                            out.print("<th align='right'>" + df.format(sqlres.getDouble(3)) + "&nbsp;</th>");
                                                            out.println("</tr>");
                                                        }
                                                    };

                                                    sqlres.close();
                                                    stmt.close();
                                                    conn.close();
                                                %>  
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table border="0" width="100%">
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td width="30%">&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp; </td>
                                        <td> Baş mühasib _________________</td>
                                        <td> İcraçı _________________</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                    </table> 
                    </font>
                </td>
                <td valign="top" align="right"> 
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
                    <FORM  method="post" action="ControlTapeExcel" name="post">
                        <input type="hidden" name="excelSql" value="<%out.print(SQLText);%>">    
                        <input type="hidden" name="RepForm" value="<%out.print(RepForm);%>">
                        <input type="submit" name="excel" value="Excel-ə at" class="NonPrintable">
                    </FORM>
                </td>
            </tr>    
        </table>
    </body>
</html>
