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

            Statement stmt_1 = conn.createStatement();
            Statement stmt = conn.createStatement();
            Statement stmt2 = conn.createStatement();
            Statement stmt3 = conn.createStatement();

            String strDateB = request.getParameter("DateB");
            String strDateE = request.getParameter("DateE");
            String filial = request.getParameter("RepFil");
            String fil = "";

            if (!filial.equals("0")) {
                String sql = " select GB_DESCRIPTION   from di_branch where date_until = '01-jan-3000' "
                        + "  and branch_id ='" + filial + "'   ";
                ResultSet sqlSel_1 = stmt_1.executeQuery(sql);
                sqlSel_1.next();
                fil = sqlSel_1.getString(1);
            } else {
                fil = "AllFilials";
            }

            DecimalFormat twoDForm = new DecimalFormat("0.00");

            SimpleDateFormat dtForm = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat dtSQL = new SimpleDateFormat("yyyy-mm-dd");

            DateFormat formatter;
            Date dateB;
            Date dateE;

            dateB = dtForm.parse(strDateB);
            strDateB = dtSQL.format(dateB);

            dateE = dtForm.parse(strDateE);
            strDateE = dtSQL.format(dateE);

            String user_name = request.getParameter("uname");
            String br = request.getParameter("br");

            String info = fil + "/" + strDateB.toString() + "&&" + strDateE.toString();
            String SqlQuery = "select x.aa,x.cem,z.balname  from ("
                    + " select COALESCE (bal1,bal2) aa, cem from ("
                    + " select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1,"
                    + " s2.cem cem2, (nvl(s2.cem,0)-nvl(s1.cem,0)) cem  from"
                    + " (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE (gl_acct_no_cr LIKE ('6%') or gl_acct_no_cr LIKE ('7%'))"
                    + " AND gl_acct_no_dt in ('50130','5501')"
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + "  AND (entry_date between  "
                    + " ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)  "
                    + "  and "
                    + "  (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ) "
                    + "     )"
                    + " group by gl_acct_no_cr) s1,"
                    + " (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE       (gl_acct_no_dt LIKE ('6%') or gl_acct_no_dt LIKE ('7%'))"
                    + " AND gl_acct_no_cr in ('50130','5501') "
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + " AND (entry_date between ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') "
                    + " and is_operdate=1) "
                    + " and (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ) )"
                    + " group by gl_acct_no_dt) s2 "
                    + " where s1.gl_acct_no_cr =  s2.gl_acct_no_dt(+)"
                    + " union  "
                    + " select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1, s2.cem cem2, (nvl(s2.cem,0)-nvl(s1.cem,0)) cem  from"
                    + " (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE       (gl_acct_no_cr LIKE ('6%') or gl_acct_no_cr LIKE ('7%'))"
                    + " AND gl_acct_no_dt in ('50130','5501')"
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + "  AND (entry_date between "
                    + " ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)  "
                    + "and (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ) )"
                    + " group by gl_acct_no_cr) s1,"
                    + " (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE       (gl_acct_no_dt LIKE ('6%') or gl_acct_no_dt LIKE ('7%'))"
                    + " AND gl_acct_no_cr in ('50130','5501')"
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + " AND (entry_date between "
                    + " ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)   "
                    + "  and (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ) )"
                    + " group by gl_acct_no_dt) s2"
                    + " where s1.gl_acct_no_cr(+) =  s2.gl_acct_no_dt)"
                    + "  ) x, bal_spr1 z  where x.aa=z.bal_cn(+)";
            System.out.println("SqlQuery  MENFEET  " + SqlQuery);
            ResultSet sqlSel = stmt.executeQuery(SqlQuery);

            String SqlQuery2 = "select x.aa,x.cem,z.balname  from ("
                    + " select COALESCE (bal1,bal2) aa, cem from ("
                    + " select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1,"
                    + " s2.cem cem2, (nvl(s1.cem,0)-nvl(s2.cem,0)) cem  from"
                    + " (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE (gl_acct_no_cr LIKE ('8%') or gl_acct_no_cr LIKE ('9%'))"
                    + " AND gl_acct_no_dt in ('50130','5501')"
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + "  AND (entry_date between "
                    + " ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)  "
                    + " and(select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ) )"
                    + " group by gl_acct_no_cr) s1,"
                    + " (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE       (gl_acct_no_dt LIKE ('8%') or gl_acct_no_dt LIKE ('9%'))"
                    + " AND gl_acct_no_cr in ('50130','5501') "
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + " AND (entry_date between "
                    + "  ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)  "
                    + " and (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ))"
                    + " group by gl_acct_no_dt) s2 "
                    + " where s1.gl_acct_no_cr =  s2.gl_acct_no_dt(+)"
                    + " union "
                    + " select s1.gl_acct_no_cr bal1, s2.gl_acct_no_dt bal2, s1.cem cem1, s2.cem cem2, (nvl(s1.cem,0)-nvl(s2.cem,0)) cem  from"
                    + " (SELECT   gl_acct_no_cr, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE       (gl_acct_no_cr LIKE ('8%') or gl_acct_no_cr LIKE ('9%'))"
                    + " AND gl_acct_no_dt in ('50130','5501')"
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + "  AND (entry_date between "
                    + " ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)  "
                    + " and(select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ))"
                    + " group by gl_acct_no_cr) s1,"
                    + " (SELECT   gl_acct_no_dt, sum(tr_amount_lcy_dt) cem"
                    + " FROM   si_transaction_account_un"
                    + " WHERE       (gl_acct_no_dt LIKE ('8%') or gl_acct_no_dt LIKE ('9%'))"
                    + " AND gl_acct_no_cr in ('50130','5501')"
                    + " AND COD_PLAT like ('%" + filial + "%') "
                    + " AND (entry_date between "
                    + " ( select  min(curr_date)  from ST_XF_DWH.di_oper_date where curr_date>=  to_date('" + strDateB + "','yyyy-mm-dd') and is_operdate=1)   "
                    + "and (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd') and is_operdate=1  ) )"
                    + " group by gl_acct_no_dt) s2"
                    + " where s1.gl_acct_no_cr(+) =  s2.gl_acct_no_dt)"
                    + "  ) x, bal_spr1 z  where x.aa=z.bal_cn(+)";
            System.out.println(" SqlQuery2   xerc  " + SqlQuery2);
            ResultSet sqlSel2 = stmt2.executeQuery(SqlQuery2);
            //--------------------------------------------------------------  
            String SqlQuery3 = "SELECT nvl(sum(a.balance_lcy_amount),0) cem"
                    + " FROM si_account_balance a,si_account_inf_bal b "
                    + " where a.gl_acct_no = '50130' "
                    + " AND b.date_until='01-JAN-3000' and b.alt_acct_id=a.alt_acct_id"
                    + "  AND a.date_from <=  "
                    + "(select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateB + "','yyyy-mm-dd')-1 and is_operdate=1  ) "
                    + " and a.date_until >="
                    + " (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateB + "','yyyy-mm-dd')-1 and is_operdate=1  ) "
                    + " AND b.filial_code like ('%" + filial + "%')";
            System.out.println("SqlQuery3  " + SqlQuery3);
            ResultSet sqlSel3 = stmt3.executeQuery(SqlQuery3);
            double GunEvvelQaliq = 0;
            String gunEvvelQaliq = "";
            while (sqlSel3.next()) {
                gunEvvelQaliq = sqlSel3.getString(1);
                GunEvvelQaliq = Double.parseDouble(gunEvvelQaliq);
            }
            sqlSel3.close();
            //--------------------------------------------------------------       
            SqlQuery3 = "SELECT nvl(sum(a.balance_lcy_amount),0) cem"
                    + " FROM si_account_balance a,si_account_inf_bal b "
                    + " where a.gl_acct_no = '50130' "
                    + " AND b.date_until='01-JAN-3000' and b.alt_acct_id=a.alt_acct_id"
                    + "  AND a.date_from <="
                    + " (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd')-1 and is_operdate=1  )   "
                    + " and a.date_until >= "
                    + "  (select max(curr_date)  from ST_XF_DWH.di_oper_date where curr_date<=to_date('" + strDateE + "','yyyy-mm-dd')-1 and is_operdate=1  ) "
                    + " AND b.filial_code like ('%" + filial + "%')";
            System.out.println("SqlQuery3  1 " + SqlQuery3);
            sqlSel3 = stmt3.executeQuery(SqlQuery3);
            double GunSonQaliq = 0;
            String gunSonQaliq = "";
            while (sqlSel3.next()) {
                gunSonQaliq = sqlSel3.getString(1);
                GunSonQaliq = Double.parseDouble(gunEvvelQaliq);
            }
            sqlSel3.close();
            stmt3.close();
            //--------------------------------------------------------------     
            double menfeet = 0;
            double xerc = 0;
        %>   
        <table  border="0" width="100%"> 

            <col width="160">
            <tr>
                <td> <font face="Times new roman" size="5"> Gəlir-Xərc hesabatı </font> </td>
                <td align="left">
                    <font face="Times new roman" size="4" color="Brown"> 
                    (
                    <%
                        out.println(dtForm.format(dateB));
                    %> 
                    ) - (
                    <%
                        out.println(dtForm.format(dateE));
                    %>  )   &nbsp;&nbsp;&nbsp;&emsp;&emsp;&emsp;&emsp; 
                    &nbsp;&nbsp;&nbsp;&emsp;&emsp;&emsp;&emsp; 



                    <%
                        if (filial.equals("0")) {

                            out.println("Ümumi bank üzrə");
                        } else {

                            String branch = "  select  GB_DESCRIPTION  from di_branch where date_until = '01-jan-3000' and BRANCH_ID = " + filial + "    ";
                            Statement stbr = conn.createStatement();
                            ResultSet sqlbr = stbr.executeQuery(branch);
                            sqlbr.next();
                            out.println(sqlbr.getString(1));
                            stbr.close();
                            stbr.close();
                        }
                    %>
                    </font>
                </td>

            </tr>

            <tr>
                <td valign="top">
                    <% out.println(footer.lMenu(user_name, br)); %>            
                </td>
                <td width="900" valign="top" > 
                    <!---- CEDVEL BASHLAYIR   --------------------------------------->              
                    <table width="100%" border="0" style="height: 100%;">
                        <tr>
                            <td width="400" valign="top">
                                <font face="Times new roman" size="4" color="blue"> Gəlir </font>
                                <table cellpadding="0" cellspacing="0" border="0" class="display" id="example" width="100%">
                                    <thead>
                                        <tr>
                                            <th>Balans hesabı</th>     
                                            <th>Məbləğ</th>
                                            <th>Balans hesabın adı</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            while (sqlSel.next()) {
                                                out.println("<tr class='odd gradeA'>");
                                                menfeet = menfeet + sqlSel.getDouble(2);
                                                out.println("<td>" + sqlSel.getString(1) + "</td>");
                                                out.println("<td>" + twoDForm.format(sqlSel.getDouble(2)) + "</td>");
                                                out.println("<td>" + sqlSel.getString(3) + "</td>");
                                                out.println("</tr>");
                                            }
                                        %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th>Balans hesabı</th>     
                                            <th>Məbləğ</th>
                                            <th>Balans hesabın adı</th>
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
                                            <th>Balans hesabın adı</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            while (sqlSel2.next()) {
                                                out.println("<tr class='odd gradeA'>");
                                                xerc = xerc + sqlSel2.getDouble(2);
                                                out.println("<td>" + sqlSel2.getString(1) + "</td>");
                                                out.println("<td>" + twoDForm.format(sqlSel2.getDouble(2)) + "</td>");
                                                out.println("<td>" + sqlSel2.getString(3) + "</td>");

                                                out.println("</tr>");
                                            }
                                        %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th>Balans hesabı</th>     
                                            <th>Məbləğ</th>
                                            <th>Balans hesabın adı</th>
                                        </tr>

                                    </tfoot>
                                </table>              
                            </td> 
                            <td width="100" valign="top">

                                <p>
                                    Gəlir: <br> <% out.println(twoDForm.format(menfeet)); %>
                                </p>
                                <p>
                                    Xərc: <br> <% out.println(twoDForm.format(xerc)); %>
                                </p>
                                <p>
                                    Başlanğıc qalıq <br> <%   out.println(gunEvvelQaliq); %>
                                </p>
                                <p>
                                    Mənfəət-xərc fərqi <br> <% out.println(twoDForm.format(menfeet - xerc)); %>
                                </p>
                                <p>
                                    Hesablanmış son qalıq <br>  <% out.println(twoDForm.format(GunEvvelQaliq + menfeet - xerc));%>
                                </p>
                                <p>
                                    50130-un son qalığı <br>  <% out.println(gunSonQaliq);%>
                                </p>
                                <p>
                                <FORM  method="post" action="IncExpExcel" name="post">
                                    <input type="hidden" name="excelSql1" value="<%out.println(SqlQuery);%>">
                                    <input type="hidden" name="excelSql2" value="<%out.println(SqlQuery2);%>">
                                    <input type="hidden" name="info" value="<%out.println(info);%>">
                                    <input type="submit" name="excel" value="Excel-ə at">
                                </FORM>

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

