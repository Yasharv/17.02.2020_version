/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
 * @author m.aliyev
 */
@WebServlet(name = "ITDeptAddEdit", urlPatterns = {"/ITDeptAddEdit"})
public class ITDeptAddEdit extends HttpServlet {

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
            throws ServletException, IOException, ClassNotFoundException, SQLException, ParseException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            request.setCharacterEncoding("UTF-8");
            DB db = new DB();
            Connection conn = db.connect();
            String action = request.getParameter("ACTION");
            String tskID = request.getParameter("tskID");

            Statement stmt = conn.createStatement();
            String SqlQuery = "select * from ittasks";
            ResultSet sqlRes = stmt.executeQuery(SqlQuery);

            String tskname = "'" + request.getParameter("tskname") + "'";
            String dat = request.getParameter("dat");
            String deadline = request.getParameter("deadline");
            String complated = request.getParameter("complated");
            String username = "'" + request.getParameter("username") + "'";
            String desc = "'" + request.getParameter("desc") + "'";
            int status;
            if (action.equals("ADD")) {
                status = 0;
            } else {
                status = Integer.parseInt(request.getParameter("status"));
            }

            SimpleDateFormat dtformat = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");

            Date date1;
            Date date2;
            Date date3;

            date1 = dtformat.parse(dat);
            dat = "to_date('" + dtformat2.format(date1) + "','yyyy-mm-dd')";

            date2 = dtformat.parse(deadline);
            deadline = "to_date('" + dtformat2.format(date2) + "','yyyy-mm-dd')";

            String InsUpdSql = "select *from dual";

            if (action.equals("ADD")) {
                InsUpdSql = " insert into ittasks (taskname, dat, deadline, username, description) "
                        + " values (" + tskname + "," + dat + "," + deadline + "," + username + "," + desc + ")";
            } else if (action.equals("EDIT")) {
                if ((complated != null) & (!(complated.equals("")))) {
                    date3 = dtformat.parse(complated);
                    complated = "to_date('" + dtformat2.format(date3) + "','yyyy-mm-dd')";
                } else {
                    complated = "null";
                }

                InsUpdSql = " update ittasks set taskname=" + tskname + ", status=" + status + ", dat=" + dat + ", deadline=" + deadline + ", complated=" + complated + ", username=" + username + ", description=" + desc + " where id=" + tskID;
            }
            // System.out.print(InsertSql);
            PreparedStatement insstmt = conn.prepareStatement(InsUpdSql);
            /*   insstmt.setString(1, tskname);
             insstmt.setDate(2, dat);
             insstmt.setDate(3, deadline);
             insstmt.setString(4, username);
             insstmt.setString(5, desc);
             */
            insstmt.execute();
            conn.close();

            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Succes</title>");
            out.println("</head>");
            out.println("<body background=\"images/indx_bg.jpg\">");
            out.println("<h1><font color='white'>Task əlavə olundu </font></h1>");
            out.println(" <br> <button onclick=\"window.close();\">Bağla</button>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
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
                Logger.getLogger(ITDeptAddEdit.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ITDeptAddEdit.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ITDeptAddEdit.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(ITDeptAddEdit.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ITDeptAddEdit.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ITDeptAddEdit.class.getName()).log(Level.SEVERE, null, ex);
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
