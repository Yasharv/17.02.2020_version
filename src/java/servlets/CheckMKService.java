/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
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
import main.DBOnpay;
import webservice.Card;
import webservice.MKWebService;
import webservice.MKWebService_Service;

/**
 *
 * @author m.aliyev
 */
@WebServlet(name = "CheckMKService", urlPatterns = {"/CheckMKService"})
public class CheckMKService extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            MKWebService_Service ws = new MKWebService_Service();
            MKWebService mks = ws.getMKWebServicePort();
            mks.corrBalance();

            String sqlText = "SELECT a.cardaccount, a.ammount, a.currency, a.datetime FROM corr_balances_new a";
            DBOnpay db = new DBOnpay();
            conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sqlText);

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td align='center'>" + rs.getString(1) + "</td>");
                out.println("<td align='center'>" + df.format(rs.getDouble(2)) + "</td>");
                out.println("<td align='center'>" + rs.getString(3) + "</td>");
                out.println("<td align='center'>" + rs.getString(4) + "</td>");
                out.println("</tr>");
            }

        } catch (SQLException ex) {
            Logger.getLogger(CheckMKService.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();

            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(CheckMKService.class.getName()).log(Level.SEVERE, null, ex);
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
