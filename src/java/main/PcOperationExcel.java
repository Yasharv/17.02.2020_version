/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.util.Date;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.ParseException;
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
@WebServlet(name = "PcOperationExcel", urlPatterns = {"/PcOperationExcel"})
public class PcOperationExcel extends HttpServlet {

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
        response.setHeader("Content-Disposition", "attachment;filename=Report.xls");
        response.setContentType("application/vnd.ms-excel");

        OutputStream os = response.getOutputStream();
        DB connt = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet sqlSel = null;
        ResultSet rs = null;
        Statement st = null;
        try {
            conn = connt.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            HSSFWorkbook workbook = new HSSFWorkbook();
            HSSFSheet sheet = workbook.createSheet("Sheet1");
            String cardType = request.getParameter("cardType");
            String[] traficType = request.getParameterValues("DebFilial");
            String tr_types = "";

            int Z = 0;

            while (Z < traficType.length) {
                tr_types = tr_types + "'" + traficType[Z] + "',";
                Z++;
            }
            tr_types = tr_types.substring(0, tr_types.length() - 1);
            //   System.out.println("tr_types  "+tr_types);
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String Filial = request.getParameter("Filial");

            String TarixSQL = "  where   act_date   between   to_date('" + DateB + "', 'DD-MM-YYYY') "
                    + " AND  to_date('" + DateE + "', 'DD-MM-YYYY')  ";
            String FilialSql = "";
            if (Filial.equals("0")) {
                FilialSql = "";
            } else {
                FilialSql = " and PER.filial_code=" + Filial;
            }
            String portfolio_sort = request.getParameter("portfolio_sort");
            String portfolio_sortSQL = "";
            if ((request.getParameter("portfolio_sort") != null) & (request.getParameter("portfolio_sort") != "") & (!(request.getParameter("portfolio_sort").trim().equals("")))) {
                portfolio_sort = portfolio_sort.replace(" ", "','");
                portfolio_sortSQL = " and BAL.INPUTTER in ('" + portfolio_sort + "')";
            }

            String cardTypeSql = "";
            if (cardType.equals("0")) {
                cardTypeSql = "";
            } else {
                cardTypeSql = " and a.CARD_TYPE='" + cardType + "'";
            }

            String tr_typesSql = "";
            if (tr_types.equals("")) {
                tr_typesSql = "";
            } else {
                tr_typesSql = " and a.product_id in (" + tr_types + ")";
            }

            String Text = "  SELECT  * FROM sql_select  where id = 11 ";
            st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
            java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
            String SQLText = clob.getSubString(1, (int) clob.length());

            SQLText = SQLText.replaceAll("FilialSql", FilialSql);
            SQLText = SQLText.replaceAll("portfolio_sortSQL", portfolio_sortSQL);
            SQLText = SQLText.replaceAll("cardTypeSql", cardTypeSql);
            SQLText = SQLText.replaceAll("tr_typesSql", tr_typesSql);
            SQLText = SQLText.replaceAll("DateE", DateE);
            SQLText = SQLText.replaceAll("TarixSQL", TarixSQL);

            stmt = conn.createStatement();

            sqlSel = stmt.executeQuery(SQLText);

            CellStyle cellStyle = workbook.createCellStyle();

            CreationHelper createHelper = workbook.getCreationHelper();
            cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));
            // Set the date format of date

            int count = sqlSel.getMetaData().getColumnCount();

            Row row = sheet.createRow(0);
            Cell cell;

            for (int i = 1; i <= count; i++) {
                cell = row.createCell(i);
                cell.setCellValue(sqlSel.getMetaData().getColumnName(i));
                //    cell.setCellStyle(style);
            };
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

            workbook.write(os);

        } catch (SQLException ex) {
            Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalArgumentException ex) {
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
            } catch (IllegalArgumentException ex) {
                Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
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
