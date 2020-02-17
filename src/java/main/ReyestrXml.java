/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
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

/**
 *
 * @author x.dashdamirov
 */
@WebServlet(name = "ReyestrXml", urlPatterns = {"/ReyestrXml"})
public class ReyestrXml extends HttpServlet {

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
            throws ServletException, IOException, SQLException, ParseException {
        String dateB = request.getParameter("TrDateB");
        String dateE = request.getParameter("TrDateE");
        String acc = request.getParameter("RepVal");
        DateFormat timeformat = new SimpleDateFormat("HH:mm:ss");
        DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        Date currentdate = new Date();
        String currentdates = dateFormat.format(currentdate);
        String currenttime = timeformat.format(currentdate);

        response.setHeader("Content-Disposition", "attachment;filename=Reyestr_" + acc + "_" + currentdates + ":" + currenttime + ".xml");
        response.setContentType("application/xml;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {

            String DateB = dateB;
            String DateE = dateE;
            String account = acc;
//        System.out.println("DateB" + DateB);
//        System.out.println("DateE" + DateE);
//        System.out.println("account" + account);
            ResultSet rs = null;
            Statement st = null;
            DB db = new DB();
            Connection conn = db.connect();
            Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            Statement stmt1 = conn.createStatement();
            String SqlText = "  SELECT  * FROM sql_select  where id = 38 ";
            st = conn.createStatement();
            rs = st.executeQuery(SqlText);
            rs.next();
            java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
            java.sql.Clob clob1 = (java.sql.Clob) rs.getClob(4);
            java.sql.Clob clob2 = (java.sql.Clob) rs.getClob(5);
            java.sql.Clob clob3 = (java.sql.Clob) rs.getClob(6);

            SqlText = clob.getSubString(1, (int) clob.length());
            String SqlText1 = clob1.getSubString(1, (int) clob1.length());
            String SqlText2 = clob2.getSubString(1, (int) clob2.length());
            String SqlText3 = clob3.getSubString(1, (int) clob3.length());
            SimpleDateFormat df1 = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat df2 = new SimpleDateFormat("yyyy-mm-dd");
            Date dateB1;
            dateB1 = df1.parse(DateB);
            String DateB1 = df2.format(dateB1);

            Date dateB2;
            dateB2 = df1.parse(DateE);
            String DateB2 = df2.format(dateB2);

            SqlText = SqlText.replaceAll("DateBSql", DateB1);
            SqlText = SqlText.replaceAll("DateESql", DateB2);
            SqlText = SqlText.replaceAll("accountSql", account);

            SqlText1 = SqlText1.replaceAll("DateBSql", DateB1);
            SqlText1 = SqlText1.replaceAll("DateESql", DateB2);
            SqlText1 = SqlText1.replaceAll("accountSql", account);

            SqlText2 = SqlText2.replaceAll("DateBSql", DateB1);
            SqlText2 = SqlText2.replaceAll("DateESql", DateB2);
            SqlText2 = SqlText2.replaceAll("accountSql", account);

            SqlText3 = SqlText3.replaceAll("DateBSql", DateB1);
            SqlText3 = SqlText3.replaceAll("DateESql", DateB2);
            SqlText3 = SqlText3.replaceAll("accountSql", account);

            // System.out.println("SqlText  " + SqlText);
            //    System.out.println("SqlText2----------------------------------- " + SqlText2);
            //   System.out.println("SqlText3------------------------------------------------------------------------ " + SqlText3);
            ResultSet sqlres = stmt.executeQuery(SqlText2);
            ResultSet sqlres1 = stmt1.executeQuery(SqlText3);
            sqlres1.next();
            sqlres.last();
            int rowcount = sqlres.getRow();
            sqlres.beforeFirst();

            out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            out.println("<root  version =\"108\" kod=\"BSC_1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
                    + " xsi:noNamespaceSchemaLocation=\"BSC_1.xsd\" >");

            out.println("<product>");
            out.println("<voen>" + sqlres1.getString(1) + "</voen>");
            out.println("<odeyiciAdi>" + sqlres1.getString(2) + "</odeyiciAdi>");
            out.println("<dovr>" + DateB1 + "</dovr>");
            out.println("<dovr1>" + DateB2 + "</dovr1>");
            out.println("<umumiMed>" + sqlres1.getString(4) + "</umumiMed>");
            out.println("<umumiMex>" + sqlres1.getString(3) + "</umumiMex>");
            out.println("<hesabAcilmaTarixi>" + sqlres1.getString(5) + "</hesabAcilmaTarixi>");
            out.println("<hesabNomresi>" + account + "</hesabNomresi>");
            out.println("<registerTable>");

            int count = sqlres.getMetaData().getColumnCount();
            String[] StrArray;
            StrArray = new String[70];
            for (int i = 1; i <= count; i++) {
                StrArray[i] = sqlres.getMetaData().getColumnName(i);
            }

            // output.append("<ROWCOUNT>" + rowcount + "</ROWCOUNT>");
            while (sqlres.next()) {

                out.println("<row rowno=\"" + sqlres.getString(1) + "\">");

                out.println("<" + StrArray[2] + ">" + sqlres.getString(2) + "</" + StrArray[2] + ">");
                out.println("<" + StrArray[3] + ">" + sqlres.getString(3) + "</" + StrArray[3] + ">");
                out.println("<" + StrArray[4] + ">" + sqlres.getString(4) + "</" + StrArray[4] + ">");
                out.println("<" + StrArray[5] + ">" + sqlres.getString(5) + "</" + StrArray[5] + ">");
                out.println("<" + StrArray[6] + ">" + sqlres.getString(6) + "</" + StrArray[6] + ">");
                out.println("<" + StrArray[7] + ">" + sqlres.getString(7) + "</" + StrArray[7] + ">");
                out.println("<" + StrArray[8] + ">" + sqlres.getString(8) + "</" + StrArray[8] + ">");
                out.println("<" + StrArray[9] + ">" + sqlres.getString(9) + "</" + StrArray[9] + ">");
                out.println("<" + StrArray[10] + ">" + sqlres.getString(10) + "</" + StrArray[10] + ">");
                out.println("<" + StrArray[11] + ">" + sqlres.getString(11) + "</" + StrArray[11] + ">");
                out.println("<" + StrArray[12] + ">" + sqlres.getString(12) + "</" + StrArray[12] + ">");
                
                out.println("</row>");
            }
            
            out.println("</registerTable>");
            out.println("</product>");
            out.println("</root>");

        } catch (SQLException ex) {
           
            Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalArgumentException ex) {
           
            Logger.getLogger(BlackListExcel.class.getName()).log(Level.SEVERE, null, ex);
        } finally {

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
            } catch (SQLException ex) {
                Logger.getLogger(ReyestrXml.class.getName()).log(Level.SEVERE, null, ex);
            }
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
            try {
                processRequest(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(ReyestrXml.class.getName()).log(Level.SEVERE, null, ex);
            }
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
