<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="main.DB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
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
                    "bScrollCollapse": true
                });
            });
        </script>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
  Date d = new Date(); 
  DB c = new DB();
  PrDict dict = new PrDict();
               
  SimpleDateFormat dtformat = new SimpleDateFormat("dd-MM-yyyy");
  SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-MM-dd");     
                     
  String strDateB = request.getParameter("DateB");      
  String strDateE = request.getParameter("DateE"); 
               
   Date dateB ;
   Date dateE ;
               
   dateB = dtformat.parse(strDateB);
   strDateB = dtformat2.format(dateB);
                                         
   dateE = dtformat.parse(strDateE); 
   strDateE = dtformat2.format(dateE);
                                     
   Statement stmt = c.connect().createStatement();
   String SqlQuery="select * from (select gl_acct_no, (sum(ilkin_qaliq) +sum(dt_dovriye) + sum(cr_dovriye)- sum(son_qaliq)) ferq from"
+" (select * from  (select alt_acct_id, balance_lcy_amount son_qaliq"
+" from ST_XF_DWH.SI_ACCOUNT_BALANCE "
+" where date_until>=TO_DATE ('"+strDateE+"', 'yyyy-mm-dd') and date_from<=TO_DATE ('"+strDateE+"', 'yyyy-mm-dd')) sq, "
+" (select alt_acct_id, balance_lcy_amount ilkin_qaliq  "
+" from ST_XF_DWH.SI_ACCOUNT_BALANCE "
+" where date_until>=TO_DATE ('"+strDateB+"', 'yyyy-mm-dd')-1 and date_from<=TO_DATE ('"+strDateB+"', 'yyyy-mm-dd')-1) iq, "
+" (select * from ST_XF_DWH.SI_ACCOUNT_INF_BAL "
+" where date_until>=TO_DATE ('"+strDateE+"', 'yyyy-mm-dd') and date_from<=TO_DATE ('"+strDateE+"', 'yyyy-mm-dd')) ml,"
+" (select k.alt_acct_id, nvl(m.DT_dovriye, 0) DT_dovriye , nvl(m.CR_dovriye, 0) CR_dovriye from"
+" (select alt_acct_id, sum(OPERATION_ACCT_AMOUNT_LCY_DT) DT_dovriye, sum(OPERATION_ACCT_AMOUNT_LCY_cr) CR_dovriye"
+" from ST_XF_DWH.SI_ACCOUNT_OPERATION_BAL "
+" where (act_date between TO_DATE ('"+strDateB+"', 'yyyy-mm-dd') and TO_DATE ('"+strDateE+"', 'yyyy-mm-dd') ) group by alt_acct_id) m,"
+" (select distinct alt_acct_id from ST_XF_DWH.SI_ACCOUNT_OPERATION_BAL ) k"
+" where m.alt_acct_id(+) = k.alt_acct_id) dv"
+" where ml.alt_acct_id = sq.alt_acct_id(+) and ml.alt_acct_id = iq.alt_acct_id(+) and ml.alt_acct_id = dv.alt_acct_id(+)) "
+" group by gl_acct_no order by gl_acct_no asc) where ferq<>0";
  
   ResultSet sqlSel = stmt.executeQuery(SqlQuery);
        %>   
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td width="246" height="60">  <font face="Times new roman" size="5">  Balans yoxla </font> </td>
                <td align="right">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <% out.println(dict.lAdminMenu()); %>
                </td>
                <td valign="top" align="left"> 
                    <!---- CEDVEL BASHLAYIR   ------------------------class="display"--------------->              
                    <table border="0" width="300">
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" border="0"  id="example" width="100%">
                                    <thead>
                                        <tr>                 
                                            <th>Balans Hesabı </th>    
                                            <th>Məbləğ</th>     
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        int j=0;
                                         while (sqlSel.next()) 
                                         {
                                        out.println("<tr >");        
                                                out.println("<td width='200' align='center'>"+sqlSel.getString(1)+"</td>");                                    
                                                out.println("<td align='right'>"+sqlSel.getDouble(2) +"</td>");    
                                     out.println("</tr>"); 
                                                j++;
                                                };

                                        %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <th>Balans Hesabı </th>    
                                            <th>Məbləğ</th>   

                                        </tr>

                                    </tfoot>
                                </table>   
                                <!---- CEDVEL SONU   --------------------------------------->
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <font size="5">
                                <%
                           if (j==0) out.println("Balans düzgündür!");
                                %>
                                </font>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>  
                </td>
                <td height="40">
                    <div align="right">
                        <% 
                        out.println(dict.ftSign());
                        %>
                    </div>
                </td>
            </tr>

        </table>
    </body>
</html>

