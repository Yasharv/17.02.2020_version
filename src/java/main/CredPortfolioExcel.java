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
 * @author m.aliyev
 */
@WebServlet(name = "CredPortfolioExcel", urlPatterns = {"/CredPortfolioExcel"})
public class CredPortfolioExcel extends HttpServlet {

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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException, SQLException, ParseException {

        response.setHeader("Content-Disposition", "attachment;filename=Kredit_Portfeli.xlsx");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8");
        OutputStream os = response.getOutputStream();
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        ResultSet sqlSel = null;
        Statement stmt = null;
        ResultSet rs = null;
        Statement st = null;
       
        DB db = new DB();
        Connection conn = null;
        conn = db.connect();
        try {

            String Tarix = request.getParameter("TrDateB");
            //System.out.println("Tarix "+Tarix);
            String Filial = request.getParameter("Filial");
            //System.out.println("Filial "+Filial);
            String FilialSql = "";
            if (Filial.equals("0")) {
                FilialSql = "";
            } else {
                FilialSql = " and l.filial_code=" + Filial;
            }
            String product_id = request.getParameter("product_id");
            //System.out.println("productId");
            String prodSql = "";
            if (Integer.parseInt(request.getParameter("product_id")) != 0) {
                prodSql = " and l.product_id=" + product_id;
            }
            String custid = request.getParameter("custid");
            //System.out.println("custid "+custid);
            String custidSQL = "";
            if ((request.getParameter("custid") != null) & (request.getParameter("custid") != "") & (!(request.getParameter("custid").trim().equals("")))) {
                custidSQL = " and l.customer_id=" + custid;
            }
            String report = request.getParameter("report");

           //  System.out.println("report "+report);
            String status = request.getParameter("status");
            // System.out.println("status "+status);
            SimpleDateFormat df1 = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat df2 = new SimpleDateFormat("yyyy-mm-dd");

            Date dateB;
            dateB = df1.parse(Tarix);
            Tarix = df2.format(dateB);
            String SqlCredLines = "";
            String SqlCredits = "";
            String SqlBankCredits = "";
            String SqlCardCredits = "";
            String SqlFullLimitCredits = "";
            String FullSql = "";
            //System.out.println("status  " + status);

            if (status.equals("1")) {

                String Text = "  SELECT * FROM sql_select_demo where id = 10 ";
                st = conn.createStatement();
                rs = st.executeQuery(Text);
                rs.next();
                java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
                java.sql.Clob clob1 = (java.sql.Clob) rs.getClob(4);
                java.sql.Clob clob2 = (java.sql.Clob) rs.getClob(5);
                java.sql.Clob clob3 = (java.sql.Clob) rs.getClob(6);
                java.sql.Clob clob4 = (java.sql.Clob) rs.getClob(7);
                java.sql.Clob clob5 = (java.sql.Clob) rs.getClob(8);
                if (report.equals("1")) {
                    SqlCredLines = clob.getSubString(1, (int) clob.length());
                    SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                    SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                    SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                    SqlCredLines = SqlCredLines.replaceAll("custidSQL", custidSQL);

                } else {
                    SqlCredLines = clob1.getSubString(1, (int) clob1.length());
                    SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                    SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                    SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                    SqlCredLines = SqlCredLines.replaceAll("custidSQL", custidSQL);

                }
                /*System.out.println("SqlCredLines  " + SqlCredLines);
                System.out.println("--@@@@@@@@@@@@@@@@@@@@@@@--");*/
                //    contract_type if  1 else  4  olanlar
                SqlCredits = clob2.getSubString(1, (int) clob2.length());
                SqlCredits = SqlCredits.replaceAll("FilialSql", FilialSql);
                SqlCredits = SqlCredits.replaceAll("Tarix", Tarix);
                SqlCredits = SqlCredits.replaceAll("prodSql", prodSql);
                SqlCredits = SqlCredits.replaceAll("custidSQL", custidSQL);

                /*System.out.println("SqlCredits  "+  SqlCredits);
                System.out.println("--@@@@@@@@@@@@@@@@@@@@@@@--");*/
                //contract_type 3 olanlar
                SqlBankCredits = clob3.getSubString(1, (int) clob3.length());
                SqlBankCredits = SqlBankCredits.replaceAll("FilialSql", FilialSql);
                SqlBankCredits = SqlBankCredits.replaceAll("Tarix", Tarix);
                SqlBankCredits = SqlBankCredits.replaceAll("prodSql", prodSql);
                SqlBankCredits = SqlBankCredits.replaceAll("custidSQL", custidSQL);
                /*
                System.out.println("SqlBankCredits" +SqlBankCredits);
                System.out.println("--@@@@@@@@@@@@@@@@@@@@@@@--");*/
                //contract_type 2 olanlar
                SqlCardCredits = clob4.getSubString(1, (int) clob4.length());
                SqlCardCredits = SqlCardCredits.replaceAll("FilialSql", FilialSql);
                SqlCardCredits = SqlCardCredits.replaceAll("Tarix", Tarix);
                SqlCardCredits = SqlCardCredits.replaceAll("prodSql", prodSql);
                SqlCardCredits = SqlCardCredits.replaceAll("custidSQL", custidSQL);
                /*
                System.out.println("SqlCardCredits   " +  SqlCardCredits);
                System.out.println("--@@@@@@@@@@@@@@@@@@@@@@@--");*/
                SqlFullLimitCredits = clob5.getSubString(1, (int) clob5.length());
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("FilialSql", FilialSql);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("Tarix", Tarix);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("prodSql", prodSql);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("custidSQL", custidSQL);

                /*System.out.println("SqlFullLimitCredits   " +  SqlFullLimitCredits);
                System.out.println("--@@@@@@@@@@@@@@@@@@@@@@@--");*/
                FullSql = SqlCredLines + " union all " + SqlCredits + " union all " 
                        + SqlBankCredits + " union all " + SqlCardCredits + " union all " + SqlFullLimitCredits;
                System.out.println("FullSql1 "+FullSql);
            } else if (status.equals("3")) {

                String Text = "  SELECT  * FROM sql_select_demo  where id = 39 ";
                st = conn.createStatement();
                rs = st.executeQuery(Text);
                rs.next();
                java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
                java.sql.Clob clob1 = (java.sql.Clob) rs.getClob(4);
                java.sql.Clob clob2 = (java.sql.Clob) rs.getClob(5);
                java.sql.Clob clob3 = (java.sql.Clob) rs.getClob(6);
                java.sql.Clob clob4 = (java.sql.Clob) rs.getClob(7);
                java.sql.Clob clob5 = (java.sql.Clob) rs.getClob(8);
                if (report.equals("1")) {
                    SqlCredLines = clob.getSubString(1, (int) clob.length());
                    SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                    SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                    SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                    SqlCredLines = SqlCredLines.replaceAll("custidSQL", custidSQL);

                } else {
                    SqlCredLines = clob1.getSubString(1, (int) clob1.length());
                    SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                    SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                    SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                    SqlCredLines = SqlCredLines.replaceAll("custidSQL", custidSQL);

                }
                 //  System.out.println("SqlCredLines  " + SqlCredLines);
                //    contract_type if  1 else  4  olanlar
                SqlCredits = clob2.getSubString(1, (int) clob2.length());
                SqlCredits = SqlCredits.replaceAll("FilialSql", FilialSql);
                SqlCredits = SqlCredits.replaceAll("Tarix", Tarix);
                SqlCredits = SqlCredits.replaceAll("prodSql", prodSql);
                SqlCredits = SqlCredits.replaceAll("custidSQL", custidSQL);

                //  System.out.println("SqlCredits  "+  SqlCredits);
                //contract_type 3 olanlar
                SqlBankCredits = clob3.getSubString(1, (int) clob3.length());
                SqlBankCredits = SqlBankCredits.replaceAll("FilialSql", FilialSql);
                SqlBankCredits = SqlBankCredits.replaceAll("Tarix", Tarix);
                SqlBankCredits = SqlBankCredits.replaceAll("prodSql", prodSql);
                SqlBankCredits = SqlBankCredits.replaceAll("custidSQL", custidSQL);

                 //  System.out.println("SqlBankCredits  "+ SqlBankCredits);
                //contract_type 2 olanlar
                SqlCardCredits = clob4.getSubString(1, (int) clob4.length());
                SqlCardCredits = SqlCardCredits.replaceAll("FilialSql", FilialSql);
                SqlCardCredits = SqlCardCredits.replaceAll("Tarix", Tarix);
                SqlCardCredits = SqlCardCredits.replaceAll("prodSql", prodSql);
                SqlCardCredits = SqlCardCredits.replaceAll("custidSQL", custidSQL);

                //   System.out.println("SqlCardCredits   " +  SqlCardCredits);
                SqlFullLimitCredits = clob5.getSubString(1, (int) clob5.length());
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("FilialSql", FilialSql);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("Tarix", Tarix);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("prodSql", prodSql);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("custidSQL", custidSQL);

                 // System.out.println("SqlFullLimitCredits   " +  SqlFullLimitCredits);
                FullSql = SqlCredLines + " union all " + SqlCredits + " union all "
                        + SqlBankCredits + " union all " + SqlCardCredits + " union all " + SqlFullLimitCredits;
                //System.out.println("FullSql3 "+FullSql);
            } else if (status.equals("2")) {

                String Text = "  SELECT  * FROM sql_select_demo  where id = 31 ";
                st = conn.createStatement();
                rs = st.executeQuery(Text);
                rs.next();
                java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
                java.sql.Clob clob1 = (java.sql.Clob) rs.getClob(4);
                java.sql.Clob clob2 = (java.sql.Clob) rs.getClob(5);
                java.sql.Clob clob3 = (java.sql.Clob) rs.getClob(6);
                java.sql.Clob clob4 = (java.sql.Clob) rs.getClob(7);
                if (report.equals("1")) {
                    SqlCredLines = clob.getSubString(1, (int) clob.length());
                    SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                    SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                    SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                    SqlCredLines = SqlCredLines.replaceAll("custidSQL", custidSQL);

                } else {
                    SqlCredLines = clob1.getSubString(1, (int) clob1.length());
                    SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                    SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                    SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                    SqlCredLines = SqlCredLines.replaceAll("custidSQL", custidSQL);

                }
               //   System.out.println("SqlCredLines  " + SqlCredLines);
                //    contract_type if  1 else  4  olanlar
                SqlCredits = clob2.getSubString(1, (int) clob2.length());
                SqlCredits = SqlCredits.replaceAll("FilialSql", FilialSql);
                SqlCredits = SqlCredits.replaceAll("Tarix", Tarix);
                SqlCredits = SqlCredits.replaceAll("prodSql", prodSql);
                SqlCredits = SqlCredits.replaceAll("custidSQL", custidSQL);

             //    System.out.println("SqlCredits  "+  SqlCredits);
                //contract_type 3 olanlar
                SqlBankCredits = clob3.getSubString(1, (int) clob3.length());
                SqlBankCredits = SqlBankCredits.replaceAll("FilialSql", FilialSql);
                SqlBankCredits = SqlBankCredits.replaceAll("Tarix", Tarix);
                SqlBankCredits = SqlBankCredits.replaceAll("prodSql", prodSql);
                SqlBankCredits = SqlBankCredits.replaceAll("custidSQL", custidSQL);

                //  System.out.println("SqlBankCredits   "  +  SqlBankCredits);
                //contract_type 2 olanlar
                SqlCardCredits = clob4.getSubString(1, (int) clob4.length());
                SqlCardCredits = SqlCardCredits.replaceAll("FilialSql", FilialSql);
                SqlCardCredits = SqlCardCredits.replaceAll("Tarix", Tarix);
                SqlCardCredits = SqlCardCredits.replaceAll("prodSql", prodSql);
                SqlCardCredits = SqlCardCredits.replaceAll("custidSQL", custidSQL);

                //  System.out.println("SqlCardCredits   " +  SqlCardCredits);
                FullSql = SqlCredLines + " union all " + SqlCredits + " union all "
                        + SqlBankCredits + " union all " + SqlCardCredits;
               // System.out.println("FullSql2 "+FullSql);
            }
            //System.out.println("SqlCredLines "+SqlCredLines);
            //System.out.println("fullSql " + FullSql);
            DecimalFormat df = new DecimalFormat("0.00");

            Sheet sheet = workbook.createSheet("Sheet1");

            stmt = conn.createStatement();

              
            System.out.println("FullSql ==> " + FullSql);
            
            sqlSel = stmt.executeQuery(FullSql);

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
                    if ((sqlSel.getMetaData().getColumnType(i) == -9) | (sqlSel.getMetaData().getColumnType(i) == 12) | (sqlSel.getMetaData().getColumnType(i) == 1)) {
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

            for (i = 0; i <= Index; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(os);

        } finally {
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
            try {
                processRequest(request, response);
            } catch (ParseException ex) {
                Logger.getLogger(CredPortfolioExcel.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CredPortfolioExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CredPortfolioExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            try {
                processRequest(request, response);
            } catch (ParseException ex) {
                Logger.getLogger(CredPortfolioExcel.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CredPortfolioExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(CredPortfolioExcel.class.getName()).log(Level.SEVERE, null, ex);
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
