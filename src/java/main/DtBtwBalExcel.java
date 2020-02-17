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
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "DtBtwBalExcel", urlPatterns = {"/DtBtwBalExcel"})
public class DtBtwBalExcel extends HttpServlet {

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

        response.setHeader("Content-Disposition", "attachment;filename=TarixAraliginaBalans.xls");
        response.setContentType("application/vnd.ms-excel");
        OutputStream os = response.getOutputStream();
        try {

            int RepForm = Integer.parseInt(request.getParameter("RepForm"));
            int BalType = Integer.parseInt(request.getParameter("BalType"));

            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");

            HttpSession session = request.getSession();

            Map rowData = (HashMap) session.getAttribute("data");

            HSSFFont font = workbook.createFont();
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            font.setColor(HSSFColor.BLUE.index);

            HSSFCellStyle style = workbook.createCellStyle();
            style.setFont(font);

            Row row = sheet.createRow(0);
            Cell cell = row.createCell(1);
            cell.setCellValue("Balans hesabı");
            cell.setCellStyle(style);

            if (RepForm == 2) {
                cell = row.createCell(2);
                cell.setCellValue("Aktiv");
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue("Passiv");
                cell.setCellStyle(style);

                cell = row.createCell(4);
                cell.setCellValue("Debet");
                cell.setCellStyle(style);

                cell = row.createCell(5);
                cell.setCellValue("Kredit");
                cell.setCellStyle(style);

                cell = row.createCell(6);
                cell.setCellValue("Aktiv");
                cell.setCellStyle(style);

                cell = row.createCell(7);
                cell.setCellValue("Passiv");
                cell.setCellStyle(style);
            } else if (RepForm == 1) {
                cell = row.createCell(2);
                cell.setCellValue("Debet");
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue("Kredit");
                cell.setCellStyle(style);

                cell = row.createCell(4);
                cell.setCellValue("Aktiv");
                cell.setCellStyle(style);

                cell = row.createCell(5);
                cell.setCellValue("Passiv");
                cell.setCellStyle(style);
            } else {
                cell = row.createCell(2);
                cell.setCellValue("Aktiv");
                cell = row.createCell(3);
                cell.setCellValue("Passiv");
            }

            int j = 1;
            double DDovr = 0;
            double KDovr = 0;
            double BAktiv = 0;
            double BPassiv = 0;
            double EAktiv = 0;
            double EPassiv = 0;
            Double a12 = 0.0;
            Double a13 = 0.0;
            Double a4 = 0.0;
            Double a5 = 0.0;
            Double a6 = 0.0;
            Double a7 = 0.0;
            Double a8 = 0.0;
            Double a9 = 0.0;
            Map col = null;
            for (int i = 1; i <= rowData.size(); i++) {
                col = (HashMap) rowData.get(i);

                row = sheet.createRow(j);
                cell = row.createCell(1);
                cell.setCellValue(col.get(1).toString());
                if (BalType == 0) {
                    BAktiv = Double.parseDouble(col.get(4).toString());
                    a4 = a4 + Double.parseDouble(col.get(4).toString());
                    BPassiv = Double.parseDouble(col.get(5).toString());
                    a5 = a5 + Double.parseDouble(col.get(5).toString());
                    DDovr = Double.parseDouble(col.get(8).toString());
                    a8 = a8 + Double.parseDouble(col.get(8).toString());
                    KDovr = Double.parseDouble(col.get(9).toString());
                    a9 = a9 + Double.parseDouble(col.get(9).toString());
                    EAktiv = Double.parseDouble(col.get(12).toString());
                    a12 = a12 + Double.parseDouble(col.get(12).toString());
                    EPassiv = Double.parseDouble(col.get(13).toString());
                    a13 = a13 + Double.parseDouble(col.get(13).toString());
                } else if (BalType == 1) {
                    BAktiv = Double.parseDouble(col.get(2).toString());
                    a4 = a4 + Double.parseDouble(col.get(2).toString());
                    BPassiv = Double.parseDouble(col.get(3).toString());
                    a5 = a5 + Double.parseDouble(col.get(3).toString());
                    DDovr = Double.parseDouble(col.get(6).toString());
                    a8 = a8 + Double.parseDouble(col.get(6).toString());
                    KDovr = Double.parseDouble(col.get(7).toString());
                    a9 = a9 + Double.parseDouble(col.get(7).toString());
                    EAktiv = Double.parseDouble(col.get(10).toString());
                    a12 = a12 + Double.parseDouble(col.get(10).toString());
                    EPassiv = Double.parseDouble(col.get(11).toString());
                    a13 = a13 + Double.parseDouble(col.get(11).toString());
                }

                if (RepForm == 2) {
                    cell = row.createCell(2);
                    cell.setCellValue(BAktiv);
                    cell = row.createCell(3);
                    cell.setCellValue(BPassiv);
                    cell = row.createCell(4);
                    cell.setCellValue(DDovr);
                    cell = row.createCell(5);
                    cell.setCellValue(KDovr);
                    cell = row.createCell(6);
                    cell.setCellValue(EAktiv);
                    cell = row.createCell(7);
                    cell.setCellValue(EPassiv);
                } else if (RepForm == 1) {
                    cell = row.createCell(2);
                    cell.setCellValue(DDovr);
                    cell = row.createCell(3);
                    cell.setCellValue(KDovr);
                    cell = row.createCell(4);
                    cell.setCellValue(EAktiv);
                    cell = row.createCell(5);
                    cell.setCellValue(EPassiv);
                } else {
                    cell = row.createCell(2);
                    cell.setCellValue(EAktiv);
                    cell = row.createCell(3);
                    cell.setCellValue(EPassiv);
                }

                j++;
            }
            row = sheet.createRow(j + 1);

            cell = row.createCell(0);
            cell.setCellValue("CƏM:");
            cell.setCellStyle(style);

            if (RepForm == 0) {
                cell = row.createCell(2);
                cell.setCellValue(a12);
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue(a13);
                cell.setCellStyle(style);
            }

            if (RepForm == 1) {
                cell = row.createCell(2);
                cell.setCellValue(a8);
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue(a9);
                cell.setCellStyle(style);
            }

            if (RepForm == 1) {
                cell = row.createCell(4);
                cell.setCellValue(a12);
                cell.setCellStyle(style);

                cell = row.createCell(5);
                cell.setCellValue(a13);
                cell.setCellStyle(style);
            }

            if (RepForm == 2) {
                cell = row.createCell(2);
                cell.setCellValue(a4);
                cell.setCellStyle(style);

                cell = row.createCell(3);
                cell.setCellValue(a5);
                cell.setCellStyle(style);

                cell = row.createCell(4);
                cell.setCellValue(a8);
                cell.setCellStyle(style);

                cell = row.createCell(5);
                cell.setCellValue(a9);
                cell.setCellStyle(style);

                cell = row.createCell(6);
                cell.setCellValue(a12);
                cell.setCellStyle(style);

                cell = row.createCell(7);
                cell.setCellValue(a13);
                cell.setCellStyle(style);
            }

            int Index = cell.getColumnIndex();
            int i;

            for (i = 0; i <= Index; i++) {
                sheet.autoSizeColumn(i);
            }

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
            Logger.getLogger(DtBtwBalExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DtBtwBalExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(DtBtwBalExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DtBtwBalExcel.class.getName()).log(Level.SEVERE, null, ex);
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
