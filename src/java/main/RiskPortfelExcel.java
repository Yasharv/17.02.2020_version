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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

/**
 *
 * @author emin.mustafayev
 */
@WebServlet(name = "RiskPortfelExcel", urlPatterns = {"/RiskPortfelExcel"})
public class RiskPortfelExcel extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Content-Disposition", "attachment;filename=Kredit_portfeli(RIED).xlsx");
        response.setContentType("application/vnd.ms-excel");

        OutputStream os = response.getOutputStream();
        DB connt = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet sqlSel = null;
        ResultSet rs = null;
        Statement st = null;
        SXSSFWorkbook workbook = null;
        try {
            conn = connt.connect();
            DecimalFormat df = new DecimalFormat("0.00");
            workbook = new SXSSFWorkbook();
            Sheet sheet = workbook.createSheet("Sheet1");
            String Filial = request.getParameter("Filial");
            String FilialSql = "";
            if (Filial.equals("0")) {
                FilialSql = " ";
            } else {
                FilialSql = " and l.filial_code=" + Filial;
            }
            int contr_type = 1;

            String Tarix = request.getParameter("TrDateB");
            SimpleDateFormat df1 = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat df2 = new SimpleDateFormat("yyyy-mm-dd");

            Date dateB;
            dateB = df1.parse(Tarix);
            Tarix = df2.format(dateB);

            String tarix1 = "12-31-2013";
            SimpleDateFormat df3 = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat df4 = new SimpleDateFormat("yyyy-mm-dd");

            Date dateB1;
            dateB1 = df1.parse(tarix1);
            tarix1 = df2.format(dateB1);

            String SqlCredLines = "";
            String SqlCredits = "";
            String SqlBankCredits = "";
            String SqlCardCredits = "";
            String SqlFullLimitCredits = "";
            String Text = "  SELECT  * FROM sql_select  where id = 9 ";
            st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
            java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
            java.sql.Clob clob1 = (java.sql.Clob) rs.getClob(4);
            java.sql.Clob clob2 = (java.sql.Clob) rs.getClob(5);
            java.sql.Clob clob3 = (java.sql.Clob) rs.getClob(6);
            java.sql.Clob clob4 = (java.sql.Clob) rs.getClob(7);

            SqlCredLines = clob.getSubString(1, (int) clob.length());
            SqlCredits = clob1.getSubString(1, (int) clob1.length());
            SqlBankCredits = clob2.getSubString(1, (int) clob2.length());
            SqlCardCredits = clob3.getSubString(1, (int) clob3.length());
            SqlFullLimitCredits = clob4.getSubString(1, (int) clob3.length());

            SqlCredLines = SqlCredLines.replaceAll("Filial", Filial);
            SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);

            SqlCredits = SqlCredits.replaceAll("Filial", Filial);
            SqlCredits = SqlCredits.replaceAll("Tarix", Tarix);

            SqlBankCredits = SqlBankCredits.replaceAll("Filial", Filial);
            SqlBankCredits = SqlBankCredits.replaceAll("Tarix", Tarix);

            SqlCardCredits = SqlCardCredits.replaceAll("Filial", Filial);
            SqlCardCredits = SqlCardCredits.replaceAll("Tarix", Tarix);

            SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("FilialSql", FilialSql);
            SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("Tarix", Tarix);
            System.out.println("SqlCredLines  " + SqlCredLines);
            System.out.println("SqlCredits   " + SqlCredits);
            System.out.println("SqlBankCredits   " + SqlBankCredits);
            System.out.println("SqlCardCredits   " + SqlCardCredits);
            System.out.println("SqlFullLimitCredits  " + SqlFullLimitCredits);

            String FullSql = "";

            stmt = conn.createStatement();
            if (contr_type == 1) {
                FullSql = SqlCredLines + " union all " + SqlBankCredits
                        + " union all " + SqlCardCredits + " union all " + SqlCredits
                        + " union all" + SqlFullLimitCredits;
            } else {
                FullSql = SqlCredLines;
            }
//   System.out.println(FullSql);
            sqlSel = stmt.executeQuery(FullSql);

            CellStyle cellStyle = workbook.createCellStyle();
            CreationHelper createHelper = workbook.getCreationHelper();
            cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));

            int count = sqlSel.getMetaData().getColumnCount();

            Row row = sheet.createRow(0);

            Cell cell;

            for (int i = 1; i <= count; i++) {

                cell = row.createCell(i);
                cell.setCellValue(sqlSel.getMetaData().getColumnName(i));

            }

            int j = 1;

            while (sqlSel.next()) {
                row = sheet.createRow(j);
                for (int i = 1; i <= count; i++) {
                    cell = row.createCell(i);
                    if ((sqlSel.getMetaData().getColumnType(i) == -9) | (sqlSel.getMetaData().getColumnType(i) == 12)) {
                        cell.setCellValue(sqlSel.getString(i));
                    } else if (sqlSel.getMetaData().getColumnType(i) == 2) {
                        if (sqlSel.getObject(i) != null) {
                            cell.setCellValue(sqlSel.getDouble(i));
                        } else {
                            cell.setCellValue(sqlSel.getString(i));
                        }
                    } else if (sqlSel.getMetaData().getColumnType(i) == 93) {
                        if (sqlSel.getObject(i) != null) {
                            cell.setCellStyle(cellStyle);
                            cell.setCellValue(sqlSel.getDate(i));
                        } else {
                            cell.setCellValue(sqlSel.getString(i));
                        }
                    }
                };
                j++;
            }
            row = sheet.createRow(j + 1);

            cell = row.createCell(0);

            int Index = cell.getColumnIndex();
            int i;

            workbook.write(os);

        } catch (ParseException ex) {
            Logger.getLogger(RiskPortfelExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
        } finally {

            try {
                workbook.dispose();
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
                Logger.getLogger(PcOperationExcel.class.getName()).log(Level.SEVERE, null, ex);

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
