<%-- 
    Document   : TransRep
    Created on : Nov 8, 2012, 3:18:49 PM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
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
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" title="currentStyle">
            @import "media/css/demo_page.css";
            @import "media/css/demo_table.css";
            @import "media/css/demo_table_jui.css";
            @import "media/examples_support/themes/smoothness/jquery-ui-1.8.4.custom.css";
        </style>
        <script type="text/javascript" language="javascript" src="media/js/jquery.js"></script>
        <script type="text/javascript" language="javascript" src="media/js/jquery.dataTables.js"></script>
        <script type="text/javascript" charset="utf-8">
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true});
                oTable = $('#example2').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true});
            });
        </script>
    </head>
    <body bgcolor=#E0EBEA>
        <%
                
                 DB db = new DB();
                 Connection conn = db.connect();
                 PrDict footer = new PrDict();
                     
                 Statement stmt = conn.createStatement();
                 Statement stmt2 = conn.createStatement();
                 Statement stmt3 = conn.createStatement(); 
                 String strDateB =  request.getParameter("DateB");
                 String strDateE =  request.getParameter("DateE");
               
                 DecimalFormat twoDForm = new DecimalFormat("#.##");
                 DateFormat formatter ; 
                 Date dateB ;
                 Date dateE ;
               
                 dateB = new SimpleDateFormat("dd-mm-yyyy").parse(strDateB);
                 strDateB = new SimpleDateFormat("yyyy-mm-dd").format(dateB);
                                         
                 dateE = new SimpleDateFormat("dd-mm-yyyy").parse(strDateE); 
                 strDateE = new SimpleDateFormat("yyyy-mm-dd").format(dateE);
                
               //  java.sql.Date TrDateB = java.sql.Date.valueOf( strDateB );
              //  java.sql.Date TrDateE = java.sql.Date.valueOf( strDateE ); 
                 String user_name = request.getParameter("uname");
                 String br = request.getParameter("br");
                
         String SqlQuery = "select COALESCE (bal1,bal2) aa, abs(cem) cem from ("
         +" select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1,"
         + " s2.cem cem2, (nvl(s1.cem,0)-nvl(s2.cem,0)) cem  from"
         +" (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE (gl_acct_no_cr LIKE ('6%') or gl_acct_no_cr LIKE ('7%'))"
         +" AND gl_acct_no_dt = '5501'"
         +"  AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         +" group by gl_acct_no_cr) s1,"
         
         +" (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE       (gl_acct_no_dt LIKE ('6%') or gl_acct_no_dt LIKE ('7%'))"
         +" AND gl_acct_no_cr = '5501' "
         +" AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         +" group by gl_acct_no_dt) s2 "
         
         +" where s1.gl_acct_no_cr =  s2.gl_acct_no_dt(+)"
         +" union "
         +" select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1, s2.cem cem2, (nvl(s1.cem,0)-nvl(s2.cem,0)) cem  from"
         +" (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE       (gl_acct_no_cr LIKE ('6%') or gl_acct_no_cr LIKE ('7%'))"
         +" AND gl_acct_no_dt = '5501'"
         +"  AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         +" group by gl_acct_no_cr) s1,"
         
         +" (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE       (gl_acct_no_dt LIKE ('6%') or gl_acct_no_dt LIKE ('7%'))"
         + " AND gl_acct_no_cr = '5501'"
         + " AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         + " group by gl_acct_no_dt) s2"
         + " where s1.gl_acct_no_cr(+) =  s2.gl_acct_no_dt)";
       
                 ResultSet sqlSel = stmt.executeQuery(SqlQuery);
                     
                String SqlQuery2 = "select COALESCE (bal1,bal2) aa, cem from ("
         +" select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1,"
         + " s2.cem cem2, (nvl(s1.cem,0)-nvl(s2.cem,0)) cem  from"
         +" (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE (gl_acct_no_cr LIKE ('8%') or gl_acct_no_cr LIKE ('9%'))"
         +" AND gl_acct_no_dt = '5501'"
         +"  AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         +" group by gl_acct_no_cr) s1,"
         
         +" (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE       (gl_acct_no_dt LIKE ('8%') or gl_acct_no_dt LIKE ('9%'))"
         +" AND gl_acct_no_cr = '5501' "
         +" AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         +" group by gl_acct_no_dt) s2 "
         
         +" where s1.gl_acct_no_cr =  s2.gl_acct_no_dt(+)"
         +" union "
         +" select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1, s2.cem cem2, (nvl(s1.cem,0)-nvl(s2.cem,0)) cem  from"
         +" (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE       (gl_acct_no_cr LIKE ('8%') or gl_acct_no_cr LIKE ('9%'))"
         +" AND gl_acct_no_dt = '5501'"
         +"  AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         +" group by gl_acct_no_cr) s1,"
         
         +" (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
         +" FROM   si_transaction_account_un"
         +" WHERE       (gl_acct_no_dt LIKE ('8%') or gl_acct_no_dt LIKE ('9%'))"
         + " AND gl_acct_no_cr = '5501'"
         + " AND (act_date between is_opdate(to_date('"+strDateB+"','yyyy-mm-dd')) and is_opdate(to_date('"+strDateE+"','yyyy-mm-dd')))"
         + " group by gl_acct_no_dt) s2"
         + " where s1.gl_acct_no_cr(+) =  s2.gl_acct_no_dt)";
               
                 ResultSet sqlSel2 = stmt2.executeQuery(SqlQuery2);

         String SqlQuery3 = "SELECT sum(a.balance_lcy_amount) cem"
         +" FROM si_account_balance a where a.gl_acct_no='5501' and a.date_until=is_opdate(to_date('"+strDateE+"','yyyy-mm-dd'))-1";
                 ResultSet sqlSel3 = stmt3.executeQuery(SqlQuery3);

                 float GunEvvelQaliq = 0;
                 String gunEvvelQaliq = "";
             while (sqlSel3.next())
              {
               gunEvvelQaliq = sqlSel3.getString(1);  
               GunEvvelQaliq = Float.parseFloat(gunEvvelQaliq);
              }                    
                 float menfeet = 0;
                 float xerc = 0;
        %>   
        <table  border="0"> 
            <col width="200">
            <td> <font face="Times new roman" size="5"> Gəlir-Xərc hesabatı </font> </td>
            <td align="left">
                <font face="Times new roman" size="4" color="Brown"> 
                (
                <% 
                out.println(new SimpleDateFormat("dd-mm-yyyy").format(dateB));
                %> 
                ) - (
                <% 
                out.println(new SimpleDateFormat("dd-mm-yyyy").format(dateE));
                %> )
                </font>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <% out.println(footer.lMenu(user_name,br)); %>            
            </td>
            <td width="900" valign="top" > 
                <!---- CEDVEL BASHLAYIR   --------------------------------------->              
                <table width="900" border="0">
                    <tr>
                        <td width="400" valign="top">
                            <font face="Times new roman" size="4" color="blue"> Gəlir </font>
                            <table cellpadding="0" cellspacing="0" border="0" class="display" id="example" width="100%">
                                <thead>
                                    <tr>
                                        <th>Balans hesabı</th>     
                                        <th>Məbləğ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
            
                                     while (sqlSel.next())
                                     {
                                    out.println("<tr class='odd gradeA'>");
                                            menfeet = menfeet + sqlSel.getFloat(2);
                                            out.println("<td>"+sqlSel.getString(1) +"</td>");  
                                            out.println("<td>"+sqlSel.getString(2) +"</td>");                     

                                    out.println("</tr>");
                                     }
                                    %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>Balans hesabı</th>     
                                        <th>Məbləğ</th>
                                    </tr>

                                </tfoot>
                            </table>            
                        </td >
                        <td width="400" valign="top">
                            <font face="Times new roman" size="4" color="blue"> Xərc </font>
                            <table cellpadding="0" cellspacing="0" border="0" class="display" id="example2" width="100%">
                                <thead>
                                    <tr>
                                        <th>Balans hesabı</th>     
                                        <th>Məbləğ</th>         
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                     while (sqlSel2.next())
                                     {
                                    out.println("<tr class='odd gradeA'>");
                                            xerc = xerc + sqlSel2.getFloat(2);
                                            out.println("<td>"+sqlSel2.getString(1) +"</td>");   
                                            out.println("<td>"+sqlSel2.getString(2) +"</td>"); 

                                    out.println("</tr>");
                                     }
                                    %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th>Balans hesabı</th>     
                                        <th>Məbləğ</th> 
                                    </tr>

                                </tfoot>
                            </table>              
                        </td> 
                        <td width="400" valign="top">

                            <p>
                                Gəlir <br> <% out.println(menfeet); %>
                            </p>
                            <p>
                                Xərc <br> <% out.println(xerc); %>
                            </p>
                            <p>
                                Başlanğıc qalıq <br> <% out.println(gunEvvelQaliq); %>
                            </p>
                            <p>
                                Mənfəət-xərc fərqi <br> <% out.println(menfeet-xerc); %>
                            </p>
                            <p>
                                Son qalıq <br>  <% out.println(GunEvvelQaliq+menfeet-xerc); %>
                            </p>

                        </td>
                    </tr>
                </table>

                <!---- CEDVEL SONU   --------------------------------------->
            </td>
        </tr>
        <tr>
            <td>  
            </td>
            <td width="500">
                <div align="left">
                    <% 
                    out.println(footer.ftSign());
                     
                    sqlSel2.close();
                    stmt2.close();
                     
                    sqlSel.close();
                    stmt.close();
                    conn.close();
                    %>
                </div>
            </td>
        </tr>

    </table>
</body>
</html>

