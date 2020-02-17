/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.text.ParseException;
import java.util.Date;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
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
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import java.lang.IllegalArgumentException;
import java.util.Locale;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "MarketingCredExcel", urlPatterns = {"/MarketingCredExcel"})
public class MarketingCredExcel extends HttpServlet {

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
            throws ServletException, IOException, ClassNotFoundException, ParseException {

        response.setHeader("Content-Disposition", "attachment;filename=KreditPortfeli(Marketinq).xlsx");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8");
        OutputStream os = response.getOutputStream();

        ResultSet sqlSel = null;
        Statement stmt = null;
        ResultSet rs = null;
        Statement st = null;
        DB db = new DB();
        Connection conn = null;
        DB connt = new DB();
        SXSSFWorkbook workbook = null;
        try {
            try {
                conn = connt.connect();
                DecimalFormat df = new DecimalFormat("0.00");

                workbook = new SXSSFWorkbook();
                SXSSFSheet sheet = (SXSSFSheet) workbook.createSheet("Sheet1");

                String Tarix = request.getParameter("TrDateB");
                String valueB = request.getParameter("valueB");
                String valueE = request.getParameter("valueE");
                String matB = request.getParameter("matB");
                String matE = request.getParameter("matE");
                String Filial = request.getParameter("Filial");

                String FilialSql = "";
                if (Filial.equals("0")) {
                    FilialSql = "";
                } else {
                    FilialSql = " and l.filial_code   =" + Filial;
                }
                String product_id = request.getParameter("product_id");
                String prodSql = "";
                if (Integer.parseInt(request.getParameter("product_id")) != 0) {
                    prodSql = " and l.product_id=" + product_id;
                }

                //Integer.parseInt(request.getParameter("contr_type"));
                //   System.out.println(closed); 
                SimpleDateFormat df1 = new SimpleDateFormat("dd-mm-yyyy", Locale.getDefault());
                SimpleDateFormat df2 = new SimpleDateFormat("yyyy-mm-dd", Locale.getDefault());

                Date dateB;
                Date date1;
                Date date2;
                Date date3;
                Date date4;

                try {
                    if (!Tarix.equals("")) {
                        dateB = df1.parse(Tarix);
                        Tarix = df2.format(dateB);
                    }
                    if (!valueB.equals("")) {
                        date1 = df1.parse(valueB);
                        valueB = df2.format(date1);
                    }
                    if (!valueE.equals("")) {
                        date2 = df1.parse(valueE);
                        valueE = df2.format(date2);
                    }
                    if (!matB.equals("")) {
                        date3 = df1.parse(matB);
                        matB = df2.format(date3);
                    }

                    if (!matE.equals("")) {
                        date4 = df1.parse(matE);
                        matE = df2.format(date4);
                    }

                } catch (ParseException ex) {
                    Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
                }

                //  System.out.println("valueB "+valueB);
//  System.out.println("valueE "+valueE);
//  System.out.println("matB "+matB);
                // System.out.println("matE "+matE);
                String valueBSQL = "";
                if ((!valueB.trim().equals("")) && (!valueE.trim().equals(""))) {
                    valueBSQL = "  and    l.value_DATE   between   to_date('" + valueB + "', 'yyyy-mm-dd')   and    to_date( '" + valueE + "' , 'yyyy-mm-dd') ";
                }

                String matBSQL = "";
                if ((!matB.trim().equals("")) && (!matE.trim().equals(""))) {
                    matBSQL = "  and    l.maturity_DATE   between   to_date('" + matB + "', 'yyyy-mm-dd')   and    to_date( '" + matE + "' , 'yyyy-mm-dd') ";
                }

                String SqlCredLines = "";
                String SqlCredLinesClose = "";
                String SqlCredits = "";
                String SqlCreditsClose = "";
                String SqlBankCredits = "";
                String SqlBankCreditsClose = "";
                String SqlCardCredits = "";
                String SqlCardCreditsClose = "";
                String SqlFullLimitCredits = "";

                String Text = "  SELECT  * FROM sql_select  where id = 8 ";
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
                SqlFullLimitCredits = clob4.getSubString(1, (int) clob4.length());

                SqlCredLines = SqlCredLines.replaceAll("FilialSql", FilialSql);
                SqlCredLines = SqlCredLines.replaceAll("Tarix", Tarix);
                SqlCredLines = SqlCredLines.replaceAll("prodSql", prodSql);
                SqlCredLines = SqlCredLines.replaceAll("valueBSQL", valueBSQL);
                SqlCredLines = SqlCredLines.replaceAll("matBSQL", matBSQL);

                SqlCredits = SqlCredits.replaceAll("FilialSql", FilialSql);
                SqlCredits = SqlCredits.replaceAll("Tarix", Tarix);
                SqlCredits = SqlCredits.replaceAll("prodSql", prodSql);
                SqlCredits = SqlCredits.replaceAll("valueBSQL", valueBSQL);
                SqlCredits = SqlCredits.replaceAll("matBSQL", matBSQL);

                SqlBankCredits = SqlBankCredits.replaceAll("FilialSql", FilialSql);
                SqlBankCredits = SqlBankCredits.replaceAll("Tarix", Tarix);
                SqlBankCredits = SqlBankCredits.replaceAll("prodSql", prodSql);
                SqlBankCredits = SqlBankCredits.replaceAll("valueBSQL", valueBSQL);
                SqlBankCredits = SqlBankCredits.replaceAll("matBSQL", matBSQL);

                SqlCardCredits = SqlCardCredits.replaceAll("FilialSql", FilialSql);
                SqlCardCredits = SqlCardCredits.replaceAll("Tarix", Tarix);
                SqlCardCredits = SqlCardCredits.replaceAll("prodSql", prodSql);
                SqlCardCredits = SqlCardCredits.replaceAll("valueBSQL", valueBSQL);
                SqlCardCredits = SqlCardCredits.replaceAll("matBSQL", matBSQL);

                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("FilialSql", FilialSql);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("Tarix", Tarix);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("prodSql", prodSql);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("valueBSQL", valueBSQL);
                SqlFullLimitCredits = SqlFullLimitCredits.replaceAll("matBSQL", matBSQL);

//     System.out.println( "SqlCredLines   "  +   SqlCredLines);
//     System.out.println( "SqlCredits   "  +   SqlCredits);
//     System.out.println( "SqlBankCredits  "   +  SqlBankCredits);  
//     System.out.println("SqlCardCredits  card"  + SqlCardCredits);
//     System.out.println("SqlFullLimitCredits   "  +  SqlFullLimitCredits);
                if (Filial.equals("0")) {
                    FilialSql = "";
                } else {
                    FilialSql = " and c.filial_code   =" + Filial;
                }

                if (Integer.parseInt(request.getParameter("product_id")) != 0) {
                    prodSql = " and c.product_id=" + product_id;
                }

                if ((!valueB.trim().equals("")) && (!valueE.trim().equals(""))) {
                    valueBSQL = "  and    c.value_DATE   between   to_date('" + valueB + "', 'yyyy-mm-dd')   and    to_date( '" + valueE + "' , 'yyyy-mm-dd') ";
                }

                if ((!matB.trim().equals("")) && (!matE.trim().equals(""))) {
                    matBSQL = "  and    c.maturity_DATE   between   to_date('" + matB + "', 'yyyy-mm-dd')   and    to_date( '" + matE + "' , 'yyyy-mm-dd') ";
                }

                String Text1 = "  SELECT  * FROM sql_select  where id = 8 ";

                rs = st.executeQuery(Text1);
                rs.next();
                java.sql.Clob clob5 = (java.sql.Clob) rs.getClob(8);
                java.sql.Clob clob6 = (java.sql.Clob) rs.getClob(9);
                java.sql.Clob clob7 = (java.sql.Clob) rs.getClob(10);
                java.sql.Clob clob8 = (java.sql.Clob) rs.getClob(11);

                SqlCredLinesClose = clob5.getSubString(1, (int) clob5.length());
                SqlCreditsClose = clob6.getSubString(1, (int) clob6.length());
                SqlBankCreditsClose = clob7.getSubString(1, (int) clob7.length());
                SqlCardCreditsClose = clob8.getSubString(1, (int) clob8.length());

                SqlCredLinesClose = SqlCredLinesClose.replaceAll("FilialSql", FilialSql);
                SqlCredLinesClose = SqlCredLinesClose.replaceAll("Tarix", Tarix);
                SqlCredLinesClose = SqlCredLinesClose.replaceAll("prodSql", prodSql);
                SqlCredLinesClose = SqlCredLinesClose.replaceAll("valueBSQL", valueBSQL);
                SqlCredLinesClose = SqlCredLinesClose.replaceAll("matBSQL", matBSQL);

                SqlCreditsClose = SqlCreditsClose.replaceAll("FilialSql", FilialSql);
                SqlCreditsClose = SqlCreditsClose.replaceAll("Tarix", Tarix);
                SqlCreditsClose = SqlCreditsClose.replaceAll("prodSql", prodSql);
                SqlCreditsClose = SqlCreditsClose.replaceAll("valueBSQL", valueBSQL);
                SqlCreditsClose = SqlCreditsClose.replaceAll("matBSQL", matBSQL);

                SqlBankCreditsClose = SqlBankCreditsClose.replaceAll("FilialSql", FilialSql);
                SqlBankCreditsClose = SqlBankCreditsClose.replaceAll("Tarix", Tarix);
                SqlBankCreditsClose = SqlBankCreditsClose.replaceAll("prodSql", prodSql);
                SqlBankCreditsClose = SqlBankCreditsClose.replaceAll("valueBSQL", valueBSQL);
                SqlBankCreditsClose = SqlBankCreditsClose.replaceAll("matBSQL", matBSQL);

                SqlCardCreditsClose = SqlCardCreditsClose.replaceAll("FilialSql", FilialSql);
                SqlCardCreditsClose = SqlCardCreditsClose.replaceAll("Tarix", Tarix);
                SqlCardCreditsClose = SqlCardCreditsClose.replaceAll("prodSql", prodSql);
                SqlCardCreditsClose = SqlCardCreditsClose.replaceAll("valueBSQL", valueBSQL);
                SqlCardCreditsClose = SqlCardCreditsClose.replaceAll("matBSQL", matBSQL);
//            System.out.println("SqlCredLinesClose    "  + SqlCredLinesClose);
//         System.out.println("SqlCreditsClose   "  + SqlCreditsClose);
//      System.out.println("SqlBankCreditsClose   "  + SqlBankCreditsClose);
//       System.out.println("SqlCardCreditsClose  "  +  SqlCardCreditsClose);
                conn = db.connect();

                String FullSql = "";

                FullSql = SqlCredLines
                        + " union all " + SqlCredLinesClose
                        + " union all " + SqlCredits + " union all " + SqlCreditsClose
                        + " union all " + SqlBankCredits + " union all " + SqlBankCreditsClose
                        + " union all " + SqlCardCredits + " union all " + SqlCardCreditsClose
                        + " union all " + SqlFullLimitCredits;

                //   System.out.println("FullSql  "  + FullSql);
                stmt = conn.createStatement();
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
                // cell.setCellValue("CÆ?M:");
                // cell.setCellStyle(style);

                /*cell =  row.createCell(2);
                 cell.setCellFormula("SUM(C2:C"+j+")");
                 cell.setCellStyle(style);   
                 */
                /*  font = workbook.createFont();
                 font.setItalic(true);
                 style = workbook.createCellStyle();
                 style.setFont(font); */
                workbook.write(os);

            } catch (SQLException ex) {
                Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalArgumentException ex) {
                Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
            }

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
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(MarketingCredExcel.class.getName()).log(Level.SEVERE, null, ex);
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
