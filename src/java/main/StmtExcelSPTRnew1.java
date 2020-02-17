/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import beans.AccHistoryInfo;
import beans.ArrayOfStmtTransactions;
import beans.StmtDB_new;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "StmtExcelSTPRnew1", urlPatterns = {"/StmtExcelSTPRnew1"})
public class StmtExcelSPTRnew1 extends HttpServlet {

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
            throws ServletException, IOException {
        response.setHeader("Content-Disposition", "attachment;filename=HesabdanChixarish.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("Sheet1");
        System.out.println("stp excell");
        HSSFFont font = workbook.createFont();
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        font.setColor(HSSFColor.BLUE.index);
        HSSFCellStyle style = workbook.createCellStyle();
        style.setFont(font);

        HSSFFont font_tr = workbook.createFont();
        font_tr.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        font_tr.setColor(HSSFColor.GREEN.index);
        HSSFCellStyle style_tr = workbook.createCellStyle();
        style_tr.setFont(font_tr);

        HSSFFont font_amnt = workbook.createFont();
        font_amnt.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        HSSFCellStyle style_amnt = workbook.createCellStyle();
        style_amnt.setFont(font_amnt);

        Date d = new Date();
        DB db = new DB();
        PrDict dict = new PrDict();
        StmtDB_new stdb = new StmtDB_new();

        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");

        String s = df.format(d);

        String strDateB = request.getParameter("DateB");
        String strDateE = request.getParameter("DateE");
        String br = request.getParameter("br");
        String reval = request.getParameter("reval");
        String turnover = request.getParameter("turnover");
        String SqlAccs = request.getParameter("SqlAccs");
        String salary_gr = request.getParameter("salary_gr");

        boolean insurance = false;
        String insurance_pdf = "";
        if (!(request.getParameter("sigorta") == null || request.getParameter("sigorta").equals("null"))) {
            insurance = true;
            insurance_pdf = "1";
        }
        String TrType = "";

        if (reval == null || reval == "" || reval.equals("null")) {
            TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
        } else if (Integer.parseInt(reval) == 0) {
            TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
        } else if (Integer.parseInt(reval) == 1) {
            TrType = " ";
        }

        String custid = "";
        int cust_id = 0;

        Connection conn = null;
        Statement Accs = null;
        Statement stmt = null;
        ResultSet sqlresAccs = null;
        ResultSet sqlres = null;
        Statement stmt2 = null;
        ResultSet sqlTrCnt = null;

        Row row = null;
        Cell cell = null;
        try {
            conn = db.connect();
            Accs = conn.createStatement();
            stmt = conn.createStatement();
            sqlresAccs = Accs.executeQuery(SqlAccs);

            int chk = 0;
            int i = 0;

            while (sqlresAccs.next()) {

                String acc_no = sqlresAccs.getString(2);
                String acc_name = sqlresAccs.getString(5);
                custid = sqlresAccs.getString(3);
                cust_id = sqlresAccs.getInt(3);
                String curr_name = sqlresAccs.getString(6);
                int CurrID = sqlresAccs.getInt(7);
                String acc_open_date = df.format(sqlresAccs.getDate(8));
                String AP = sqlresAccs.getString(9);
                String cust_inn = sqlresAccs.getString(11);

                if (turnover.equals("1")) {
                    if (stdb.getTrCount(acc_no, strDateB, strDateE, TrType, salary_gr) > 0) {
                        AccHistoryInfo bahi = stdb.getAccBeginInf(acc_no, strDateB, AP);
                        AccHistoryInfo eahi = stdb.getAccEndInf(acc_no, strDateE, AP);
                        double EXC_RATE_B = stdb.getEXCRate(CurrID, strDateB);
                        double EXC_RATE_E = stdb.getEXCRate(CurrID, strDateE);
                        //----------------- hesab hisse
                        row = sheet.createRow(i);
                        cell = row.createCell(2);
                        cell.setCellValue("Hesab №");
                        cell.setCellStyle(style);
                        cell = row.createCell(3);
                        cell.setCellValue(acc_no);
                        cell.setCellStyle(style);
                        cell = row.createCell(4);
                        cell.setCellValue("(" + acc_open_date + ")");
                        cell.setCellStyle(style);

                        i = i + 2;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("Hesabın adı:");
                        cell = row.createCell(1);
                        cell.setCellValue(acc_name);
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("VÖEN:");
                        cell = row.createCell(1);
                        cell.setCellValue(cust_inn);
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("Valyuta:");
                        cell = row.createCell(1);
                        cell.setCellValue(curr_name);
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("Əməliyyatların tarixi:");
                        cell = row.createCell(1);
                        cell.setCellValue(strDateB + " - " + strDateE);
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("Əvvəlki əməliyyat tarixi: ");
                        cell = row.createCell(1);
                        cell.setCellValue(bahi.getFirst_date());
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("Günün əvvəlinə qalıq:");
                        cell = row.createCell(1);
                        if (curr_name.equals("AZN")) {
                            cell.setCellValue("Manat: " + Math.abs(bahi.getFirst_Lammount()));
                        } else {
                            cell.setCellValue("Valyuta: " + Math.abs(bahi.getFirst_ammount()));
                            i++;
                            row = sheet.createRow(i);
                            cell = row.createCell(1);
                            cell.setCellValue("Manat: " + Math.abs(bahi.getFirst_Lammount()));
                            i++;
                            row = sheet.createRow(i);
                            cell = row.createCell(1);
                            cell.setCellValue("Rəsmi məzənnə: " + EXC_RATE_B);

                        }
                        cell = row.createCell(2);
                        cell.setCellValue("\"Expressbank\" ASC" + dict.getFililal4Statm(Integer.parseInt(br)));

                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(2);
                        cell.setCellValue("(" + bahi.getfAP() + ")");

                        i = i + 2;
                        row = sheet.createRow(i);
                        cell = row.createCell(1);
                        cell.setCellValue("Tarix");
                        cell.setCellStyle(style_tr);
                        //--
                        cell = row.createCell(2);
                        cell.setCellValue("Val.");
                        cell.setCellStyle(style_tr);
                        //--
                        cell = row.createCell(3);
                        cell.setCellValue("Qarşı hesab");
                        cell.setCellStyle(style_tr);
                        //--
                        cell = row.createCell(4);
                        cell.setCellValue("Göndərən/Alan Şirkət");
                        cell.setCellStyle(style_tr);
                        //--
                        cell = row.createCell(5);
                        cell.setCellValue("Debet");
                        cell.setCellStyle(style_tr);
                        //--
                        cell = row.createCell(7);
                        cell.setCellValue("Kredit");
                        cell.setCellStyle(style_tr);
                        //--
                        cell = row.createCell(9);
                        cell.setCellValue("Təyinat");
                        cell.setCellStyle(style_tr);
                        //-------------------- emeliyyatlar hissesi
                        i++;
                        ArrayOfStmtTransactions aost = stdb.getTransactionsSTPR(acc_no, strDateB, strDateE, TrType, insurance, salary_gr);
                        int trCount = aost.getStmttransactions().size();
                        int cem_setr = 0;
                        cem_setr = i + 2;
                        for (int j = 0; j < trCount; j++) {
                            i++;
                            row = sheet.createRow(i);
                            //--
                            cell = row.createCell(1);
                            cell.setCellValue(aost.getStmttransactions().get(j).getTarix());
                            //--
                            cell = row.createCell(2);
                            cell.setCellValue(aost.getStmttransactions().get(j).getValyuta());
                            //--
                            cell = row.createCell(3);
                            cell.setCellValue(aost.getStmttransactions().get(j).getAccount());
                            //--
                            cell = row.createCell(4);
                            cell.setCellValue(aost.getStmttransactions().get(j).getsendAndRecei());
                            //--
                            cell = row.createCell(5);
                            cell.setCellValue(aost.getStmttransactions().get(j).getDebtAmount());
                            //--
                            if (aost.getStmttransactions().get(j).getDLAmount() != 0.0) {
                                cell = row.createCell(6);
                                cell.setCellValue(aost.getStmttransactions().get(j).getDLAmount());
                                cell.setCellStyle(style_amnt);
                            }
                            cell = row.createCell(7);
                            cell.setCellValue(aost.getStmttransactions().get(j).getCredAmount());
                            if (aost.getStmttransactions().get(j).getCLAmount() != 0.0) {
                                cell = row.createCell(8);
                                cell.setCellValue(aost.getStmttransactions().get(j).getCLAmount());
                                cell.setCellStyle(style_amnt);
                            }
                            cell = row.createCell(9);
                            cell.setCellValue(aost.getStmttransactions().get(j).getTeyinat() + aost.getStmttransactions().get(j).getLapNo());

                        }
                        // ----------------cem hisse
                        i = i + 2;
                        row = sheet.createRow(i);
                        if (cem_setr != 0) {
                            cell = row.createCell(4);
                            cell.setCellFormula("SUM(E" + cem_setr + ":E" + (i - 1) + ")");
                            cell = row.createCell(5);
                            cell.setCellFormula("SUM(F" + cem_setr + ":F" + (i - 1) + ")");
                            cell.setCellStyle(style_amnt);
                            cell = row.createCell(6);
                            cell.setCellFormula("SUM(G" + cem_setr + ":G" + (i - 1) + ")");
                            cell = row.createCell(7);
                            cell.setCellFormula("SUM(H" + cem_setr + ":H" + (i - 1) + ")");
                            cell.setCellStyle(style_amnt);
                        }
                        //-------------------- emeliyyatlar hissesinin sonu    
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(0);
                        cell.setCellValue("Günün sonuna qalıq:");
                        cell = row.createCell(1);
                        if (curr_name.equals("AZN")) {
                            cell.setCellValue("Manat: " + Math.abs(eahi.getFirst_Lammount()));
                        } else {
                            cell.setCellValue("Valyuta: " + Math.abs(eahi.getFirst_ammount()));
                            i++;
                            row = sheet.createRow(i);
                            cell = row.createCell(1);
                            cell.setCellValue("Manat: " + Math.abs(eahi.getFirst_Lammount()));
                            i++;
                            row = sheet.createRow(i);
                            cell = row.createCell(1);
                            cell.setCellValue("Rəsmi məzənnə: " + EXC_RATE_E);

                        }
                        cell = row.createCell(2);
                        cell.setCellValue("(" + eahi.getfAP() + ")");
                        cell = row.createCell(3);
                        cell.setCellValue("Sənədlərin sayı: " + trCount);

                        chk = 1;
                        i = i + 3;
                    }

                } else {
                    AccHistoryInfo bahi = stdb.getAccBeginInf(acc_no, strDateB, AP);
                    AccHistoryInfo eahi = stdb.getAccEndInf(acc_no, strDateE, AP);
                    double EXC_RATE_B = stdb.getEXCRate(CurrID, strDateB);
                    double EXC_RATE_E = stdb.getEXCRate(CurrID, strDateE);
                    //----------------- hesab hisse
                    row = sheet.createRow(i);
                    cell = row.createCell(2);
                    cell.setCellValue("Hesab №");
                    cell.setCellStyle(style);
                    cell = row.createCell(3);
                    cell.setCellValue(acc_no);
                    cell.setCellStyle(style);
                    cell = row.createCell(4);
                    cell.setCellValue("(" + acc_open_date + ")");
                    cell.setCellStyle(style);

                    i = i + 2;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("Hesabın adı:");
                    cell = row.createCell(1);
                    cell.setCellValue(acc_name);
                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("VÖEN:");
                    cell = row.createCell(1);
                    cell.setCellValue(cust_inn);
                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("Valyuta:");
                    cell = row.createCell(1);
                    cell.setCellValue(curr_name);
                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("Əməliyyatların tarixi:");
                    cell = row.createCell(1);
                    cell.setCellValue(strDateB + " - " + strDateE);
                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("Əvvəlki əməliyyat tarixi: ");
                    cell = row.createCell(1);
                    cell.setCellValue(bahi.getFirst_date());
                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("Günün əvvəlinə qalıq:");
                    cell = row.createCell(1);
                    if (curr_name.equals("AZN")) {
                        cell.setCellValue("Manat: " + Math.abs(bahi.getFirst_Lammount()));
                    } else {
                        cell.setCellValue("Valyuta: " + Math.abs(bahi.getFirst_ammount()));
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(1);
                        cell.setCellValue("Manat: " + Math.abs(bahi.getFirst_Lammount()));
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(1);
                        cell.setCellValue("Rəsmi məzənnə: " + EXC_RATE_B);

                    }
                    cell = row.createCell(2);
                    cell.setCellValue("\"Expressbank\" ASC" + dict.getFililal4Statm(Integer.parseInt(br)));

                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(2);
                    cell.setCellValue("(" + bahi.getfAP() + ")");

                    i = i + 2;
                    row = sheet.createRow(i);
                    cell = row.createCell(1);
                    cell.setCellValue("Tarix");
                    cell.setCellStyle(style_tr);
                    cell = row.createCell(2);
                    cell.setCellValue("Val.");
                    cell.setCellStyle(style_tr);
                    cell = row.createCell(3);
                    cell.setCellValue("Qarşı hesab");
                    cell.setCellStyle(style_tr);
                    cell = row.createCell(4);
                    cell.setCellValue("Göndərən/Alan Şirkət");
                    cell.setCellStyle(style_tr);
                    cell = row.createCell(5);
                    cell.setCellValue("Debet");
                    cell.setCellStyle(style_tr);
                    cell = row.createCell(7);
                    cell.setCellValue("Kredit");
                    cell.setCellStyle(style_tr);
                    cell = row.createCell(9);
                    cell.setCellValue("Təyinat");
                    cell.setCellStyle(style_tr);
                    //-------------------- emeliyyatlar hissesi
                    i++;
                    ArrayOfStmtTransactions aost = stdb.getTransactionsSTPR(acc_no, strDateB, strDateE, TrType, insurance, salary_gr);
                    int trCount = aost.getStmttransactions().size();
                    int cem_setr = 0;
                    cem_setr = i + 2;
                    for (int j = 0; j < trCount; j++) {
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(1);
                        cell.setCellValue(aost.getStmttransactions().get(j).getTarix());
                        cell = row.createCell(2);
                        cell.setCellValue(aost.getStmttransactions().get(j).getValyuta());
                        cell = row.createCell(3);
                        cell.setCellValue(aost.getStmttransactions().get(j).getAccount());
                        
                        cell = row.createCell(4);
                        cell.setCellValue(aost.getStmttransactions().get(j).getsendAndRecei());

                        cell = row.createCell(5);
                        cell.setCellValue(aost.getStmttransactions().get(j).getDebtAmount());
                        if (aost.getStmttransactions().get(j).getDLAmount() != 0.0) {
                            cell = row.createCell(6);
                            cell.setCellValue(aost.getStmttransactions().get(j).getDLAmount());
                            cell.setCellStyle(style_amnt);
                        }
                        cell = row.createCell(7);
                        cell.setCellValue(aost.getStmttransactions().get(j).getCredAmount());
                        if (aost.getStmttransactions().get(j).getCLAmount() != 0.0) {
                            cell = row.createCell(8);
                            cell.setCellValue(aost.getStmttransactions().get(j).getCLAmount());
                            cell.setCellStyle(style_amnt);
                        }
                        cell = row.createCell(9);
                        cell.setCellValue(aost.getStmttransactions().get(j).getTeyinat() + aost.getStmttransactions().get(j).getLapNo());

                    }
                    // ----------------cem hisse
                    i = i + 2;
                    row = sheet.createRow(i);
                    if (cem_setr != 0) {
                        cell = row.createCell(4);
                        cell.setCellFormula("SUM(E" + cem_setr + ":E" + (i - 1) + ")");
                        cell = row.createCell(5);
                        cell.setCellFormula("SUM(F" + cem_setr + ":F" + (i - 1) + ")");
                        cell.setCellStyle(style_amnt);
                        cell = row.createCell(6);
                        cell.setCellFormula("SUM(G" + cem_setr + ":G" + (i - 1) + ")");
                        cell = row.createCell(7);
                        cell.setCellFormula("SUM(H" + cem_setr + ":H" + (i - 1) + ")");
                        cell.setCellStyle(style_amnt);
                    }
                    //-------------------- emeliyyatlar hissesinin sonu    
                    i++;
                    row = sheet.createRow(i);
                    cell = row.createCell(0);
                    cell.setCellValue("Günün sonuna qalıq:");
                    cell = row.createCell(1);
                    if (curr_name.equals("AZN")) {
                        cell.setCellValue("Manat: " + Math.abs(eahi.getFirst_Lammount()));
                    } else {
                        cell.setCellValue("Valyuta: " + Math.abs(eahi.getFirst_ammount()));
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(1);
                        cell.setCellValue("Manat: " + Math.abs(eahi.getFirst_Lammount()));
                        i++;
                        row = sheet.createRow(i);
                        cell = row.createCell(1);
                        cell.setCellValue("Rəsmi məzənnə: " + EXC_RATE_E);

                    }
                    cell = row.createCell(2);
                    cell.setCellValue("(" + eahi.getfAP() + ")");
                    cell = row.createCell(3);
                    cell.setCellValue("Sənədlərin sayı: " + trCount);
                    i = i + 3;
                }

            }

            if ((chk == 0) & (turnover.equals("1"))) {
                row = sheet.createRow(1);
                cell = row.createCell(0);
                cell.setCellValue("Bu müştəri üçün seçilən tarix aralığında heç bir əməliyyat olmamışdır!");
            }

            for (i = 0; i < 5; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(os);

        } catch (SQLException ex) {
            Logger.getLogger(StmtExcelSPTRnew1.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                os.flush();
                os.close();
                conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(StmtExcelSPTRnew1.class.getName()).log(Level.SEVERE, null, ex);
            }
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
        processRequest(request, response);
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
        processRequest(request, response);
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
