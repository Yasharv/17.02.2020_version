package test;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import main.*;
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
@WebServlet(name = "GoldRepExcel1", urlPatterns = {"/GoldRepExcel1"})
public class GoldRepExcel extends HttpServlet {

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

        response.setHeader("Content-Disposition", "attachment;filename=GununSenedleri.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();
        String SqlQuery = "";
        try {

            SqlQuery = request.getParameter("excelSql");
            System.out.println("excell " + SqlQuery);
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
            while (sqlSel.next()) {
                row = sheet.createRow(j);
                Cell cell = row.createCell(1);
                cell.setCellValue(sqlSel.getString(1).substring(0, 10));

                cell = row.createCell(2);
                cell.setCellValue(sqlSel.getString(2));

                cell = row.createCell(3);
                cell.setCellValue(sqlSel.getString(3));

                cell = row.createCell(4);
                cell.setCellType(1);
                cell.setCellValue(sqlSel.getString(4));

                cell = row.createCell(5);
                cell.setCellValue(sqlSel.getString(5));

                cell = row.createCell(6);
                cell.setCellValue(sqlSel.getString(6));

                cell = row.createCell(7);
                cell.setCellValue(sqlSel.getString(7));

                cell = row.createCell(8);
                cell.setCellType(0);
                cell.setCellValue(sqlSel.getString(8));

                cell = row.createCell(9);
                cell.setCellValue(sqlSel.getString(9));

                cell = row.createCell(10);
                cell.setCellValue(sqlSel.getString(10));

                cell = row.createCell(11);
                cell.setCellValue(sqlSel.getString(11));

                cell = row.createCell(12);
                cell.setCellValue(sqlSel.getString(12));

                cell = row.createCell(13);
                cell.setCellValue(sqlSel.getString(13));

                cell = row.createCell(14);
                cell.setCellValue(sqlSel.getString(14));

                cell = row.createCell(15);
                cell.setCellValue(sqlSel.getString(15));

                j++;
            }
// row = sheet.createRow(j+1);
 /*
             Cell cell =  row.createCell(0);
             cell.setCellValue("CƏM:");
             cell.setCellStyle(style);   
 
             cell =  row.createCell(8);
             cell.setCellFormula("SUM(I2:I"+j+")");
             cell.setCellStyle(style);   
 
             cell = row.createCell(9);
             cell.setCellFormula("SUM(J2:J"+j+")");
             cell.setCellStyle(style);   */

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
            Logger.getLogger(GoldRepExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(GoldRepExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(GoldRepExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(GoldRepExcel.class.getName()).log(Level.SEVERE, null, ex);
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
