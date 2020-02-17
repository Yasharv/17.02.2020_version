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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;

/**
 *
 * @author emin.mustafayev
 */
@WebServlet(name = "ReservsRep", urlPatterns = {"/ReservsRep"})
public class ReservsRep extends HttpServlet {

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
        response.setHeader("Content-Disposition", "attachment;filename=ReservsRep.xls");
        response.setContentType("application/vnd.ms-excel");

        OutputStream os = response.getOutputStream();
        DB connt = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet sqlSel = null;
        try {
            conn = connt.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String Filial = request.getParameter("Filial");
            String balcn = request.getParameter("balcn");
            String forSrc = request.getParameter("forSrc");

            String SQLText = "";
            // System.out.println(SQLText);

            stmt = conn.createStatement();

            sqlSel = stmt.executeQuery(SQLText);

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            CellStyle cellStyle = workbook.createCellStyle();
            CreationHelper createHelper = workbook.getCreationHelper();
            cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));

            int count = sqlSel.getMetaData().getColumnCount();

            Row row = sheet.createRow(0);
            Cell cell = row.createCell(1);
            for (int i = 1; i <= count; i++) {

                cell = row.createCell(i);
                cell.setCellValue(sqlSel.getMetaData().getColumnName(i));
                // System.out.println(sqlSel.getMetaData().getColumnName(i));
                cell.setCellStyle(style);
            }

            int j = 1;

            while (sqlSel.next()) {
                row = sheet.createRow(j);

                for (int i = 1; i <= count; i++) {

                    cell = row.createCell(i);
                    switch (i) {
                        case 2:
                            cell.setCellValue(sqlSel.getDouble(i));
                            break;
                        case 12: {
                            cell.setCellStyle(cellStyle);
                            cell.setCellValue(sqlSel.getDate(i));
                            break;
                        }
                        default:
                            cell.setCellValue(sqlSel.getString(i));
                    }

                }
                j++;
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

        } catch (SQLException ex) {
            Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (sqlSel != null) {
                    sqlSel.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ReservsRep.class.getName()).log(Level.SEVERE, null, ex);
            }
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
