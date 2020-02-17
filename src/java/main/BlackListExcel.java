/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.Charset;
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
@WebServlet(name = "BlackListExcel", urlPatterns = {"/BlackListExcel"})
public class BlackListExcel extends HttpServlet {

    final Charset windowsCharset = Charset.forName("windows-1252");
    final Charset utfCharset = Charset.forName("UTF-8");

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
        response.setHeader("Content-Disposition", "attachment;filename=BlackList.xlsx");
        response.setContentType("application/vnd.ms-excel");

        OutputStream os = response.getOutputStream();
        DB connt = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet sqlSel = null;
        SXSSFWorkbook workbook = null;
        try {
            conn = connt.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            workbook = new SXSSFWorkbook();
            Sheet sheet = workbook.createSheet("Sheet1");
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String intext = "";
            String status = request.getParameter("status");

            if (status.equals("0")) {

                intext = "";
            } else {

                intext = "  and SLC.problem_department = '" + status + "' ";
            }

            String intext_real = "";

            String status_real = request.getParameter("status_real");

            if (status_real.equals("0")) {
                intext_real = "";
            } else {

                intext_real = "  and SLC.problem_department_real = '" + status_real + "' ";
            }

            String custid = request.getParameter("custid");
            String custidSQL = "";
            if ((request.getParameter("custid") != null) & (request.getParameter("custid") != "") & (!(request.getParameter("custid").trim().equals("")))) {
                custidSQL = " and slc.customer_id=" + custid;
            }
            String contract_id = request.getParameter("contract_id");
            String contract_idSQL = "";
            if ((request.getParameter("contract_id") != null) & (request.getParameter("contract_id") != "") & (!(request.getParameter("contract_id").trim().equals("")))) {
                contract_id = contract_id.replace(",", "','");
                contract_idSQL = " and slc.contract_id in ('" + contract_id + "')";
            }

            String FilialSql = request.getParameter("Filial");

            String PROBLEM_DEPARTMENT_USER = request.getParameter("PROBLEM_DEPARTMENT_USER");
            String PROBLEM_DEPARTMENT_USERSQL = "";
            if ((request.getParameter("PROBLEM_DEPARTMENT_USER") != null) & (request.getParameter("PROBLEM_DEPARTMENT_USER") != "") & (!(request.getParameter("PROBLEM_DEPARTMENT_USER").trim().equals("")))) {
                PROBLEM_DEPARTMENT_USER = PROBLEM_DEPARTMENT_USER.replace(",", "','");
                PROBLEM_DEPARTMENT_USERSQL = " and slc.PROBLEM_DEPARTMENT_USER in ('" + PROBLEM_DEPARTMENT_USER + "')";
            }

            String product_id = request.getParameter("product_id");
            String prodSql = "";
            if (Integer.parseInt(request.getParameter("product_id")) != 0) {
                prodSql = " and slc.product_id=" + product_id;
            }

            String other_officer = request.getParameter("other_officer");
            String other_officerSQL = "";
            if ((request.getParameter("other_officer") != null) & (request.getParameter("other_officer") != "") & (!(request.getParameter("other_officer").trim().equals("")))) {
                other_officer = other_officer.replace(",", "','");
                other_officerSQL = " and slc.other_officer in ('" + other_officer + "')";
            }

            String Text = "  SELECT  * FROM sql_select  where id = 21 ";
            ResultSet rs = null;
            Statement st = null;
            st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
            java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);

            String SQLText = clob.getSubString(1, (int) clob.length());

            SQLText = SQLText.replaceAll("intext_real", intext_real);
            SQLText = SQLText.replaceAll("intext", intext);
            SQLText = SQLText.replaceAll("custidSQL", custidSQL);
            SQLText = SQLText.replaceAll("contract_idSQL", contract_idSQL);
            SQLText = SQLText.replaceAll("FilialSql", FilialSql);
            SQLText = SQLText.replaceAll("PROBLEM_DEPARTMENT_USERSQL", PROBLEM_DEPARTMENT_USERSQL);
            SQLText = SQLText.replaceAll("prodSql", prodSql);
            SQLText = SQLText.replaceAll("other_officerSQL", other_officerSQL);
            SQLText = SQLText.replaceAll("DateB", DateB);
            SQLText = SQLText.replaceAll("DateE", DateE);

             System.out.println("SQLText  " + SQLText);
            stmt = conn.createStatement();

            
            sqlSel = stmt.executeQuery(SQLText);

            CellStyle cellStyle = workbook.createCellStyle();
            CreationHelper createHelper = workbook.getCreationHelper();
            cellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));

            int count = sqlSel.getMetaData().getColumnCount();

            Row row = sheet.createRow(0);

            Cell cell;

            for (int i = 1; i <= count; i++) {

                //    System.out.println("type  " +  sqlSel.getMetaData().getColumnName(i) + "  " +  sqlSel.getMetaData().getColumnType(i));
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

            st.close();
            rs.close();

            row = sheet.createRow(j + 1);

            cell = row.createCell(0);

            int Index = cell.getColumnIndex();
            int i;

            for (i = 0; i <= Index; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(os);

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
