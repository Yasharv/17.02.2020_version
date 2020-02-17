/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.text.ParseException;
import java.util.Date;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import java.lang.IllegalArgumentException;
import java.util.Locale;

/**
 *
 * @author emin.mustafayev
 */
@WebServlet(name = "BlackListPcExcel", urlPatterns = {"/BlackListPcExcel"})
public class BlackListPcExcel extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @SuppressWarnings("empty-statement")
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, ParseException {

        response.setHeader("Content-Disposition", "attachment;filename=BlackList.xlsx");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8");
        OutputStream os = response.getOutputStream();
        DB connt = new DB();
        Connection conn = connt.connect();
        Statement stmt = null;
        ResultSet sqlSel = null;
        SXSSFWorkbook workbook = null;
        try {
            try {
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
                // System.out.println("excel status "+status);
                if (status.equals("0")) {
                    //System.out.println("userin id-si " + RepUser);

                    intext = "";
                } else {
                    //  System.out.println("userin id-si " + RepUser);
                    intext = "  and SLC.problem_department = '" + status + "' ";
                }

                String intext_real = "";

                String status_real = request.getParameter("status_real");
                // System.out.println("excel status "+status);
                if (status_real.equals("0")) {
                    //System.out.println("userin id-si " + RepUser);

                    intext_real = "";
                } else {
                    //  System.out.println("userin id-si " + RepUser);
                    intext_real = "  and SLC.problem_department_real = '" + status_real + "' ";
                }

                String custid = request.getParameter("custid");
                String custidSQL = "";
                if ((request.getParameter("custid") != null) & (request.getParameter("custid") != "") & (!(request.getParameter("custid").trim().equals("")))) {
                    custidSQL = " and slc.customer_id=" + custid;
                }
                String contract_id = request.getParameter("contract_id");
                String contract_idSQL = "";
                if ((request.getParameter("contract_id") != null) & (request.getParameter("contract_id") != "") & (!(request.getParameter("contract_id").trim().equals("")))) {
                    contract_id = contract_id.replace(",", "','");
                    contract_idSQL = " and slc.contract_id in ('" + contract_id + "')";
                }

                String Filial = request.getParameter("Filial");

                String PROBLEM_DEPARTMENT_USER = request.getParameter("PROBLEM_DEPARTMENT_USER");
                String PROBLEM_DEPARTMENT_USERSQL = "";
                if ((request.getParameter("PROBLEM_DEPARTMENT_USER") != null) & (request.getParameter("PROBLEM_DEPARTMENT_USER") != "") & (!(request.getParameter("PROBLEM_DEPARTMENT_USER").trim().equals("")))) {
                    PROBLEM_DEPARTMENT_USER = PROBLEM_DEPARTMENT_USER.replace(",", "','");
                    PROBLEM_DEPARTMENT_USERSQL = " and slc.PROBLEM_DEPARTMENT_USER in ('" + PROBLEM_DEPARTMENT_USER + "')";
                }

                String product_id = request.getParameter("product_id");
                String prodSql = "";
                if (Integer.parseInt(request.getParameter("product_id")) != 0) {
                    prodSql = " and slc.product_id=" + product_id;
                }

                String other_officer = request.getParameter("other_officer");
                String other_officerSQL = "";
                if ((request.getParameter("other_officer") != null) & (request.getParameter("other_officer") != "") & (!(request.getParameter("other_officer").trim().equals("")))) {
                    other_officer = other_officer.replace(",", "','");
                    other_officerSQL = " and slc.other_officer in ('" + other_officer + "')";
                }

                String SqlQuery = " SELECT SLC.CONTRACT_ID \"PC\",    "
                        + "  slc.customer_id \"ID\",   "
                        + " br.GB_DESCRIPTION  \"Filial\",  "
                        + "   SLC.PRODUCT_ID \"Məhsul\",  "
                        + "  spn.name_short_az \"Müştəri\",    "
                        + " TO_CHAR (slc.VALUE_DATE, 'DD-MM-YYYY') \"Verilmə tarixi\",    "
                        + "  TO_CHAR (SLC.MATURITY_DATE, 'DD-MM-YYYY') \"Bitmə tarixi\",  "
                        + "     CR.NAME_CURRENCY  \"Valyuta\",  "
                        + "     SLPD.PENALTY_RATE/2 || ' / ' ||  SLPD.PENALTY_RATE  \"Faiz dərəcəsi\", "
                        + "      SLC.ORIG_AMOUNT \"Verilmiş məbləğ\",     "
                        + " SLB.DEBT_STANDARD_LCY + SLB.DEBT_PAST_DUE_LCy \"Qalıq (ekv)\",  "
                        + "  SLPD.PAST_DUE_PR_AMOUNT \"Gecikməyə cıxan borc\",   "
                        + "    SLPD.PAST_DUE_INT_AMOUNT - SLB.ARREARS_B_PAST_DUE \"Gecikməyə çıxan faiz\",   "
                        + "    SLB.ARREARS_B_PAST_DUE \"Hesablanmış cərimə\",   "
                        + "    TO_CHAR (SLPD.PAST_DUE_START_DATE, 'DD-MM-YYYY') \"Gecikmənin tarixi\",  "
                        + "     TO_CHAR (SLC.DATE_UNTIL+1, 'DD-MM-YYYY') \"Gecikmədən çıxma tarixi\", "
                        + "  TR_ALL.AMOUNT_ALL   \"Cəmi ödənilən məbləğ\",    "
                        + "     TR_KR5.AMOUNT_KR5        \"Əsas borcdan ödənilib\",    "
                        + "     TR_KR6.AMOUNT_KR6          \"Gec əsas borcdan ödənilib\",    "
                        + "      TR_KR7.AMOUNT_KR7        \" Adi faiz ödənilib \",    "
                        + "       TR_KR9.AMOUNT_KR9         \" Gecikmiş faiz ödənilib \",    "
                        + "    TR_KR8.AMOUNT_KR8       \" Cərimə ödənilib \",    "
                        + "       to_nchar( get_collateral_name(slc.contract_id))  \"Təminat\",    "
                        + "      sc.nominal_value  \"Təminatın dəyəri\",    "
                        + "     SLC.RISK_GROUP || '/' || slc.risk_group_interest \"Ehtiyat qrupu\",  "
                        + "     SLC.PROBLEM_DEPARTMENT \"Öd qabaqkı status\",   "
                        + "     SLC.other_officer \"Cəlb edən\",    "
                        + "   NVL (TO_CHAR (SLC.PARTNER), '') \"Partnyor\", "
                        + "      GREATEST (slpd.past_due_pr_days, slpd.past_due_int_days)  \"Gec günlərin sayı\" , "
                        + "( SELECT  count(distinct PAST_DUE_START_DATE) PAST_DUE_START_DATE "
                        + "   from   si_PC_loan_past_due"
                        + " where   contract_id = slc.contract_id"
                        + "  AND ACT_DATE between TO_DATE ('" + DateB + "', 'dd.MM.yyyy') and   TO_DATE ('" + DateE + "', 'dd.MM.yyyy') "
                        + " )   \"Ümumi gec sayı\"  ,"
                        + "  slc.problem_department_real  \"Real Status\"  ,  "
                        + "  slc.portf_sort  \" İdarə edən  \"    "
                        + "   FROM si_PC_loan_contract slc,     "
                        + "  si_person_natural spn,   "
                        + "    si_PC_loan_balance slb,    "
                        + "   si_PC_loan_past_due slpd, ST_XF_DWH.DI_BRANCH br, DI_CURRENCY_INFO cr,"
                        + "   (select min(PAST_DUE_START_DATE) PAST_DUE_START_DATE, contract_id  from   si_PC_loan_past_due   group by contract_id)  slpd1 , "
                        + "           (SELECT SUM (a.nominal_value)  nominal_value,  contract_id    "
                        + " FROM si_collateral  a, si_collateral_right   b    where a.date_until = '01-jan-3000' "
                        + " and b.date_until = '01-jan-3000'  and  a.collateral_contract_id  = b.collateral_contract_id  "
                        + "   group by  b.contract_id )  sc,"
                        + "      (SELECT SUM (tr_amount_fcy_dt) AMOUNT_ALL , NUMBER_DOC   "
                        + "      FROM si_transaction_account_un        "
                        + " WHERE transaction_type IN ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9')  "
                        + "               "
                        + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                        + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')"
                        + "    and NUMBER_DOC like ('PC%')  GROUP BY NUMBER_DOC )  TR_ALL ,  "
                        + "      (SELECT SUM (tr_amount_fcy_dt) AMOUNT_KR5 , NUMBER_DOC   "
                        + "      FROM si_transaction_account_un        "
                        + "   WHERE transaction_type ='KR-5'  "
                        + "               "
                        + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                        + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')"
                        + "    and NUMBER_DOC like ('PC%')  GROUP BY NUMBER_DOC )  TR_KR5,   "
                        + "      (SELECT SUM (tr_amount_fcy_dt) AMOUNT_KR6 , NUMBER_DOC   "
                        + "      FROM si_transaction_account_un        "
                        + "   WHERE transaction_type ='KR-6'  "
                        + "               "
                        + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                        + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')"
                        + "    and NUMBER_DOC like ('PC%')  GROUP BY NUMBER_DOC )  TR_KR6 ,  "
                        + "      (SELECT SUM (tr_amount_fcy_dt) AMOUNT_KR7 , NUMBER_DOC   "
                        + "      FROM si_transaction_account_un        "
                        + "   WHERE GL_ACCT_NO_DT  IN (21072,21077,21082,21087)"
                        + "               "
                        + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                        + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')"
                        + "    and NUMBER_DOC like ('PC%')  GROUP BY NUMBER_DOC )  TR_KR7 ,  "
                        + "      (SELECT SUM (tr_amount_fcy_dt) AMOUNT_KR8, NUMBER_DOC   "
                        + "      FROM si_transaction_account_un        "
                        + "   WHERE GL_ACCT_NO_DT IN (21074,21084, 21079, 21089)  "
                        + "  AND  GL_ACCT_NO_CR ='64710'   "
                        + "               "
                        + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                        + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')"
                        + "    and NUMBER_DOC like ('PC%')  GROUP BY NUMBER_DOC )  TR_KR8,    "
                        + "      (SELECT SUM (tr_amount_fcy_dt) AMOUNT_KR9, NUMBER_DOC   "
                        + "      FROM si_transaction_account_un        "
                        + "   WHERE GL_ACCT_NO_DT IN (21074,21084, 21079, 21089)  "
                        + "  AND  GL_ACCT_NO_CR <>'64710'   "
                        + "               "
                        + "     AND act_date BETWEEN TO_DATE ('" + DateB + "', 'dd.MM.yyyy') "
                        + "     AND TO_DATE ('" + DateE + "', 'dd.MM.yyyy')"
                        + "    and NUMBER_DOC like ('PC%')  GROUP BY NUMBER_DOC )  TR_KR9    "
                        + " WHERE   TR_ALL.number_doc = SLPD.CONTRACT_ID  AND TR_KR5.number_doc(+) =  TR_ALL.number_doc "
                        + " and  sc.contract_id(+) = slpd.contract_id    and slpd1.contract_id = slpd.contract_id "
                        + " AND TR_KR6.number_doc(+) =  TR_ALL.number_doc  AND TR_KR7.number_doc(+) =  TR_ALL.number_doc  "
                        + "  AND TR_KR8.number_doc(+) =  TR_ALL.number_doc AND TR_KR9.number_doc(+) =  TR_ALL.number_doc  AND   "
                        + "    SLB.CONTRACT_ID = SLC.CONTRACT_ID and br.branch_id =slc.FILIAL_CODE and br.date_until = '01-jan-3000' "
                        + " and CR.NUMERIC_CCY_CODE = SLC.CURRENCY_ID AND CR.DATE_UNTIL = '01-JAN-3000' "
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
                        + " FROM si_PC_loan_contract slc2      WHERE SLC2.CONTRACT_ID = SLC.CONTRACT_ID  "
                        + " AND slc2.date_from =  (SELECT MIN (SLc3.date_from)    "
                        + "   FROM si_PC_loan_contract slc3    WHERE SLc2.CONTRACT_ID =   SLc3.CONTRACT_ID     "
                        + "     AND SLc3.date_from >    slc.date_from  "
                        + "  AND SLC3.DATE_FROM <=     TO_DATE ('" + DateE + "', 'dd.MM.yyyy'))),  "
                        + "                       10)                 FROM DUAL)    "
                        + "   AND slb.date_from =           "
                        + "   (SELECT MAX (date_from)           "
                        + "      FROM si_PC_loan_balance slb1         "
                        + "       WHERE slb1.date_from <= Slc.DATE_UNTIL   "
                        + "                   AND Slb1.CONTRACT_ID = Slc.CONTRACT_ID)  "
                        + "     AND (SLPD.ACT_DATE =  (SELECT MAX (ACT_DATE)  "
                        + "                FROM si_PC_loan_past_due slpd1    "
                        + "    WHERE SLPD1.CONTRACT_ID = SLC.CONTRACT_ID  "
                        + "           AND slpd1.act_date <= slc.date_UNTIL)   "
                        + "    OR SLPD.ACT_DATE IS NULL)      "
                        + "  AND slc.filial_code LIKE ('%" + Filial + "%')  "
                        + "  " + custidSQL + "  " + contract_idSQL + " " + PROBLEM_DEPARTMENT_USERSQL + "  " + intext + "  " + intext_real + "  " + prodSql + " " + other_officerSQL + " ";
                //    System.out.println("  SqlQuery " + SqlQuery);

                DecimalFormat df = new DecimalFormat("0.00");

                stmt = conn.createStatement();
                sqlSel = stmt.executeQuery(SqlQuery);
                // System.out.println(SqlQuery);

                workbook = new SXSSFWorkbook();
                SXSSFSheet sheet = (SXSSFSheet) workbook.createSheet("Sheet1");

                int count = sqlSel.getMetaData().getColumnCount();

                Row row = sheet.createRow(0);
                Cell cell = row.createCell(1);
                for (int i = 1; i <= count; i++) {

                    cell = row.createCell(i);
                    cell.setCellValue(sqlSel.getMetaData().getColumnName(i));
                    // System.out.println(sqlSel.getMetaData().getColumnName(i));
                    //    CellStyle cellStyle = workbook.createCellStyle();
                    CellStyle cellStyle = workbook.createCellStyle();

                    CreationHelper createHelper = workbook.getCreationHelper();
                    cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));
                }

                int j = 1;

                while (sqlSel.next()) {
                    row = sheet.createRow(j);
                    //  System.out.println("j = " + j);
                    for (int i = 1; i <= count; i++) {

                        cell = row.createCell(i);
                        //   cell.setCellValue(sqlSel.getString(i));
                        switch (i) {
                            case 10:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 11:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            case 12:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 13:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 14:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 17:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 18:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 19:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 20:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 21:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 22:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            case 24:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getDouble(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 26:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            case 27:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            case 28:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 29:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            case 30:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;
                            case 32:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            case 33:
                                if (sqlSel.getObject(i) != null) {
                                    cell.setCellValue(sqlSel.getInt(i));
                                } else {
                                    cell.setCellValue(sqlSel.getString(i));
                                }
                                break;

                            default:
                                cell.setCellValue(sqlSel.getString(i));
                        }
                    }
                    j++;
                }
                row = sheet.createRow(j + 1);

                cell = row.createCell(0);
                int Index = cell.getColumnIndex();
                int i;

                for (i = 0; i <= Index; i++) {
                    sheet.autoSizeColumn(i);
                }

                workbook.write(os);

            } catch (SQLException ex) {
                Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalArgumentException ex) {
                Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
            }

        } finally {

            try {
                workbook.dispose();
                if (sqlSel != null) {
                    sqlSel.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (IllegalArgumentException ex) {
                Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
            }

            os.flush();
            os.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
