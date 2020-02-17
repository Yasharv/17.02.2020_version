<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
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
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->


        <%
         Date d = new Date(); 
         DB db = new DB();   
         Connection conn = db.connect();
           
                   SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
                   SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
                   String s = format.format(d);
                   MemorialRep RepTrans = new MemorialRep();
               
                   int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                   String strDateB = request.getParameter("TrDateB");
                   String strDateE = request.getParameter("TrDateE");
                   String reval = request.getParameter("reval");
                   String RepValDeb = request.getParameter("RepValDeb"); 
                   String RepValKred = request.getParameter("RepValKred"); 
                   String DebFil = request.getParameter("DebFil");
                   String KredFil = request.getParameter("KredFil");
               
               
                   int DebForm = Integer.parseInt(request.getParameter("DebForm"));
                   int CredForm = Integer.parseInt(request.getParameter("CredForm"));
                   String DebValue = request.getParameter("DebValue");
                   String CredValue = request.getParameter("CredValue");
                   String RepUser = request.getParameter("RepUser");
                   String user_name = request.getParameter("uname");
                   String user_branch = request.getParameter("br");
                            
                   String TrSqlVal ="";
                   String TrSqlAccDeb ="";
                   String TrSqlAccCred ="";
                   String CategForSalary = "";
               
                   String View = ""; 
                   String TrType  ="";
               
                    Statement stmtUser = conn.createStatement();
           String SqlUserQuery= "select user_branch,all_filials,salary_acc from dwh_users where user_id='"+user_name+"'";
           ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
           int salary_acc=0; 
      
           while (sqlUserSel.next())
                {
               salary_acc = sqlUserSel.getInt(3);
                };
            sqlUserSel.close();
            stmtUser.close();
    
          CategForSalary = " AND debt_category<>1200 and cred_category<>1200";
          if (salary_acc==1) CategForSalary = "";
      
                    switch (RepForm) {
                case 0:  {
                        View="vi_memorial_all";
                        TrSqlVal="";
                        }
                         break;
                case 1: {
                        View="vi_memorial";
                        TrSqlVal=" and currency_dt_id like ('%"+RepValDeb+"%')";
                        break;
                         }
                case 2:  {
                        View="vi_memorial2";
                        TrSqlVal="	AND (currency_dt_id LIKE ('%"+RepValDeb+"%') or currency_cr_id LIKE ('%"+RepValKred+"%'))";
                        break;
                        }
                case 3:  {
                        View="vi_memorial_all";
                        if (DebForm==1) TrSqlAccDeb=" AND acct_no_dt like ('%"+DebValue+"%')";
                         if (DebForm==2) TrSqlAccDeb=" AND debt_balans like ('%"+DebValue+"%')";    
                        if (CredForm==1) TrSqlAccCred=" AND acct_no_cr like ('%"+CredValue+"%')";
                         if (CredForm==2) TrSqlAccCred=" AND kred_balans like ('%"+CredValue+"%')";   
                        TrSqlVal="	AND (currency_dt_id LIKE ('%"+RepValDeb+"%') AND currency_cr_id LIKE ('%"+RepValKred+"%'))"
                        + TrSqlAccDeb+TrSqlAccCred;
                        break;
                        }
                }
                     
                   if (reval==null || reval=="") TrType = " AND transaction_type<>'REVAL' " ;
                   else
                     if (Integer.parseInt(reval)==1) TrType= " ";//" AND transaction_type='REVAL' "; 
               
                   Date dateB = format.parse(strDateB);
                    strDateB = format2.format(dateB);
                           
                   Date dateE = format.parse(strDateE); 
                    strDateE = format2.format(dateE);
                
                   String SqlPart1 = "SELECT a.*, (SELECT tax_pay_id FROM cust_hs_fs where customer_id=dcustid) DCustInn,"
                    +  " (SELECT tax_pay_id FROM cust_hs_fs where customer_id=ccustid) CCustInn";  
                                   
                   String SqlSumPart = "Select sum(a.ammount) aaa,sum(a.lammount) bbb ";
               
                   String SqlPart2 = " FROM "+ View 
                    +  " a where  a.tarix BETWEEN to_date('"+strDateB+"','yyyy-mm-dd') AND to_date('"+strDateE+"','yyyy-mm-dd')"
                    +TrType + TrSqlVal + " and (debt_filial_id like ('%"+DebFil+"%') and cred_filial_id like ('%"+KredFil+"%'))";
               
                    String SQLText = SqlPart1 + SqlPart2+CategForSalary;
                    String SqlSumText = SqlSumPart + SqlPart2+CategForSalary;
                    //System.out.println(SQLText);
                    Statement stmt = conn.createStatement();                	
                    ResultSet sqlres = stmt.executeQuery(SQLText);                
        %>
        <table width="100%" border="0">
            <tr>
                <td valign="top" align="left">
                    <font face="Times new roman" size="5">
                    <A Href="Memorial.jsp<%out.print("?uname="+user_name+"&br="+user_branch);%>" >
                        <img src="images/back.png">
                    </a>
                    </font>    
                </td>
                <td>
                </td>
                <td valign="top" align="right">
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()"></FORM>
                </td>
            </tr> 
            <tr>
                <td valign="top" align="left">  
                </td>
                <td valign="top" align="center">

                    <table bgcolor='white' border='1' width="900" cellspacing="1">
                        <tr>
                            <td>
                                <table bgcolor='white' border='0' width="900">
                                    <tr>
                                        <td align="left"> <font size="5"> "Expressbank" ASC </font> <br> VÖEN: 1500031691</td>
                                    </tr>  
                                    <tr>
                                        <td align="center"> <font size="5"> Memorial Orderi </font> </td>
                                    </tr> 
                                    <tr>
                                        <td align="center">
                                            <font size="4"> 
                                            <%  
                                            String strDateB2 = format.format(dateB);
                                            String strDateE2 = format.format(dateE);
                                            out.println(strDateB2); out.println("&nbsp;"); out.println(strDateE2);
                                            %> 
                                            </font>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td align="center"> <font size="4"> Bütün valyutalar </font> </td>
                                    </tr> 
                                    <!--
                                    <tr>
                                        <td align="left"> <hr>  <font size="3">  Aşağıdakı göstərilən əməliyyatları keçirməli. </font> </td>
                                    </tr> 
                                     <tr>
                                        <td align="left">  <hr> </td>
                                    </tr>         
                                    -->

                                </table>
                                <table bgcolor='white' border='1' width="900" cellpadding="1" cellspacing="0">
                                    <tr>
                                        <th width="39" align="center"> Sənəd № </th>
                                        <th width="46" align="center"> Valyuta </th>
                                        <th width="240" align="center"> D E B E T hesabı </th>
                                        <th width="46" align="center"> Valyuta </th>
                                        <th width="240" align="center"> K R E D İ T hesabı </th>
                                        <th align="center" width="100"> M Ə B L Ə Ğ<BR>
                                    <table bgcolor='white' border='0' width="250">
                                        <tr>
                                            <td align="center" width='80'>
                                                Valyutada
                                            </td>
                                            <td align="center" width='80'>
                                                Manatla
                                            </td>
                                        </tr>
                                    </table> 
                                    </th>
                        </tr> 
                    </table>
                    <!--
                     <table bgcolor='white' border='0' width="900">
                        <tr>
                             <td > <hr> </td>    
                         </tr> 
                     </table>
                    -->
                    <% 
   
   
                    String DVal = "";
                    String DAccNo = "";
                    String CVal = "";
                    String CAccNo = "";
                    double Ammount = 0;
                    double LAmmount = 0;
                    String SumAmmount = "";
                    String SumLAmmount = "";
                    String DAccName = "";
                    String CAccName = "";
                    String DInn = "";
                    String CInn = "";
                    String TrName = "";
                    int cnt = 0;
   
                     while (sqlres.next())
                      {
                     DVal = sqlres.getString(3);
                     DAccNo = sqlres.getString(2);
                     CVal = sqlres.getString(6);
                     CAccNo = sqlres.getString(5);
                     Ammount = sqlres.getDouble(16);
                     LAmmount = sqlres.getDouble(17);
                     DAccName = sqlres.getString(11);
                     CAccName = sqlres.getString(12);
                     DInn = sqlres.getString(18);
                     CInn = sqlres.getString(19);
                     TrName = sqlres.getString(8);
                     cnt ++;  
    
                    out.println(RepTrans.main(DVal,DAccNo,CVal,CAccNo,Ammount,LAmmount,DAccName,CAccName,DInn,CInn,TrName,cnt));
                      }
                    sqlres.close();
                    sqlres=stmt.executeQuery(SqlSumText);
                    while (sqlres.next())
                    {
                     SumAmmount= sqlres.getString(1);
                     SumLAmmount= sqlres.getString(2);
                    }
                    stmt.close();
                    conn.close();
                    DecimalFormat twoDForm = new DecimalFormat("0.00");
   
                    %>

                    <table  bgcolor='white' border='0' width='900'>
                        <tr>
                            <td width="642"  align="left"> Cəmi: </td> 
                            <td width="118" align="right"> <% out.println(SumAmmount); %></td>  
                            <td width="118" align="right"> <% out.println(SumLAmmount); %></td>        
                        </tr>
                    </table>
                    <table  bgcolor='white' border='0' width='900'>
                        <tr>
                            <td width="642"  align="center">
                                <p>
                                    &ensp;
                                </p>
                                <p>  <font size="4">
                                    &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Məsul İcraçı _________________________ 
                                    </font>
                                </p>
                            </td>     
                        </tr>
                    </table>
                </td>
        </table> 

    </td>
<td valign="top" align="right">   
</td>
</tr>    
</table>
</body>
</html>
