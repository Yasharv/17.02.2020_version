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
<%@page import="main.MemorialRep"%>

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
        <script type="text/javascript"  language="javascript" charset="utf-8">
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
                });
            });
            function validateForm()
            {
                var e = document.post.elements.length;
                var i = 0;
                var cnt = 0;
                for (i = 0; i < e; i++)
                {
                    if (document.post.elements[i].name == "ids") {
                        if (document.post.elements[i].checked)
                        {
                            cnt++;
                        }
                    }
                }
                if (cnt == 0) {
                    alert("Heç bir əməliyyat seçilməyib!");
                    return false;
                }

            }
            ;
            function checkAll(field)
            {
                var z = document.forms["post"]["chkall"].checked;

                if (z == true)
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = true;
                }
                else
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = false;
                }

            }

        </script>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
    <center>
        <form method="post" action="MemRepPrint.jsp" name="post" target="_blank" onsubmit="return validateForm()">    
            <%
                Date d = new Date();
                DB db = new DB();
                Connection conn = db.connect();
                PrDict dict = new PrDict();

                SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
                SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
                DecimalFormat twoDForm = new DecimalFormat("0.00");
                String s = format.format(d);
                MemorialRep RepTrans = new MemorialRep();
                
                String strDateB = request.getParameter("TrDateB");
                String strDateE = request.getParameter("TrDateE");
               
                String RepValDeb = request.getParameter("RepValDeb");
                String RepValKred = request.getParameter("RepValKred");
                String DebFil = request.getParameter("DebFil");

                int CredForm = Integer.parseInt(request.getParameter("CredForm"));

                String CredValue = request.getParameter("CredValue");
                CredValue = CredValue.replace(",", "','");

                String RepUser = request.getParameter("RepUser");
                String user_name = request.getParameter("uname");
                String user_branch = request.getParameter("br");
                String brForRep = "";

                String TrSqlVal="";
                String TrSqlAccCred = "";
                String CategForSalary = "";
                String SqlUserFilter = " and inputter=" + RepUser;
                if (RepUser.equals("0")) {
                    SqlUserFilter = "";
                }

                String TrType = "";

                Statement stmtUser = conn.createStatement();
                String SqlUserQuery = "select user_branch,all_filials,salary_acc from dwh_users where user_id='" + user_name + "'";
                ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
                int salary_acc = 0;

                while (sqlUserSel.next()) {
                    salary_acc = sqlUserSel.getInt(3);
                    brForRep = sqlUserSel.getString(1);

                };
                sqlUserSel.close();
                stmtUser.close();

                CategForSalary = " and cred_category<>1200 ";
                              //  +" AND debt_category<>1200 ";
                if (salary_acc == 1) {
                    CategForSalary = "";
                }

                        if (!(CredValue.equals(""))) {
                            if (CredForm == 1) {
                                TrSqlAccCred =  " acct_no_cr in ('" + CredValue + "')";
                            }
                            if (CredForm == 2) {
                                TrSqlAccCred = "  kred_balans in ('" + CredValue + "')";
                            }
                        } else {
                            TrSqlAccCred = ")";
                        }
                        
                        if (CredValue.equals("")) {
                        TrSqlVal = "	AND (currency_dt_id LIKE ('%" + RepValDeb + "%') AND currency_cr_id LIKE ('%" + RepValKred + "%'))";
                                               }
                        else
                        TrSqlVal = "	AND (currency_dt_id LIKE ('%" + RepValDeb + "%') AND currency_cr_id LIKE ('%" + RepValKred + "%')) and "
                                 + TrSqlAccCred;
     

                Date dateB = format.parse(strDateB);
                String strDateB2 = strDateB;
                strDateB = format2.format(dateB);


                Date dateE = format.parse(strDateE);
                String strDateE2 = strDateE;
                strDateE = format2.format(dateE);

                String SqlPart1 = "SELECT a.*, (SELECT tax_pay_id FROM cust_hs_fs where customer_id=dcustid) DCustInn,"
                        + " (SELECT tax_pay_id FROM cust_hs_fs where customer_id=ccustid) CCustInn";

                String SqlSumPart = "Select sum(a.ammount) aaa,sum(a.lammount) bbb ";

                String SqlPart2 = " FROM vi_other_trans" 
                        + " a where a.tarix BETWEEN to_date('" + strDateB + "','yyyy-mm-dd') AND to_date('" + strDateE + "','yyyy-mm-dd')"
                        + TrSqlVal + SqlUserFilter+" and debt_filial_id LIKE ('%"+DebFil+"%')  and debt_balans in (41010,41020,41025)";

                String SQLText = SqlPart1 + SqlPart2 + CategForSalary;
                String SqlSumText = SqlSumPart + SqlPart2 + CategForSalary;
                
