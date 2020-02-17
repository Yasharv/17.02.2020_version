<%-- 
    Document   : TransRep
    Created on : Nov 8, 2012, 3:18:49 PM
    Author     : m.aliyev
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="main.DB"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<!doctype html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 15mm 10mm 15mm 10mm;  /* this affects the margin in the printer settings */
            }
            .NonPrintable
            {
                display: none;
            }      
        </style>
    </head>
    <body bgcolor=#E0EBEA>
        <%

            DB connt = new DB();

            String strDateB = request.getParameter("TrDateB");
            String strDateE = request.getParameter("TrDateE");
            String DFil = request.getParameter("DebFil");
            String FilialSql = "";
            if (!(DFil.equals("0")))
                    FilialSql=" and filial_code like ('%"+DFil+"%')";

            DateFormat formatter;
            Date dateB;
            Date dateE;

            dateB = new SimpleDateFormat("dd-mm-yyyy").parse(strDateB);
            strDateB = new SimpleDateFormat("yyyy-mm-dd").format(dateB);

            dateE = new SimpleDateFormat("dd-mm-yyyy").parse(strDateE);
            strDateE = new SimpleDateFormat("yyyy-mm-dd").format(dateE);
        //-------------------------------------------------------------------
            String SqlQueryB = "";
            Statement stmtB = connt.connect().createStatement();

            SqlQueryB = "SELECT tt_cash_sym Simvol,SUM(tt_amount_dt_lcy) Mebleg"
                    + " FROM si_teller_operation where tt_cash_sym is not null and substr(tt_cash_sym,1,1) =('B') and"
                    + " act_date between TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') and TO_DATE ('" + strDateE + "', 'yyyy-mm-dd') "
                 + " AND TELLER_GL_AC_1= 10010"
                    + FilialSql
                    + " group by tt_cash_sym"
                    + " ORDER BY tt_cash_sym";
          //    System.out.println("SqlQueryB   " + SqlQueryB);      
            ResultSet sqlSelB = stmtB.executeQuery(SqlQueryB);
             //-------------------------------------------------------------------
            String SqlQueryC = "";
            Statement stmtC = connt.connect().createStatement();

            SqlQueryC = "SELECT tt_cash_sym Simvol,SUM(tt_amount_dt_lcy) Mebleg"
                    + " FROM si_teller_operation where tt_cash_sym is not null and substr(tt_cash_sym,1,1) =('C') and"
                    + " act_date between TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') and TO_DATE ('" + strDateE + "', 'yyyy-mm-dd')"
            + "   AND TELLER_GL_AC_2= 10010 "
                    + FilialSql
                    + " group by tt_cash_sym"
                    + " ORDER BY tt_cash_sym";
                    //  System.out.println("SqlQueryC   " + SqlQueryC);     
            ResultSet sqlSelC = stmtC.executeQuery(SqlQueryC);
        //-------------------------------------------------------------------            
           Statement stmt2 = connt.connect().createStatement();
          String  SqlQuery2 = "SELECT   substr(tt_cash_sym,1,1) simvol, "
            + " (SUM (tt_amount_dt_lcy)+(select abs(sum(balance_lcy_amount)) from si_account_balance"
            + " where (is_opdate_next(TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))-1 between date_from and date_until)"
            + " AND gl_acct_no = '10010' and substr(alt_acct_id,23,3) like ('%"+DFil+"%'))) mebleg,"
            + " (select abs( sum(balance_lcy_amount)) aaa from si_account_balance"
            + " where (is_opdate_next(TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))-1 between date_from and date_until)"
            + " and gl_acct_no='10010' and substr(alt_acct_id,23,3)like ('%"+DFil+"%')) A10 FROM si_teller_operation"
            +" WHERE tt_cash_sym IS NOT NULL"
            +" AND act_date BETWEEN is_opdate_next(TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))"
            +" AND  is_opdate(TO_DATE ('" + strDateE + "', 'yyyy-mm-dd')) and substr(tt_cash_sym,1,1) =('B') "
               + "  AND TELLER_GL_AC_1= 10010  "
            + FilialSql
            +" GROUP BY   substr(tt_cash_sym,1,1)";
          //     System.out.println("SqlQuery2   " + SqlQuery2);     
         
            ResultSet sqlSel2 = stmt2.executeQuery(SqlQuery2);
            String A10_Amount="";
            String B_SUMM="";
             while (sqlSel2.next()) {
                                  B_SUMM=sqlSel2.getString(2);
                                  A10_Amount=sqlSel2.getString(3);
                                    }
        //-------------------------------------------------------------------            
             Statement stmt3 = connt.connect().createStatement();
           String SqlQuery3 = "SELECT substr(tt_cash_sym,1,1) simvol, "
              + " (SUM (tt_amount_dt_lcy)+(select abs(sum(balance_lcy_amount)) aaa from si_account_balance"
              +" where (TO_DATE ('"+strDateE+"', 'yyyy-mm-dd') between date_from and date_until)"
              +" and gl_acct_no='10010' and substr(alt_acct_id,23,3) like ('%"+DFil+"%'))) mebleg,"
              +" (select abs(sum(balance_lcy_amount)) aaa from si_account_balance"
              +" where (TO_DATE ('"+strDateE+"', 'yyyy-mm-dd') between date_from and date_until)"
              +" and gl_acct_no='10010' and substr(alt_acct_id,23,3) like ('%"+DFil+"%')) A20 FROM si_teller_operation"
              +" WHERE tt_cash_sym IS NOT NULL"
              +" AND act_date BETWEEN TO_DATE ('"+strDateB+"', 'yyyy-mm-dd')"
              +" AND  TO_DATE ('"+strDateE+"', 'yyyy-mm-dd') and substr(tt_cash_sym,1,1) =('C') "
                 + " AND TELLER_GL_AC_2= 10010 "
              + FilialSql
              +" GROUP BY substr(tt_cash_sym,1,1)";
   //System.out.println("SqlQuery3   " + SqlQuery3);    
   ResultSet sqlSel3 = stmt3.executeQuery(SqlQuery3);
              
            String A20_Amount="";
            String C_SUMM="";
             while (sqlSel3.next()) {
                                  C_SUMM=sqlSel3.getString(2);
                                  A20_Amount=sqlSel3.getString(3);
                                    }
         //-------------------------------------------------------------------
                     
            DecimalFormat df = new DecimalFormat("0.00");
            PrDict footer = new PrDict();
        %>    
        <table  border="0" width="100%"> 
            <tr> 
                <td valign="top"></td>
                <td  valign="top"  > 

                    <!---- CEDVEL BASHLAYIR   --------------------------------------->              
            <CENTER>
                <table width="900" bgcolor='white' border="0">
                    <tr><td align="right"> AZƏRBAYCAN RESPUBLİKASI <br> MİLLİ BANKI STATİSTİKA DEPARTAMENTİNİN </td></tr>
                    <tr><td>  "Expressbank" ASC  <% out.println(footer.getFililal4Statm(Integer.parseInt(DFil)));%>  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1500031691</td></tr>
                    <tr><td>  ÜZRƏ XƏZİNƏ ƏMƏLİYYATLARI NƏZƏRİNİZƏ ÇATDIRIR</td></tr>
                    <tr><td> 
                            <% out.println(new SimpleDateFormat("dd-mm-yyyy").format(dateB));%> - <% out.println(new SimpleDateFormat("dd-mm-yyyy").format(dateE));%>
                        </td></tr>
                    <tr><td> 
                            <table width="300"  border="1">
                                <tr>
                                    <td align="left">A10</td>
                                    <td align="right"><%=A10_Amount%></td>
                                </tr>
                                <%                                            
             while (sqlSelB.next()) {
                                        out.println("<tr>");
                                        out.println("<td align='left'>" + sqlSelB.getString(1) + "</td>");
                                        out.println("<td align='right'>" + df.format(sqlSelB.getDouble(2)) + "</td>");
                                        out.println("</tr>");
                                    }
                                %>
                                <tr>
                                    <td align="left">Cəm mədaxil:</td>
                                    <td align="right"><%=B_SUMM%></td>
                                </tr>
                                <tr>
                                    <td align="left">A20</td>
                                    <td align="right"><%=A20_Amount%></td>
                                </tr>
                                <%                                            
                    while (sqlSelC.next()) {
                                               out.println("<tr>");
                                               out.println("<td align='left'>" + sqlSelC.getString(1) + "</td>");
                                               out.println("<td align='right'>" + df.format(sqlSelC.getDouble(2)) + "</td>");
                                               out.println("</tr>");
                                           }
                                %>
                                <tr>
                                    <td align="left">Cəm məxaric:</td>
                                    <td align="right"><%=C_SUMM%></td>
                                </tr>
                            </table>
                        </td></tr>
                    <tr><td><P> S Ə D R </p></td></tr> 
                    <tr><td><P> BAŞ MÜHASİB </P></td></tr>
                </table>
            </CENTER>
            <!---- CEDVEL SONU   --------------------------------------->
        </td>
        <td valign="top"  align="left"> 
            <FORM  method="post" action="CashSymbolsEx" name="post">
                <input type="hidden" name="excelSqlB" value="<%out.println(SqlQueryB);%>" >
                <input type="hidden" name="excelSqlC" value="<%out.println(SqlQueryC);%>" >
                <input type="hidden" name="excelSql2" value="<%out.println(SqlQuery2);%>" >
                <input type="hidden" name="excelSql3" value="<%out.println(SqlQuery3);%>" >
                <input type="submit" name="excel" value="Excel-ə at" class="NonPrintable">
            </FORM>
            <FORM> 
                <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable">
            </FORM>
        </td>
    </tr>
    <%
        sqlSelB.close();
        stmtB.close();
         sqlSelC.close();
        stmtC.close();
        connt.connect().close();
    %>

</table>
</body>
</html>

