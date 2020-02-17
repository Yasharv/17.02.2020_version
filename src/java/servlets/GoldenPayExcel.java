/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

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
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "GoldenPayExcel", urlPatterns = {"/GoldenPayExcel"})
public class GoldenPayExcel extends HttpServlet {

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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) {

        response.setHeader("Content-Disposition", "attachment;filename=GoldenPayTransactions.xls");
        response.setContentType("application/vnd.ms-excel");

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        OutputStream os = null;
        Cell cell = null;
        Row row = null;
        try {
            request.setCharacterEncoding("UTF-8");
            os = response.getOutputStream();
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String sqlText = "SELECT a.id, a.timestmp, a.contract_no,"
                    + " a.amount, a.gp_id, a.status, a.t24id"
                    + " FROM gp_operations a "
                    + " where trunc(a.timestmp) between to_date('" + DateB + "','dd-MM-yyyy') and to_date('" + DateE + "','dd-MM-yyyy')"
                    + " order by a.id";
            DBOnpay db = new DBOnpay();
            conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            stmt = conn.createStatement();
            rs = stmt.executeQuery(sqlText);

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            font.setColor(HSSFColor.BLUE.index);

            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            CellStyle cellStyle = workbook.createCellStyle();
            CreationHelper createHelper = workbook.getCreationHelper();
            cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));

            int count = rs.getMetaData().getColumnCount();

            row = sheet.createRow(0);

            for (int i = 1; i <= count; i++) {
                cell = row.createCell(i);
                switch (i) {
                    case 1:
                        cell.setCellValue("ID");
                        break;
                    default:
                        cell.setCellValue(rs.getMetaData().getColumnName(i));
                        break;
                }
                cell.setCellStyle(style);
            };
            int j = 1;

            while (rs.next()) {

                row = sheet.createRow(j);

                for (int i = 1; i <= count; i++) {
                    cell = row.createCell(i);
                    switch (i) {
                        case 1:
                            cell.setCellValue(rs.getString(i));
                            break;
                        case 2:
                            cell.setCellStyle(cellStyle);
                            cell.setCellValue(rs.getTimestamp(i));
                            break;
                        case 3:
                            cell.setCellValue(rs.getString(i));
                            break;
                        case 4:
                            cell.setCellValue(rs.getDouble(i));
                            break;
                        case 5:
                            cell.setCellValue(rs.getString(i));
                            break;
                        case 6:
                            cell.setCellValue(rs.getInt(i));
                            break;
                        default:
                            cell.setCellValue(rs.getString(i));
                            break;
                    }
                };

                j++;
            }
            /*//row = sheet.createRow(j+1);
 
             // cell =  row.createCell(0);
             //cell.setCellValue("CƏM:");
             //cell.setCellStyle(style);   
 
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

        } catch (IOException ex) {
            Logger.getLogger(GoldenPayExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(GoldenPayExcel.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (os != null) {
                    os.flush();
                    os.close();
                }
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (IOException ex) {
                Logger.getLogger(GoldenPayExcel.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(GoldenPayExcel.class.getName()).log(Level.SEVERE, null, ex);
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
