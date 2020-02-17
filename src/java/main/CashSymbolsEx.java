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
@WebServlet(name = "CashSymbolsEx", urlPatterns = {"/CashSymbolsEx"})
public class CashSymbolsEx extends HttpServlet {

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

        response.setHeader("Content-Disposition", "attachment;filename=KassaSimvollari.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();
        try {

            String excelSqlB = request.getParameter("excelSqlB");
            String excelSqlC = request.getParameter("excelSqlC");
            String excelSql2 = request.getParameter("excelSql2");
            String excelSql3 = request.getParameter("excelSql3");

            DB db = new DB();
            Connection conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            Row row = sheet.createRow(0);

            Cell cell = row.createCell(1);
            cell.setCellValue("Simvol");
            cell.setCellStyle(style);
            cell = row.createCell(2);
            cell.setCellValue("Mebleg");
            cell.setCellStyle(style);

            //-------------- ---------------------------------------------------       
            Statement stmt2 = conn.createStatement();
            ResultSet sqlSel2 = stmt2.executeQuery(excelSql2);
            Double A10 = 0.0;
            Double C_Med = 0.0;
            Double A20 = 0.0;
            Double C_Mex = 0.0;
            while (sqlSel2.next()) {
                C_Med = sqlSel2.getDouble(2);
                A10 = sqlSel2.getDouble(3);
            }
            sqlSel2.close();
            stmt2.close();
            //---------------------------------------------------
            Statement stmt3 = conn.createStatement();
            ResultSet sqlSel3 = stmt3.executeQuery(excelSql3);

            while (sqlSel3.next()) {
                C_Mex = sqlSel3.getDouble(2);
                A20 = sqlSel3.getDouble(3);
            }
            sqlSel3.close();
            stmt3.close();
//-------------- ---------------------------------------------------       
            Statement stmtB = conn.createStatement();
            ResultSet sqlSelB = stmtB.executeQuery(excelSqlB);

            int j = 1;
            row = sheet.createRow(j);
            cell = row.createCell(1);
            cell.setCellValue("A10");
            cell = row.createCell(2);
            cell.setCellValue(A10);
            j++;
            while (sqlSelB.next()) {
                row = sheet.createRow(j);

                cell = row.createCell(1);
                cell.setCellValue(sqlSelB.getString(1));

                cell = row.createCell(2);
                cell.setCellType(0);
                cell.setCellValue(sqlSelB.getDouble(2));
                j++;
            }
            sqlSelB.close();
            stmtB.close();

            row = sheet.createRow(j);
            cell = row.createCell(1);
            cell.setCellValue("Cəm mədaxil");
            cell = row.createCell(2);
            cell.setCellValue(C_Med);
            j++;
            row = sheet.createRow(j);
            cell = row.createCell(1);
            cell.setCellValue("A20");
            cell = row.createCell(2);
            cell.setCellValue(A20);
            j++;
            //-------------- ---------------------------------------------------       
            Statement stmtC = conn.createStatement();
            ResultSet sqlSelC = stmtB.executeQuery(excelSqlC);

            while (sqlSelC.next()) {
                row = sheet.createRow(j);

                cell = row.createCell(1);
                cell.setCellValue(sqlSelC.getString(1));

                cell = row.createCell(2);
                cell.setCellType(0);
                cell.setCellValue(sqlSelC.getDouble(2));
                j++;
            }
            sqlSelC.close();
            stmtC.close();
            //---------------------------------------------------
            row = sheet.createRow(j);
            cell = row.createCell(1);
            cell.setCellValue("Cəm məxaric");
            cell = row.createCell(2);
            cell.setCellValue(C_Mex);
            j++;
            /*   
             row = sheet.createRow(j+1);

             Cell cell =  row.createCell(0);
             cell.setCellValue("CƏM:");
             cell.setCellStyle(style);   
 
             cell =  row.createCell(2);
             cell.setCellFormula("SUM(C2:C"+j+")");
             cell.setCellStyle(style);   
             */
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
            Logger.getLogger(CashSymbolsEx.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CashSymbolsEx.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(CashSymbolsEx.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CashSymbolsEx.class.getName()).log(Level.SEVERE, null, ex);
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
