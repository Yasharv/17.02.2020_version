/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.DottedLineSeparator;
import com.itextpdf.text.pdf.draw.LineSeparator;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "Print2PDF", urlPatterns = {"/Print2PDF"})
public class Print2PDF extends HttpServlet {

    String repLang;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, DocumentException, SQLException, ParseException {
        response.setHeader("Content-Disposition", "attachment;filename=HesabdanCixarish.pdf");
        response.setContentType("application/pdf");
        OutputStream os = response.getOutputStream();
        try {
            int turnover = 1;
            String SqlQuery = request.getParameter("pdfSql");
          //  System.out.println("SqlQuery "+SqlQuery);
            if (request.getParameter("turnover").equals("0")) {
                turnover = 0;
            }
           // System.out.println("turnover "+turnover);
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String reval = request.getParameter("reval");
            String salary_gr = request.getParameter("salary_gr");
            repLang=request.getParameter("repLang");
            // System.out.println("salary_gr "+salary_gr);
            DB db = new DB();
            Connection conn = db.connect();
            SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
            // SimpleDateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
            DecimalFormat twoDForm = new DecimalFormat("0.00");

            Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SqlQuery);

            Document document = new Document();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = PdfWriter.getInstance(document, baos);

            document.open();
            String acc_no = "";
            String AccMaxDate = "";
            Statement stmt2 = conn.createStatement();

            boolean insurance = false;
            if ((request.getParameter("sigorta") != null) & (!(request.getParameter("sigorta").equals("")))) {
                insurance = true;
            }

            String TrType = "";

            if (reval == null || reval.equals("") || reval.equals("null")) {
                TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
            } else if (Integer.parseInt(reval) == 0) {
                TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
            } else if (Integer.parseInt(reval) == 1) {
                TrType = " ";
            }

            String view = "";
            if (salary_gr.equals("1")) {

                view = "  vi_transaction_acc_salary ";

            } else {

                view = " vi_transaction_account ";
            }

            String SqlCount = "";

            while (sqlres.next()) {
                acc_no = sqlres.getString(2);
                AccMaxDate = df.format(sqlres.getDate(1));

                if (turnover == 1) {
                    SqlCount = "select count(*) cnt from " + view + " where "
                            + "(acct_no_dt = '" + acc_no + "' or acct_no_cr='" + acc_no + "')"
                            + " and (tarix BETWEEN to_date('" + DateB + "','dd-mm-yyyy') "
                            + " AND to_date('" + DateE + "','dd-mm-yyyy')) " + TrType;

                    ResultSet sqlTrCnt = stmt2.executeQuery(SqlCount);
                    
                    System.out.println("SqlCount "+SqlCount);

                    while (sqlTrCnt.next()) {
                        if (sqlTrCnt.getInt(1) > 0) {
                            AddTrByAccNo(document, writer, acc_no, DateB, DateE, AccMaxDate, insurance, salary_gr);
                            document.newPage();
                        }

                    }
                    sqlTrCnt.close();
                } else {
                    
                  
                    AddTrByAccNo(document, writer, acc_no, DateB, DateE, AccMaxDate, insurance, salary_gr);
                    document.newPage();
                }
            }
            document.close();

            response.setHeader("Expires", "0");
            response.setHeader("Cache-Control",
                    "must-revalidate, post-check=0, pre-check=0");
            response.setHeader("Pragma", "public");
            // setting the content type
            response.setContentType("application/pdf");
            // the contentlength
            response.setContentLength(baos.size());
            // write ByteArrayOutputStream to the ServletOutputStream
            baos.writeTo(os);

            sqlres.close();
            stmt.close();
            stmt2.close();
            conn.close();
            // out.println(os);

        } finally {
            os.flush();
            os.close();
        }
    }

    public void AddTrByAccNo(Document document, PdfWriter writer, String acc_no, String DateB, String DateE, String AccMaxDate, boolean insurance, String salary_gr) throws DocumentException, IOException, SQLException, ClassNotFoundException, ParseException {
        Font font = new Font(Font.FontFamily.TIMES_ROMAN, 9);
        try {
            BaseFont arial = BaseFont.createFont("/tsm/DWHReports/Fonts/Arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            //    BaseFont arial = BaseFont.createFont("C:/Windows/Fonts/Arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            font = new Font(
                    arial, 9, Font.NORMAL, BaseColor.BLACK);

            // 2  Image img = Image.getInstance("C:/logo.jpg");
            Image img = Image.getInstance("/tsm/DWHReports/images/logo.jpg");
            img.scaleToFit(700, 60);
            img.setAbsolutePosition(470, 780);
            writer.getDirectContent().addImage(img);
        } catch (Exception ex) {
            //       System.out.println("Exception in Print2PDF; Method: AddTrByAccNo: "+ex.toString());
        }

        DB db = new DB();
        Connection conn = db.connect();
        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
        //SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        DecimalFormat twoDForm = new DecimalFormat("0.00");

        String view = "";
        if (salary_gr.equals("1")) {

            view = "  vi_transaction_acc_salary ";

        } else {

            view = " vi_transaction_account ";
        }

        String teyinatSQL = "payment_purpose";
        if (insurance) {
            teyinatSQL = "  (get_desc_for_inshurance(a.payment_purpose)||' '||GET_LAPNO_FOR_INSHURANCE(a.payment_purpose))  ";
        } else {
            teyinatSQL = "payment_purpose";
        }

        Statement stmtAccInfo = conn.createStatement();
        String SQLAccInfo = "SELECT alt_acct_id, account_title, customer_id, curr_name, currency_id, opening_date, gl_acct_no, ap, nvl(voen,' ')"
                + " FROM vi_account_inf_bal where date_from=to_date('" + AccMaxDate + "','dd-mm-yyyy') and  alt_acct_id='" + acc_no + "'";
        System.out.println("SQLAccInfo "+SQLAccInfo);
        Statement stmt = conn.createStatement();
        String SQLText = "SELECT tarix,currency_cr_name qarshi_val,acct_no_cr qarshi_hesab, "
                + " ABS (DECODE (currency_dt_id - 944,0,tr_amount_fcy_cr ,tr_amount_fcy_dt)) AS D_Ammount,"
                + " abs(tr_amount_lcy_dt) as DL_Ammount,"
                + " 0 as C_Ammount,0 as cl_ammount ,"
                + teyinatSQL + ","
                + " currency_dt_id,currency_cr_id, currency_dt_id Hval "
                + " FROM " + view + " a  where "
                + " acct_no_dt = ('" + acc_no + "') and (tarix BETWEEN to_date('" + DateB + "','dd-mm-yyyy') AND to_date('" + DateE + "','dd-mm-yyyy'))"
                + " and transaction_type<>'REVAL'"
                + " union all"
                + " SELECT tarix,currency_dt_name qarshi_val,acct_no_dt qarshi_hesab, "
                + " 0 as D_Ammount,0 as DL_Ammount,"
                + " ABS (DECODE (currency_cr_id - 944,0,tr_amount_fcy_dt, tr_amount_fcy_cr)) AS C_Ammount,"
                + " abs(tr_amount_lcy_cr) as CL_Ammount,"
                + teyinatSQL + ","
                + " currency_dt_id,currency_cr_id, currency_cr_id Hval  "
                + " FROM " + view + " a  where"
                + " acct_no_cr = ('" + acc_no + "') and (tarix BETWEEN to_date('" + DateB + "','dd-mm-yyyy') AND to_date('" + DateE + "','dd-mm-yyyy'))"
                + " and transaction_type<>'REVAL'"
                + "  order by tarix";

         System.out.println("SQLText "+SQLText);
        ResultSet sqlres = stmt.executeQuery(SQLText);
        ResultSet sqlAccInfo = stmtAccInfo.executeQuery(SQLAccInfo);

        String Acc_OpenDate = "";
        String Acc_Name = "";
        String INN = "";
        String curr_name = "";

        Date BeginDate = df.parse(DateB);
        Date EndDate = df.parse(DateE);
        int CurrID = 0;
        String AcPs = "";
        while (sqlAccInfo.next()) {
            Acc_OpenDate = " (" + df.format(sqlAccInfo.getDate(6)) + ")";
            Acc_Name = sqlAccInfo.getString(2);
            INN = sqlAccInfo.getString(9);
            curr_name = sqlAccInfo.getString(4);
            CurrID = sqlAccInfo.getInt(5);
            AcPs = sqlAccInfo.getString(8);
        };

        Statement stmt2 = conn.createStatement();
        String SqlText2 = "";
        /*SELECT date_from,currency_id,al_type,balance_fcy_amount,balance_lcy_amount "
         + " FROM si_account_balance a where a.alt_acct_id='"+acc_no+"' and date_from="
         + " (SELECT  max(tarix) FROM   vi_transaction_account  WHERE   (acct_no_dt = '"+acc_no+"'"
         +     " OR acct_no_cr = '"+acc_no+"') AND tarix < TO_DATE ('"+DateB+"', 'dd-mm-yyyy'))";
         */
        SqlText2 = "SELECT (SELECT   MAX (t.act_date) from si_transaction_account_un t"
                + "  WHERE   (t.acct_no_dt = '" + acc_no + "'"
                + "           OR t.acct_no_cr = '" + acc_no + "')"
                + "           AND t.act_date < TO_DATE ('" + DateB + "', 'dd-mm-yyyy'))"
                + "    AS act_date1,a.currency_id,a.al_type,a.balance_fcy_amount,a.balance_lcy_amount"
                + " FROM   si_account_balance a"
                + " WHERE   a.alt_acct_id = '" + acc_no + "'"
                + "      AND (SELECT   MAX (t.act_date) FROM   si_transaction_account_un t"
                + " WHERE   (t.acct_no_dt = '" + acc_no + "'"
                + "                     OR t.acct_no_cr = '" + acc_no + "')"
                + "                    AND t.act_date < TO_DATE ('" + DateB + "', 'dd-mm-yyyy')) BETWEEN a.date_from AND  a.date_until";

        System.out.println("SqlText2 "+SqlText2);
        Statement stmt3 = conn.createStatement();
        String SqlText3 = "SELECT (SELECT   MAX (t.act_date) from si_transaction_account_un t"
                + "  WHERE   (t.acct_no_dt = '" + acc_no + "'"
                + "           OR t.acct_no_cr = '" + acc_no + "')"
                + "           AND t.act_date <= TO_DATE ('" + DateE + "', 'dd-mm-yyyy'))"
                + "    AS act_date1,a.currency_id,a.al_type,a.balance_fcy_amount,a.balance_lcy_amount"
                + " FROM   si_account_balance a"
                + " WHERE   a.alt_acct_id = '" + acc_no + "'"
                + "      AND (SELECT   MAX (t.act_date) FROM   si_transaction_account_un t"
                + " WHERE   (t.acct_no_dt = '" + acc_no + "'"
                + "                     OR t.acct_no_cr = '" + acc_no + "')"
                + "                    AND t.act_date <= TO_DATE ('" + DateE + "', 'dd-mm-yyyy')) BETWEEN a.date_from AND  a.date_until";
        /*"SELECT date_from,currency_id,al_type,balance_fcy_amount,balance_lcy_amount "
         + " FROM si_account_balance a where a.alt_acct_id='"+acc_no+"' and date_from="
         + " (SELECT  max(tarix) FROM   vi_transaction_account  WHERE   (acct_no_dt = '"+acc_no+"'"
         +     " OR acct_no_cr = '"+acc_no+"') AND tarix <= TO_DATE ('"+DateE+"', 'dd-mm-yyyy'))";*/
        //---------------------------------------------------------------------   
        
        System.out.println("SqlText3 "+SqlText3);
        Statement stmEXCRate = conn.createStatement();
        String SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                + " AND TO_DATE ('" + DateB + "','dd-mm-yyyy')-1 BETWEEN date_from AND date_until";
        System.out.println("SqlTextEXCRate "+SqlTextEXCRate);
        ResultSet sqlresEXCRate = stmEXCRate.executeQuery(SqlTextEXCRate);
        double EXC_RATE_B = 0;
        while (sqlresEXCRate.next()) {
            EXC_RATE_B = sqlresEXCRate.getDouble(1);
        }
        sqlresEXCRate.close();
        //  stmEXCRate.close();

        SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                + " AND TO_DATE ('" + DateE + "','dd-mm-yyyy') BETWEEN date_from AND date_until";
        System.out.println("SqlTextEXCRate "+SqlTextEXCRate);
        sqlresEXCRate = stmEXCRate.executeQuery(SqlTextEXCRate);

        double EXC_RATE_E = 0;
        while (sqlresEXCRate.next()) {
            EXC_RATE_E = sqlresEXCRate.getDouble(1);
        }
        sqlresEXCRate.close();
        stmEXCRate.close();
//----------------------------------------------------------------------
        String first_date = "";
        //int curr_id;
        String al_type = "";
        double first_ammount = 0;
        double first_Lammount = 0;
        String fAP = AcPs;
        String fAmmount = "";
        String fAmmount2 = "";
        String fExc = "";
        ResultSet sqlres2 = stmt2.executeQuery(SqlText2);
        while (sqlres2.next()) {
            first_date = df.format(sqlres2.getDate(1));
            //curr_id = sqlres2.getInt(2);
            al_type = sqlres2.getString(3);
            first_ammount = sqlres2.getDouble(4);
            first_Lammount = sqlres2.getDouble(5);
        }
        sqlres2.close();
        stmt2.close();
        if ((AcPs.equals("A")) && (first_Lammount > 0)) {
            fAP = "P";
        } else if ((AcPs.equals("P")) && (first_Lammount < 0)) {
            fAP = "A";
        }

        if (curr_name.equals("AZN")) {
            fAmmount = "Manat: " + twoDForm.format(Math.abs(first_Lammount));
        } else {
            fAmmount = "Valyuta: " + twoDForm.format(Math.abs(first_ammount));
            fAmmount2 = " Manat: " + twoDForm.format(Math.abs(first_Lammount));
            fExc = " Rəsmi məzənnə: " + EXC_RATE_B;

        }
        //---------------------------------------------------------------------  
        String last_date = "";
        // int curr_id;
        // String al_type = "";
        double last_ammount = 0;
        double last_Lammount = 0;
        String lAP = AcPs;
        String lAmmount = "";
        String lAmmount2 = "";
        String lExc = "";
        ResultSet sqlres3 = stmt3.executeQuery(SqlText3);
        while (sqlres3.next()) {
            // last_date = new SimpleDateFormat("dd-MM-yyyy").format(sqlres3.getDate(1));
            //curr_id = sqlres3.getInt(2);
            //al_type = sqlres3.getString(3);
            last_ammount = sqlres3.getDouble(4);
            last_Lammount = sqlres3.getDouble(5);
        }
        sqlres3.close();
        stmt3.close();
        if ((AcPs.equals("A")) && (last_Lammount > 0)) {
            lAP = "P";
        } else if ((AcPs.equals("P")) && (last_Lammount < 0)) {
            lAP = "A";
        }

        if (curr_name.equals("AZN")) {
            lAmmount = "Manat: " + twoDForm.format(Math.abs(last_Lammount));
        } else {
            lAmmount = "Valyuta: " + twoDForm.format(Math.abs(last_ammount));
            lAmmount2 = " Manat: " + twoDForm.format(Math.abs(last_Lammount));
            lExc = " Rəsmi məzənnə: " + EXC_RATE_E;
        }
        //---------------------------------------------------------------------  

        if (repLang.equals("ENG")){
                   document.add(new Chunk("                                                            "
                + "Account №:      " + acc_no + Acc_OpenDate, font));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Account name:                       " + Acc_Name, font));
        document.add(new Paragraph("VÖEN:                                " + INN, font));
        document.add(new Paragraph("Currency:                              " + curr_name, font));
        document.add(new Paragraph("Operation date:          " + df.format(BeginDate) + "  " + df.format(EndDate), font));
        document.add(new Paragraph("Previous operation date:     " + first_date, font));
        document.add(new Paragraph("Balance beginning of day:        " + fAmmount, font));
        }else{
        
                document.add(new Chunk("                                                            "
                + "Hesab №:      " + acc_no + Acc_OpenDate, font));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Hesabın adı:                       " + Acc_Name, font));
        document.add(new Paragraph("VÖEN:                                " + INN, font));
        document.add(new Paragraph("Valyuta:                              " + curr_name, font));
        document.add(new Paragraph("Əməliyyatların tarixi:          " + df.format(BeginDate) + "  " + df.format(EndDate), font));
        document.add(new Paragraph("Əvvəlki əməliyyat tarixi:     " + first_date, font));
        document.add(new Paragraph("Günün əvvəlinə qalıq:        " + fAmmount, font));
        }
        
        if (!(curr_name.equals("AZN"))) {
            document.add(new Paragraph("                                          " + fAmmount2, font));
            document.add(new Paragraph("                                          " + fExc, font));
        }
        Paragraph bankname = new Paragraph("                  \"Expressbank\" ASC", font);
        bankname.setAlignment(Element.ALIGN_CENTER);
        bankname.setSpacingBefore(0);
        bankname.setSpacingAfter(5);
        //paragraph.setIndentationLeft(50);
        document.add(bankname);

        Paragraph AP = new Paragraph("                  (" + fAP + ")", font);
        AP.setAlignment(Element.ALIGN_CENTER);
        AP.setSpacingBefore(5);
        AP.setSpacingAfter(5);
        //paragraph.setIndentationLeft(50);
        document.add(AP);

        Paragraph empty = new Paragraph("", font);
        empty.setAlignment(Element.ALIGN_CENTER);
        empty.setSpacingBefore(5);
        empty.setSpacingAfter(5);

        LineSeparator UNDERLINE = new LineSeparator(1, 100, null, Element.ALIGN_CENTER, -2);
        document.add(UNDERLINE);
        if (repLang.equals("ENG")){
        document.add(new Chunk("Date", font));
        document.add(new Chunk("               ", font));
        document.add(new Chunk("Currency", font));
        document.add(new Chunk("     ", font));
        document.add(new Chunk("Opposite account:", font));
        document.add(new Chunk("                                              ", font));

        document.add(new Chunk("Debit", font));
        document.add(new Chunk("        ", font));
        document.add(new Chunk("Credit", font));
        document.add(new Chunk("          ", font));
        document.add(new Chunk("Payment purpose", font));  
            
        }
        else{
        document.add(new Chunk("Tarix", font));
        document.add(new Chunk("               ", font));
        document.add(new Chunk("Val", font));
        document.add(new Chunk("     ", font));
        document.add(new Chunk("Qarşı hesab:", font));
        document.add(new Chunk("                                              ", font));

        document.add(new Chunk("Debet", font));
        document.add(new Chunk("        ", font));
        document.add(new Chunk("Kredit", font));
        document.add(new Chunk("          ", font));
        document.add(new Chunk("Təyinat", font));
        }
//------- emeliyyatlar 
        double dAmount = 0;
        double dLAmount = 0;

        double SumDAmount = 0;
        double SumDLAmount = 0;

        double cAmount = 0;
        double cLAmount = 0;

        double SumCAmount = 0;
        double SumCLAmount = 0;

        String Teyinat = "";
        String DAmount = "";
        String CAmount = "";
        String DLAmount = "";
        String CLAmount = "";
        String SummDAmount = "";
        String SummDLAmount = "";
        String SummCAmount = "";
        String SummCLAmount = "";

        int dCurrID = 0;
        int cCurrID = 0;
        int trCount = 0;
        int Hval = 0;

        while (sqlres.next()) {
            dAmount = sqlres.getDouble(4);
            dLAmount = sqlres.getDouble(5);
            cAmount = sqlres.getDouble(6);
            cLAmount = sqlres.getDouble(7);

            Teyinat = sqlres.getString(8);
            dCurrID = sqlres.getInt(9);
            cCurrID = sqlres.getInt(10);
            Hval = sqlres.getInt(11);

            SumDLAmount = SumDLAmount + dLAmount;
            SumDAmount = SumDAmount + dAmount;

            SumCLAmount = SumCLAmount + cLAmount;
            SumCAmount = SumCAmount + cAmount;

            if ((dCurrID == 944) && (cCurrID == 944)) {
                // DLAmount = String.valueOf(dLAmount);  
                DLAmount = String.valueOf(twoDForm.format(dLAmount));;
                CLAmount = String.valueOf(twoDForm.format(cLAmount));;
                SummDLAmount = String.valueOf(twoDForm.format(SumDLAmount));
                SummCLAmount = String.valueOf(twoDForm.format(SumCLAmount));
            } else {
                DLAmount = String.valueOf(twoDForm.format(dLAmount));
                DAmount = String.valueOf(twoDForm.format(dAmount));
                CLAmount = String.valueOf(twoDForm.format(cLAmount));
                CAmount = String.valueOf(twoDForm.format(cAmount));

                SummDAmount = String.valueOf(twoDForm.format(SumDAmount));
                SummDLAmount = String.valueOf(twoDForm.format(SumDLAmount));
                SummCAmount = String.valueOf(twoDForm.format(SumCAmount));
                SummCLAmount = String.valueOf(twoDForm.format(SumCLAmount));
            };
            PdfPTable table = new PdfPTable(6);
            table.setTotalWidth(525);
            table.setLockedWidth(true);
            table.setWidths(new float[]{1.5f, 0.7f, 4.3f, 1.5f, 1.5f, 5});
            PdfPCell cell;
            cell = new PdfPCell(new Phrase(df.format(sqlres.getDate(1)), font));
            cell.setBorder(0);
            table.addCell(cell);
            cell = new PdfPCell(new Phrase(sqlres.getString(2), font));
            cell.setBorder(0);
            table.addCell(cell);
            cell = new PdfPCell(new Phrase(sqlres.getString(3), font));
            cell.setBorder(0);
            table.addCell(cell);

            if (!((dCurrID == 944) && (cCurrID == 944))) {
                //  if (Hval==944)
                //  cell = new PdfPCell(new Phrase((DLAmount),font));
                //  else
                cell = new PdfPCell(new Phrase((DLAmount + "\n" + DAmount), font));
                //  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setBorder(0);
                table.addCell(cell);

                if (Hval == 944) {
                    cell = new PdfPCell(new Phrase((CLAmount), font));
                } else {
                    cell = new PdfPCell(new Phrase((CLAmount + "\n" + CAmount), font));
                }
                //   cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setBorder(0);
                table.addCell(cell);
            } else {
                cell = new PdfPCell(new Phrase(DLAmount, font));
                //  cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setBorder(0);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase(CLAmount, font));
                //   cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setBorder(0);
                table.addCell(cell);
            }

            cell = new PdfPCell(new Phrase(Teyinat, font));
            cell.setBorder(0);
            table.addCell(cell);

            document.add(table);
            trCount++;
        }
        sqlres.close();
        stmt.close();
        sqlAccInfo.close();
        stmtAccInfo.close();
        conn.close();
        //------- emeliyyatlar  
        document.add(empty);
        document.add(UNDERLINE);

        document.add(new Chunk("                                      "));
        document.add(new Chunk("                                    "));
        document.add(new Chunk(SummDLAmount + "      " + SummCLAmount, font));
        if (Hval != 944) {
            document.add(new Paragraph(new Chunk("                                                            "
                    + "                                       "
                    + SummDAmount + "      " + SummCAmount, font)));
        }

        Paragraph AP2;
        if(repLang.equals("ENG")){
           AP2 = new Paragraph("Balance end of day:     " + lAmmount, font); 
        }else{
           AP2 = new Paragraph("Günün sonuna qalıq:     " + lAmmount, font);
        }
       // Paragraph AP2 = new Paragraph("Günün sonuna qalıq:     " + lAmmount, font);
        AP2.add("                                                   ");
        AP2.add("(" + lAP + ")");
        AP2.setAlignment(Element.ALIGN_LEFT);
        AP2.setSpacingBefore(5);
        AP2.setSpacingAfter(0);
        //paragraph.setIndentationLeft(50);
        document.add(AP2);
        if (!(curr_name.equals("AZN"))) {
            document.add(new Paragraph("                                      " + lAmmount2, font));
            document.add(new Paragraph("                                      " + lExc, font));
        }

        Paragraph TrCnt;
        if(repLang.equals("ENG")){
        TrCnt =  new Paragraph("Documents count: " + trCount, font);
        }else{
        TrCnt =  new Paragraph("Sənədlərin sayı: " + trCount, font);
        }
           
       // Paragraph TrCnt = new Paragraph("Sənədlərin sayı: " + trCount, font);
        TrCnt.add("             ");
        TrCnt.setAlignment(Element.ALIGN_RIGHT);
        TrCnt.setSpacingBefore(0);
        TrCnt.setSpacingAfter(5);
        //paragraph.setIndentationLeft(50);
        document.add(TrCnt);

        Paragraph pend = new Paragraph("");
        pend.add(new DottedLineSeparator());
        document.add(pend);
        Paragraph emptyend = new Paragraph("", font);
        emptyend.setAlignment(Element.ALIGN_CENTER);
        emptyend.setSpacingBefore(15);
        emptyend.setSpacingAfter(15);
        document.add(emptyend);

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
                Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DocumentException ex) {
            Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DocumentException ex) {
            Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(Print2PDF.class.getName()).log(Level.SEVERE, null, ex);
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
