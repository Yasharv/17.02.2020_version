<%-- 
    Document   : StatmPrint
    Created on : Dec 21, 2012, 4:07:50 PM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="main.DB"%>
<%@page import="java.io.OutputStream"%>
<%@page import="main.PrintPDF"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%

                
         String srcValue = request.getParameter("srcValue");
                String forSrc = request.getParameter("forSrc");
                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE"); 
                String reval = request.getParameter("reval");
                String SQLText = "SELECT max(date_from) date_from,alt_acct_id,customer_id,gl_acct_no"
                                 +" FROM bi_account_inf_bal ";
      
                int iforSrc = Integer.valueOf(forSrc);
             switch (iforSrc) {
             case 1:  SQLText = SQLText+" where customer_id in ("+srcValue+")";
                      break;
             case 2:  SQLText = SQLText+" where alt_acct_id in ('"+srcValue+"')";
                      break;
             case 3:  SQLText = SQLText+" where gl_acct_no in ("+srcValue+")";
                      break;
                              }
            SQLText = SQLText+" group by alt_acct_id,customer_id,gl_acct_no"
                    + " order by alt_acct_id";

                 String TrType = "";
             if (Integer.parseInt(reval)==0) TrType = " AND transaction_type<>'REVAL' " ;
                else
             if (Integer.parseInt(reval)==1) TrType= " ";
       
        PrintPDF pdf = new PrintPDF();
         DB db = new DB(); 
         Connection conn = db.connect();
         Format formatter = new SimpleDateFormat("dd-MM-yyyy");
         DecimalFormat twoDForm = new DecimalFormat("0.00");
         Statement stmt = conn.createStatement();

         ResultSet sqlres =  stmt.executeQuery(SQLText);
        
         Document document = new Document();
         ByteArrayOutputStream baos = new ByteArrayOutputStream();
         PdfWriter writer =  PdfWriter.getInstance(document, baos);

         document.open();
         String acc_no ="";
         String AccMaxDate ="";
         while (sqlres.next())
         {
          acc_no= sqlres.getString(2); 
          AccMaxDate = formatter.format(sqlres.getDate(1)); 
         pdf.AddTrByAccNo(document, writer, acc_no, DateB, DateE,AccMaxDate);
         }
         document.close();
        sqlres.close();
        stmt.close();
        conn.close();
       
             response.setHeader("Expires", "0");
             response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
             response.setHeader("Pragma", "public");
             response.setContentType("application/pdf");  // setting the content type
             response.setContentLength(baos.size());// the contentlength
             OutputStream os = response.getOutputStream(); // write ByteArrayOutputStream to the ServletOutputStream
             baos.writeTo(os);
             out.println(os);
             os.flush();
             os.close();
       // out.println(pdf.createPdf(102415, DateB, DateE,res));  
        %>
    </body>
</html>
