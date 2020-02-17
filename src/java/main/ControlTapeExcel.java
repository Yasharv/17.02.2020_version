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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "ControlTapeExcel", urlPatterns = {"/ControlTapeExcel"})
public class ControlTapeExcel extends HttpServlet {

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
            throws ServletException, IOException, ClassNotFoundException, SQLException {

        response.setHeader("Content-Disposition", "attachment;filename=KontrolLenti.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();
        try {

            String SqlQuery = request.getParameter("excelSql");
            int RepForm = Integer.parseInt(request.getParameter("RepForm"));

            DB db = new DB();
            Connection conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            Statement stmt = conn.createStatement();
            ResultSet sqlSel = stmt.executeQuery(SqlQuery);

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            int count = sqlSel.getMetaData().getColumnCount();

            Row row = sheet.createRow(0);
            Cell cell;

            cell = row.createCell(1);
            cell.setCellValue("Balans hesabı:");
            cell.setCellStyle(style);

            if (RepForm == 0) {
                cell = row.createCell(2);
                cell.setCellValue("Debit məbləğ:");
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue("Debit ekvivalent:");
                cell.setCellStyle(style);

                cell = row.createCell(4);
                cell.setCellValue("Kredit məbləğ:");
                cell.setCellStyle(style);

                cell = row.createCell(5);
                cell.setCellValue("Kredit ekvivalent:");
                cell.setCellStyle(style);
            } else {
                cell = row.createCell(2);
                cell.setCellValue("Debit məbləğ:");
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue("Kredit məbləğ:");
                cell.setCellStyle(style);
            }

            int j = 1;
            while (sqlSel.next()) {
                row = sheet.createRow(j);
                cell = row.createCell(1);
                cell.setCellValue(sqlSel.getString(1));
                if (RepForm == 0) {
                    cell = row.createCell(2);
                    cell.setCellValue(sqlSel.getDouble(2));

                    cell = row.createCell(3);
                    cell.setCellValue(sqlSel.getDouble(3));

                    cell = row.createCell(4);
                    cell.setCellValue(sqlSel.getDouble(4));

                    cell = row.createCell(5);
                    cell.setCellValue(sqlSel.getDouble(5));
                } else {
                    cell = row.createCell(2);
                    cell.setCellValue(sqlSel.getDouble(2));

                    cell = row.createCell(3);
                    cell.setCellValue(sqlSel.getDouble(4));
                }

                j++;
            }
            row = sheet.createRow(j + 1);

            cell = row.createCell(0);
            cell.setCellValue("CƏM:");
            cell.setCellStyle(style);

            cell = row.createCell(2);
            cell.setCellFormula("SUM(C2:C" + j + ")");
            cell.setCellStyle(style);

            cell = row.createCell(3);
            cell.setCellFormula("SUM(D2:D" + j + ")");
            cell.setCellStyle(style);

            if (RepForm == 0) {
                cell = row.createCell(4);
                cell.setCellFormula("SUM(E2:E" + j + ")");
                cell.setCellStyle(style);

                cell = row.createCell(5);
                cell.setCellFormula("SUM(F2:F" + j + ")");
                cell.setCellStyle(style);
            }

            int Index = cell.getColumnIndex();
            int i;

            for (i = 0; i <= Index; i++) {
                sheet.autoSizeColumn(i);
            }
            /*  font = workbook.createFont();
             font.setItalic(true);
             style = workbook.createCellStyle();
             style.setFont(font); */

            workbook.write(os);
            sqlSel.close();
            stmt.close();
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
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ControlTapeExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ControlTapeExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(ControlTapeExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ControlTapeExcel.class.getName()).log(Level.SEVERE, null, ex);
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
