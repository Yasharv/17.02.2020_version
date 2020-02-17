<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.PreparedStatement"%>
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
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->


        <%
         Date d = new Date(); 
         DB db = new DB();
             Connection conn = db.connect();
         PrDict dict = new PrDict();   
         MemorialRep RepTrans = new MemorialRep();        
               String ipAddress = request.getRemoteAddr();

                   SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
                   SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
                      DecimalFormat twoDForm = new DecimalFormat("0.00");
                   String s = format.format(d);
              
               
                   String PrID = "";
                   String[] PrIDs = null;
                   String br=request.getParameter("brNum");
                   if (br.equals("100")) br="0";
               
                   String DateB=request.getParameter("dtb");
                   String DateE=request.getParameter("dte");
                   if (DateB.equals(DateE)) DateE="";
               
                   if (!(request.getParameter("id")==null))
                           PrID=request.getParameter("id");
                                   else
                   {
                  
                            Statement statement = conn.createStatement();
                
                   
                   PrIDs = request.getParameterValues("ids");
              
                     for (int i = 0; i < PrIDs.length; i++)
                        {
                           String insertTableSQL = "insert into PRID_REAL  values( + '"+PrIDs[i]+"','"+ipAddress+"')  " ;
                      //   PrID=PrID+","+PrIDs[i];   
                                  statement.executeUpdate(insertTableSQL);
                        } 
                   }
                    PrID=PrID.replace(",", "','");
                   String SqlPart1 = "SELECT a.*, (SELECT tax_pay_id FROM cust_hs_fs where customer_id=dcustid) DCustInn,"
                    +  " (SELECT tax_pay_id FROM cust_hs_fs where customer_id=ccustid) CCustInn";  
                                   
                   String SqlSumPart = "Select sum(a.ammount) aaa,sum(a.lammount) bbb ";
               
             /*      String SqlPart2 = " FROM vi_memorial_in_out "
                    +  " a where  a.id in ('"+PrID+"') order by a.lammount desc";*/
                   String SqlPart2 = " FROM vi_memorial_in_out "
                    +  " a  , PRID_REAL pr  where  a.id = pr.id order by a.lammount desc";
                    String SQLText = SqlPart1 + SqlPart2;
                    String SqlSumText = SqlSumPart + SqlPart2;
              System.out.println("SQLText  " + SQLText); 
                System.out.println("SqlSumText " + SqlSumText); 
                    Statement stmt = conn.createStatement();                	
                    ResultSet sqlres = stmt.executeQuery(SQLText); 
                    PreparedStatement preparedStatement = null;
            String deleteSQL = "DELETE PRID_REAL WHERE ip = ?";
              preparedStatement = conn.prepareStatement(deleteSQL);
              preparedStatement.setString(1, ipAddress);
              preparedStatement.executeUpdate();
             System.out.println("Record is deleted!");


    //System.out.println(SQLText);                             
        %>
        <table width="100%" border="0" align="center">
            <tr>
                <td valign="top" align="left">

                </td>
                <td>
                </td>
                <td valign="top" align="right">
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
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
                                        <td align="left"> <font size="5"> Expressbank ASC <% out.println(dict.getFililal(Integer.parseInt(br)));%> </font> <br> VÖEN: 1500031691</td>
                                    </tr>  
                                    <tr>
                                        <td align="center"> <font size="5"> Memorial Orderi </font> </td>
                                    </tr> 
                                    <tr>
                                        <td align="center">
                                            <font size="4"> 
                                            <%  
                                            out.println(DateB); out.println("&nbsp;"); out.println(DateE);
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
                    double SumAmmount = 0;
                    double SumLAmmount = 0;
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
                     SumAmmount= sqlres.getDouble(1);
                     SumLAmmount= sqlres.getDouble(2);
                    }
                    stmt.close();
                    conn.close();   
                    %>

                    <table  bgcolor='white' border='0' width='900'>
                        <tr>
                            <td width="642"  align="left"> Cəmi: </td> 
                            <td width="118" align="right"> <% out.println(twoDForm.format(SumAmmount)); %></td>  
                            <td width="118" align="right"> <% out.println(twoDForm.format(SumLAmmount)); %></td>        
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
