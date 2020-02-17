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
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.PrintSetup;
import org.apache.poi.ss.usermodel.Row;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "IncExpExcel", urlPatterns = {"/IncExpExcel"})
public class IncExpExcel extends HttpServlet {

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

        response.setContentType("text/html; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=GelirXercHesabati.xls");
        response.setContentType("application/vnd.m s-excel");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        OutputStream os = response.getOutputStream();
        try {
            String info = request.getParameter("info");
            System.out.println(info);
            String excelSql1 = request.getParameter("excelSql1");
            String excelSql2 = request.getParameter("excelSql2");

            DB db = new DB();
            Connection conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");
            PrintSetup setup = sheet.getPrintSetup();
            // setup.setPaperSize(PrintSetup.LEGAL_PAPERSIZE);
            setup.setLandscape(true);

            Statement stmt = conn.createStatement();
            ResultSet sqlSel = stmt.executeQuery(excelSql1);

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            font.setColor(HSSFColor.BLUE.index);

            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            HSSFFont font1 = workbook.createFont();
            font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            font1.setColor(HSSFColor.RED.index);

            HSSFCellStyle style1 = workbook.createCellStyle();
            style1.setFont(font1);

            Row row1 = sheet.createRow(0);
            Cell cell1 = row1.createCell(0);
            cell1.setCellValue("Period:  ");
            cell1.setCellStyle(style1);

            cell1 = row1.createCell(1);
            cell1.setCellValue(info);
            cell1.setCellStyle(style1);
            //    cell1 = row1.createCell(2);

            Row row = sheet.createRow(1);
            Cell cell = row.createCell(0);
            cell.setCellValue("Balans hesabı");
            cell.setCellStyle(style);

            cell = row.createCell(1);
            cell.setCellValue("Məbləğ");
            cell.setCellStyle(style);

            cell = row.createCell(2);
            cell.setCellValue("Balans hesabının adı");
            cell.setCellStyle(style);

            int j = 2;

            while (sqlSel.next()) {

                row = sheet.createRow(j);
                cell = row.createCell(0);
                cell.setCellValue(sqlSel.getString(1));

                cell = row.createCell(1);
                cell.setCellValue(sqlSel.getDouble(2));

                cell = row.createCell(2);
                cell.setCellValue(sqlSel.getString(3));

                j++;
            }
            row = sheet.createRow(j + 1);

            cell = row.createCell(0);
            cell.setCellValue("CƏM:");
            cell.setCellStyle(style);

            cell = row.createCell(1);
            cell.setCellFormula("SUM(B2:B" + j + ")");
            cell.setCellStyle(style);

            int g = j + 3;
            sqlSel.close();
            stmt.close();

            stmt = conn.createStatement();
            sqlSel = stmt.executeQuery(excelSql2);

            row = sheet.createRow(g);

            cell = row.createCell(0);
            cell.setCellValue("Balans hesabı");
            cell.setCellStyle(style);

            cell = row.createCell(1);
            cell.setCellValue("Məbləğ");
            cell.setCellStyle(style);

            cell = row.createCell(2);
            cell.setCellValue("Balans hesabının adı");
            cell.setCellStyle(style);

            while (sqlSel.next()) {

                row = sheet.createRow(g);
                cell = row.createCell(0);
                cell.setCellValue(sqlSel.getString(1));

                cell = row.createCell(1);
                cell.setCellValue(sqlSel.getDouble(2));

                cell = row.createCell(2);
                cell.setCellValue(sqlSel.getString(3));

                g++;
            }
            row = sheet.createRow(g + 1);

            cell = row.createCell(0);
            cell.setCellValue("CƏM:");
            cell.setCellStyle(style);

            cell = row.createCell(1);
            cell.setCellFormula("SUM(B" + (j + 4) + ":B" + g + ")");
            cell.setCellStyle(style);

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
            Logger.getLogger(IncExpExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(IncExpExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(IncExpExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(IncExpExcel.class.getName()).log(Level.SEVERE, null, ex);
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
