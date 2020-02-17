/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author j.gazikhanov
 */
@WebServlet(name = "DownloadsFile", urlPatterns = {"/DownloadsFile"})
public class DownloadsFile extends HttpServlet {

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
        final String fileNamePath = request.getParameter("fileNamePath");
        
        File file = null;
        FileInputStream fileInputStream = null;
        try 
        {
            file = new File(fileNamePath);
            fileInputStream = new FileInputStream(file);
            final byte[] fileContent = new byte[(int) file.length()];
            fileInputStream.read(fileContent);
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename="+file.getName());
            response.getOutputStream().write(fileContent, 0, fileContent.length);
        } 
        catch (Exception ex) {
            ex.printStackTrace();
            Logger.getLogger(DownloadsFile.class.getName()).log(Level.SEVERE, null, ex);
            throw new ServletException(ex);
        }
        finally 
        {
            if (fileInputStream != null) 
            {
                fileInputStream.close();
            }
            
            if (file != null && file.exists()) {
                try {
                    file.delete();
                } catch (Exception ex) {
                    Logger.getLogger(DownloadsFile.class.getName()).log(Level.SEVERE, null, ex);
                }
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
