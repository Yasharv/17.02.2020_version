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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
@WebServlet(name = "RestTurnOverExcel", urlPatterns = {"/RestTurnOverExcel"})
public class RestTurnOverExcel extends HttpServlet {

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

        response.setHeader("Content-Disposition", "attachment;filename=QaliqDovriyye.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();
        try {
            HttpSession session = request.getSession();

            Map rowData = (HashMap) session.getAttribute("data");
            ArrayList<String> columns = (ArrayList<String>) session.getAttribute("columns");
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            Row row = sheet.createRow(0);
            for (int i = 0; i < columns.size(); i++) {

                Cell cell = row.createCell(i + 1);
                cell.setCellValue(columns.get(i));
                cell.setCellStyle(style);
            };
            int j = 1;
            Map col = null;
            Double a2 = 0.0;
            Double a3 = 0.0;
            Double a4 = 0.0;
            Double a5 = 0.0;
            Double a6 = 0.0;
            Double a7 = 0.0;

            for (int i = 1; i <= rowData.size(); i++) {
                col = (HashMap) rowData.get(i);
                row = sheet.createRow(j);
                Cell cell = row.createCell(1);
                cell.setCellValue(col.get(1).toString());

                cell = row.createCell(2);
                cell.setCellValue(Double.parseDouble(col.get(2).toString()));
                a2 = a2 + Double.parseDouble(col.get(2).toString());
                cell = row.createCell(3);
                cell.setCellValue(Double.parseDouble(col.get(3).toString()));
                a3 = a3 + Double.parseDouble(col.get(3).toString());
                cell = row.createCell(4);
                cell.setCellType(1);
                cell.setCellValue(Double.parseDouble(col.get(4).toString()));
                a4 = a4 + Double.parseDouble(col.get(4).toString());
                cell = row.createCell(5);
                cell.setCellValue(Double.parseDouble(col.get(5).toString()));
                a5 = a5 + Double.parseDouble(col.get(5).toString());
                cell = row.createCell(6);
                cell.setCellValue(Double.parseDouble(col.get(6).toString()));
                a6 = a6 + Double.parseDouble(col.get(6).toString());
                cell = row.createCell(7);
                cell.setCellType(0);
                cell.setCellValue(Double.parseDouble(col.get(7).toString()));
                a7 = a7 + Double.parseDouble(col.get(7).toString());
                cell = row.createCell(8);
                cell.setCellValue(col.get(8).toString());

                cell = row.createCell(9);
                cell.setCellValue(col.get(9).toString());
                j++;
            }
            row = sheet.createRow(j + 1);

            Cell cell = row.createCell(0);
            cell.setCellValue("CƏM:");

            cell.setCellStyle(style);

            cell = row.createCell(2);
            cell.setCellValue(a2);
            cell.setCellStyle(style);

            cell = row.createCell(3);
            cell.setCellValue(a3);
            cell.setCellStyle(style);

            cell = row.createCell(4);
            cell.setCellValue(a4);
            cell.setCellStyle(style);

            cell = row.createCell(5);
            cell.setCellValue(a5);
            cell.setCellStyle(style);

            cell = row.createCell(6);
            cell.setCellValue(a6);
            cell.setCellStyle(style);

            cell = row.createCell(7);
            cell.setCellValue(a7);
            cell.setCellStyle(style);

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
            Logger.getLogger(RestTurnOverExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(RestTurnOverExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(RestTurnOverExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(RestTurnOverExcel.class.getName()).log(Level.SEVERE, null, ex);
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
