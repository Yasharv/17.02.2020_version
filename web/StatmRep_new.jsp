<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>
<%@page import="main.StatementRep_new"%>
<%@page import="main.PrintPDF_new"%>
<!DOCTYPE html>
<html>
    <head>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 10mm 10mm 10mm 10mm;  /* this affects the margin in the printer settings */
            }

            .NonPrintable
            {
                display: none;
            }
        </style> 


        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->

        <%
            Date d = new Date();
            DB db = new DB();
            StatementRep_new html = new StatementRep_new();
            PrDict dict = new PrDict();

            SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
            String s = df.format(d);

            String strDateB = request.getParameter("DateB");
            String strDateE = request.getParameter("DateE");
            String br = request.getParameter("br");
            String reval = request.getParameter("reval");
            String turnover = request.getParameter("turnover");
            String SqlAccs = request.getParameter("SqlAccs");
            String salary_gr = request.getParameter("salary_gr");

            boolean insurance = false;
            String insurance_pdf = "";
            if (!(request.getParameter("sigorta") == null || request.getParameter("sigorta").equals("null"))) {
                insurance = true;
                insurance_pdf = "1";
            }
            String TrType = "";

            if (reval == null || reval == "" || reval.equals("null")) {
                TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
            } else if (Integer.parseInt(reval) == 0) {
                TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
            } else if (Integer.parseInt(reval) == 1) {
                TrType = " ";
            }
            
             String table = "  vi_transaction_acc_salary  ";

          
             
            Connection conn = null;
            Statement Accs = null;
            Statement stmt = null;
            ResultSet sqlresAccs = null;
            ResultSet sqlres = null;
            Statement stmt2 = null;
            ResultSet sqlTrCnt = null;
            String custid = "";
            int cust_id = 0;

            try {
                conn = db.connect();
                Accs = conn.createStatement();
                stmt = conn.createStatement();
                sqlresAccs = Accs.executeQuery(SqlAccs);
        %>

        <table width="900" border="0">
            <tr>
                <td valign="top">

                </td>
                <td valign="top"> 

            <center> 
                <table border="0" width="100%" >
                    <%
                            stmt2 = conn.createStatement();
                            int chk = 0;
                            String acc_no = "";

                            String acc_name = "";
                            String curr_name = "";
                            int CurrID;
                            String acc_open_date = "";
                            String AP = "";
                            String cust_inn = "";

                            while (sqlresAccs.next()) {

                                acc_no = sqlresAccs.getString(2);
                                acc_name = sqlresAccs.getString(5);
                                custid = sqlresAccs.getString(3);
                                cust_id = sqlresAccs.getInt(3);
                                curr_name = sqlresAccs.getString(6);
                                CurrID = sqlresAccs.getInt(7);
                                acc_open_date = df.format(sqlresAccs.getDate(8));
                                AP = sqlresAccs.getString(9);
                                String sqlTrCn = "select count(*) cnt from "+table+" where (acct_no_dt = '" + acc_no + "' or acct_no_cr='" + acc_no + "') and (tarix BETWEEN to_date('" + strDateB + "','dd-mm-yyyy') AND to_date('" + strDateE + "','dd-mm-yyyy')) " + TrType;
               //          System.out.println("sqlTrCnt " + sqlTrCn);
                                cust_inn = sqlresAccs.getString(11);

                                if (turnover.equals("1")) {
                                    sqlTrCnt = stmt2.executeQuery(sqlTrCn);
                                    

                                    while (sqlTrCnt.next()) {
                                        if (sqlTrCnt.getInt(1) > 0) {
                                                      if (salary_gr.equals("1")) {

               
                                            out.println("<tr><td>");
                                            out.println(html.main(acc_no, acc_name, curr_name, CurrID, acc_open_date, cust_inn, strDateB, strDateE, AP, reval, br, insurance, salary_gr));
                                            chk = 1;
                                            out.println("</td></tr>");
                                                      }
                                                      
                                                      else {
                                                      
                                                    out.println("<tr><td>");
                                            out.println(html.main(acc_no, acc_name, curr_name, CurrID, acc_open_date, cust_inn, strDateB, strDateE, AP, reval, br, insurance, salary_gr));
                                            chk = 1;
                                            out.println("</td></tr>");   
                                                      }
                                        }
                                    }
                                    sqlTrCnt.close();
                               
                                    } else {
                                    out.println("<tr><td>");
                                    out.println(html.main(acc_no, acc_name, curr_name, CurrID, acc_open_date, cust_inn, strDateB, strDateE, AP, reval, br, insurance, salary_gr));
                                    out.println("</td></tr>");
                                }

                            }


                            if ((chk == 0) & (turnover.equals("1"))) {
                                out.println("Bu müştəri üçün seçilən tarix aralığında heç bir əməliyyat olmamışdır!");
                            }
                        } catch (Exception ex) {
                            ex.toString();
                        } finally {


                            if (sqlresAccs != null) {
                                sqlresAccs.close();
                            }
                            if (sqlres != null) {
                                sqlres.close();
                            }
                            if (sqlTrCnt != null) {
                                sqlTrCnt.close();
                            }
                            if (stmt2 != null) {
                                stmt2.close();
                            }
                            if (stmt != null) {
                                stmt.close();
                            }
                            if (Accs != null) {
                                Accs.close();
                            }
                            if (conn != null) {
                                conn.close();
                            }
                        }
                    %>
                </table>
            </center>     
        </td>   
        <td valign="top" >
            <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
            <FORM  method="post" action="Print2PDF_new" name="post">
                <input type="hidden" name="pdfSql" value="<%=SqlAccs%>">   
                <input type="hidden" name="turnover" value="<%=turnover%>">  
                <input type="hidden" name="DateB" value=<%=strDateB%> />
                <input type="hidden" name="DateE" value=<%=strDateE%> />
                <input type="hidden" name="reval" value=<%=reval%> />
                <input type="hidden" name="sigorta" value="<%=insurance_pdf%>">
                <input type="hidden" name="salary_gr" value="<%=salary_gr%>">
                <input type="submit" name="pdf" value="PDF-ə at" class="NonPrintable">
            </FORM>
        </td> 
    </tr>
</table>

</body>
</html>