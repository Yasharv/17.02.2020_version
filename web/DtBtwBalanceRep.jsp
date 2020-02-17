<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
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
                margin: 15mm 10mm 15mm 10mm;  /* this affects the margin in the printer settings */
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
            Date d = new Date();
            DB db = new DB();
            DecimalFormat df = new DecimalFormat("0.00");
            PrDict dict = new PrDict();

            SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
            String s = format.format(d);

            int RepForm = Integer.parseInt(request.getParameter("RepForm"));
            String strDateB = request.getParameter("TrDateB");
            String strDateE = request.getParameter("TrDateE");
            String SrcValue = request.getParameter("SrcValue");
            String Filial = request.getParameter("Filial");
            String RepValue = request.getParameter("RepVal");
            String Valute = request.getParameter("Valute");
            String BalType = request.getParameter("BalType");

            String RepValueSql = "";
            if (!(RepValue.isEmpty() || RepValue.equals(""))) {
                RepValue = RepValue.replace(",", "','");
                RepValueSql = " and ml.gl_acct_no in ('" + RepValue + "') ";
            }

            String user_name = request.getParameter("uname");
            String user_branch = request.getParameter("br");

            String title = "";
            if (RepForm == 0) {
                title = "Qalıq balansı";
            }
            if (RepForm == 1) {
                title = "Qalıq-Dövriyyə balansı";
            }
            if (RepForm == 2) {
                title = "Tam balans";
            }

            Date dateB = format.parse(strDateB);
            strDateB = format2.format(dateB);
            Date dateE = format.parse(strDateE);
            strDateE = format2.format(dateE);

            String ValuteSql = "";
            if (!(Valute.equals("0"))) {
                ValuteSql = " and ml.currency_id=" + Valute;
            } else {
                BalType = "1";
            }

            String SqlPart1 = "SELECT   ml.gl_acct_no,"
                    + " SUM (NVL (baktiv, 0)) baktiv, SUM (NVL (bpassiv, 0)) bpassiv,"
                    + " SUM (NVL (baktivval, 0)) baktivval, SUM (NVL (bpassivval, 0)) bpassivval,"
                    + " ABS (SUM (NVL (dt_dovriye, 0))) dt_dovriye, ABS (SUM (NVL (cr_dovriye, 0))) cr_dovriye,"
                    + " ABS (SUM (NVL (dt_dovriye_val, 0))) dt_dovriye_val, ABS (SUM (NVL (cr_dovriye_val, 0))) cr_dovriye_val,"
                    + " SUM (NVL (eaktiv, 0)) eaktiv, SUM (NVL (epassiv, 0)) epassiv,"
                    + " SUM (NVL (eaktivval, 0)) eaktivval, SUM (NVL (epassivval, 0)) epassivval";
            String SqlPart2 = " FROM   (SELECT   alt_acct_id, eaktiv, epassiv, eaktivval, epassivval FROM   vi_tarix_balans"
                    + "  WHERE  TO_DATE ('" + strDateE + "', 'yyyy-mm-dd') between date_from and date_until "
                    + "          ) sq,"
                    + " (SELECT   alt_acct_id, eaktiv AS baktiv, epassiv AS bpassiv,"
                    + "          eaktivval AS baktivval, epassivval AS bpassivval"
                    + "   FROM   vi_tarix_balans"
                    + "   WHERE  TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') - 1  between date_from and  date_until "
                    + "         ) iq,"
                    + " (SELECT   * FROM   si_account_inf_bal"
                    + "  WHERE   TO_DATE ('" + strDateE + "', 'yyyy-mm-dd') between date_from and date_until "
                    + "            AND NVL(closure_date, '01-JAN-3000')   >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')) ml,"
                    + "  (  SELECT   alt_acct_id, "
                    + "               SUM (operation_acct_amount_lcy_dt) dt_dovriye, SUM (operation_acct_amount_lcy_cr) cr_dovriye, "
                    + "               SUM (operation_acct_amount_dt) dt_dovriye_val, SUM (operation_acct_amount_cr) cr_dovriye_val"
                    + "                 FROM   si_account_operation_bal"
                    + "                WHERE   (act_date BETWEEN TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                    + "                           AND  TO_DATE ('" + strDateE + "', 'yyyy-mm-dd')) GROUP BY   alt_acct_id ) dv"
                    + " WHERE  ml.alt_acct_id = sq.alt_acct_id(+)"
                    + "  AND ml.alt_acct_id = iq.alt_acct_id(+)"
                    + "  AND ml.alt_acct_id = dv.alt_acct_id(+)"
                    + "  AND (   dt_dovriye <> 0 OR cr_dovriye <> 0 OR eaktiv <> 0 OR epassiv <> 0"
                    + "     OR baktiv <> 0 OR bpassiv <> 0  OR baktivval <> 0 OR bpassivval <> 0"
                    + " OR dt_dovriye_val <> 0 OR cr_dovriye_val <> 0 OR eaktivval <> 0 OR epassivval <> 0)"
                    + " AND ml.filial_code like ('%" + Filial + "%') " + RepValueSql + ValuteSql;
            String SqlPart3 = " group by ml.gl_acct_no  ORDER BY   ml.gl_acct_no";

            String SQLText = SqlPart1 + SqlPart2 + SqlPart3;
            // System.out.println(SQLText);

            Connection conn = db.connect();
            Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SQLText);

            Map rows = new HashMap();
            ResultSetMetaData rsmd = sqlres.getMetaData();
            Map data = new HashMap();
            int a = 0;
        %>
        <table width="100%" border="0">
            <tr>
                <td valign="top" align="left">
                    <!--  <font face="Times new roman" size="5">
                              <A Href="TodayBalance.jsp<% //out.print("?uname="+user_name+"&br="+user_branch);%>" >
                                  <img src="images/back.png">
                              </a>
                     </font>    -->
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

                    <table bgcolor='white' border='1' width="900" cellspacing="1">
                        <tr>
                            <td>
                                <table bgcolor='white' border='0' width="900">
                                    <tr>
                                        <td align="left"> <font size="5"> "Expressbank" ASC <% out.println(dict.getFililal4Statm(Integer.parseInt(Filial)));%> </font> <br> VÖEN: 1500031691</td>
                                    </tr>  
                                    <tr>
                                        <td align="center"> <font size="5"> <% out.println(title);%> </font> </td>
                                    </tr> 
                                    <tr>
                                        <td align="center">
                                            <font size="4"> 
                                            <%  
                                                String strDateB2 = format.format(dateB);
                                                String strDateE2 = format.format(dateE);
                                                out.println(strDateB2 + "  -  " + strDateE2);
                                            %> 
                                            </font>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td align="center"> <font size="4"> <% out.println(dict.getValute(Integer.parseInt(Valute))); %> </font> </td>
                                    </tr> 
                                    <!--
                                    <tr>
                                        <td align="left"> <hr>  <font size="3">  Aşağıdakı göstərilən əməliyyatları keçirməli. </font> </td>
                                    </tr> 
                                     <tr>
                                        <td align="left">  <hr> </td>
                                    </tr>         
                                    -->

                                </table>
                                <table bgcolor='white' border='1' width="900" cellpadding="1" cellspacing="0" class="repform">
                                    <tr>
                                        <th rowspan="2" width="30" align="center"> Balans Hesabı </th>  
                                            <%
                                                if (RepForm == 0) {
                                                    out.println("<th colspan='2' width='300' align='center'> QALIQLAR </th>");
                                                }
                                                if (RepForm == 1) {
                                                    out.println("<th colspan='2' width='300' align='center'> Dövriyyələr </th>");
                                                    out.println("<th colspan='2' width='300' align='center'> Son qalıqlar </th>");
                                                }
                                                if (RepForm == 2) {
                                                    out.println("<th colspan='2' width='300' align='center'> İlkin qalıq </th>");
                                                    out.println("<th colspan='2' width='300' align='center'> Dövriyyələr </th>");
                                                    out.println("<th colspan='2' width='300' align='center'> Son qalıq </th>");
                                                }
                                            %>

                                    </tr> 
                                    <tr> 
                                        <%
                                            if (RepForm == 0) {
                                                out.println("<th width='100' align='center'> Aktiv </th>  <th width='100' align='center'> Passiv </th>");
                                            }
                                            if (RepForm == 1) {
                                                out.println("<th width='100' align='center'> Debet </th>  <th width='100' align='center'> Kredit </th>");
                                                out.println("<th width='100' align='center'> Aktiv </th>  <th width='100' align='center'> Passiv </th>");
                                            };
                                            if (RepForm == 2) {
                                                out.println("<th width='100' align='center'> Aktiv </th>  <th width='100' align='center'> Passiv </th>");
                                                out.println("<th width='100' align='center'> Debet </th>  <th width='100' align='center'> Kredit </th>");
                                                out.println("<th width='100' align='center'> Aktiv </th>  <th width='100' align='center'> Passiv </th>");
                                            };
                                        %>
                                    </tr> 
                                    <!--</table>
                                       
                                        <table bgcolor='white' border='0' width="900">
                                           <tr>
                                                <td > <hr> </td>    
                                            </tr> 
                                        </table>
                                       
                                       <table bgcolor='white' border='1' width='900' >-->
                                    <%
                                        String BalCn = "";

                                        double DDovr = 0;
                                        double KDovr = 0;

                                        double BAktiv = 0;
                                        double BPassiv = 0;
                                        double EAktiv = 0;
                                        double EPassiv = 0;

                                        double SumBAktiv = 0;
                                        double SumBPassiv = 0;
                                        double SumDebt = 0;
                                        double SumKred = 0;
                                        double SumEAktiv = 0;
                                        double SumEPassiv = 0;
                                        String emps = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                        String emps2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                        double BAktivSum = 0.0;
                                        double BPassivSum = 0.0;
                                        double DDovrSum = 0.0;
                                        double KDovrSum = 0.0;
                                        double EAktivSum = 0.0;
                                        double EPassivSum = 0.0;

                                        while (sqlres.next()) {
                                            a++;
                                            Map row = new HashMap();
                                            for (int col = 1; col <= rsmd.getColumnCount(); col++) {
                                                row.put(col, sqlres.getString(col));

                                            }
                                            data.put(a, row);

                                            out.print("<tr class=\"repform\">");
                                            BalCn = sqlres.getString(1);  //gl_acct_no
                                            if (BalType.equals("0")) {

                                                BAktiv = sqlres.getDouble(4); //b aktivval
                                                SumEAktiv = SumEAktiv + BAktiv;
                                                BPassiv = sqlres.getDouble(5); // b passivval
                                                SumBPassiv = SumBPassiv + BPassiv;

                                                DDovr = sqlres.getDouble(8);  //dt_dovriye_val
                                                SumDebt = SumDebt + DDovr;
                                                KDovr = sqlres.getDouble(9);  //cr_dovriye_val
                                                SumKred = SumKred + KDovr;

                                                EAktiv = sqlres.getDouble(12); // e aktivval
                                                SumEAktiv = SumEAktiv + EAktiv;
                                                EPassiv = sqlres.getDouble(13); // e passivval
                                                SumEPassiv = SumEPassiv + EPassiv;
                                            } else {
                                                BAktiv = sqlres.getDouble(2); //b aktiv
                                                SumBAktiv = SumBAktiv + BAktiv;
                                                BPassiv = sqlres.getDouble(3); // b passiv
                                                SumBPassiv = SumBPassiv + BPassiv;

                                                DDovr = sqlres.getDouble(6); //dt_dovriye
                                                SumDebt = SumDebt + DDovr;
                                                KDovr = sqlres.getDouble(7); //cr_dovriye
                                                SumKred = SumKred + KDovr;

                                                EAktiv = sqlres.getDouble(10); // e aktiv
                                                SumEAktiv = SumEAktiv + EAktiv;
                                                EPassiv = sqlres.getDouble(11); // e passiv
                                                SumEPassiv = SumEPassiv + EPassiv;
                                            }

                                            out.println("<td align='center'>" + BalCn + "</td>");
                                            if (RepForm == 2) {
                                                out.println("<td align='right'>" + df.format(BAktiv) + emps2 + "</td>");
                                                out.println("<td align='right'>" + df.format(BPassiv) + emps2 + "</td>");
                                                out.println("<td align='right'>" + df.format(DDovr) + emps2 + "</td>");
                                                out.println("<td align='right'>" + df.format(KDovr) + emps2 + "</td>");
                                                out.println("<td align='right' >" + df.format(EAktiv) + emps2 + "</td>");
                                                out.println("<td align='right' >" + df.format(EPassiv) + emps2 + "</td>");
                                            } else if (RepForm == 1) {
                                                out.println("<td align='right'>" + df.format(DDovr) + emps + emps + "</td>");
                                                out.println("<td align='right'>" + df.format(KDovr) + emps + emps + "</td>");
                                                out.println("<td align='right' >" + df.format(EAktiv) + emps + emps + "</td>");
                                                out.println("<td align='right' >" + df.format(EPassiv) + emps + emps + "</td>");
                                            } else {
                                                out.println("<td align='right' >" + df.format(EAktiv) + emps + emps + emps + emps + "</td>");
                                                out.println("<td align='right' >" + df.format(EPassiv) + emps + emps + emps + emps + "</td>");
                                            }
                                            out.print("</tr>");
                                        }

                                        session.setAttribute("data", data);

                                        sqlres.close();

                                        stmt.close();
                                        conn.close();


                                    %>
                                    <tr>
                                        <th align="center"> <font size="4">Cəmi: </font></th> 
                                            <%                                                if (RepForm == 2) {
                                                    out.println("<th align='right'>" + df.format(SumBAktiv) + "</th>" + "<th align='right'>" + df.format(SumBPassiv) + "</th>");
                                                    out.println("<th align='right'>" + df.format(SumDebt) + "</th>" + "<th align='right'>" + df.format(SumKred) + "</th>");
                                                };
                                                if (RepForm == 1) {
                                                    out.println("<th align='right'>" + df.format(SumDebt) + "</th>" + "<th align='right'>" + df.format(SumKred) + "</th>");
                                                };
                                                out.println("<th align='right'>" + df.format(SumEAktiv) + "</th>" + "<th align='right'>" + df.format(SumEPassiv) + "</th>");
                                            %>        
                                    </tr>
                                </table>
                                <% out.println(dict.getBankInfo(Integer.parseInt(user_branch))); %>
                            </td>
                    </table> 

                </td>
                <td valign="top" align="right">   
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
                    <FORM  method="post" action="DtBtwBalExcel" name="post">

                        <input type="hidden" name="RepForm" value="<%out.print(RepForm);%>">
                        <input type="hidden" name="BalType" value="<%out.print(BalType);%>">                          
                        <input type="submit" name="excel" value="Excel-ə at" class="NonPrintable">
                    </FORM>
                </td>
            </tr>    
        </table>
    </body>
</html>
