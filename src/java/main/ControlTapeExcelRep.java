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
import java.text.DecimalFormat;
import java.text.ParseException;
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
@WebServlet(name = "ControlTapeExcelRep", urlPatterns = {"/ControlTapeExcelRep"})
public class ControlTapeExcelRep extends HttpServlet {

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

        response.setHeader("Content-Disposition", "attachment;filename=ControlTapeExcelRep.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();

        String strDateB = request.getParameter("TrDateB");
        String RepValue = request.getParameter("RepVal");
        String Filial = request.getParameter("Filial");
        String Valute = request.getParameter("Valute");
        int RepType = Integer.parseInt(request.getParameter("RepType"));
        String user_name = request.getParameter("uname");
        String user_branch = request.getParameter("br");
        String ValueSql = "";

        if (request.getParameter("RepVal") == null || request.getParameter("RepVal") == "" || request.getParameter("RepVal").equals("")) {
            ValueSql = "";
        } else {
            ValueSql = "and a.bal_cn in (" + request.getParameter("RepVal") + ")";
        }

        String ValuteSql = "";
        if (!(Valute.equals("0"))) {
            ValuteSql = " and a.val=" + Valute;
        }
        String FilialSql = "";
        if (!(Filial.equals("0"))) {
            FilialSql = " and a.filial_id like('%" + Filial + "%') ";
        }
        String CategForSalary = " AND nvl(category,0)<>1200 and nvl(category,0)<>1200";
        try {
            String SqlBal_CN = "";
            if (RepType == 1) {
                SqlBal_CN = "select distinct a.bal_cn from vi_tr_ctrltape_rep2 a"
                        + " WHERE a.tarix=to_date('" + strDateB + "','dd-mm-yyyy') " + ValuteSql + FilialSql + ValueSql
                        + CategForSalary
                        + " order by a.bal_cn";
            } else {
                SqlBal_CN = "select distinct a.bal_cn from vi_tr_ctrltape_rep2_ob  a"
                        + " WHERE a.tarix=to_date('" + strDateB + "','dd-mm-yyyy') " + ValuteSql + FilialSql + ValueSql
                        + CategForSalary
                        + " order by a.bal_cn";
            }
            // System.out.println(SqlBal_CN);
            DB db = new DB();
            Connection conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            font.setColor(HSSFColor.BLUE.index);

            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);
            Row row = sheet.createRow(0);
            Cell cell;

            cell = row.createCell(1);
            cell.setCellValue("Tarix:  " + strDateB);
            cell.setCellStyle(style);

            Statement stmt_bal_cn = conn.createStatement();
            Statement stmt = conn.createStatement();

            ResultSet sqlBalCn = stmt_bal_cn.executeQuery(SqlBal_CN);
            int j = 2;
            int b_sum = 0;
            String sqlText = "";
            while (sqlBalCn.next()) {
                if (RepType == 1) {
                    sqlText = "select a.d_amt,a.d_ekv,a.c_amt,a.c_ekv"
                            + " from vi_tr_ctrltape_rep2 a where a.tarix=to_date('" + strDateB + "','dd-mm-yyyy') "
                            + " and a.bal_cn=" + sqlBalCn.getString(1) + FilialSql + ValuteSql
                            + CategForSalary + " order by a.c_amt,a.c_ekv,a.d_amt,a.d_ekv";

                } else {
                    sqlText = "select a.d_amt,a.d_ekv,a.c_amt,a.c_ekv"
                            + " from vi_tr_ctrltape_rep2_ob a where a.tarix=to_date('" + strDateB + "','dd-mm-yyyy') "
                            + " and a.bal_cn=" + sqlBalCn.getString(1) + FilialSql + ValuteSql
                            + CategForSalary + " order by a.c_amt,a.c_ekv,a.d_amt,a.d_ekv";
                }
                //  System.out.println(sqlText);
                ResultSet sqlSel = stmt.executeQuery(sqlText);

                row = sheet.createRow(j);
                cell = row.createCell(1);
                cell.setCellValue(sqlBalCn.getString(1));
                cell.setCellStyle(style);

                j++;
                row = sheet.createRow(j);
                cell = row.createCell(1);
                cell.setCellValue("D. Məbləğ");
                cell.setCellStyle(style);
                cell = row.createCell(2);
                cell.setCellValue("D. Ekv");
                cell.setCellStyle(style);
                cell = row.createCell(3);
                cell.setCellValue("K. Məbləğ");
                cell.setCellStyle(style);
                cell = row.createCell(4);
                cell.setCellValue("K. Ekv");
                cell.setCellStyle(style);

                j++;
                b_sum = j + 1;
                while (sqlSel.next()) {

                    row = sheet.createRow(j);
                    cell = row.createCell(1);
                    cell.setCellValue(sqlSel.getDouble(1));
                    cell = row.createCell(2);
                    cell.setCellValue(sqlSel.getDouble(2));
                    cell = row.createCell(3);
                    cell.setCellValue(sqlSel.getDouble(3));
                    cell = row.createCell(4);
                    cell.setCellValue(sqlSel.getDouble(4));

                    j++;
                }

                row = sheet.createRow(j);
                cell = row.createCell(1);
                cell.setCellType(0);
                cell.setCellFormula("SUM(B" + b_sum + ":B" + j + ")");
                cell.setCellStyle(style);
                cell = row.createCell(2);
                cell.setCellType(0);
                cell.setCellFormula("SUM(C" + b_sum + ":C" + j + ")");
                cell.setCellStyle(style);
                cell = row.createCell(3);
                cell.setCellType(0);
                cell.setCellFormula("SUM(D" + b_sum + ":D" + j + ")");
                cell.setCellStyle(style);
                cell = row.createCell(4);
                cell.setCellType(0);
                cell.setCellFormula("SUM(E" + b_sum + ":E" + j + ")");
                cell.setCellStyle(style);

                sqlSel.close();
                j++;
                j++;
            }

            // for (int i = 0; i <= 4; i++) { sheet.autoSizeColumn(i); }
            //row = sheet.createRow(j+1);
// cell =  row.createCell(0);
            //cell.setCellValue("CƏM:");
            //cell.setCellStyle(style);   
/* 
             cell =  row.createCell(2);
             cell.setCellFormula("SUM(C2:C"+j+")");
             cell.setCellStyle(style);   
             */
            workbook.write(os);
            sqlBalCn.close();
            stmt.close();
            stmt_bal_cn.close();
            conn.close();
        } finally {
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
                Logger.getLogger(ControlTapeExcelRep.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControlTapeExcelRep.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ControlTapeExcelRep.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(ControlTapeExcelRep.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControlTapeExcelRep.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ControlTapeExcelRep.class.getName()).log(Level.SEVERE, null, ex);
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
