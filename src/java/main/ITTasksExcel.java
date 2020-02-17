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
@WebServlet(name = "ITTasksExcel", urlPatterns = {"/ITTasksExcel"})
public class ITTasksExcel extends HttpServlet {

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

        response.setHeader("Content-Disposition", "attachment;filename=ITTasks.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();
        try {

            String SqlQuery = request.getParameter("excelSql");
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
            for (int i = 1; i <= count; i++) {

                Cell cell = row.createCell(i);
                cell.setCellValue(sqlSel.getMetaData().getColumnName(i));
                cell.setCellStyle(style);
            };
            int j = 1;

            Cell cell = row.createCell(1);
            while (sqlSel.next()) {
                row = sheet.createRow(j);

                for (int i = 1; i <= count; i++) {

                    cell = row.createCell(i);
                    cell.setCellValue(sqlSel.getString(i));
                };
                j++;
            }
            sqlSel.close();
            stmt.close();
            conn.close();

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
            Logger.getLogger(ITTasksExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ITTasksExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(ITTasksExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ITTasksExcel.class.getName()).log(Level.SEVERE, null, ex);
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
