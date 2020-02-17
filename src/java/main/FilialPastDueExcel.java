/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

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
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "FilialPastDueExcel", urlPatterns = {"/FilialPastDueExcel"})
public class FilialPastDueExcel extends HttpServlet {

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
            throws ServletException, IOException, ClassNotFoundException, SQLException, ParseException {

        response.setHeader("Content-Disposition", "attachment;filename=Past.xls");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8");
        OutputStream os = response.getOutputStream();
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet();

        HSSFCellStyle style1 = workbook.createCellStyle();
        HSSFCellStyle style2 = workbook.createCellStyle();
        style2.setFillForegroundColor(new HSSFColor.YELLOW().getIndex());
        style2.setFillPattern(CellStyle.ALIGN_FILL);
        style2.setFillBackgroundColor(new HSSFColor.YELLOW().getIndex());
        HSSFCellStyle style = workbook.createCellStyle();
        HSSFFont font = workbook.createFont();
        font.setColor(new HSSFColor.BLACK().getIndex());
        font.setFontName(HSSFFont.FONT_ARIAL);
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        style.setFont(font);
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        HSSFFont font1 = workbook.createFont();
        font1.setColor(HSSFFont.COLOR_RED);

        style1.setFont(font1);

        HSSFCellStyle style3 = workbook.createCellStyle();
        style3.setFillForegroundColor(new HSSFColor.ORANGE().getIndex());
        style3.setFillPattern(CellStyle.ALIGN_FILL);
        style3.setFillBackgroundColor(new HSSFColor.ORANGE().getIndex());

        ResultSet rs = null;
        Statement stmt = null;
        DB db = new DB();
        Connection conn = null;

        try {

            String Filial = request.getParameter("Filial");
            if (Filial.equals("0")) {
                Filial = " 100,101,102,103,104,105,106,107,108,109,200,201,202,203,204,300,301,500,600,800,900 ";

            }
            //     System.out.println("Filial  " +  Filial);

            String Tarix = request.getParameter("Tarix");
            //     System.out.println("Tarix  " +  Tarix);
            conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");
            int ay;
            int[] n = new int[20];
            Double[] m = new Double[20];

            int ay2;
            int[] n1_ = new int[20];
            Double[] m1_ = new Double[20];

            int ay3;
            int[] n2_ = new int[20];
            Double[] m2_ = new Double[20];

            int[] res30 = new int[20];
            Double[] res30_m = new Double[20];
            int[] res31 = new int[20];
            Double[] res31_m = new Double[20];
            int[] res90 = new int[20];
            Double[] res90_m = new Double[20];

            int[] mh = new int[20];
            Double[] mh_m = new Double[20];
            int[] mhh = new int[20];
            Double[] mh_mm = new Double[20];
            int[] x = new int[20];
            Double[] xm = new Double[20];
            int[] xx = new int[20];
            Double[] xmm = new Double[20];
            int[] xe = new int[20];
            Double[] xme = new Double[20];
            int[] xf = new int[20];
            Double[] xmf = new Double[20];

            int[] dd = new int[20];
            Double[] dm = new Double[20];
            int[] d1d = new int[20];
            Double[] d1m = new Double[20];
            int[] d2d = new int[20];
            Double[] d2m = new Double[20];

            int ay1;

            String[] say = new String[20];
            String[] say1_ = new String[20];
            String[] s = new String[20];
            String[] s1_ = new String[20];
            String[] y = new String[20];
            String[] y1_ = new String[20];
            String[] sa = new String[20];
            String[] a = new String[20];
            String[] m0_ = new String[20];
            String[] mm1_ = new String[20];
            String[] mm2_ = new String[20];
            String[] mm3_ = new String[20];
            String[] mm4_ = new String[20];
            String[] mm5_ = new String[20];
            String[] mm6_ = new String[20];
            String[] mm7_ = new String[20];

            for (int i = 1; i <= 12; i++) {
                ay = i;
                ay1 = i;
                ay2 = i;
                ay3 = i;
                String odenilmish = " SELECT COUNT (DISTINCT A.contract_id),  sum(tr.TR_AMOUNT_LCY_CR)  FROM (  SELECT DISTINCT * FROM (     SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE   TO_DATE(PAST.PAST_DUE_START_DATE  , 'DD-MM-YYYY')  <   to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY') "
                        + " and  TO_DATE(PAST.act_DATE )   =     to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY') "
                        + "  and   PAST.act_DATE    <  to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY') )     <= 30   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY')  and   PAST.act_DATE   =    to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY')and "
                        + "  PAST.act_DATE    =     to_date('1-" + ay + "-" + Tarix + "', 'DD-MM-YYYY')-1      )  <= 30 )   "
                        + "      union  SELECT DISTINCT * FROM ( SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay + "-" + Tarix + "'    "
                        + "  ) <=    30"
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay + "-" + Tarix + "'    "
                        + "  ) < =   30  )   )  A, SI_TRANSACTION_ACCOUNT_UN  TR  WHERE  TR.NUMBER_DOC = A.CONTRACT_ID   AND "
                        + "  EXTRACT(MONTH FROM TR.ACT_DATE) ||'-' || EXTRACT(YEAR FROM TR.ACT_DATE) = '1-2015'   "
                        + " AND TR.TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )   ";
                //     System.out.println("odenilmish   " + odenilmish);

                Statement stmt1 = conn.createStatement();
                ResultSet rs1 = stmt1.executeQuery(odenilmish);
                rs1.next();
                n[i] = rs1.getInt(1);
                m[i] = rs1.getDouble(2);
                if (m[i].isNaN()) {
                    m[i] = 0.0;
                }

                String odenilmish_31_90 = " SELECT COUNT (DISTINCT A.contract_id),  sum(tr.TR_AMOUNT_LCY_CR)  FROM (  SELECT DISTINCT * FROM (     SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE   TO_DATE(PAST.PAST_DUE_START_DATE  , 'DD-MM-YYYY')  <   to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY') "
                        + " and  TO_DATE(PAST.act_DATE )   =     to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY') "
                        + "  and   PAST.act_DATE    <  to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY') )    "
                        + " between  31 and 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY')  and   PAST.act_DATE   =    to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY')and "
                        + "  PAST.act_DATE    =     to_date('1-" + ay2 + "-" + Tarix + "', 'DD-MM-YYYY')-1      )  "
                        + "  between 31 and 90 )   "
                        + "      union  SELECT DISTINCT * FROM ( SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay2 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay2 + "-" + Tarix + "'    "
                        + "  ) between 31 and 90"
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay2 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay2 + "-" + Tarix + "'    "
                        + "  ) between 31 and 90  )   )  A, SI_TRANSACTION_ACCOUNT_UN  TR  WHERE  TR.NUMBER_DOC = A.CONTRACT_ID   AND "
                        + "  EXTRACT(MONTH FROM TR.ACT_DATE) ||'-' || EXTRACT(YEAR FROM TR.ACT_DATE) = '1-2015'   "
                        + " AND TR.TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )   ";
                //     System.out.println("odenilmish_31_90   " + odenilmish_31_90);

                Statement stmt2 = conn.createStatement();
                ResultSet rs2 = stmt2.executeQuery(odenilmish_31_90);
                rs2.next();
                n1_[i] = rs2.getInt(1);
                m1_[i] = rs2.getDouble(2);
                //    if ( n1_[i]==null)  { n1_[i]="0"; }
                if (m1_[i].isNaN()) {
                    m1_[i] = 0.0;
                }

                String odenilmish_90 = " SELECT COUNT (DISTINCT A.contract_id),  sum(tr.TR_AMOUNT_LCY_CR)  FROM (  SELECT DISTINCT * FROM (     SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE   TO_DATE(PAST.PAST_DUE_START_DATE  , 'DD-MM-YYYY')  <   to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY') "
                        + " and  TO_DATE(PAST.act_DATE )   =     to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY') "
                        + "  and   PAST.act_DATE    <  to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY') )    "
                        + " > 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY')  and   PAST.act_DATE   =    to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY')and "
                        + "  PAST.act_DATE    =     to_date('1-" + ay3 + "-" + Tarix + "', 'DD-MM-YYYY')-1      )  "
                        + "  > 90 )   "
                        + "      union  SELECT DISTINCT * FROM ( SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay3 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay3 + "-" + Tarix + "'    "
                        + "  ) > 90"
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay3 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay3 + "-" + Tarix + "'    "
                        + "  ) > 90  )   )  A, SI_TRANSACTION_ACCOUNT_UN  TR  WHERE  TR.NUMBER_DOC = A.CONTRACT_ID   AND "
                        + "  EXTRACT(MONTH FROM TR.ACT_DATE) ||'-' || EXTRACT(YEAR FROM TR.ACT_DATE) = '1-2015'   "
                        + " AND TR.TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )   ";
                //        System.out.println("odenilmish_90   " + odenilmish_90);

                Statement stmt3 = conn.createStatement();
                ResultSet rs3 = stmt3.executeQuery(odenilmish_90);
                rs3.next();
                n2_[i] = rs3.getInt(1);
                m2_[i] = rs3.getDouble(2);
                if (m2_[i].isNaN()) {
                    m2_[i] = 0.0;
                }

                String restruct = "   select "
                        + "  ( select  count(*)     from "
                        + " ( SELECT DISTINCT slc.CONTRACT_ID       FROM si_loan_contract slc, si_loan_past_due slpd "
                        + "  WHERE slc.date_until = '01-jan-3000'  AND EXTRACT (MONTH FROM slc.RESTRUCT_DATE )    "
                        + "  || '-'          || EXTRACT (YEAR FROM slc.RESTRUCT_DATE ) = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   AND slpd.contract_id = slc.contract_id      "
                        + "    AND (SELECT COUNT (*)          FROM si_loan_past_due    WHERE contract_id = slpd.contract_id    ) <= 30 )"
                        + "  )  r_30 ,"
                        + "  nvl  ( (select sum(debt_total_lcy)     from"
                        + " ( select contract_id, Max(debt_total_lcy)  debt_total_lcy  from si_loan_balance "
                        + "   group by contract_id   )         "
                        + "  where contract_id in  "
                        + " ( SELECT DISTINCT slc.CONTRACT_ID       FROM si_loan_contract slc, si_loan_past_due slpd "
                        + "  WHERE slc.date_until = '01-jan-3000'  AND EXTRACT (MONTH FROM slc.RESTRUCT_DATE )    "
                        + "  || '-'          || EXTRACT (YEAR FROM slc.RESTRUCT_DATE ) = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   AND slpd.contract_id = slc.contract_id      "
                        + "    AND (SELECT COUNT (*)          FROM si_loan_past_due    WHERE contract_id = slpd.contract_id) <= 30 )  ) ,0)  mr_30, "
                        + "  ( select  count(*)     from "
                        + " ( SELECT DISTINCT slc.CONTRACT_ID       FROM si_loan_contract slc, si_loan_past_due slpd "
                        + "  WHERE slc.date_until = '01-jan-3000'  AND EXTRACT (MONTH FROM slc.RESTRUCT_DATE )    "
                        + "  || '-'          || EXTRACT (YEAR FROM slc.RESTRUCT_DATE ) = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   AND slpd.contract_id = slc.contract_id      "
                        + "    AND (SELECT COUNT (*)          FROM si_loan_past_due    WHERE contract_id = slpd.contract_id) between 31 and 90 )"
                        + "  )  r_31_90 ,"
                        + "  nvl  ( (select sum(debt_total_lcy)     from"
                        + " ( select contract_id, Max(debt_total_lcy)  debt_total_lcy  from si_loan_balance "
                        + "   group by contract_id   )         "
                        + "  where contract_id in  "
                        + " ( SELECT DISTINCT slc.CONTRACT_ID       FROM si_loan_contract slc, si_loan_past_due slpd "
                        + "  WHERE slc.date_until = '01-jan-3000'  AND EXTRACT (MONTH FROM slc.RESTRUCT_DATE )    "
                        + "  || '-'          || EXTRACT (YEAR FROM slc.RESTRUCT_DATE ) = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   AND slpd.contract_id = slc.contract_id      "
                        + "    AND (SELECT COUNT (*)          FROM si_loan_past_due    WHERE contract_id = slpd.contract_id) between 31 and 90  )  ) ,0)  mr_31_90, "
                        + "  ( select  count(*)     from "
                        + " ( SELECT DISTINCT slc.CONTRACT_ID       FROM si_loan_contract slc, si_loan_past_due slpd "
                        + "  WHERE slc.date_until = '01-jan-3000'  AND EXTRACT (MONTH FROM slc.RESTRUCT_DATE )    "
                        + "  || '-'          || EXTRACT (YEAR FROM slc.RESTRUCT_DATE ) = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   AND slpd.contract_id = slc.contract_id      "
                        + "    AND (SELECT COUNT (*)          FROM si_loan_past_due    WHERE contract_id = slpd.contract_id) >90 )"
                        + "  )  r_90 ,  "
                        + "  nvl  ( (select sum(debt_total_lcy)     from"
                        + " ( select contract_id, Max(debt_total_lcy)  debt_total_lcy  from si_loan_balance "
                        + "   group by contract_id   )         "
                        + "  where contract_id in  "
                        + " ( SELECT DISTINCT slc.CONTRACT_ID       FROM si_loan_contract slc, si_loan_past_due slpd "
                        + "  WHERE slc.date_until = '01-jan-3000'  AND EXTRACT (MONTH FROM slc.RESTRUCT_DATE )    "
                        + "  || '-'          || EXTRACT (YEAR FROM slc.RESTRUCT_DATE ) = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   AND slpd.contract_id = slc.contract_id      "
                        + "    AND (SELECT COUNT (*)          FROM si_loan_past_due    WHERE contract_id = slpd.contract_id) >90 )  ) ,0)  mr_90 "
                        + "   from dual   "
                        + "  ";

                //      System.out.println("restruct   " + restruct);
                Statement stmtRES = conn.createStatement();
                ResultSet rsRES = stmtRES.executeQuery(restruct);

                rsRES.next();

                res30[i] = rsRES.getInt(1);
                res30_m[i] = rsRES.getDouble(2);
                res31[i] = rsRES.getInt(3);
                res31_m[i] = rsRES.getDouble(4);
                res90[i] = rsRES.getInt(5);
                res90_m[i] = rsRES.getDouble(6);

                String mehkeme = " select * from "
                        + " ( select count(*)  from "
                        + " (  select   distinct  slc.CONTRACT_ID from si_loan_contract  slc, si_loan_past_due  slpd  "
                        + "where slc.date_until ='01-jan-3000'  and   slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and  "
                        + " extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "'   and  slc.FILIAL_CODE in ( " + Filial + ") "
                        + " and   slpd.contract_id = slc.contract_id    and (select count(*)  from si_loan_past_due "
                        + " where contract_id = slpd.contract_id)    between 31 and 90    union all select distinct  slc.CONTRACT_ID "
                        + "from si_pc_loan_contract  slc, si_pc_loan_past_due  slpd  where slc.date_until ='01-jan-3000'  and  "
                        + " slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and   extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year "
                        + "from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ")    and   slpd.contract_id = slc.contract_id   and (select count(*)  "
                        + "from si_pc_loan_past_due  where contract_id = slpd.contract_id)    between 31 and 90  ) "
                        + " ) a, "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where      to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   "
                        + "union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  ) "
                        + "  where contract_id in  "
                        + "( select * from (   select   distinct  slc.CONTRACT_ID from si_loan_contract  slc, si_loan_past_due  slpd  "
                        + "where slc.date_until ='01-jan-3000'  and   slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and  "
                        + " extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "' "
                        + " and   slpd.contract_id = slc.contract_id  and  slc.FILIAL_CODE in ( " + Filial + ")    and (select count(*)  from si_loan_past_due "
                        + " where contract_id = slpd.contract_id)    between 31 and 90    union all select distinct  slc.CONTRACT_ID "
                        + "from si_pc_loan_contract  slc, si_pc_loan_past_due  slpd  where slc.date_until ='01-jan-3000'  and  "
                        + " slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and   extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year "
                        + "from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ")   and   slpd.contract_id = slc.contract_id   and (select count(*)  "
                        + "from si_pc_loan_past_due  where contract_id = slpd.contract_id)    between 31 and 90  )"
                        + ") ) m_a ,   "
                        + "( select count(*)  from "
                        + "(  select   distinct  slc.CONTRACT_ID from si_loan_contract  slc, si_loan_past_due  slpd  "
                        + "where slc.date_until ='01-jan-3000'  and   slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and  "
                        + " extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "' "
                        + " and   slpd.contract_id = slc.contract_id  and  slc.FILIAL_CODE in ( " + Filial + ")    and (select count(*)  from si_loan_past_due "
                        + " where contract_id = slpd.contract_id) > 90    union all select distinct  slc.CONTRACT_ID "
                        + "from si_pc_loan_contract  slc, si_pc_loan_past_due  slpd  where slc.date_until ='01-jan-3000'  and  "
                        + " slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and   extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year "
                        + "from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ")   and   slpd.contract_id = slc.contract_id   and (select count(*)  "
                        + "from si_pc_loan_past_due  where contract_id = slpd.contract_id)  > 90  )"
                        + " ) b, "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  ) "
                        + "  where contract_id in  "
                        + "( select * from (   select   distinct  slc.CONTRACT_ID from si_loan_contract  slc, si_loan_past_due  slpd  "
                        + "where slc.date_until ='01-jan-3000'  and   slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and  "
                        + " extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "' "
                        + " and   slpd.contract_id = slc.contract_id    and "
                        + "(select count(*)  from si_loan_past_due "
                        + " where contract_id = slpd.contract_id)    > 90"
                        + "    union all select distinct  slc.CONTRACT_ID "
                        + "from si_pc_loan_contract  slc, si_pc_loan_past_due  slpd  where slc.date_until ='01-jan-3000'  and  "
                        + " slc.PROBLEM_DEPARTMENT_REAL  in (4,5,6) and   extract(month from slc.PROBLEM_DEPARTMENT_DATE) ||'-'|| extract(year "
                        + "from slc.PROBLEM_DEPARTMENT_DATE)  = '" + ay + "-" + Tarix + "'  and  slc.FILIAL_CODE in ( " + Filial + ")  and   slpd.contract_id = slc.contract_id   and (select count(*)  "
                        + "from si_pc_loan_past_due  where contract_id = slpd.contract_id) >90  )"
                        + ") ) m_b , "
                        + " (select count(distinct contract_id) from "
                        + "(select contract_id from si_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")  "
                        + " union all "
                        + "select contract_id from si_pc_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")  "
                        + "   )  where contract_id in "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID    and slc.FILIAL_CODE in ( " + Filial + ")"
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   )  )  c, "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where       to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where      to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  )  "
                        + "  where contract_id in  "
                        + " (select distinct contract_id from "
                        + "(select contract_id from si_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")   "
                        + " union all "
                        + "select contract_id from si_pc_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')   and  FILIAL_CODE in ( " + Filial + ")  ) "
                        + "   where contract_id in "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID    and slc.FILIAL_CODE in ( " + Filial + ")"
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   )  )  )   m_c,"
                        + " ( select count(*)   from "
                        + " (select distinct contract_id from si_loan_contract where date_until = '01-jan-3000' "
                        + "and PROBLEM_DEPARTMENT_REAL in (4,5,6)  and    extract(month from problem_department_date) ||'-'||"
                        + " extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "'  and  FILIAL_CODE in ( " + Filial + ")    union all  select distinct contract_id "
                        + " from si_pc_loan_contract where date_until = '01-jan-3000' and PROBLEM_DEPARTMENT_REAL in (4,5,6)  and "
                        + "   extract(month from problem_department_date) ||'-'|| extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "'"
                        + " and  FILIAL_CODE in ( " + Filial + ")  )"
                        + ") d ,"
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where       to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where      to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  )     "
                        + "  where contract_id in  "
                        + " (select distinct contract_id from si_loan_contract where date_until = '01-jan-3000' "
                        + "and PROBLEM_DEPARTMENT_REAL in (4,5,6)  and    extract(month from problem_department_date) ||'-'||"
                        + " extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "' and  FILIAL_CODE in ( " + Filial + ")     union all  select distinct contract_id "
                        + " from si_pc_loan_contract where date_until = '01-jan-3000' and PROBLEM_DEPARTMENT_REAL in (4,5,6)  and "
                        + "   extract(month from problem_department_date) ||'-'|| extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "'"
                        + "  and  FILIAL_CODE in ( " + Filial + ")  ) "
                        + "   ) m_d,  "
                        + " ( select count(*)   from "
                        + " (select distinct contract_id from si_loan_contract where date_until = '01-jan-3000' "
                        + "and PROBLEM_DEPARTMENT_REAL  ='6'  and    extract(month from problem_department_date) ||'-'||"
                        + " extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "'  and  FILIAL_CODE in ( " + Filial + ")    union all  select distinct contract_id "
                        + " from si_pc_loan_contract where date_until = '01-jan-3000' and PROBLEM_DEPARTMENT_REAL  ='6'  and "
                        + "   extract(month from problem_department_date) ||'-'|| extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "'"
                        + " and  FILIAL_CODE in ( " + Filial + ")  )"
                        + ") e ,"
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where       to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where      to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  )     "
                        + "  where contract_id in  "
                        + " (select distinct contract_id from si_loan_contract where date_until = '01-jan-3000' "
                        + "and PROBLEM_DEPARTMENT_REAL ='6' and    extract(month from problem_department_date) ||'-'||"
                        + " extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "' and  FILIAL_CODE in ( " + Filial + ")     union all  select distinct contract_id "
                        + " from si_pc_loan_contract where date_until = '01-jan-3000' and PROBLEM_DEPARTMENT_REAL ='6'  and "
                        + "   extract(month from problem_department_date) ||'-'|| extract(year from problem_department_date)   = '" + ay + "-" + Tarix + "'"
                        + "  and  FILIAL_CODE in ( " + Filial + ")  ) "
                        + "   ) m_e ,  "
                        + "  ( select count (distinct  c.contract_id)  from  ( select * from si_transaction_account_un where  "
                        + "   extract(month from act_DATE) ||'-'|| extract(year from act_DATE) ="
                        + "   '" + ay + "-" + Tarix + "'  "
                        + " ) b ,"
                        + " (select * from    (select contract_id from si_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")  "
                        + " union all "
                        + "select contract_id from si_pc_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")  "
                        + "   )  where contract_id in "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID    and slc.FILIAL_CODE in ( " + Filial + ")"
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   )  )  c  where b.number_doc = c.contract_id  )  f ,"
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where       to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where      to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  )     "
                        + "  where contract_id in  "
                        + "  ( select  distinct  c.contract_id  from  ( select * from si_transaction_account_un where  "
                        + "   extract(month from act_DATE) ||'-'|| extract(year from act_DATE) ="
                        + "   '" + ay + "-" + Tarix + "'  "
                        + " ) b ,"
                        + " (select * from    (select contract_id from si_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")  "
                        + " union all "
                        + "select contract_id from si_pc_loan_contract where date_until = '01-jan-3000'"
                        + "  and problem_department_real in (4,5,6) and  problem_department_date   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') and  FILIAL_CODE in ( " + Filial + ")  "
                        + "   )  where contract_id in "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE   "
                        + " <  to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID    and slc.FILIAL_CODE in ( " + Filial + ")"
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =     to_date('1-" + ay + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "   )  )  c  where b.number_doc = c.contract_id  ) ) m_f "
                        + "  ";

                //   System.out.println("mehkeme " + mehkeme);
                Statement stmt11 = conn.createStatement();
                ResultSet rs11 = stmt11.executeQuery(mehkeme);

                rs11.next();

                mh[i] = rs11.getInt(1);

                mh_m[i] = rs11.getDouble(2);
                if (mh_m[i].isNaN()) {
                    mh_m[i] = 0.0;
                }
                mhh[i] = rs11.getInt(3);

                mh_mm[i] = rs11.getDouble(4);
                if (mh_mm[i].isNaN()) {
                    mh_mm[i] = 0.0;
                }
                x[i] = rs11.getInt(5);

                xm[i] = rs11.getDouble(6);
                if (xm[i].isNaN()) {
                    xm[i] = 0.0;
                }
                xx[i] = rs11.getInt(7);

                xmm[i] = rs11.getDouble(8);
                if (xmm[i].isNaN()) {
                    xmm[i] = 0.0;
                }
                xe[i] = rs11.getInt(9);

                xme[i] = rs11.getDouble(10);
                if (xme[i].isNaN()) {
                    xme[i] = 0.0;
                }
                xf[i] = rs11.getInt(11);

                xmf[i] = rs11.getDouble(12);
                if (xmf[i].isNaN()) {
                    xmf[i] = 0.0;
                }

                String odenish = " select * from "
                        + "(   select count( distinct SI.CONTRACT_ID) from  ( select tr.number_doc  from si_transaction_account_un  TR "
                        + "where  extract(month from act_date)||'-'|| extract(year from act_date)  ='1-2015' "
                        + "and transaction_type in ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9') )  tr1, "
                        + "(select a.* from (select distinct slc.contract_id  from si_loan_past_due  slpd, si_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   and extract(month from slpd.act_date)||'-'||"
                        + " extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ") )   a "
                        + "  where (select   count(*)  from si_loan_past_due  "
                        + "where extract(month from act_date)||'-'|| extract(year from act_date)  = '" + ay + "-" + Tarix + "' "
                        + "  and contract_id = a.contract_id )  <30 "
                        + "union all select a.* from (select distinct slc.contract_id  from si_pc_loan_past_due  slpd, si_pc_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   "
                        + "and extract(month from slpd.act_date)||'-'|| extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' "
                        + " and slc.FILIAL_CODE in ( " + Filial + ") )   a   "
                        + "where (select   count(*)  from si_pc_loan_past_due  where extract(month from act_date)||'-'|| "
                        + "extract(year from act_date)  = '" + ay + "-" + Tarix + "'   and contract_id = a.contract_id "
                        + "    )  <30)  SI  where  TR1.number_doc =SI.CONTRACT_ID) a, "
                        + "(   select sum(  tr1.TR_AMOUNT_FCY_CR) from  ( select tr.number_doc, tr.TR_AMOUNT_FCY_CR  from si_transaction_account_un  TR "
                        + "where  extract(month from act_date)||'-'|| extract(year from act_date)  ='1-2015' "
                        + "and transaction_type in ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9') )  tr1, "
                        + "(select a.* from (select distinct slc.contract_id  from si_loan_past_due  slpd, si_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   and extract(month from slpd.act_date)||'-'||"
                        + " extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ") )   a "
                        + "  where (select   count(*)  from si_loan_past_due  "
                        + "where extract(month from act_date)||'-'|| extract(year from act_date)  = '" + ay + "-" + Tarix + "' "
                        + "  and contract_id = a.contract_id )  <30 "
                        + "union all select a.* from (select distinct slc.contract_id  from si_pc_loan_past_due  slpd, si_pc_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   "
                        + "and extract(month from slpd.act_date)||'-'|| extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' "
                        + " and slc.FILIAL_CODE in ( " + Filial + ") )   a   "
                        + "where (select   count(*)  from si_pc_loan_past_due  where extract(month from act_date)||'-'|| "
                        + "extract(year from act_date)  = '" + ay + "-" + Tarix + "'   and contract_id = a.contract_id "
                        + "    )  <30)  SI  where  TR1.number_doc =SI.CONTRACT_ID) b,  "
                        + "(   select count( distinct SI.CONTRACT_ID) from  ( select tr.number_doc  from si_transaction_account_un  TR "
                        + "where  extract(month from act_date)||'-'|| extract(year from act_date)  ='1-2015' "
                        + "and transaction_type in ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9') )  tr1, "
                        + "(select a.* from (select distinct slc.contract_id  from si_loan_past_due  slpd, si_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   and extract(month from slpd.act_date)||'-'||"
                        + " extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ") )   a "
                        + "  where (select   count(*)  from si_loan_past_due  "
                        + "where extract(month from act_date)||'-'|| extract(year from act_date)  = '" + ay + "-" + Tarix + "' "
                        + "  and contract_id = a.contract_id )  between 30  and 90 "
                        + "union all select a.* from (select distinct slc.contract_id  from si_pc_loan_past_due  slpd, si_pc_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   "
                        + "and extract(month from slpd.act_date)||'-'|| extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' "
                        + " and slc.FILIAL_CODE in ( " + Filial + ") )   a  "
                        + "where (select   count(*)  from si_pc_loan_past_due  where extract(month from act_date)||'-'|| "
                        + "extract(year from act_date)  = '" + ay + "-" + Tarix + "'   and contract_id = a.contract_id "
                        + "    )  between 30  and 90 )  SI  where  TR1.number_doc =SI.CONTRACT_ID) c, "
                        + "(   select sum(  tr1.TR_AMOUNT_FCY_CR) from  ( select tr.number_doc, tr.TR_AMOUNT_FCY_CR  from si_transaction_account_un  TR "
                        + "where  extract(month from act_date)||'-'|| extract(year from act_date)  ='1-2015' "
                        + "and transaction_type in ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9') )  tr1, "
                        + "(select a.* from (select distinct slc.contract_id  from si_loan_past_due  slpd, si_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   and extract(month from slpd.act_date)||'-'||"
                        + " extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ") )   a "
                        + "  where (select   count(*)  from si_loan_past_due  "
                        + "where extract(month from act_date)||'-'|| extract(year from act_date)  = '" + ay + "-" + Tarix + "' "
                        + "  and contract_id = a.contract_id )   between 30  and 90 "
                        + "union all select a.* from (select distinct slc.contract_id  from si_pc_loan_past_due  slpd, si_pc_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   "
                        + "and extract(month from slpd.act_date)||'-'|| extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' "
                        + " and slc.FILIAL_CODE in ( " + Filial + ") )   a   "
                        + "where (select   count(*)  from si_pc_loan_past_due  where extract(month from act_date)||'-'|| "
                        + "extract(year from act_date)  = '" + ay + "-" + Tarix + "'   and contract_id = a.contract_id "
                        + "    )   between 30  and 90)  SI  where  TR1.number_doc =SI.CONTRACT_ID) d,  "
                        + "(   select count( distinct SI.CONTRACT_ID) from  ( select tr.number_doc  from si_transaction_account_un  TR "
                        + "where  extract(month from act_date)||'-'|| extract(year from act_date)  ='1-2015' "
                        + "and transaction_type in ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9') )  tr1, "
                        + "(select a.* from (select distinct slc.contract_id  from si_loan_past_due  slpd, si_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   and extract(month from slpd.act_date)||'-'||"
                        + " extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ") )   a "
                        + "  where (select   count(*)  from si_loan_past_due  "
                        + "where extract(month from act_date)||'-'|| extract(year from act_date)  = '" + ay + "-" + Tarix + "' "
                        + "  and contract_id = a.contract_id ) > 90 "
                        + "union all select a.* from (select distinct slc.contract_id  from si_pc_loan_past_due  slpd, si_pc_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   "
                        + "and extract(month from slpd.act_date)||'-'|| extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' "
                        + " and slc.FILIAL_CODE in ( " + Filial + ") )   a   "
                        + "where (select   count(*)  from si_pc_loan_past_due  where extract(month from act_date)||'-'|| "
                        + "extract(year from act_date)  = '" + ay + "-" + Tarix + "'   and contract_id = a.contract_id "
                        + "    ) >90 )  SI  where  TR1.number_doc =SI.CONTRACT_ID) e, "
                        + "(   select sum(  tr1.TR_AMOUNT_FCY_CR) from  ( select tr.number_doc, tr.TR_AMOUNT_FCY_CR  from si_transaction_account_un  TR "
                        + "where  extract(month from act_date)||'-'|| extract(year from act_date)  ='1-2015' "
                        + "and transaction_type in ('KR-5', 'KR-6', 'KR-7', 'KR-8', 'KR-9') )  tr1, "
                        + "(select a.* from (select distinct slc.contract_id  from si_loan_past_due  slpd, si_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   and extract(month from slpd.act_date)||'-'||"
                        + " extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' and  slc.FILIAL_CODE in ( " + Filial + ") )   a "
                        + "  where (select   count(*)  from si_loan_past_due  "
                        + "where extract(month from act_date)||'-'|| extract(year from act_date)  = '" + ay + "-" + Tarix + "' "
                        + "  and contract_id = a.contract_id ) > 90 "
                        + "union all select a.* from (select distinct slc.contract_id  from si_pc_loan_past_due  slpd, si_pc_loan_contract   slc "
                        + "where date_until = '01-jan-3000' and slpd.contract_id = slc.contract_id   "
                        + "and extract(month from slpd.act_date)||'-'|| extract(year from slpd.act_date)  = '" + ay + "-" + Tarix + "' "
                        + " and slc.FILIAL_CODE in ( " + Filial + ") )   a   "
                        + "where (select   count(*)  from si_pc_loan_past_due  where extract(month from act_date)||'-'|| "
                        + "extract(year from act_date)  = '" + ay + "-" + Tarix + "'   and contract_id = a.contract_id "
                        + "    ) >90)  SI  where  TR1.number_doc =SI.CONTRACT_ID) f  "
                        + "";

                //        System.out.println("odenish  "+ odenish);
                Statement stmt12 = conn.createStatement();
                ResultSet rs12 = stmt12.executeQuery(odenish);
                rs12.next();
                dd[i] = rs12.getInt(1);

                dm[i] = rs12.getDouble(2);
                if (dm[i].isNaN()) {
                    dm[i] = 0.0;
                }
                d1d[i] = rs12.getInt(3);

                d1m[i] = rs12.getDouble(4);
                if (d1m[i].isNaN()) {
                    d1m[i] = 0.0;
                }
                d2d[i] = rs12.getInt(5);

                d2m[i] = rs12.getDouble(6);
                if (d2m[i].isNaN()) {
                    d2m[i] = 0.0;
                }

                String say_yanvar = "  select"
                        + "  (select count(*)  from "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') )     < 30   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + " and   PAST.act_DATE    =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      )  < 30   "
                        + "   )"
                        + "  )  a, "
                        + "  (select count(*) from "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'    "
                        + "  ) <    30"
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'   "
                        + "  ) <    30"
                        + ") "
                        + ")  b,  "
                        + "  (select count(*)  from"
                        + " (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE < to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') )     between  31 and 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE < to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "and   PAST.act_DATE    =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      ) between  31 and 90   "
                        + "   ) "
                        + " )  c  , "
                        + "  (select count(*) from "
                        + "( "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'   "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'   "
                        + "  ) between  31 and 90 "
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'  "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'  "
                        + "  ) between  31 and 90"
                        + ") "
                        + ")  d, "
                        + "  (select count(*)  from "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') )    > 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1"
                        + "   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + "and   PAST.act_DATE    =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      ) >90   "
                        + "   )"
                        + "  )  e , "
                        + "  (select count(*) from"
                        + " ( "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "     '" + ay1 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'    "
                        + "  ) > 90 "
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'   "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'    "
                        + "  )>90"
                        + ")"
                        + " )  f,"
                        + "  (select count(*)  from "
                        + "( select distinct a.contract_id from (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE < to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') )     between  31 and 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "and   PAST.act_DATE    =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      ) between  31 and 90   "
                        + "   )  a, "
                        + "( select * from si_transaction_account_un where  TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )"
                        + "  and  extract(month from act_DATE) ||'-'|| extract(year from act_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'  "
                        + " ) b"
                        + " where a.contract_id = b.number_doc )"
                        + " )  g ,  "
                        + "  (select count(*)  from "
                        + "( select distinct a.contract_id from (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE < to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy'))   >90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE < to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "and   PAST.act_DATE    =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      ) > 90   "
                        + "   )  a, ( select * from si_transaction_account_un where  TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )"
                        + "  and  extract(month from act_DATE) ||'-'|| extract(year from act_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'     "
                        + " ) b"
                        + " where a.contract_id = b.number_doc )"
                        + " )  h ,"
                        + " (select sum(debt_total_lcy)   from "
                        + "( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + "  between date_from and date_until   union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   between date_from and date_until "
                        + "  ) "
                        + "  where contract_id in  (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1    "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + "  and   PAST.act_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy'))     < 30   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + " and   PAST.act_DATE    =      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      )  < 30   "
                        + "   ) ) m0 ,"
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'   "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "     '" + ay1 + "-" + Tarix + "'  "
                        + "  ) <    30"
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "     '" + ay1 + "-" + Tarix + "'  "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "     '" + ay1 + "-" + Tarix + "'  "
                        + "  ) <    30"
                        + ") "
                        + ") m1 , "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + "( select distinct a.contract_id from (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + " and   PAST.act_DATE =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + "  and   PAST.act_DATE    <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') )     between  31 and 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') and   PAST.act_DATE   =    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "and   PAST.act_DATE    =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')    ) between  31 and 90   "
                        + "   )  a, ( select * from si_transaction_account_un where  TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )"
                        + "  and  extract(month from act_DATE) ||'-'|| extract(year from act_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'    "
                        + " ) b"
                        + " where a.contract_id = b.number_doc )"
                        + ") m2,  "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + " (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') -1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  )     between  31 and 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  and   PAST.act_DATE   =   "
                        + "   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <   to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')  "
                        + "and   PAST.act_DATE    =      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') -1      ) between  31 and 90   "
                        + "   ) "
                        + ") m3 , "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + "( "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "      '" + ay1 + "-" + Tarix + "'  "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "      '" + ay1 + "-" + Tarix + "'    "
                        + "  ) between  31 and 90 "
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "     '" + ay1 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "     '" + ay1 + "-" + Tarix + "'    "
                        + "  ) between  31 and 90"
                        + ") "
                        + ") m4,  "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + "( select distinct a.contract_id from (SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "  and   PAST.act_DATE    <    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') )   >90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "and   PAST.act_DATE   =      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <    to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + "and   PAST.act_DATE    =       to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      ) > 90   "
                        + "   )  a, ( select * from si_transaction_account_un where  TRANSACTION_TYPE in ('KR-6','KR-8', 'KR-9' )"
                        + "  and  extract(month from act_DATE) ||'-'|| extract(year from act_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'     "
                        + " ) b"
                        + " where a.contract_id = b.number_doc )"
                        + ") m5 , "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + "(SELECT DISTINCT PAST.CONTRACT_ID   FROM SI_LOAN_PAST_DUE  PAST,"
                        + "   SI_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE    <  to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + " and   PAST.act_DATE =        to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1  "
                        + " AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID   and slc.FILIAL_CODE in ( " + Filial + ")"
                        + "  and        (select count(*) from si_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <     to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + "  and   PAST.act_DATE    <      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy'))    > 90   "
                        + " UNION ALL SELECT DISTINCT PAST.CONTRACT_ID"
                        + "  FROM SI_PC_LOAN_PAST_DUE  PAST,   SI_PC_LOAN_CONTRACT SLC  WHERE  PAST.PAST_DUE_START_DATE "
                        + "   <      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')"
                        + " and   PAST.act_DATE   =       to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1   AND SLC.DATE_UNTIL = '01-JAN-3000' AND "
                        + " SLC.CONTRACT_ID = PAST.CONTRACT_ID  and slc.FILIAL_CODE in ( " + Filial + ") "
                        + "  and        (select count(*) from si_pc_loan_past_due  where contract_id = PAST.CONTRACT_ID"
                        + "  and PAST.PAST_DUE_START_DATE <      to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy') "
                        + "and   PAST.act_DATE    =        to_date('1-" + ay1 + "-" + Tarix + "', 'dd-mm-yyyy')-1      ) >90   "
                        + "   )"
                        + ") m6,  "
                        + " (select sum(debt_total_lcy)   from ( select contract_id, debt_total_lcy from si_loan_balance "
                        + " where  date_until = '01-jan-3000'  union all   "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_pc_loan_balance"
                        + "   where    date_until='01-jan-3000' "
                        + " union all "
                        + "  select contract_id, DEBT_STANDARD_LCY+INTEREST_ACCRUAL_LCY debt_total_lcy from si_invest_mm_balance"
                        + "   where    date_until='01-jan-3000' "
                        + "  ) "
                        + "  where contract_id in "
                        + " ( "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_LOAN_PAST_DUE PAST, SI_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'   "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "    '" + ay1 + "-" + Tarix + "'    "
                        + "  ) > 90 "
                        + "  union all "
                        + "SELECT DISTINCT PAST.CONTRACT_ID     "
                        + "   FROM SI_pc_LOAN_PAST_DUE PAST, SI_pc_LOAN_CONTRACT SLC       WHERE  "
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'    "
                        + "   AND slc.FILIAL_CODE in ( " + Filial + ")      AND SLC.CONTRACT_ID = PAST.CONTRACT_ID     "
                        + "  AND SLC.DATE_UNTIL = '01-JAN-3000'       AND (SELECT COUNT (*)      "
                        + "   FROM si_pc_loan_past_due      WHERE     contract_id = PAST.CONTRACT_ID    "
                        + " AND"
                        + "   extract(month from PAST.PAST_DUE_START_DATE) ||'-'|| extract(year from PAST.PAST_DUE_START_DATE) ="
                        + "   '" + ay1 + "-" + Tarix + "'  "
                        + "  )>90"
                        + ")"
                        + ") m7  "
                        + "from dual";
                //      System.out.println("say_yanvar  " + say_yanvar);

                stmt = conn.createStatement();
                rs = stmt.executeQuery(say_yanvar);
                rs.next();
                // if ( m2_[i].isNaN())  { m2_[i]=0.0; }
                say[i] = rs.getString(1);
                if (say[i] == null) {
                    say[i] = "0";
                }
                say1_[i] = rs.getString(2);
                if (say1_[i] == null) {
                    say1_[i] = "0";
                }
                s[i] = rs.getString(3);
                if (s[i] == null) {
                    s[i] = "0";
                }
                s1_[i] = rs.getString(4);
                if (s1_[i] == null) {
                    s1_[i] = "0";
                }
                y[i] = rs.getString(5);
                if (y[i] == null) {
                    y[i] = "0";
                }
                y1_[i] = rs.getString(6);
                if (y1_[i] == null) {
                    y1_[i] = "0";
                }
                sa[i] = rs.getString(7);
                if (sa[i] == null) {
                    sa[i] = "0";
                }
                a[i] = rs.getString(8);
                if (a[i] == null) {
                    a[i] = "0";
                }
                m0_[i] = rs.getString(9);
                if (m0_[i] == null) {
                    m0_[i] = "0";
                }
                mm1_[i] = rs.getString(10);
                if (mm1_[i] == null) {
                    mm1_[i] = "0";
                }
                mm2_[i] = rs.getString(11);
                if (mm2_[i] == null) {
                    mm2_[i] = "0";
                }
                mm3_[i] = rs.getString(12);
                if (mm3_[i] == null) {
                    mm3_[i] = "0";
                }
                mm4_[i] = rs.getString(13);
                if (mm4_[i] == null) {
                    mm4_[i] = "0";
                }
                mm5_[i] = rs.getString(14);
                if (mm5_[i] == null) {
                    mm5_[i] = "0";
                }
                mm6_[i] = rs.getString(15);
                if (mm6_[i] == null) {
                    mm6_[i] = "0";
                }
                mm7_[i] = rs.getString(16);
                if (mm7_[i] == null) {
                    mm7_[i] = "0";
                }

                if (i == 12) {

                    rs1.close();
                    stmt1.close();

                    rs2.close();
                    stmt2.close();

                    rs3.close();
                    stmt3.close();

                    rs1.close();
                    stmt1.close();

                    rsRES.close();
                    stmtRES.close();

                    rs11.close();
                    stmt11.close();

                    rs12.close();
                    stmt12.close();

                    rs.close();
                    stmt.close();
                }
            }

            int say_1 = Integer.parseInt(say[1]);
            int say_1_1 = Integer.parseInt(say1_[1]);
            int s_1 = Integer.parseInt(s[1]);
            int s_1_1 = Integer.parseInt(s1_[1]);
            int y_1 = Integer.parseInt(y[1]);
            int y_1_1 = Integer.parseInt(y1_[1]);
            int sa_1 = Integer.parseInt(sa[1]);
            int a_1 = Integer.parseInt(a[1]);
            double m_1 = Double.parseDouble(m0_[1]);
            double m1_1 = Double.parseDouble(mm1_[1]);
            double m2_1 = Double.parseDouble(mm2_[1]);
            double m3_1 = Double.parseDouble(mm3_[1]);
            double m4_1 = Double.parseDouble(mm4_[1]);
            double m5_1 = Double.parseDouble(mm5_[1]);
            double m6_1 = Double.parseDouble(mm6_[1]);
            double m7_1 = Double.parseDouble(mm7_[1]);

            int say_2 = Integer.parseInt(say[2]);
            int say_2_2 = Integer.parseInt(say1_[2]);
            int s_2 = Integer.parseInt(s[2]);
            int s_2_2 = Integer.parseInt(s1_[2]);
            int y_2 = Integer.parseInt(y[2]);
            int y_2_2 = Integer.parseInt(y1_[2]);
            int sa_2 = Integer.parseInt(sa[2]);
            int a_2 = Integer.parseInt(a[2]);
            double m_2 = Double.parseDouble(m0_[2]);
            double m1_2 = Double.parseDouble(mm1_[2]);
            double m2_2 = Double.parseDouble(mm2_[2]);
            double m3_2 = Double.parseDouble(mm3_[2]);
            double m4_2 = Double.parseDouble(mm4_[2]);
            double m5_2 = Double.parseDouble(mm5_[2]);
            double m6_2 = Double.parseDouble(mm6_[2]);
            double m7_2 = Double.parseDouble(mm7_[2]);

            int say_3 = Integer.parseInt(say[3]);
            int say_3_3 = Integer.parseInt(say1_[3]);
            int s_3 = Integer.parseInt(s[3]);
            int s_3_3 = Integer.parseInt(s1_[3]);
            int y_3 = Integer.parseInt(y[3]);
            int y_3_3 = Integer.parseInt(y1_[3]);
            int sa_3 = Integer.parseInt(sa[3]);
            int a_3 = Integer.parseInt(a[3]);
            double m_3 = Double.parseDouble(m0_[3]);
            double m1_3 = Double.parseDouble(mm1_[3]);
            double m2_3 = Double.parseDouble(mm2_[3]);
            double m3_3 = Double.parseDouble(mm3_[3]);
            double m4_3 = Double.parseDouble(mm4_[3]);
            double m5_3 = Double.parseDouble(mm5_[3]);
            double m6_3 = Double.parseDouble(mm6_[3]);
            double m7_3 = Double.parseDouble(mm7_[3]);

            int say_4 = Integer.parseInt(say[4]);
            int say_4_4 = Integer.parseInt(say1_[4]);
            int s_4 = Integer.parseInt(s[4]);
            int s_4_4 = Integer.parseInt(s1_[4]);
            int y_4 = Integer.parseInt(y[4]);
            int y_4_4 = Integer.parseInt(y1_[4]);
            int sa_4 = Integer.parseInt(sa[4]);
            int a_4 = Integer.parseInt(a[4]);
            double m_4 = Double.parseDouble(m0_[4]);
            double m1_4 = Double.parseDouble(mm1_[4]);
            double m2_4 = Double.parseDouble(mm2_[4]);
            double m3_4 = Double.parseDouble(mm3_[4]);
            double m4_4 = Double.parseDouble(mm4_[4]);
            double m5_4 = Double.parseDouble(mm5_[4]);
            double m6_4 = Double.parseDouble(mm6_[4]);
            double m7_4 = Double.parseDouble(mm7_[4]);

            int say_5 = Integer.parseInt(say[5]);
            int say_5_5 = Integer.parseInt(say1_[5]);
            int s_5 = Integer.parseInt(s[5]);
            int s_5_5 = Integer.parseInt(s1_[5]);
            int y_5 = Integer.parseInt(y[5]);
            int y_5_5 = Integer.parseInt(y1_[5]);
            int sa_5 = Integer.parseInt(sa[5]);
            int a_5 = Integer.parseInt(a[5]);
            double m_5 = Double.parseDouble(m0_[5]);
            double m1_5 = Double.parseDouble(mm1_[5]);
            double m2_5 = Double.parseDouble(mm2_[5]);
            double m3_5 = Double.parseDouble(mm3_[5]);
            double m4_5 = Double.parseDouble(mm4_[5]);
            double m5_5 = Double.parseDouble(mm5_[5]);
            double m6_5 = Double.parseDouble(mm6_[5]);
            double m7_5 = Double.parseDouble(mm7_[5]);

            int say_6 = Integer.parseInt(say[6]);
            int say_6_6 = Integer.parseInt(say1_[6]);
            int s_6 = Integer.parseInt(s[6]);
            int s_6_6 = Integer.parseInt(s1_[6]);
            int y_6 = Integer.parseInt(y[6]);
            int y_6_6 = Integer.parseInt(y1_[6]);
            int sa_6 = Integer.parseInt(sa[6]);
            int a_6 = Integer.parseInt(a[6]);
            double m_6 = Double.parseDouble(m0_[6]);
            double m1_6 = Double.parseDouble(mm1_[6]);
            double m2_6 = Double.parseDouble(mm2_[6]);
            double m3_6 = Double.parseDouble(mm3_[6]);
            double m4_6 = Double.parseDouble(mm4_[6]);
            double m5_6 = Double.parseDouble(mm5_[6]);
            double m6_6 = Double.parseDouble(mm6_[6]);
            double m7_6 = Double.parseDouble(mm7_[6]);

            int say_7 = Integer.parseInt(say[7]);
            int say_7_7 = Integer.parseInt(say1_[7]);
            int s_7 = Integer.parseInt(s[7]);
            int s_7_7 = Integer.parseInt(s1_[7]);
            int y_7 = Integer.parseInt(y[7]);
            int y_7_7 = Integer.parseInt(y1_[7]);
            int sa_7 = Integer.parseInt(sa[7]);
            int a_7 = Integer.parseInt(a[7]);
            double m_7 = Double.parseDouble(m0_[7]);
            double m1_7 = Double.parseDouble(mm1_[7]);
            double m2_7 = Double.parseDouble(mm2_[7]);
            double m3_7 = Double.parseDouble(mm3_[7]);
            double m4_7 = Double.parseDouble(mm4_[7]);
            double m5_7 = Double.parseDouble(mm5_[7]);
            double m6_7 = Double.parseDouble(mm6_[7]);
            double m7_7 = Double.parseDouble(mm7_[7]);

            int say_8 = Integer.parseInt(say[8]);
            int say_8_8 = Integer.parseInt(say1_[8]);
            int s_8 = Integer.parseInt(s[8]);
            int s_8_8 = Integer.parseInt(s1_[8]);
            int y_8 = Integer.parseInt(y[8]);
            int y_8_8 = Integer.parseInt(y1_[8]);
            int sa_8 = Integer.parseInt(sa[8]);
            int a_8 = Integer.parseInt(a[8]);
            double m_8 = Double.parseDouble(m0_[8]);
            double m1_8 = Double.parseDouble(mm1_[8]);
            double m2_8 = Double.parseDouble(mm2_[8]);
            double m3_8 = Double.parseDouble(mm3_[8]);
            double m4_8 = Double.parseDouble(mm4_[8]);
            double m5_8 = Double.parseDouble(mm5_[8]);
            double m6_8 = Double.parseDouble(mm6_[8]);
            double m7_8 = Double.parseDouble(mm7_[8]);

            int say_9 = Integer.parseInt(say[9]);
            int say_9_9 = Integer.parseInt(say1_[9]);
            int s_9 = Integer.parseInt(s[9]);
            int s_9_9 = Integer.parseInt(s1_[9]);
            int y_9 = Integer.parseInt(y[9]);
            int y_9_9 = Integer.parseInt(y1_[9]);
            int sa_9 = Integer.parseInt(sa[9]);
            int a_9 = Integer.parseInt(a[9]);
            double m_9 = Double.parseDouble(m0_[9]);
            double m1_9 = Double.parseDouble(mm1_[9]);
            double m2_9 = Double.parseDouble(mm2_[9]);
            double m3_9 = Double.parseDouble(mm3_[9]);
            double m4_9 = Double.parseDouble(mm4_[9]);
            double m5_9 = Double.parseDouble(mm5_[9]);
            double m6_9 = Double.parseDouble(mm6_[9]);
            double m7_9 = Double.parseDouble(mm7_[9]);

            int say_10 = Integer.parseInt(say[10]);
            int say_10_10 = Integer.parseInt(say1_[10]);
            int s_10 = Integer.parseInt(s[10]);
            int s_10_10 = Integer.parseInt(s1_[10]);
            int y_10 = Integer.parseInt(y[10]);
            int y_10_10 = Integer.parseInt(y1_[10]);
            int sa_10 = Integer.parseInt(sa[10]);
            int a_10 = Integer.parseInt(a[10]);
            double m_10 = Double.parseDouble(m0_[10]);
            double m1_10 = Double.parseDouble(mm1_[10]);
            double m2_10 = Double.parseDouble(mm2_[10]);
            double m3_10 = Double.parseDouble(mm3_[10]);
            double m4_10 = Double.parseDouble(mm4_[10]);
            double m5_10 = Double.parseDouble(mm5_[10]);
            double m6_10 = Double.parseDouble(mm6_[10]);
            double m7_10 = Double.parseDouble(mm7_[10]);

            int say_11 = Integer.parseInt(say[11]);
            int say_11_11 = Integer.parseInt(say1_[11]);
            int s_11 = Integer.parseInt(s[11]);
            int s_11_11 = Integer.parseInt(s1_[11]);
            int y_11 = Integer.parseInt(y[11]);
            int y_11_11 = Integer.parseInt(y1_[11]);
            int sa_11 = Integer.parseInt(sa[11]);
            int a_11 = Integer.parseInt(a[11]);
            double m_11 = Double.parseDouble(m0_[11]);
            double m1_11 = Double.parseDouble(mm1_[11]);
            double m2_11 = Double.parseDouble(mm2_[11]);
            double m3_11 = Double.parseDouble(mm3_[11]);
            double m4_11 = Double.parseDouble(mm4_[11]);
            double m5_11 = Double.parseDouble(mm5_[11]);
            double m6_11 = Double.parseDouble(mm6_[11]);
            double m7_11 = Double.parseDouble(mm7_[11]);

            int say_12 = Integer.parseInt(say[12]);
            int say_12_12 = Integer.parseInt(say1_[12]);
            int s_12 = Integer.parseInt(s[12]);
            int s_12_12 = Integer.parseInt(s1_[12]);
            int y_12 = Integer.parseInt(y[12]);
            int y_12_12 = Integer.parseInt(y1_[12]);
            int sa_12 = Integer.parseInt(sa[12]);
            int a_12 = Integer.parseInt(a[12]);
            double m_12 = Double.parseDouble(m0_[12]);
            double m1_12 = Double.parseDouble(mm1_[12]);
            double m2_12 = Double.parseDouble(mm2_[12]);
            double m3_12 = Double.parseDouble(mm3_[12]);
            double m4_12 = Double.parseDouble(mm4_[12]);
            double m5_12 = Double.parseDouble(mm5_[12]);
            double m6_12 = Double.parseDouble(mm6_[12]);
            double m7_12 = Double.parseDouble(mm7_[12]);

            HSSFRow row = sheet.createRow(0);
            HSSFCell cell = row.createCell(0);

            cell.setCellValue(new HSSFRichTextString("  30 günə qədər  "));
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue("Yanvar");
            cell.setCellStyle(style);
            cell = row.createCell(4);
            cell.setCellValue("Fevral");
            cell.setCellStyle(style);
            cell = row.createCell(6);
            cell.setCellValue("Mart");
            cell.setCellStyle(style);
            cell = row.createCell(8);
            cell.setCellValue("Aprel");
            cell.setCellStyle(style);
            cell = row.createCell(10);
            cell.setCellValue("May");
            cell.setCellStyle(style);
            cell = row.createCell(12);
            cell.setCellValue("Iyun");
            cell.setCellStyle(style);
            cell = row.createCell(14);
            cell.setCellValue("Iyul");
            cell.setCellStyle(style);
            cell = row.createCell(16);
            cell.setCellValue("Avqust");
            cell.setCellStyle(style);
            cell = row.createCell(18);
            cell.setCellValue("Sentyabr");
            cell.setCellStyle(style);
            cell = row.createCell(20);
            cell.setCellValue("Oktyabr");
            cell.setCellStyle(style);
            cell = row.createCell(22);
            cell.setCellValue("Noyabr");
            cell.setCellStyle(style);
            cell = row.createCell(24);
            cell.setCellValue("Dekabr");
            cell.setCellStyle(style);
            row = sheet.createRow(1);
            int c = 0;
            int d = 1;
            for (int i = 1; i <= 12; i++) {
                c = c + 2;
                d = d + 2;
                cell = row.createCell(c);
                cell.setCellValue("Say");
                cell = row.createCell(d);
                cell.setCellValue("Məbləğ");
            }
            row = sheet.createRow(2);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün əvvəlinə qalıq");
            cell = row.createCell(2);
            cell.setCellValue(say_1);
            cell = row.createCell(4);
            cell.setCellValue(say_2);
            cell = row.createCell(6);
            cell.setCellValue(say_3);
            cell = row.createCell(8);
            cell.setCellValue(say_4);
            cell = row.createCell(10);
            cell.setCellValue(say_5);
            cell = row.createCell(12);
            cell.setCellValue(say_6);
            cell = row.createCell(14);
            cell.setCellValue(say_7);
            cell = row.createCell(16);
            cell.setCellValue(say_8);
            cell = row.createCell(18);
            cell.setCellValue(say_9);
            cell = row.createCell(20);
            cell.setCellValue(say_10);
            cell = row.createCell(22);
            cell.setCellValue(say_11);
            cell = row.createCell(24);
            cell.setCellValue(say_12);

            cell = row.createCell(3);
            cell.setCellValue(m_1);
            cell = row.createCell(5);
            cell.setCellValue(m_2);
            cell = row.createCell(7);
            cell.setCellValue(m_3);
            cell = row.createCell(9);
            cell.setCellValue(m_4);
            cell = row.createCell(11);
            cell.setCellValue(m_5);
            cell = row.createCell(13);
            cell.setCellValue(m_6);
            cell = row.createCell(15);
            cell.setCellValue(m_7);
            cell = row.createCell(17);
            cell.setCellValue(m_8);
            cell = row.createCell(19);
            cell.setCellValue(m_9);
            cell = row.createCell(21);
            cell.setCellValue(m_10);
            cell = row.createCell(23);
            cell.setCellValue(m_11);
            cell = row.createCell(25);
            cell.setCellValue(m_12);
            row = sheet.createRow(3);
            cell = row.createCell(1);
            cell.setCellValue("Dövr ərzində yeni əlavə olunmuş");

            cell = row.createCell(2);
            cell.setCellValue(say_1_1);

            cell = row.createCell(4);
            cell.setCellValue(say_2_2);

            cell = row.createCell(6);
            cell.setCellValue(say_3_3);

            cell = row.createCell(8);
            cell.setCellValue(say_4_4);

            cell = row.createCell(10);
            cell.setCellValue(say_5_5);

            cell = row.createCell(12);
            cell.setCellValue(say_6_6);

            cell = row.createCell(14);
            cell.setCellValue(say_7_7);

            cell = row.createCell(16);
            cell.setCellValue(say_8_8);

            cell = row.createCell(18);
            cell.setCellValue(say_9_9);

            cell = row.createCell(20);
            cell.setCellValue(say_10_10);

            cell = row.createCell(22);
            cell.setCellValue(say_11_11);

            cell = row.createCell(24);
            cell.setCellValue(say_12_12);

            cell = row.createCell(3);
            cell.setCellValue(m1_1);

            cell = row.createCell(5);
            cell.setCellValue(m1_2);

            cell = row.createCell(7);
            cell.setCellValue(m1_3);

            cell = row.createCell(9);
            cell.setCellValue(m1_4);

            cell = row.createCell(11);
            cell.setCellValue(m1_5);

            cell = row.createCell(13);
            cell.setCellValue(m1_6);

            cell = row.createCell(15);
            cell.setCellValue(m1_7);

            cell = row.createCell(17);
            cell.setCellValue(m1_8);

            cell = row.createCell(19);
            cell.setCellValue(m1_9);

            cell = row.createCell(21);
            cell.setCellValue(m1_10);

            cell = row.createCell(23);
            cell.setCellValue(m1_11);

            cell = row.createCell(25);
            cell.setCellValue(m1_12);

            row = sheet.createRow(4);
            cell = row.createCell(1);
            cell.setCellValue("31-90 gün GAP-dən qayıdmış");
            cell = row.createCell(2);
            cell.setCellValue(sa_1);
            cell = row.createCell(4);
            cell.setCellValue(sa_2);
            cell = row.createCell(6);
            cell.setCellValue(sa_3);
            cell = row.createCell(8);
            cell.setCellValue(sa_4);
            cell = row.createCell(10);
            cell.setCellValue(sa_5);
            cell = row.createCell(12);
            cell.setCellValue(sa_6);
            cell = row.createCell(14);
            cell.setCellValue(sa_7);
            cell = row.createCell(16);
            cell.setCellValue(sa_8);
            cell = row.createCell(18);
            cell.setCellValue(sa_9);
            cell = row.createCell(20);
            cell.setCellValue(sa_10);
            cell = row.createCell(22);
            cell.setCellValue(sa_11);
            cell = row.createCell(24);
            cell.setCellValue(sa_12);

            cell = row.createCell(3);
            cell.setCellValue(m2_1);
            cell = row.createCell(5);
            cell.setCellValue(m2_2);
            cell = row.createCell(7);
            cell.setCellValue(m2_3);
            cell = row.createCell(9);
            cell.setCellValue(m2_4);
            cell = row.createCell(11);
            cell.setCellValue(m2_5);
            cell = row.createCell(13);
            cell.setCellValue(m2_6);
            cell = row.createCell(15);
            cell.setCellValue(m2_7);
            cell = row.createCell(17);
            cell.setCellValue(m2_8);
            cell = row.createCell(19);
            cell.setCellValue(m2_9);
            cell = row.createCell(21);
            cell.setCellValue(m2_10);
            cell = row.createCell(23);
            cell.setCellValue(m2_11);
            cell = row.createCell(25);
            cell.setCellValue(m2_12);
            row = sheet.createRow(5);
            cell = row.createCell(1);
            cell.setCellValue("Dövr ərzində ödənilmiş");
            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(n[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(n[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(n[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(n[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(n[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(n[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(n[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(n[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(n[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(n[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(n[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(n[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m[10]);

            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m[12]);
            cell.setCellStyle(style1);
            row = sheet.createRow(6);
            cell = row.createCell(1);
            cell.setCellValue("31-90 gün GAP-ə keçmiş");
            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(s_1_1);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(s_2_2);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(s_3_3);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(s_4_4);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(s_5_5);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(s_6_6);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(s_7_7);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(s_8_8);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(s_9_9);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(s_10_10);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(s_11_11);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(s_12_12);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m4_1);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m4_2);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m4_3);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m4_4);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m4_5);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m4_6);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m4_7);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m4_8);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m4_9);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m4_10);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m4_11);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m4_12);
            cell.setCellStyle(style1);

            row = sheet.createRow(7);
            cell = row.createCell(1);
            cell.setCellValue("Restrukturizasiya olunmuş");

            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(res30[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(res30[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(res30[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(res30[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(res30[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(res30[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(res30[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(res30[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(res30[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(res30[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(res30[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(res30[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(res30_m[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(res30_m[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(res30_m[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(res30_m[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(res30_m[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(res30_m[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(res30_m[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(res30_m[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(res30_m[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(res30_m[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(res30_m[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(res30_m[12]);

            cell.setCellStyle(style1);
            row = sheet.createRow(8);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün sonuna qalıq");

            cell = row.createCell(2);
            cell.setCellValue(say_1 + say_1_1 + sa_1 - (n[1]) - s_1_1 - res30[1]);
            cell = row.createCell(4);
            cell.setCellValue((say_2) + (say_2_2) + (sa_2) - (n[2]) - (s_2_2) - res30[2]);
            cell = row.createCell(6);
            cell.setCellValue((say_3) + (say_3_3) + (sa_3) - (n[3]) - (s_3_3) - res30[3]);
            cell = row.createCell(8);
            cell.setCellValue((say_4) + (say_4_4) + (sa_4) - (n[4]) - (s_4_4) - res30[4]);
            cell = row.createCell(10);
            cell.setCellValue((say_5) + (say_5_5) + (sa_5) - (n[5]) - (s_5_5) - res30[5]);
            cell = row.createCell(12);
            cell.setCellValue((say_6) + (say_6_6) + (sa_6) - (n[6]) - (s_6_6) - res30[6]);
            cell = row.createCell(14);
            cell.setCellValue((say_7) + (say_7_7) + (sa_7) - (n[7]) - (s_7_7) - res30[7]);
            cell = row.createCell(16);
            cell.setCellValue((say_8) + (say_8_8) + (sa_8) - (n[8]) - (s_8_8) - res30[8]);
            cell = row.createCell(18);
            cell.setCellValue((say_9) + (say_9_9) + (sa_9) - (n[9]) - (s_9_9) - res30[9]);
            cell = row.createCell(20);
            cell.setCellValue((say_10) + (say_10_10) + (sa_10) - (n[10]) - (s_10_10) - res30[10]);
            cell = row.createCell(22);
            cell.setCellValue((say_11) + (say_11_11) + (sa_11) - (n[11]) - (s_11_11) - res30[11]);
            cell = row.createCell(24);
            cell.setCellValue((say_12) + (say_12_12) + (sa_12) - (n[12]) - (s_12_12) - res30[12]);

            Double my_1 = 0.0;
            if (!Double.isNaN(m_1)) {
                my_1 = (m_1) + (m1_1) + (m2_1) - m[1] - (m4_1) - res30_m[1];
            }
            Double my_2 = 0.0;
            if (!Double.isNaN(m_2)) {
                my_2 = (m_2) + (m1_2) + (m2_2) - m[2] - (m4_2) - res30_m[2];
            }
            Double my_3 = 0.0;
            if (!Double.isNaN(m_3)) {
                my_3 = (m_3) + (m1_3) + (m2_3) - m[3] - (m4_3) - res30_m[3];
            }
            Double my_4 = 0.0;
            if (!Double.isNaN(m_4)) {
                my_4 = (m_4) + (m1_4) + (m2_4) - m[4] - (m4_4) - res30_m[4];
            }
            Double my_5 = 0.0;
            if (!Double.isNaN(m_5)) {
                my_5 = (m_5) + (m1_5) + (m2_5) - m[5] - (m4_5) - res30_m[5];
            }
            Double my_6 = 0.0;
            if (!Double.isNaN(m_6)) {
                my_6 = (m_6) + (m1_6) + (m2_6) - m[6] - (m4_6) - res30_m[6];
            }
            Double my_7 = 0.0;
            if (!Double.isNaN(m_7)) {
                my_7 = (m_7) + (m1_7) + (m2_7) - m[7] - (m4_7) - res30_m[7];
            }
            Double my_8 = 0.0;
            if (!Double.isNaN(m_8)) {
                my_8 = (m_8) + (m1_8) + (m2_8) - m[8] - (m4_8) - res30_m[8];
            }
            Double my_9 = 0.0;
            if (!Double.isNaN(m_9)) {
                my_9 = (m_9) + (m1_9) + (m2_9) - m[9] - (m4_9) - res30_m[9];
            }
            Double my_10 = 0.0;
            if (!Double.isNaN(m_10)) {
                my_10 = (m_10) + (m1_10) + (m2_10) - m[10] - (m4_10) - res30_m[10];
            }
            Double my_11 = 0.0;
            if (!Double.isNaN(m_11)) {
                my_11 = (m_11) + (m1_11) + (m2_1) - m[11] - (m4_11) - res30_m[11];
            }
            Double my_12 = 0.0;
            if (!Double.isNaN(m_12)) {
                my_12 = (m_12) + (m1_12) + (m2_12) - m[12] - (m4_12) - res30_m[12];
            }
            cell = row.createCell(3);
            cell.setCellValue(my_1);
            cell = row.createCell(5);
            cell.setCellValue(my_2);
            cell = row.createCell(7);
            cell.setCellValue(my_3);
            cell = row.createCell(9);
            cell.setCellValue(my_4);
            cell = row.createCell(11);
            cell.setCellValue(my_5);
            cell = row.createCell(13);
            cell.setCellValue(my_6);
            cell = row.createCell(15);
            cell.setCellValue(my_7);
            cell = row.createCell(17);
            cell.setCellValue(my_8);
            cell = row.createCell(19);
            cell.setCellValue(my_9);

            cell = row.createCell(21);
            cell.setCellValue(my_10);
            cell = row.createCell(23);
            cell.setCellValue(my_11);
            cell = row.createCell(25);
            cell.setCellValue(my_12);

            row = sheet.createRow(9);
            for (int i = 0; i <= 25; i++) {
                cell = row.createCell(i);
                cell.setCellStyle(style2);
            }

            row = sheet.createRow(10);
            cell = row.createCell(0);

            cell.setCellValue("31-90 gün arası");
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue("Yanvar");
            cell.setCellStyle(style);
            cell = row.createCell(4);
            cell.setCellValue("Fevral");
            cell.setCellStyle(style);
            cell = row.createCell(6);
            cell.setCellValue("Mart");
            cell.setCellStyle(style);
            cell = row.createCell(8);
            cell.setCellValue("Aprel");
            cell.setCellStyle(style);
            cell = row.createCell(10);
            cell.setCellValue("May");
            cell.setCellStyle(style);
            cell = row.createCell(12);
            cell.setCellValue("Iyun");
            cell.setCellStyle(style);
            cell = row.createCell(14);
            cell.setCellValue("Iyul");
            cell.setCellStyle(style);
            cell = row.createCell(16);
            cell.setCellValue("Avqust");
            cell.setCellStyle(style);
            cell = row.createCell(18);
            cell.setCellValue("Sentyabr");
            cell.setCellStyle(style);
            cell = row.createCell(20);
            cell.setCellValue("Oktyabr");
            cell.setCellStyle(style);
            cell = row.createCell(22);
            cell.setCellValue("Noyabr");
            cell.setCellStyle(style);
            cell = row.createCell(24);
            cell.setCellValue("Dekabr");
            cell.setCellStyle(style);
            row = sheet.createRow(11);
            c = 0;
            d = 1;
            for (int i = 1; i <= 12; i++) {
                c = c + 2;
                d = d + 2;
                cell = row.createCell(c);
                cell.setCellValue("Say");
                cell = row.createCell(d);
                cell.setCellValue("Məbləğ");
            }
            row = sheet.createRow(12);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün əvvəlinə qalıq");
            cell = row.createCell(2);
            cell.setCellValue(s_1);
            cell = row.createCell(4);
            cell.setCellValue(s_2);
            cell = row.createCell(6);
            cell.setCellValue(s_3);
            cell = row.createCell(8);
            cell.setCellValue(s_4);
            cell = row.createCell(10);
            cell.setCellValue(s_5);
            cell = row.createCell(12);
            cell.setCellValue(s_6);
            cell = row.createCell(14);
            cell.setCellValue(s_7);
            cell = row.createCell(16);
            cell.setCellValue(s_8);
            cell = row.createCell(18);
            cell.setCellValue(s_9);
            cell = row.createCell(20);
            cell.setCellValue(s_10);
            cell = row.createCell(22);
            cell.setCellValue(s_11);
            cell = row.createCell(24);
            cell.setCellValue(s_12);

            cell = row.createCell(3);
            cell.setCellValue(m3_1);
            cell = row.createCell(5);
            cell.setCellValue(m3_2);
            cell = row.createCell(7);
            cell.setCellValue(m3_3);
            cell = row.createCell(9);
            cell.setCellValue(m3_4);
            cell = row.createCell(11);
            cell.setCellValue(m3_5);
            cell = row.createCell(13);
            cell.setCellValue(m3_6);
            cell = row.createCell(15);
            cell.setCellValue(m3_7);
            cell = row.createCell(17);
            cell.setCellValue(m3_8);
            cell = row.createCell(19);
            cell.setCellValue(m3_9);
            cell = row.createCell(21);
            cell.setCellValue(m3_10);
            cell = row.createCell(23);
            cell.setCellValue(m3_11);
            cell = row.createCell(25);
            cell.setCellValue(m3_12);

            row = sheet.createRow(13);
            cell = row.createCell(1);
            cell.setCellValue(" 30 günə gədər GAP-dən əlavə olunmuş");
            cell = row.createCell(2);
            cell.setCellValue(s_1_1);
            cell = row.createCell(4);
            cell.setCellValue(s_2_2);
            cell = row.createCell(6);
            cell.setCellValue(s_3_3);
            cell = row.createCell(8);
            cell.setCellValue(s_4_4);
            cell = row.createCell(10);
            cell.setCellValue(s_5_5);
            cell = row.createCell(12);
            cell.setCellValue(s_6_6);
            cell = row.createCell(14);
            cell.setCellValue(s_7_7);
            cell = row.createCell(16);
            cell.setCellValue(s_8_8);
            cell = row.createCell(18);
            cell.setCellValue(s_9_9);
            cell = row.createCell(20);
            cell.setCellValue(s_10_10);
            cell = row.createCell(22);
            cell.setCellValue(s_11_11);
            cell = row.createCell(24);
            cell.setCellValue(s_12_12);

            cell = row.createCell(3);
            cell.setCellValue(m4_1);
            cell = row.createCell(5);
            cell.setCellValue(m4_2);
            cell = row.createCell(7);
            cell.setCellValue(m4_3);
            cell = row.createCell(9);
            cell.setCellValue(m4_4);
            cell = row.createCell(11);
            cell.setCellValue(m4_5);
            cell = row.createCell(13);
            cell.setCellValue(m4_6);
            cell = row.createCell(15);
            cell.setCellValue(m4_7);
            cell = row.createCell(17);
            cell.setCellValue(m4_8);
            cell = row.createCell(19);
            cell.setCellValue(m4_9);
            cell = row.createCell(21);
            cell.setCellValue(m4_10);
            cell = row.createCell(23);
            cell.setCellValue(m4_11);
            cell = row.createCell(25);
            cell.setCellValue(m4_12);

            row = sheet.createRow(14);
            cell = row.createCell(1);
            cell.setCellValue(" 90 gündən yuxarı GAP-dən qayıdmış");
            cell = row.createCell(2);
            cell.setCellValue(a_1);
            cell = row.createCell(4);
            cell.setCellValue(a_2);
            cell = row.createCell(6);
            cell.setCellValue(a_3);
            cell = row.createCell(8);
            cell.setCellValue(a_4);
            cell = row.createCell(10);
            cell.setCellValue(a_5);
            cell = row.createCell(12);
            cell.setCellValue(a_6);
            cell = row.createCell(14);
            cell.setCellValue(a_7);
            cell = row.createCell(16);
            cell.setCellValue(a_8);
            cell = row.createCell(18);
            cell.setCellValue(a_9);
            cell = row.createCell(20);
            cell.setCellValue(a_10);
            cell = row.createCell(22);
            cell.setCellValue(a_11);
            cell = row.createCell(24);
            cell.setCellValue(a_12);

            cell = row.createCell(3);
            cell.setCellValue(m5_1);
            cell = row.createCell(5);
            cell.setCellValue(m5_2);
            cell = row.createCell(7);
            cell.setCellValue(m5_3);
            cell = row.createCell(9);
            cell.setCellValue(m5_4);
            cell = row.createCell(11);
            cell.setCellValue(m5_5);
            cell = row.createCell(13);
            cell.setCellValue(m5_6);
            cell = row.createCell(15);
            cell.setCellValue(m5_7);
            cell = row.createCell(17);
            cell.setCellValue(m5_8);
            cell = row.createCell(19);
            cell.setCellValue(m5_9);
            cell = row.createCell(21);
            cell.setCellValue(m5_10);
            cell = row.createCell(23);
            cell.setCellValue(m5_11);
            cell = row.createCell(25);
            cell.setCellValue(m5_12);

            row = sheet.createRow(15);
            cell = row.createCell(1);
            cell.setCellValue(" 30 günə gədər GAP-ə qayıdmış");
            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(sa_1);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(sa_2);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(sa_3);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(sa_4);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(sa_5);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(sa_6);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(sa_7);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(sa_8);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(sa_9);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(sa_10);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(sa_11);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(sa_12);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m2_1);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m2_2);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m2_3);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m2_4);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m2_5);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m2_6);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m2_7);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m2_8);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m2_9);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m2_10);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m2_11);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m2_12);
            cell.setCellStyle(style1);

            row = sheet.createRow(16);
            cell = row.createCell(1);
            cell.setCellValue("Dövr ərzində ödənilmiş");
            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(n1_[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(n1_[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(n1_[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(n1_[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(n1_[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(n1_[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(n1_[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(n1_[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(n1_[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(n1_[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(n1_[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(n1_[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m1_[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m1_[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m1_[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m1_[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m1_[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m1_[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m1_[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m1_[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m1_[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m1_[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m1_[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m1_[12]);
            cell.setCellStyle(style1);

            row = sheet.createRow(17);
            cell = row.createCell(1);
            cell.setCellValue("90 gündən yuxarı GAP-ə keçmiş");
            cell.setCellStyle(style1);

            cell = row.createCell(2);
            cell.setCellValue(y_1_1);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(y_2_2);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(y_3_3);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(y_4_4);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(y_5_5);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(y_6_6);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(y_7_7);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(y_8_8);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(y_9_9);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(y_10_10);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(y_11_11);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(y_12_12);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m7_1);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m7_2);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m7_3);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m7_4);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m7_5);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m7_6);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m7_7);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m7_8);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m7_9);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m7_10);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m7_11);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m7_12);
            cell.setCellStyle(style1);

            row = sheet.createRow(18);
            cell = row.createCell(1);
            cell.setCellValue("Restruturizasiya olunmuş");

            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(res31[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(res31[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(res31[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(res31[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(res31[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(res31[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(res31[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(res31[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(res31[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(res31[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(res31[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(res31[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(res31_m[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(res31_m[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(res31_m[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(res31_m[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(res31_m[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(res31_m[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(res31_m[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(res31_m[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(res31_m[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(res31_m[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(res31_m[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(res31_m[12]);

            cell.setCellStyle(style1);
            row = sheet.createRow(19);
            cell = row.createCell(1);
            cell.setCellValue("Məhkəməyə yönədilmiş");
            cell.setCellStyle(style1);

            cell = row.createCell(2);
            cell.setCellValue(mh[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(mh[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(mh[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(mh[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(mh[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(mh[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(mh[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(mh[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(mh[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(mh[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(mh[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(mh[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(mh_m[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(mh_m[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(mh_m[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(mh_m[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(mh_m[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(mh_m[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(mh_m[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(mh_m[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(mh_m[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(mh_m[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(mh_m[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(mh_m[12]);
            cell.setCellStyle(style1);

            row = sheet.createRow(20);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün sonuna qalıq");

            cell = row.createCell(2);
            cell.setCellValue(s_1 + s_1_1 + a_1 - sa_1 - (n1_[1]) - y_1_1 - (mh[1]) - res31[1]);
            cell = row.createCell(4);
            cell.setCellValue(s_2 + s_2_2 + a_2 - sa_2 - (n1_[2]) - y_2_2 - (mh[2]) - res31[2]);
            cell = row.createCell(6);
            cell.setCellValue((s_3) + (s_3_3) + (a_3) - (sa_3) - (n1_[3]) - (y_3_3) - (mh[3]) - res31[3]);
            cell = row.createCell(8);
            cell.setCellValue((s_4) + (s_4_4) + (a_4) - (sa_4) - (n1_[4]) - (y_4_4) - (mh[4]) - res31[4]);
            cell = row.createCell(10);
            cell.setCellValue((s_5) + (s_5_5) + (a_5) - (sa_5) - (n1_[5]) - (y_5_5) - (mh[5]) - res31[5]);
            cell = row.createCell(12);
            cell.setCellValue((s_6) + (s_6_6) + (a_6) - (sa_6) - (n1_[6]) - (y_6_6) - (mh[6]) - res31[6]);
            cell = row.createCell(14);
            cell.setCellValue((s_7) + (s_7_7) + (a_7) - (sa_7) - (n1_[7]) - (y_7_7) - (mh[7]) - res31[7]);
            cell = row.createCell(16);
            cell.setCellValue((s_8) + (s_8_8) + (a_8) - (sa_8) - (n1_[8]) - (y_8_8) - (mh[8]) - res31[8]);
            cell = row.createCell(18);
            cell.setCellValue((s_9) + (s_9_9) + (a_9) - (sa_9) - (n1_[9]) - (y_9_9) - (mh[9]) - res31[9]);
            cell = row.createCell(20);
            cell.setCellValue((s_10) + (s_10_10) + (a_10) - (sa_10) - (n1_[10]) - (y_10_10) - (mh[10]) - res31[10]);
            cell = row.createCell(22);
            cell.setCellValue((s_11) + (s_11_11) + (a_11) - (sa_11) - (n1_[11]) - (y_11_11) - (mh[11]) - res31[11]);
            cell = row.createCell(24);
            cell.setCellValue((s_12) + (s_12_12) + (a_12) - (sa_12) - (n1_[12]) - (y_12_12) - (mh[12]) - res31[11]);
            Double my1_1 = 0.0;
            if (!(Double.isNaN(m3_1))) {
                my1_1 = m3_1 + m4_1 + m5_1 - m2_1 - m1_[1] - mh_m[1] - y_1_1 - res31_m[1];
            }

            Double my1_2 = 0.0;
            if (!(Double.isNaN(m3_2))) {
                my1_2 = (m3_2) + (m4_2) + (m5_2) - (m2_2) - m1_[2] - mh_m[2] - (y_2_2) - res31_m[2];
            }

            Double my1_3 = 0.0;
            if (!(Double.isNaN(m3_3))) {
                my1_3 = (m3_3) + (m4_3) + (m5_3) - (m2_3) - m1_[3] - mh_m[3] - (y_3_3) - res31_m[3];
            }

            Double my1_4 = 0.0;
            if (!(Double.isNaN(m3_4))) {
                my1_4 = (m3_4) + (m4_4) + (m5_4) - (m2_4) - m1_[4] - mh_m[4] - (y_4_4) - res31_m[4];
            }

            Double my1_5 = 0.0;
            if (!(Double.isNaN(m3_5))) {
                my1_5 = (m3_5) + (m4_5) + (m5_5) - (m2_5) - m1_[5] - mh_m[5] - (y_5_5) - res31_m[5];
            }

            Double my1_6 = 0.0;
            if (!(Double.isNaN(m3_6))) {
                my1_6 = (m3_6) + (m4_6) + (m5_6) - (m2_6) - m1_[6] - mh_m[6] - (y_6_6) - res31_m[6];
            }

            Double my1_7 = 0.0;
            if (!(Double.isNaN(m3_7))) {
                my1_7 = (m3_7) + (m4_7) + (m5_7) - (m2_7) - m1_[7] - mh_m[7] - (y_7_7) - res31_m[7];
            }

            Double my1_8 = 0.0;
            if (!(Double.isNaN(m3_8))) {
                my1_8 = (m3_8) + (m4_8) + (m5_8) - (m2_8) - m1_[8] - mh_m[8] - (y_8_8) - res31_m[8];
            }

            Double my1_9 = 0.0;
            if (!(Double.isNaN(m3_9))) {
                my1_9 = (m3_9) + (m4_9) + (m5_9) - (m2_9) - m1_[9] - mh_m[9] - (y_9_9) - res31_m[9];
            }

            Double my1_10 = 0.0;
            if (!(Double.isNaN(m3_10))) {
                my1_10 = (m3_10) + (m4_10) + (m5_10) - (m2_10) - m1_[10] - mh_m[10] - (y_10_10) - res31_m[10];
            }

            Double my1_11 = 0.0;
            if (!(Double.isNaN(m3_11))) {
                my1_11 = (m3_11) + (m4_11) + (m5_11) - (m2_11) - m1_[11] - mh_m[11] - (y_11_11) - res31_m[11];
            }

            Double my1_12 = 0.0;
            if (!(Double.isNaN(m3_12))) {
                my1_12 = (m3_12) + (m4_12) + (m5_12) - (m2_12) - m1_[12] - mh_m[12] - (y_12_12) - res31_m[12];
            }

            cell = row.createCell(3);
            cell.setCellValue(my1_1);
            cell = row.createCell(5);
            cell.setCellValue(my1_2);
            cell = row.createCell(7);
            cell.setCellValue(my1_3);
            cell = row.createCell(9);
            cell.setCellValue(my1_4);
            cell = row.createCell(11);
            cell.setCellValue(my1_5);
            cell = row.createCell(13);
            cell.setCellValue(my1_6);
            cell = row.createCell(15);
            cell.setCellValue(my1_7);
            cell = row.createCell(17);
            cell.setCellValue(my1_8);
            cell = row.createCell(19);
            cell.setCellValue(my1_9);

            cell = row.createCell(21);
            cell.setCellValue(my1_10);
            cell = row.createCell(23);
            cell.setCellValue(my1_11);
            cell = row.createCell(25);
            cell.setCellValue(my1_12);

            row = sheet.createRow(21);
            for (int i = 0; i <= 25; i++) {
                cell = row.createCell(i);
                cell.setCellStyle(style2);
            }

            row = sheet.createRow(22);
            cell = row.createCell(0);
            cell.setCellValue("90 gündən yuxarı");
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue("Yanvar");
            cell.setCellStyle(style);
            cell = row.createCell(4);
            cell.setCellValue("Fevral");
            cell.setCellStyle(style);
            cell = row.createCell(6);
            cell.setCellValue("Mart");
            cell.setCellStyle(style);
            cell = row.createCell(8);
            cell.setCellValue("Aprel");
            cell.setCellStyle(style);
            cell = row.createCell(10);
            cell.setCellValue("May");
            cell.setCellStyle(style);
            cell = row.createCell(12);
            cell.setCellValue("Iyun");
            cell.setCellStyle(style);
            cell = row.createCell(14);
            cell.setCellValue("Iyul");
            cell.setCellStyle(style);
            cell = row.createCell(16);
            cell.setCellValue("Avqust");
            cell.setCellStyle(style);
            cell = row.createCell(18);
            cell.setCellValue("Sentyabr");
            cell.setCellStyle(style);
            cell = row.createCell(20);
            cell.setCellValue("Oktyabr");
            cell.setCellStyle(style);
            cell = row.createCell(22);
            cell.setCellValue("Noyabr");
            cell.setCellStyle(style);
            cell = row.createCell(24);
            cell.setCellValue("Dekabr");
            cell.setCellStyle(style);
            row = sheet.createRow(23);
            c = 0;
            d = 1;
            for (int i = 1; i <= 12; i++) {
                c = c + 2;
                d = d + 2;
                cell = row.createCell(c);
                cell.setCellValue("Say");
                cell = row.createCell(d);
                cell.setCellValue("Məbləğ");
            }
            row = sheet.createRow(24);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün əvvəlinə qalıq");
            cell = row.createCell(2);
            cell.setCellValue(y_1);
            cell = row.createCell(4);
            cell.setCellValue(y_2);
            cell = row.createCell(6);
            cell.setCellValue(y_3);
            cell = row.createCell(8);
            cell.setCellValue(y_4);
            cell = row.createCell(10);
            cell.setCellValue(y_5);
            cell = row.createCell(12);
            cell.setCellValue(y_6);
            cell = row.createCell(14);
            cell.setCellValue(y_7);
            cell = row.createCell(16);
            cell.setCellValue(y_8);
            cell = row.createCell(18);
            cell.setCellValue(y_9);
            cell = row.createCell(20);
            cell.setCellValue(y_10);
            cell = row.createCell(22);
            cell.setCellValue(y_11);
            cell = row.createCell(24);
            cell.setCellValue(y_12);

            cell = row.createCell(3);
            cell.setCellValue(m6_1);
            cell = row.createCell(5);
            cell.setCellValue(m6_2);
            cell = row.createCell(7);
            cell.setCellValue(m6_3);
            cell = row.createCell(9);
            cell.setCellValue(m6_4);
            cell = row.createCell(11);
            cell.setCellValue(m6_5);
            cell = row.createCell(13);
            cell.setCellValue(m6_6);
            cell = row.createCell(15);
            cell.setCellValue(m6_7);
            cell = row.createCell(17);
            cell.setCellValue(m6_8);
            cell = row.createCell(19);
            cell.setCellValue(m6_9);
            cell = row.createCell(21);
            cell.setCellValue(m6_10);
            cell = row.createCell(23);
            cell.setCellValue(m6_11);
            cell = row.createCell(25);
            cell.setCellValue(m6_12);

            row = sheet.createRow(25);
            cell = row.createCell(1);
            cell.setCellValue("31 -90 gün arası GAP-dən əlavə olunmuş");
            cell = row.createCell(2);
            cell.setCellValue(y_1_1);
            cell = row.createCell(4);
            cell.setCellValue(y_2_2);
            cell = row.createCell(6);
            cell.setCellValue(y_3_3);
            cell = row.createCell(8);
            cell.setCellValue(y_4_4);
            cell = row.createCell(10);
            cell.setCellValue(y_5_5);
            cell = row.createCell(12);
            cell.setCellValue(y_6_6);
            cell = row.createCell(14);
            cell.setCellValue(y_7_7);
            cell = row.createCell(16);
            cell.setCellValue(y_8_8);
            cell = row.createCell(18);
            cell.setCellValue(y_9_9);
            cell = row.createCell(20);
            cell.setCellValue(y_10_10);
            cell = row.createCell(22);
            cell.setCellValue(y_11_11);
            cell = row.createCell(24);
            cell.setCellValue(y_12_12);

            cell = row.createCell(3);
            cell.setCellValue(m7_1);
            cell = row.createCell(5);
            cell.setCellValue(m7_2);
            cell = row.createCell(7);
            cell.setCellValue(m7_3);
            cell = row.createCell(9);
            cell.setCellValue(m7_4);
            cell = row.createCell(11);
            cell.setCellValue(m7_5);
            cell = row.createCell(13);
            cell.setCellValue(m7_6);
            cell = row.createCell(15);
            cell.setCellValue(m7_7);
            cell = row.createCell(17);
            cell.setCellValue(m7_8);
            cell = row.createCell(19);
            cell.setCellValue(m7_9);
            cell = row.createCell(21);
            cell.setCellValue(m7_10);
            cell = row.createCell(23);
            cell.setCellValue(m7_11);
            cell = row.createCell(25);
            cell.setCellValue(m7_12);
            row = sheet.createRow(26);
            cell = row.createCell(1);
            cell.setCellValue("31 -90 gün arası GAP-ə qayıdmış");
            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(a_1);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(a_2);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(a_3);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(a_4);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(a_5);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(a_6);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(a_7);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(a_8);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(a_9);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(a_10);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(a_11);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(a_12);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m5_1);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m5_2);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m5_3);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m5_4);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m5_5);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m5_6);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m5_7);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m5_8);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m5_9);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m5_10);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m5_11);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m5_12);
            cell.setCellStyle(style1);

            row = sheet.createRow(27);
            cell = row.createCell(1);
            cell.setCellValue("Dövr ərzində ödənilmiş");
            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(n2_[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(n2_[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(n2_[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(n2_[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(n2_[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(n2_[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(n2_[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(n2_[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(n2_[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(n2_[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(n2_[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(n2_[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(m2_[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(m2_[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(m2_[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(m2_[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(m2_[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(m2_[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(m2_[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(m2_[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(m2_[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(m2_[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(m2_[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(m2_[12]);
            cell.setCellStyle(style1);

            row = sheet.createRow(28);
            cell = row.createCell(1);

            cell.setCellValue("Restrukturizasiya olunmuş");

            cell.setCellStyle(style1);
            cell = row.createCell(2);
            cell.setCellValue(res90[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(res90[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(res90[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(res90[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(res90[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(res90[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(res90[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(res90[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(res90[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(res90[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(res90[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(res90[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(res90_m[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(res90_m[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(res90_m[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(res90_m[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(res90_m[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(res90_m[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(res90_m[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(res90_m[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(res90_m[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(res90_m[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(res90_m[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(res90_m[12]);
            cell.setCellStyle(style1);

            row = sheet.createRow(29);
            cell = row.createCell(1);
            cell.setCellValue("Məhkəməyə yönədilmiş");
            cell.setCellStyle(style1);

            cell = row.createCell(2);
            cell.setCellValue(mhh[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(mhh[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(mhh[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(mhh[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(mhh[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(mhh[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(mhh[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(mhh[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(mhh[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(mhh[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(mhh[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(mhh[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(mh_mm[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(mh_mm[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(mh_mm[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(mh_mm[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(mh_mm[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(mh_mm[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(mh_mm[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(mh_mm[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(mh_mm[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(mh_mm[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(mh_mm[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(mh_mm[12]);
            cell.setCellStyle(style1);

            row = sheet.createRow(30);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün sonuna qalıq");

            cell = row.createCell(2);
            cell.setCellValue((y_1) + (y_1_1) - (a_1) - (n2_[1]) - (mhh[1]) - res90[1]);
            cell = row.createCell(4);
            cell.setCellValue((y_2) + (y_2_2) - (a_2) - (n2_[2]) - (mhh[2]) - res90[2]);
            cell = row.createCell(6);
            cell.setCellValue((y_3) + (y_3_3) - (a_3) - (n2_[3]) - (mhh[3]) - res90[3]);
            cell = row.createCell(8);
            cell.setCellValue((y_4) + (y_4_4) - (a_4) - (n2_[4]) - (mhh[4]) - res90[4]);
            cell = row.createCell(10);
            cell.setCellValue((y_5) + (y_5_5) - (a_5) - (n2_[5]) - (mhh[5]) - res90[5]);
            cell = row.createCell(12);
            cell.setCellValue((y_6) + (y_6_6) - (a_6) - (n2_[6]) - (mhh[6]) - res90[6]);
            cell = row.createCell(14);
            cell.setCellValue((y_7) + (y_7_7) - (a_7) - (n2_[7]) - (mhh[7]) - res90[7]);
            cell = row.createCell(16);
            cell.setCellValue((y_8) + (y_8_8) - (a_8) - (n2_[8]) - (mhh[8]) - res90[8]);
            cell = row.createCell(18);
            cell.setCellValue((y_9) + (y_9_9) - (a_9) - (n2_[9]) - (mhh[9]) - res90[9]);
            cell = row.createCell(20);
            cell.setCellValue((y_10) + (y_10_10) - (a_10) - (n2_[10]) - (mhh[10]) - res90[10]);
            cell = row.createCell(22);
            cell.setCellValue((y_11) + (y_11_11) - (a_11) - (n2_[11]) - (mhh[1]) - res90[11]);
            cell = row.createCell(24);
            cell.setCellValue((y_12) + (y_12_12) - (a_12) - (n2_[12]) - (mhh[12]) - res90[12]);

            Double my2_1 = 0.0;
            if (!(Double.isNaN(m6_1))) {
                my2_1 = (m6_1) + (m7_1) - (m5_1) - m2_[1] - mh_mm[1] - res90_m[1];
            }

            Double my2_2 = 0.0;
            if (!(Double.isNaN(m6_2))) {
                my2_2 = (m6_2) + (m7_2) - (m5_2) - m2_[2] - mh_mm[2] - res90_m[2];
            }

            Double my2_3 = 0.0;
            if (!(Double.isNaN(m6_3))) {
                my2_3 = (m6_3) + (m7_3) - (m5_3) - m2_[3] - mh_mm[3] - res90_m[3];
            }

            Double my2_4 = 0.0;
            if (!(Double.isNaN(m6_4))) {
                my2_4 = (m6_4) + (m7_4) - (m5_4) - m2_[4] - mh_mm[4] - res90_m[4];
            }

            Double my2_5 = 0.0;
            if (!(Double.isNaN(m6_5))) {
                my2_5 = (m6_5) + (m7_5) - (m5_5) - m2_[5] - mh_mm[5] - res90_m[5];
            }

            Double my2_6 = 0.0;
            if (!(Double.isNaN(m6_6))) {
                my2_6 = (m6_6) + (m7_6) - (m5_6) - m2_[6] - mh_mm[6] - res90_m[6];
            }

            Double my2_7 = 0.0;
            if (!(Double.isNaN(m6_7))) {
                my2_7 = (m6_7) + (m7_7) - (m5_7) - m2_[7] - mh_mm[7] - res90_m[7];
            }

            Double my2_8 = 0.0;
            if (!(Double.isNaN(m6_8))) {
                my2_8 = (m6_8) + (m7_8) - (m5_8) - m2_[8] - mh_mm[8] - res90_m[8];
            }

            Double my2_9 = 0.0;
            if (!(Double.isNaN(m6_9))) {
                my2_9 = (m6_9) + (m7_9) - (m5_9) - m2_[9] - mh_mm[9] - res90_m[9];
            }

            Double my2_10 = 0.0;
            if (!(Double.isNaN(m6_10))) {
                my2_10 = (m6_10) + (m7_10) - (m5_10) - m2_[10] - mh_mm[10] - res90_m[10];
            }

            Double my2_11 = 0.0;
            if (!(Double.isNaN(m6_11))) {
                my2_11 = (m6_11) + (m7_11) - (m5_11) - m2_[11] - mh_mm[11] - res90_m[11];
            }

            Double my2_12 = 0.0;
            if (!(Double.isNaN(m6_12))) {
                my2_12 = (m6_12) + (m7_12) - (m5_12) - m2_[12] - mh_mm[12] - res90_m[12];
            }

            cell = row.createCell(3);
            cell.setCellValue(my1_1);
            cell = row.createCell(5);
            cell.setCellValue(my1_2);
            cell = row.createCell(7);
            cell.setCellValue(my1_3);
            cell = row.createCell(9);
            cell.setCellValue(my1_4);
            cell = row.createCell(11);
            cell.setCellValue(my1_5);
            cell = row.createCell(13);
            cell.setCellValue(my1_6);
            cell = row.createCell(15);
            cell.setCellValue(my1_7);
            cell = row.createCell(17);
            cell.setCellValue(my1_8);
            cell = row.createCell(19);
            cell.setCellValue(my1_9);

            cell = row.createCell(21);
            cell.setCellValue(my1_10);
            cell = row.createCell(23);
            cell.setCellValue(my1_11);
            cell = row.createCell(25);
            cell.setCellValue(my1_12);

            row = sheet.createRow(31);
            for (int i = 0; i <= 25; i++) {
                cell = row.createCell(i);
                cell.setCellStyle(style2);
            }

            row = sheet.createRow(32);
            cell = row.createCell(0);
            cell.setCellValue(" Məhkəmə İşləri ");
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue("Yanvar");
            cell.setCellStyle(style);
            cell = row.createCell(4);
            cell.setCellValue("Fevral");
            cell.setCellStyle(style);
            cell = row.createCell(6);
            cell.setCellValue("Mart");
            cell.setCellStyle(style);
            cell = row.createCell(8);
            cell.setCellValue("Aprel");
            cell.setCellStyle(style);
            cell = row.createCell(10);
            cell.setCellValue("May");
            cell.setCellStyle(style);
            cell = row.createCell(12);
            cell.setCellValue("Iyun");
            cell.setCellStyle(style);
            cell = row.createCell(14);
            cell.setCellValue("Iyul");
            cell.setCellStyle(style);
            cell = row.createCell(16);
            cell.setCellValue("Avqust");
            cell.setCellStyle(style);
            cell = row.createCell(18);
            cell.setCellValue("Sentyabr");
            cell.setCellStyle(style);
            cell = row.createCell(20);
            cell.setCellValue("Oktyabr");
            cell.setCellStyle(style);
            cell = row.createCell(22);
            cell.setCellValue("Noyabr");
            cell.setCellStyle(style);
            cell = row.createCell(24);
            cell.setCellValue("Dekabr");
            cell.setCellStyle(style);
            row = sheet.createRow(33);
            c = 0;
            d = 1;
            for (int i = 1; i <= 12; i++) {
                c = c + 2;
                d = d + 2;
                cell = row.createCell(c);
                cell.setCellValue("Say");
                cell = row.createCell(d);
                cell.setCellValue("Məbləğ");
            }
            row = sheet.createRow(34);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün əvvəlinə qalıq");

            cell = row.createCell(2);
            cell.setCellValue(x[1]);
            cell = row.createCell(4);
            cell.setCellValue(x[2]);
            cell = row.createCell(6);
            cell.setCellValue(x[3]);
            cell = row.createCell(8);
            cell.setCellValue(x[4]);
            cell = row.createCell(10);
            cell.setCellValue(x[5]);
            cell = row.createCell(12);
            cell.setCellValue(x[6]);
            cell = row.createCell(14);
            cell.setCellValue(x[7]);
            cell = row.createCell(16);
            cell.setCellValue(x[8]);
            cell = row.createCell(18);
            cell.setCellValue(x[9]);
            cell = row.createCell(20);
            cell.setCellValue(x[10]);
            cell = row.createCell(22);
            cell.setCellValue(x[11]);
            cell = row.createCell(24);
            cell.setCellValue(x[12]);

            cell = row.createCell(3);
            cell.setCellValue(xm[1]);
            cell = row.createCell(5);
            cell.setCellValue(xm[2]);
            cell = row.createCell(7);
            cell.setCellValue(xm[3]);
            cell = row.createCell(9);
            cell.setCellValue(xm[4]);
            cell = row.createCell(11);
            cell.setCellValue(xm[5]);
            cell = row.createCell(13);
            cell.setCellValue(xm[6]);
            cell = row.createCell(15);
            cell.setCellValue(xm[7]);
            cell = row.createCell(17);
            cell.setCellValue(xm[8]);
            cell = row.createCell(19);
            cell.setCellValue(xm[9]);
            cell = row.createCell(21);
            cell.setCellValue(xm[10]);
            cell = row.createCell(23);
            cell.setCellValue(xm[11]);
            cell = row.createCell(25);
            cell.setCellValue(xm[12]);

            row = sheet.createRow(35);
            cell = row.createCell(1);
            cell.setCellValue("Dövr ərzində əlavə olunmuş");

            cell = row.createCell(2);
            cell.setCellValue(xx[1]);
            cell = row.createCell(4);
            cell.setCellValue(xx[2]);
            cell = row.createCell(6);
            cell.setCellValue(xx[3]);
            cell = row.createCell(8);
            cell.setCellValue(xx[4]);
            cell = row.createCell(10);
            cell.setCellValue(xx[5]);
            cell = row.createCell(12);
            cell.setCellValue(xx[6]);
            cell = row.createCell(14);
            cell.setCellValue(xx[7]);
            cell = row.createCell(16);
            cell.setCellValue(xx[8]);
            cell = row.createCell(18);
            cell.setCellValue(xx[9]);
            cell = row.createCell(20);
            cell.setCellValue(xx[10]);
            cell = row.createCell(22);
            cell.setCellValue(xx[11]);
            cell = row.createCell(24);
            cell.setCellValue(xx[12]);

            cell = row.createCell(3);
            cell.setCellValue(xmm[1]);
            cell = row.createCell(5);
            cell.setCellValue(xmm[2]);
            cell = row.createCell(7);
            cell.setCellValue(xmm[3]);
            cell = row.createCell(9);
            cell.setCellValue(xmm[4]);
            cell = row.createCell(11);
            cell.setCellValue(xmm[5]);
            cell = row.createCell(13);
            cell.setCellValue(xmm[6]);
            cell = row.createCell(15);
            cell.setCellValue(xmm[7]);
            cell = row.createCell(17);
            cell.setCellValue(xmm[8]);
            cell = row.createCell(19);
            cell.setCellValue(xmm[9]);
            cell = row.createCell(21);
            cell.setCellValue(xmm[10]);
            cell = row.createCell(23);
            cell.setCellValue(xmm[11]);
            cell = row.createCell(25);
            cell.setCellValue(xmm[12]);

            row = sheet.createRow(36);
            cell = row.createCell(1);
            cell.setCellValue("Məhkəmə qərarları alınmış");
            cell.setCellStyle(style3);

            cell = row.createCell(2);
            cell.setCellValue(xe[1]);
            cell.setCellStyle(style3);
            cell = row.createCell(4);
            cell.setCellValue(xe[2]);
            cell.setCellStyle(style3);
            cell = row.createCell(6);
            cell.setCellValue(xe[3]);
            cell.setCellStyle(style3);
            cell = row.createCell(8);
            cell.setCellValue(xe[4]);
            cell.setCellStyle(style3);
            cell = row.createCell(10);
            cell.setCellValue(xe[5]);
            cell.setCellStyle(style3);
            cell = row.createCell(12);
            cell.setCellValue(xe[6]);
            cell.setCellStyle(style3);
            cell = row.createCell(14);
            cell.setCellValue(xe[7]);
            cell.setCellStyle(style3);
            cell = row.createCell(16);
            cell.setCellValue(xe[8]);
            cell.setCellStyle(style3);
            cell = row.createCell(18);
            cell.setCellValue(xe[9]);
            cell.setCellStyle(style3);
            cell = row.createCell(20);
            cell.setCellValue(xe[10]);
            cell.setCellStyle(style3);
            cell = row.createCell(22);
            cell.setCellValue(xe[11]);
            cell.setCellStyle(style3);
            cell = row.createCell(24);
            cell.setCellValue(xe[12]);
            cell.setCellStyle(style3);

            cell = row.createCell(3);
            cell.setCellValue(xme[1]);
            cell.setCellStyle(style3);
            cell = row.createCell(5);
            cell.setCellValue(xme[2]);
            cell.setCellStyle(style3);
            cell = row.createCell(7);
            cell.setCellValue(xme[3]);
            cell.setCellStyle(style3);
            cell = row.createCell(9);
            cell.setCellValue(xme[4]);
            cell.setCellStyle(style3);
            cell = row.createCell(11);
            cell.setCellValue(xme[5]);
            cell.setCellStyle(style3);
            cell = row.createCell(13);
            cell.setCellValue(xme[6]);
            cell.setCellStyle(style3);
            cell = row.createCell(15);
            cell.setCellValue(xme[7]);
            cell.setCellStyle(style3);
            cell = row.createCell(17);
            cell.setCellValue(xme[8]);
            cell.setCellStyle(style3);
            cell = row.createCell(19);
            cell.setCellValue(xme[9]);
            cell.setCellStyle(style3);
            cell = row.createCell(21);
            cell.setCellValue(xme[10]);
            cell.setCellStyle(style3);
            cell = row.createCell(23);
            cell.setCellValue(xme[11]);
            cell.setCellStyle(style3);
            cell = row.createCell(25);
            cell.setCellValue(xme[12]);
            cell.setCellStyle(style3);

            row = sheet.createRow(37);
            cell = row.createCell(1);
            cell.setCellValue("Dövr ərzində ödənilmiş");
            cell.setCellStyle(style1);

            cell = row.createCell(2);
            cell.setCellValue(xf[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(4);
            cell.setCellValue(xf[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(6);
            cell.setCellValue(xf[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(8);
            cell.setCellValue(xf[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(10);
            cell.setCellValue(xf[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(12);
            cell.setCellValue(xf[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(14);
            cell.setCellValue(xf[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(16);
            cell.setCellValue(xf[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(18);
            cell.setCellValue(xf[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(20);
            cell.setCellValue(xf[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(22);
            cell.setCellValue(xf[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(24);
            cell.setCellValue(xf[12]);
            cell.setCellStyle(style1);

            cell = row.createCell(3);
            cell.setCellValue(xmf[1]);
            cell.setCellStyle(style1);
            cell = row.createCell(5);
            cell.setCellValue(xmf[2]);
            cell.setCellStyle(style1);
            cell = row.createCell(7);
            cell.setCellValue(xmf[3]);
            cell.setCellStyle(style1);
            cell = row.createCell(9);
            cell.setCellValue(xmf[4]);
            cell.setCellStyle(style1);
            cell = row.createCell(11);
            cell.setCellValue(xmf[5]);
            cell.setCellStyle(style1);
            cell = row.createCell(13);
            cell.setCellValue(xmf[6]);
            cell.setCellStyle(style1);
            cell = row.createCell(15);
            cell.setCellValue(xmf[7]);
            cell.setCellStyle(style1);
            cell = row.createCell(17);
            cell.setCellValue(xmf[8]);
            cell.setCellStyle(style1);
            cell = row.createCell(19);
            cell.setCellValue(xmf[9]);
            cell.setCellStyle(style1);
            cell = row.createCell(21);
            cell.setCellValue(xmf[10]);
            cell.setCellStyle(style1);
            cell = row.createCell(23);
            cell.setCellValue(xmf[11]);
            cell.setCellStyle(style1);
            cell = row.createCell(25);
            cell.setCellValue(xmf[12]);
            cell.setCellStyle(style1);

            row = sheet.createRow(38);
            cell = row.createCell(1);
            cell.setCellValue("Dövrün sonuna qalıq");

            cell = row.createCell(2);
            cell.setCellValue((x[1]) + (xx[1]) - (xf[1]));
            cell = row.createCell(4);
            cell.setCellValue((x[2]) + (xx[2]) - (xf[2]));
            cell = row.createCell(6);
            cell.setCellValue((x[3]) + (xx[3]) - (xf[3]));
            cell = row.createCell(8);
            cell.setCellValue((x[4]) + (xx[4]) - (xf[4]));
            cell = row.createCell(10);
            cell.setCellValue((x[5]) + (xx[5]) - (xf[5]));
            cell = row.createCell(12);
            cell.setCellValue((x[6]) + (xx[6]) - (xf[6]));
            cell = row.createCell(14);
            cell.setCellValue((x[7]) + (xx[7]) - (xf[7]));
            cell = row.createCell(16);
            cell.setCellValue((x[8]) + (xx[8]) - (xf[8]));
            cell = row.createCell(18);
            cell.setCellValue((x[9]) + (xx[9]) - (xf[9]));
            cell = row.createCell(20);
            cell.setCellValue((x[10]) + (xx[10]) - (xf[10]));
            cell = row.createCell(22);
            cell.setCellValue((x[11]) + (xx[11]) - (xf[11]));
            cell = row.createCell(24);
            cell.setCellValue((x[12]) + (xx[12]) - (xf[12]));

            cell = row.createCell(3);
            cell.setCellValue(xm[1] + xmm[1] - xmf[1]);
            cell = row.createCell(5);
            cell.setCellValue(xm[2] + xmm[2] - xmf[2]);
            cell = row.createCell(7);
            cell.setCellValue(xm[3] + xmm[3] - xmf[3]);
            cell = row.createCell(9);
            cell.setCellValue(xm[4] + xmm[4] - xmf[4]);
            cell = row.createCell(11);
            cell.setCellValue(xm[5] + xmm[5] - xmf[5]);
            cell = row.createCell(13);
            cell.setCellValue(xm[6] + xmm[6] - xmf[6]);
            cell = row.createCell(15);
            cell.setCellValue(xm[7] + xmm[7] - xmf[7]);
            cell = row.createCell(17);
            cell.setCellValue(xm[8] + xmm[8] - xmf[8]);
            cell = row.createCell(19);
            cell.setCellValue(xm[9] + xmm[9] - xmf[9]);
            cell = row.createCell(21);
            cell.setCellValue(xm[10] + xmm[10] - xmf[10]);
            cell = row.createCell(23);
            cell.setCellValue(xm[11] + xmm[11] - xmf[11]);
            cell = row.createCell(25);
            cell.setCellValue(xm[12] + xmm[12] - xmf[12]);

            row = sheet.createRow(39);
            for (int i = 0; i <= 25; i++) {
                cell = row.createCell(i);
                cell.setCellStyle(style2);
            }

            row = sheet.createRow(40);
            cell = row.createCell(0);
            cell.setCellValue(" Ödənişlər ");
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue("Yanvar");
            cell.setCellStyle(style);
            cell = row.createCell(4);
            cell.setCellValue("Fevral");
            cell.setCellStyle(style);
            cell = row.createCell(6);
            cell.setCellValue("Mart");
            cell.setCellStyle(style);
            cell = row.createCell(8);
            cell.setCellValue("Aprel");
            cell.setCellStyle(style);
            cell = row.createCell(10);
            cell.setCellValue("May");
            cell.setCellStyle(style);
            cell = row.createCell(12);
            cell.setCellValue("Iyun");
            cell.setCellStyle(style);
            cell = row.createCell(14);
            cell.setCellValue("Iyul");
            cell.setCellStyle(style);
            cell = row.createCell(16);
            cell.setCellValue("Avqust");
            cell.setCellStyle(style);
            cell = row.createCell(18);
            cell.setCellValue("Sentyabr");
            cell.setCellStyle(style);
            cell = row.createCell(20);
            cell.setCellValue("Oktyabr");
            cell.setCellStyle(style);
            cell = row.createCell(22);
            cell.setCellValue("Noyabr");
            cell.setCellStyle(style);
            cell = row.createCell(24);
            cell.setCellValue("Dekabr");
            cell.setCellStyle(style);
            row = sheet.createRow(41);
            c = 0;
            d = 1;
            for (int i = 1; i <= 12; i++) {
                c = c + 2;
                d = d + 2;
                cell = row.createCell(c);
                cell.setCellValue("Say");
                cell = row.createCell(d);
                cell.setCellValue("Məbləğ");
            }
            row = sheet.createRow(42);
            cell = row.createCell(1);
            cell.setCellValue("Filialın işçiləri");
            cell = row.createCell(2);
            cell.setCellValue(dd[1]);
            cell = row.createCell(4);
            cell.setCellValue(dd[2]);
            cell = row.createCell(6);
            cell.setCellValue(dd[3]);
            cell = row.createCell(8);
            cell.setCellValue(dd[4]);
            cell = row.createCell(10);
            cell.setCellValue(dd[5]);
            cell = row.createCell(12);
            cell.setCellValue(dd[6]);
            cell = row.createCell(14);
            cell.setCellValue(dd[7]);
            cell = row.createCell(16);
            cell.setCellValue(dd[8]);
            cell = row.createCell(18);
            cell.setCellValue(dd[9]);
            cell = row.createCell(20);
            cell.setCellValue(dd[10]);
            cell = row.createCell(22);
            cell.setCellValue(dd[11]);
            cell = row.createCell(24);
            cell.setCellValue(dd[12]);

            cell = row.createCell(3);
            cell.setCellValue(dm[1]);
            cell = row.createCell(5);
            cell.setCellValue(dm[2]);
            cell = row.createCell(7);
            cell.setCellValue(dm[3]);
            cell = row.createCell(9);
            cell.setCellValue(dm[4]);
            cell = row.createCell(11);
            cell.setCellValue(dm[5]);
            cell = row.createCell(13);
            cell.setCellValue(dm[6]);
            cell = row.createCell(15);
            cell.setCellValue(dm[7]);
            cell = row.createCell(17);
            cell.setCellValue(dm[8]);
            cell = row.createCell(19);
            cell.setCellValue(dm[9]);
            cell = row.createCell(21);
            cell.setCellValue(dm[10]);
            cell = row.createCell(23);
            cell.setCellValue(dm[11]);
            cell = row.createCell(25);
            cell.setCellValue(dm[12]);

            row = sheet.createRow(43);
            cell = row.createCell(1);
            cell.setCellValue(" PKŞ ");
            cell = row.createCell(2);
            cell.setCellValue(d1d[1]);
            cell = row.createCell(4);
            cell.setCellValue(d1d[2]);
            cell = row.createCell(6);
            cell.setCellValue(d1d[3]);
            cell = row.createCell(8);
            cell.setCellValue(d1d[4]);
            cell = row.createCell(10);
            cell.setCellValue(d1d[5]);
            cell = row.createCell(12);
            cell.setCellValue(d1d[6]);
            cell = row.createCell(14);
            cell.setCellValue(d1d[7]);
            cell = row.createCell(16);
            cell.setCellValue(d1d[8]);
            cell = row.createCell(18);
            cell.setCellValue(d1d[9]);
            cell = row.createCell(20);
            cell.setCellValue(d1d[10]);
            cell = row.createCell(22);
            cell.setCellValue(d1d[11]);
            cell = row.createCell(24);
            cell.setCellValue(d1d[12]);

            cell = row.createCell(3);
            cell.setCellValue(d1m[1]);
            cell = row.createCell(5);
            cell.setCellValue(d1m[2]);
            cell = row.createCell(7);
            cell.setCellValue(d1m[3]);
            cell = row.createCell(9);
            cell.setCellValue(d1m[4]);
            cell = row.createCell(11);
            cell.setCellValue(d1m[5]);
            cell = row.createCell(13);
            cell.setCellValue(d1m[6]);
            cell = row.createCell(15);
            cell.setCellValue(d1m[7]);
            cell = row.createCell(17);
            cell.setCellValue(d1m[8]);
            cell = row.createCell(19);
            cell.setCellValue(d1m[9]);
            cell = row.createCell(21);
            cell.setCellValue(d1m[10]);
            cell = row.createCell(23);
            cell.setCellValue(d1m[11]);
            cell = row.createCell(25);
            cell.setCellValue(d1m[12]);
            row = sheet.createRow(44);
            cell = row.createCell(1);
            cell.setCellValue(" Hüquq Departamenti (məhkəmə yolu ilə) ");
            cell = row.createCell(2);
            cell.setCellValue(d2d[1]);
            cell = row.createCell(4);
            cell.setCellValue(d2d[2]);
            cell = row.createCell(6);
            cell.setCellValue(d2d[3]);
            cell = row.createCell(8);
            cell.setCellValue(d2d[4]);
            cell = row.createCell(10);
            cell.setCellValue(d2d[5]);
            cell = row.createCell(12);
            cell.setCellValue(d2d[6]);
            cell = row.createCell(14);
            cell.setCellValue(d2d[7]);
            cell = row.createCell(16);
            cell.setCellValue(d2d[8]);
            cell = row.createCell(18);
            cell.setCellValue(d2d[9]);
            cell = row.createCell(20);
            cell.setCellValue(d2d[10]);
            cell = row.createCell(22);
            cell.setCellValue(d2d[11]);
            cell = row.createCell(24);
            cell.setCellValue(d2d[12]);

            cell = row.createCell(3);
            cell.setCellValue(d2m[1]);
            cell = row.createCell(5);
            cell.setCellValue(d2m[2]);
            cell = row.createCell(7);
            cell.setCellValue(d2m[3]);
            cell = row.createCell(9);
            cell.setCellValue(d2m[4]);
            cell = row.createCell(11);
            cell.setCellValue(d2m[5]);
            cell = row.createCell(13);
            cell.setCellValue(d2m[6]);
            cell = row.createCell(15);
            cell.setCellValue(d2m[7]);
            cell = row.createCell(17);
            cell.setCellValue(d2m[8]);
            cell = row.createCell(19);
            cell.setCellValue(d2m[9]);
            cell = row.createCell(21);
            cell.setCellValue(d2m[10]);
            cell = row.createCell(23);
            cell.setCellValue(d2m[11]);
            cell = row.createCell(25);
            cell.setCellValue(d2m[12]);

            int a1 = 0;
            int b = 1;
            for (int i = 1; i <= 12; i++) {
                a1 = a1 + 2;
                b = b + 2;
                sheet.addMergedRegion(new CellRangeAddress(
                        0, //first row (0-based)
                        0, //last row  (0-based)
                        a1, //first column (0-based)
                        b //last column  (0-based)
                ));
            }
            a1 = 0;
            b = 1;
            for (int i = 1; i <= 12; i++) {
                a1 = a1 + 2;
                b = b + 2;
                sheet.addMergedRegion(new CellRangeAddress(
                        10, //first row (0-based)
                        10, //last row  (0-based)
                        a1, //first column (0-based)
                        b //last column  (0-based)
                ));
            }
            a1 = 0;
            b = 1;
            for (int i = 1; i <= 12; i++) {
                a1 = a1 + 2;
                b = b + 2;
                sheet.addMergedRegion(new CellRangeAddress(
                        22, //first row (0-based)
                        22, //last row  (0-based)
                        a1, //first column (0-based)
                        b //last column  (0-based)
                ));
            }
            a1 = 0;
            b = 1;
            for (int i = 1; i <= 12; i++) {
                a1 = a1 + 2;
                b = b + 2;
                sheet.addMergedRegion(new CellRangeAddress(
                        32, //first row (0-based)
                        32, //last row  (0-based)
                        a1, //first column (0-based)
                        b //last column  (0-based)
                ));
            }

            sheet.addMergedRegion(new CellRangeAddress(
                    0, //first row (0-based)
                    8, //last row  (0-based)
                    0, //first column (0-based)
                    0 //last column  (0-based)
            ));

            sheet.addMergedRegion(new CellRangeAddress(
                    10, //first row (0-based)
                    20, //last row  (0-based)
                    0, //first column (0-based)
                    0 //last column  (0-based)
            ));

            sheet.addMergedRegion(new CellRangeAddress(
                    22, //first row (0-based)
                    30, //last row  (0-based)
                    0, //first column (0-based)
                    0 //last column  (0-based)
            ));

            sheet.addMergedRegion(new CellRangeAddress(
                    32, //first row (0-based)
                    38, //last row  (0-based)
                    0, //first column (0-based)
                    0 //last column  (0-based)
            ));

            sheet.addMergedRegion(new CellRangeAddress(
                    40, //first row (0-based)
                    44, //last row  (0-based)
                    0, //first column (0-based)
                    0 //last column  (0-based)
            ));

            workbook.write(os);

        } catch (Exception e) {

            e.printStackTrace();
        } finally {
            //   workbook.addOlePackage(null, null, null, null)
            rs.close();

            stmt.close();

            conn.close();
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
            try {
                processRequest(request, response);
            } catch (ParseException ex) {
                Logger.getLogger(FilialPastDueExcel.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(FilialPastDueExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(FilialPastDueExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            try {
                processRequest(request, response);
            } catch (ParseException ex) {
                Logger.getLogger(FilialPastDueExcel.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(FilialPastDueExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(FilialPastDueExcel.class.getName()).log(Level.SEVERE, null, ex);
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
