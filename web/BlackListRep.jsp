<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date"%>
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

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->

        <%
            Date d = new Date();
            DB db = new DB();
            PrDict dict = new PrDict();

            String DateB_E = "";
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            if (DateB.equals(DateE)) {
                DateB_E = DateB;
                //   System.out.println(DateB_E);
            } else {
                DateB_E = DateB + "<>" + DateE;
            }

            String intext = "";

            String status = request.getParameter("status");
           // System.out.println("status jsp "+status);
            if (status.equals("0")) {
                //System.out.println("userin id-si " + RepUser);

                intext = "";
            } else {
                //  System.out.println("userin id-si " + RepUser);
                intext = "  and SLC.problem_department = '" + status + "' ";
            }


            String SQLText = "SELECT SLC.CONTRACT_ID \"LD\", "
                    + " slc.customer_id \"ID\","
                    + " SLC.FILIAL_CODE \"Filial\", "
                    + "      SLC.PRODUCT_ID \"Məhsul\", "
                    + " spn.name_short_az \"Müştəri\", "
                    + " TO_CHAR (slc.VALUE_DATE, 'DD-MM-YYYY') \"Verilmə tarixi\",    "
                    + "   TO_CHAR (SLC.MATURITY_DATE, 'DD-MM-YYYY') \"Bitmə tarixi\","
                    + "  SLC.CURRENCY_ID \"Valyuta\",   "
                    + "    (SELECT MAX (slpd.PENALTY_RATE)   FROM si_loan_past_due slpd "
                    + "   WHERE slpd.contract_id IN (SELECT contract_id     FROM si_loan_contract   "
                    + " WHERE commitment_no = slc.contract_id)  "
                    + "   AND slpd.ACT_DATE = slc.date_until)   \"Faiz dərəcəsi\",  "
                    + "     SLC.ORIG_AMOUNT \"Verilmiş məbləğ\", "
                    + " SLB.DEBT_TOTAL \"Qalıq (ekv)\",    "
                    + "   (SELECT MAX (slpd.PAST_DUE_PR_AMOUNT)    FROM si_loan_past_due slpd      "
                    + "   WHERE slpd.contract_id IN (SELECT contract_id      FROM si_loan_contract      "
                    + "  WHERE commitment_no = slc.contract_id)   AND slpd.ACT_DATE = slc.date_until) "
                    + "     \"Gecikməyə cıxan əsas borc\",  "
                    + " (SELECT MAX (slpd.PAST_DUE_INT_AMOUNT)     "
                    + "     FROM si_loan_past_due slpd WHERE slpd.contract_id IN (SELECT contract_id      "
                    + "     FROM si_loan_contract        WHERE commitment_no = slc.contract_id)           "
                    + "    AND slpd.ACT_DATE = slc.date_until)- (SELECT SUM (ARREARS_B_PAST_DUE)"
                    + " FROM Si_loan_balance"
                    + " WHERE contract_id IN (SELECT contract_id "
                    + "  FROM si_loan_contract "
                    + "   WHERE commitment_no = slc.contract_id) "
                    + "AND date_until = slc.date_until)  \"Gecikməyə çıxan faiz\",   "
                    + "    (SELECT SUM (ARREARS_B_PAST_DUE)     FROM Si_loan_balance   "
                    + "  WHERE contract_id IN (SELECT contract_id     FROM si_loan_contract    "
                    + "      WHERE commitment_no = slc.contract_id)             "
                    + "  AND date_until = slc.date_until)      \"Hesablanmış cərimə\",   "
                    + " (SELECT TO_CHAR (min(SLPD.PAST_DUE_START_DATE), 'DD-MM-YYYY')       "
                    + "   FROM si_loan_past_due slpd     WHERE slpd.contract_id IN (SELECT contract_id    "
                    + "   FROM si_loan_contract                               "
                    + "      WHERE commitment_no = slc.contract_id)  "
                    + "    AND slpd.ACT_DATE = slc.date_until) \"Gecikmənin tarixi\",    "
                    + "TO_CHAR (SLC.DATE_UNTIL+1, 'DD-MM-YYYY') \"Gecikmədən çıxma tarixi\",    "
                    + "   (SELECT SUM (tr_amount_fcy_dt)          FROM si_transaction_account_un     "
                    + "   WHERE transaction_type IN ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9')        "
                    + "       AND number_doc IN (SELECT contract_id          FROM si_loan_contract     "
                    + "  WHERE commitment_no = slc.contract_id)   "
                    + "    AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy')   "
                    + "    AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')  "
                    + "    AND system_id = 'PD')          \"Cəmi ödənilən məbləğ\",  "
                    + "    NVL(TO_CHAR(SC.DESCRIPT),' ') \"Təminat\",   "
                    + "    NVL ( to_char(SC.NOMINAL_VALUE),' ') \"Təminatın dəyəri\",    "
                    + "   SLC.RISK_GROUP || '/' || slc.risk_group_interest \"Ehtiyat qrupu\", "
                    + "      SLC.PROBLEM_DEPARTMENT \"Status\",    "
                    + "   SLC.FILIAL_CODE \"Dao\",    "
                    + "   NVL (TO_CHAR (SLC.PARTNER), ' ') \"Partner\",  "
                    + "     (SELECT MAX (slpd.past_due_int_days)      "
                    + "    FROM si_loan_past_due slpd       "
                    + "  WHERE slpd.contract_id IN (SELECT contract_id  "
                    + "   FROM si_loan_contract    "
                    + "    WHERE commitment_no = slc.contract_id)         "
                    + "     AND slpd.ACT_DATE = slc.date_UNTIL)          \"Gunlərin sayı\"  "
                    + "FROM si_loan_contract slc,    "
                    + "   si_person_natural spn,    "
                    + "   si_loan_balance slb,      "
                    + " si_collateral_right scr,     "
                    + "  si_collateral sc WHERE     SLC.CONTRACT_ID = SCR.CONTRACT_ID(+) "
                    + "     AND SLB.CONTRACT_ID = SLC.CONTRACT_ID     "
                    + "  AND SCR.COLLATERAL_CONTRACT_ID = SC.COLLATERAL_CONTRACT_ID(+) "
                    + "     AND spn.customer_id = slc.customer_id       AND spn.DATE_UNTIL = '01-jan-3000'  "
                    + "     AND slc.DATE_FROM >= TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                    + "      AND SLC.DATE_FROM <= TO_DATE ('" + DateE + "', 'dd.MM.yyyy')   "
                    + "    AND slb.DATE_FROM >= TO_DATE ('" + DateB + "', 'dd.MM.yyyy')    "
                    + "   AND SLb.DATE_FROM <= TO_DATE ('" + DateE + "', 'dd.MM.yyyy')    "
                    + "   AND SLC.OTHER_OFFICER <> 1     "
                    + "  AND SLC.problem_department <> '0'   "
                    + "    AND 0 =      (SELECT NVL (  (SELECT SLC2.problem_department     "
                    + "  FROM si_loan_contract slc2   "
                    + "   WHERE SLC2.CONTRACT_ID = SLC.CONTRACT_ID   "
                    + "   AND slc2.date_from =   (SELECT MIN (SLc3.date_from)  "
                    + "    FROM si_loan_contract slc3          WHERE SLc2.CONTRACT_ID =    "
                    + "     SLc3.CONTRACT_ID           AND SLc3.date_from >    slc.date_from   "
                    + "      AND SLC3.DATE_FROM <=        TO_DATE ('" + DateE + "', 'dd.MM.yyyy'))),   "
                    + "   10)  FROM DUAL)   "
                    + "    AND slb.date_from =   "
                    + "  (SELECT MAX (date_from)  FROM si_loan_balance slb1 "
                    + "  WHERE slb1.date_from <= Slc.DATE_UNTIL    "
                    + "  AND Slb1.CONTRACT_ID = Slc.CONTRACT_ID)  "
                    + "  AND (scr.date_from =   (SELECT MAX (date_from)   FROM si_collateral_right scr1     "
                    + "            WHERE scr1.date_from <= SLC.DATE_UNTIL   "
                    + "     AND SCR1.CONTRACT_ID = SLC.CONTRACT_ID)         "
                    + "OR scr.date_from IS NULL)    AND (sc.date_from =    "
                    + "(SELECT MAX (date_from)                "
                    + "FROM si_collateral sc1    "
                    + " WHERE sc1.date_from <= SCR.DATE_UNTIL       "
                    + "AND SC1.COLLATERAL_CONTRACT_ID =                 "
                    + "SCR.COLLATERAL_CONTRACT_ID)     "
                    + "OR sc.date_from IS NULL)   AND EXISTS          "
                    + " (SELECT *        FROM si_loan_contract            "
                    + "WHERE commitment_no = slc.contract_id)     "
                    + "  AND slc.commitment_no IS NULL "
                    + "UNION ALL "
                    + "SELECT SLC.CONTRACT_ID \"LD\",    "
                    + "slc.customer_id \"ID\",   "
                    + " SLC.FILIAL_CODE \"Filial\",  "
                    + "SLC.PRODUCT_ID \"Məhsul\",  "
                    + "spn.name_short_az \"Müştəri\",    "
                    + "TO_CHAR (slc.VALUE_DATE, 'DD-MM-YYYY') \"Verilmə tarixi\",    "
                    + "TO_CHAR (SLC.MATURITY_DATE, 'DD-MM-YYYY') \"Bitmə tarixi\",  "
                    + "SLC.CURRENCY_ID \"Valyuta\",  "
                    + "SLPD.PENALTY_RATE \"Faiz dərəcəsi\", "
                    + "SLC.ORIG_AMOUNT \"Verilmiş məbləğ\",     "
                    + "SLB.DEBT_TOTAL \"Qalıq (ekv)\",  "
                    + "SLPD.PAST_DUE_PR_AMOUNT \"Gecikməyə cıxan borc\",   "
                    + "    SLPD.PAST_DUE_INT_AMOUNT - SLB.ARREARS_B_PAST_DUE \"Gecikməyə çıxan faiz\",   "
                    + "    SLB.ARREARS_B_PAST_DUE \"Hesablanmış cərimə\",   "
                    + "    TO_CHAR (SLPD.PAST_DUE_START_DATE, 'DD-MM-YYYY') \"Gecikmənin tarixi\",  "
                    + "     TO_CHAR (SLC.DATE_UNTIL+1, 'DD-MM-YYYY') \"Gecikmədən çıxma tarixi\", "
                    + "      (SELECT SUM (tr_amount_fcy_dt)    "
                    + "      FROM si_transaction_account_un        "
                    + " WHERE transaction_type IN ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9')  "
                    + "         AND number_doc = SLC.CONTRACT_ID        "
                    + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                    + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy'))         \"Cəmi ödənilən məbləğ\",    "
                    + "      NVL ( to_char( get_collateral_name(slc.contract_id)),' ')  \"Təminat\",    "
                    + "      NVL ( to_char( (SELECT sum(nominal_value) FROM si_collateral sc1  "
                    + "WHERE collateral_contract_id IN (SELECT collateral_contract_id   "
                    + "      FROM si_collateral_right scr1   "
                    + "  WHERE scr1.contract_id = slc.contract_id and scr1.date_until='01-jan-3000')"
                    + " and sc1.date_until='01-jan-3000')),' ')  \"Təminatın dəyəri\",    "
                    + "     SLC.RISK_GROUP || '/' || slc.risk_group_interest \"Ehtiyat qrupu\",  "
                    + "     SLC.PROBLEM_DEPARTMENT \"Status\",   "
                    + "    SLC.FILIAL_CODE \"Dao\",    "
                    + "   NVL (TO_CHAR (SLC.PARTNER), ' ') \"Partner\", "
                    + "      GREATEST (slpd.past_due_pr_days, slpd.past_due_int_days)  \"Günlərin sayı\"  "
                    + "FROM si_loan_contract slc,     "
                    + "  si_person_natural spn,   "
                    + "    si_loan_balance slb,    "
                    + "   si_loan_past_due slpd WHERE       "
                    + "    SLB.CONTRACT_ID = SLC.CONTRACT_ID  "
                    + "     AND spn.customer_id = slc.customer_id   "
                    + "    AND SLC.CONTRACT_ID = SLPD.CONTRACT_ID(+)   "
                    + "    AND spn.DATE_UNTIL = '01-jan-3000'    "
                    + "   AND slc.DATE_FROM >= TO_DATE ('" + DateB + "', 'dd.MM.yyyy')   "
                    + "    AND SLC.DATE_FROM <= TO_DATE ('" + DateE + "', 'dd.MM.yyyy')   "
                    + "    AND slb.DATE_FROM >= TO_DATE ('" + DateB + "', 'dd.MM.yyyy')  "
                    + "     AND SLb.DATE_FROM <= TO_DATE ('" + DateE + "', 'dd.MM.yyyy')  "
                    + "     AND SLC.OTHER_OFFICER <> 1    "
                    + "   AND SLC.problem_department <> '0'    "
                    + "   AND 0 =   "
                    + "    (SELECT NVL (   (SELECT SLC2.problem_department   "
                    + " FROM si_loan_contract slc2      WHERE SLC2.CONTRACT_ID = SLC.CONTRACT_ID  "
                    + " AND slc2.date_from =  (SELECT MIN (SLc3.date_from)    "
                    + "   FROM si_loan_contract slc3    WHERE SLc2.CONTRACT_ID =   SLc3.CONTRACT_ID     "
                    + "     AND SLc3.date_from >    slc.date_from  "
                    + "  AND SLC3.DATE_FROM <=     TO_DATE ('" + DateE + "', 'dd.MM.yyyy'))),  "
                    + "                       10)                 FROM DUAL)    "
                    + "   AND slb.date_from =           "
                    + "   (SELECT MAX (date_from)           "
                    + "      FROM si_loan_balance slb1         "
                    + "       WHERE slb1.date_from <= Slc.DATE_UNTIL   "
                    + "                   AND Slb1.CONTRACT_ID = Slc.CONTRACT_ID)  "
                    + "     AND (SLPD.ACT_DATE =  (SELECT MAX (ACT_DATE)  "
                    + "                FROM si_loan_past_due slpd1    "
                    + "    WHERE SLPD1.CONTRACT_ID = SLC.CONTRACT_ID  "
                    + "           AND slpd1.act_date <= slc.date_UNTIL)   "
                    + "    OR SLPD.ACT_DATE IS NULL)       AND NOT EXISTS  "
                    + "      (SELECT *   FROM si_loan_contract "
                    + "    WHERE commitment_no = slc.contract_id) AND slc.commitment_no IS NULL";
             System.out.println(SQLText);
            Connection conn = db.connect();
            Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SQLText);

        %>
        <table border="0" width="2700" > <tr> <td>
                    <table cellpadding="0" cellspacing="0" border="0"  id="example" width="100%" >
                        <thead>
                            <tr width=350 height=20>
                                <%
                                    int count = sqlres.getMetaData().getColumnCount();

                                    for (int i = 1; i <= count; i++) {
                                        out.println("<th >" + sqlres.getMetaData().getColumnName(i) + "</th>");
                                    };
                                %>

                            </tr>
                        </thead>
                        <tbody>

                            <%
                                while (sqlres.next()) {
                                    out.println("<tr align='center' >");
                                    out.println("<td width=150>" + sqlres.getString(1) + "</td>");  //tarix                                  
                                    out.println("<td width=80>" + sqlres.getString(2) + "</td>");                 //dhesab
                                    out.println("<td width=350>" + sqlres.getString(3) + "</td>");                  //dval
                                    out.println("<td width=50>" + sqlres.getString(4) + "</td>");                //dbal
                                    out.println("<td width=350 align='center'>" + sqlres.getString(5) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(6) + "</td>");
                                    out.println("<td width=150 align='center'>" + sqlres.getString(7) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(8) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(9) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(10) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getDouble(11) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getDouble(12) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getDouble(13) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getDouble(14) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(15) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(16) + "</td>");
                                    out.println("<td width=200 align='center'>" + sqlres.getDouble(17) + "</td>");
                                    out.println("<td  align='center'>" + sqlres.getString(18) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(19) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(20) + "</td>");
                                    out.println("<td width=30 align='center'>" + sqlres.getString(21) + "</td>");
                                    out.println("<td width=120 align='center'>" + sqlres.getString(22) + "</td>");
                                    out.println("<td width=100 align='center'>" + sqlres.getString(23) + "</td>");
                                    out.println("<td width=100 align='center'>" + sqlres.getString(24) + "</td>");

                                    //kredit

                                    out.println("</tr>");
                                };
                            %>
                        </tbody>
                        <tfoot>
                            <tr>
                                <%

                                    for (int i = 1; i <= count; i++) {
                                        out.println("<th>" + sqlres.getMetaData().getColumnName(i) + "</th>");
                                    };

                                %>
                            </tr>

                        </tfoot>
                    </table> </td>
                <td valign="top">
                    <form method="post" action="BlackListExcel" name="excel" >
                        <input type="image" src="images/Office-excel-xls-icon.png" name="go" >

                        <input type="hidden" name="DateB" value="<%=DateB%>">
                        <input type="hidden" name="DateE" value="<%=DateE%>">
                        <input type="hidden" name="status" value="<%=status%>">

                    </form>
                </td></tr>
        </table>
        <table  border='0' width="100%" cellspacing="1" >

            <tr>
                <td align="right"  >
                    <p>
                        <%
                            out.println(dict.ftSign());
                            sqlres.close();
                            stmt.close();
                            conn.close();

                        %>
                    </p>
                </td></tr>
        </table>
    </body>
</html>