//System.out.print(SQLText);
                Statement stmt = conn.createStatement();
                ResultSet sqlres = stmt.executeQuery(SQLText);

                double Ammount = 0;
                double LAmmount = 0;
                String SumAmmount = "";
                String SumLAmmount = "";


            %>
            <input type="hidden" name="f" value="<%out.print(brForRep);%>">

            <table cellpadding="0" cellspacing="0" border="0"  id="example" width="1350">
                <thead>
                    <tr>
                        <%
                            int count = sqlres.getMetaData().getColumnCount();

                            //  for (int i = 1; i <= count; i++)
                            {
                                out.println("<th>" + " <input type='checkbox' name='chkall' onClick='checkAll(document.post.ids)'> " + "</th>");
                                out.println("<th>" + "TARIX" + "</th>");
                                out.println("<th>" + "DEBET" + "</th>");
                                out.println("<th>" + "DVAL" + "</th>");
                                out.println("<th>" + "DBAL" + "</th>");
                                out.println("<th>" + "KREDIT" + "</th>");
                                out.println("<th>" + "KVAL" + "</th>");
                                out.println("<th>" + "KBAL" + "</th>");
                                out.println("<th>" + "MEBLEG" + "</th>");
                                out.println("<th>" + "EKVIVALENT" + "</th>");
                                out.println("<th>" + "TEYINAT" + "</th>");
                                out.println("<th>" + "    " + "</th>");
                                //  out.println("<th>"+"DFILIAL"+"</th>");  
                                //   out.println("<th>"+"KFILIAL"+"</th>");  
                            };
                        %>

                    </tr>
                </thead>
                <tbody>

                    <%

                        while (sqlres.next()) {
                            out.println("<tr >");

                            out.println("<td width=25><input type='checkbox' name='ids' value='" + sqlres.getString(23) + "'> </td>");
                            out.println("<td width=80>" + sqlres.getString(1).substring(0, 10) + "</td>");  //tarix                                  
                            out.println("<td width=250>" + sqlres.getString(2) + "</td>");                 //dhesab
                            out.println("<td width=40>" + sqlres.getString(3) + "</td>");                  //dval
                            out.println("<td width=50>" + sqlres.getString(4) + "</td>");                //dbal
                            out.println("<td width=250>" + sqlres.getString(5) + "</td>");                 //kredit
                            out.println("<td width=40>" + sqlres.getString(6) + "</td>");                  //kval
                            out.println("<td width=60>" + sqlres.getString(7) + "</td>");                  //kbal
                            out.println("<td width=50>" + twoDForm.format(sqlres.getDouble(16)) + "</td>");  //mebleg
                            out.println("<td width=50>" + twoDForm.format(sqlres.getDouble(17)) + "</td>"); //ekvivalent
                            out.println("<td >" + sqlres.getString(8) + "</td>");                         //teyinat
                            out.println("<td >" + "<a href='MemRepPrint.jsp?id=" + sqlres.getString(23) + "&brNum=" + user_branch + "&dtb=" + strDateB2 + "&dte=" + strDateE2 + "' target='_blank'>Print</a></td>");
                            //  out.println("<td width=250>"+sqlres.getString(11) +"</td>");                //dfilial
                            //   out.println("<td width=250>"+sqlres.getString(12) +"</td>");                //kfilial
                            out.println("</tr>");
                        };
                    %>
                </tbody>
                <tfoot>
                    <tr>
                        <%

                            //  for (int i = 1; i <= count; i++)
                            {
                                out.println("<th>" + "  " + "</th>");
                                out.println("<th>" + "TARIX" + "</th>");
                                out.println("<th>" + "DEBET" + "</th>");
                                out.println("<th>" + "DVAL" + "</th>");
                                out.println("<th>" + "DBAL" + "</th>");
                                out.println("<th>" + "KREDIT" + "</th>");
                                out.println("<th>" + "KVAL" + "</th>");
                                out.println("<th>" + "KBAL" + "</th>");
                                out.println("<th>" + "MEBLEG" + "</th>");
                                out.println("<th>" + "EKVIVALENT" + "</th>");
                                out.println("<th>" + "TEYINAT" + "</th>");
                                out.println("<th>" + "    " + "</th>");
                                //   out.println("<th>"+"DFILIAL"+"</th>");  
                                //   out.println("<th>"+"KFILIAL"+"</th>");  
                            }

                        %>
                    </tr>

                </tfoot>
            </table> 
            <%
                sqlres.close();
                sqlres = stmt.executeQuery(SqlSumText);

                while (sqlres.next()) {
                    SumAmmount = sqlres.getString(1);
                    SumLAmmount = sqlres.getString(2);
                }
                stmt.close();
                conn.close();


            %>

            <table  border='1' width="100%" cellspacing="1">
                <tr>
                    <td>

                        <table  bgcolor='white' border='0' width='900'>
                            <tr>
                            <font size="4">
                            <td width="642"  align="left"> Cəmi: </td> 
                            <td width="118" align="right"> <% out.println(SumAmmount);%></td>  
                            <td width="118" align="right"> <% out.println(SumLAmmount);%></td>   
                            </font>
                </tr>
            </table>

            </td>
            <td>
                <input type="hidden" name="brNum" value='<%out.print(user_branch);%>'>
                <input type="hidden" name="dtb" value="<%out.print(strDateB2);%>">
                <input type="hidden" name="dte" value="<%out.print(strDateE2);%>">

                <input type="submit" name="print" value="Print selected">
            </td>    
            </table>
        </form>
    </center>     
    <div align="left">
        <p>
            <%
                out.println(dict.ftSign());
            %>
        </p>
    </div>    
</body>
</html>
