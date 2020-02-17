<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="javax.sound.midi.Soundbank"%>
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
        <style type="text/css">
            table.bottomBorder { border-collapse:collapse; page-break-inside:auto}
            table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; page-break-inside:avoid; page-break-after:auto}

        </style>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->


        <%
         Date d = new Date(); 
         DB db = new DB();  
     
         DecimalFormat df = new DecimalFormat("0.00");    
        PrDict dict = new PrDict();     
           
                   SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
                   SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
                   String s = format.format(d);
               
                   String strDateB = request.getParameter("TrDateB");
                   String RepValue = request.getParameter("RepVal");  
                    String Filial = request.getParameter("Filial"); 
                    String Valute  = request.getParameter("Valute");   
                   int RepType = Integer.parseInt(request.getParameter("RepType"));
               
                    String RepValueSql="";
                    if (!(RepValue.equals(""))) RepValueSql= " and bal_cn in ("+RepValue+") ";
                            else RepValueSql="";               
                
                   String user_name = request.getParameter("uname");
                   String user_branch = request.getParameter("br");
               
                   Connection conn=db.connect();
             int all_filials = 0;
             int salary_acc = 0;     
                             
           Statement stmtUser = conn.createStatement();
           String SqlUserQuery= "select user_branch,all_filials,salary_acc from dwh_users where user_id='"+user_name+"'";
           ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
           while (sqlUserSel.next())
                {
               user_branch = sqlUserSel.getString(1);
               all_filials = sqlUserSel.getInt(2);
               salary_acc = sqlUserSel.getInt(3);
                };
            sqlUserSel.close();
            stmtUser.close();
          
          if (user_branch.equals("")||user_branch.isEmpty()||user_branch==null||all_filials==1) user_branch="0";
          String CategForSalary = " AND nvl(debt_category,0)<>1200 and nvl(cred_category,0)<>1200";
          if (salary_acc==1) CategForSalary = "";
               
                   Date dateB = format.parse(strDateB);
                   strDateB = format2.format(dateB);
                   int RepForm=0;
                  String ValuteSql="";
                      if (!(Valute.equals("0")))  ValuteSql=" and a.currency_dt_id="+Valute;
               
        String SQLTextBalCN="";
                    if (RepType==1) {                
                      SQLTextBalCN="select distinct a.dbal from vi_tr_controltape_rep a"
                  + " where a.tarix=to_date('"+strDateB+"','yyyy-mm-dd') "
                  + " and a.debt_filial_id like('%"+Filial+"%') "+ValuteSql
                  + CategForSalary+" order by a.dbal";   
                
                    }
                   else
                    {
                      SQLTextBalCN="select distinct a.dbal from vi_tr_controltape_rep_ob a"
                  + " where a.tarix=to_date('"+strDateB+"','yyyy-mm-dd') "
                  + " and a.debt_filial_id like('%"+Filial+"%') "+ValuteSql
                  + CategForSalary+" order by a.dbal";   
                    }
             
                    Statement stmt_balcn = conn.createStatement();
                    Statement stmt = conn.createStatement();
                    ResultSet sqlresBalCn = stmt_balcn.executeQuery(SQLTextBalCN);
                    ResultSet sqlres ;  
                
        %>
        <table width="100%" border="0">
            <tr>
                <td valign="top" align="left">
                </td>
                <td>
                </td>
                <td valign="top" align="right">

                </td>
            </tr> 
            <tr>
                <td valign="top" align="left">  
                </td>
                <td valign="top" align="center">

                    <table bgcolor='white' border='1' width="900" cellspacing="1">
                        <tr>
                            <td>
                                <font size="3">  
                                <table border="0" width="100%" >
                                    <tr>
                                        <td width="270"><font size="5"> <b>Nəzarət lenti</b></font> </td>
                                        <td>
                                            <%
                                         out.println(dict.getValute(Integer.parseInt(Valute))); 
                                            %> 
                                        </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                    </tr>   
                                    <tr>
                                        <td>"Expressbank" ASC <% out.println(dict.getFililal4Statm(Integer.parseInt(Filial)));%></td>
                                        <td> Tarix  
                                            <% 
                                         String strDateB2 = format.format(dateB);
                                        out.println(strDateB2);
                                            %>
                                        </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                    </tr> 
                                    <tr>
                                        <td> &nbsp; </td>
                                        <td> </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                    </tr> 
                                    <tr>
                                        <td>  &nbsp; </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>
                                        <td>  </td>

                                    </tr> 
                                    <tr>
                                        <td colspan="7" >
                                            <table width="100%" cellspacing="0" class="bottomBorder">

                                                <%  
                                                Double sum_ammount=0.0;
                                                Double sum_ammount_ekv=0.0;
                                                 String SQLText=""; 
                                                 String Bal_CN="";
                                                while (sqlresBalCn.next())
                                                {    Bal_CN=sqlresBalCn.getString(1);
                                                %>
                                                <tr>
                                                    <td> <b> <%=Bal_CN%> </b></td>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td>  </td>

                                                </tr> 
                                                <%
                                                if (RepType==1) {       
                             SQLText="select a.dval,a.debet,a.kval,a.kredit, a.mebleg, a.ekvivalent,a.payment_purpose,"
                                         + " a.tarix, a.currency_dt_id, a.currency_cr_id,"
                                         + " a.dbal, a.kbal, a.debt_filial_id, a.cred_filial_id "
                                         + " from vi_tr_controltape_rep a where a.tarix=to_date('"+strDateB+"','yyyy-mm-dd') "
                                     + " and a.dbal="+Bal_CN+" and a.debt_filial_id like('%"+Filial+"%') "+ValuteSql
                                     +CategForSalary+" order by a.mebleg";}
                                                else
                                                {
                             SQLText="select a.dval,a.debet,a.kval,a.kredit, a.mebleg, a.ekvivalent,a.payment_purpose,"
                                         + " a.tarix, a.currency_dt_id, a.currency_cr_id,"
                                         + " a.dbal, a.kbal, a.debt_filial_id, a.cred_filial_id "
                                         + " from vi_tr_controltape_rep_ob a where a.tarix=to_date('"+strDateB+"','yyyy-mm-dd') "
                                     + " and a.dbal="+Bal_CN+" and a.debt_filial_id like('%"+Filial+"%') "+ValuteSql
                                     +CategForSalary+" order by a.mebleg";
                                                }
                            sqlres = stmt.executeQuery(SQLText);          
                            while (sqlres.next())
                                 {
                                    sum_ammount =sum_ammount+sqlres.getDouble(5);
                                    sum_ammount_ekv=sum_ammount_ekv+sqlres.getDouble(6);
                                   out.print("<tr>");
                                   out.print("<td align='center' >"+sqlres.getString(1)+"</td>");
                                   out.print("<td align='center' >"+sqlres.getString(2)+"</td>");
                                   out.print("<td align='center' >"+sqlres.getString(3)+"</td>");
                                   out.print("<td align='center' >"+sqlres.getString(4)+"</td>");
                                   out.print("<td align='right' >"+df.format(sqlres.getDouble(5))+"&nbsp; </td>");
                                   out.print("<td align='right' >"+df.format(sqlres.getDouble(6))+"&nbsp; </td>");
                                   out.print("<td align='left' width='250'>"+sqlres.getString(7)+"</td>");
                                   out.println("</tr>"); 
                                 }
                            sqlres.close();
                                                %>

                                                <tr>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td>  </td>
                                                    <td> <b><%=df.format(sum_ammount)%> </b></td>
                                                    <td> <b><%=df.format(sum_ammount_ekv)%> </b></td>
                                                    <td>  </td>

                                                </tr>  

                                                <%
                                                sum_ammount=0.0;
                                                sum_ammount_ekv=0.0;
                                                }             
                                              
                                                   sqlresBalCn.close();
                                                   stmt.close();
                                                   stmt_balcn.close();
                                                   conn.close();
                                                %>  

                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table border="0" width="100%">
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td width="30%">&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp; </td>
                                        <td> Baş mühasib _________________</td>
                                        <td> İcraçı _________________</td>
                                    </tr>
                                </table>
                                </font>
                            </td>
                        </tr>

                    </table> 

                </td>
                <td valign="top" align="right"> 
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
                </td>
            </tr>    
        </table>
    </body>
</html>
