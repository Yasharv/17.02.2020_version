<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>
<%@page import="main.PrDict"%>
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
                $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers"
                });
            });
        </script>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
         Date d = new Date(); 
               
                   Format formatter = new SimpleDateFormat("dd-MM-yyyy");
                   String s = formatter.format(d);

                   String srcValue = request.getParameter("CustIds");
                   String forSrc = request.getParameter("forSrc");
                   String strDateB = request.getParameter("DateB");
                   String strDateE = request.getParameter("DateE"); 
                   srcValue=srcValue.trim(); 
                    Date dateB ;
                    Date dateE ;
                    dateB = new SimpleDateFormat("dd-mm-yyyy").parse(strDateB);
                    strDateB = new SimpleDateFormat("yyyy-mm-dd").format(dateB);
                                         
                    dateE = new SimpleDateFormat("dd-mm-yyyy").parse(strDateE); 
                    strDateE = new SimpleDateFormat("yyyy-mm-dd").format(dateE);
               
                   String SqlAccs =  "select date_until,balance_fcy_amount,balance_lcy_amount from SI_ACCOUNT_BALANCE "
        + " where alt_acct_id='"+srcValue+"' and "
        + " (date_until BETWEEN TO_DATE('"+strDateB+"','yyyy-mm-dd') and TO_DATE('"+strDateE+"','yyyy-mm-dd'))"
        + " order by date_from, date_until"; 
  
            String SqlBalccs = "select date_until, sum(balance_fcy_amount) sumAmount,sum(balance_lcy_amount) sumLAmount"
                 + " from SI_ACCOUNT_BALANCE "
                 + " where gl_acct_no="+srcValue+" and "
                 + " (date_until BETWEEN TO_DATE('"+strDateB+"','yyyy-mm-dd') and TO_DATE('"+strDateE+"','yyyy-mm-dd'))"
                    + " group by date_until  order by date_until";

               DB connt = new DB();
                   String SQLText = " ";
                   Statement Accs = connt.connect().createStatement();              
                   ResultSet sqlresAccs = Accs.executeQuery(SqlAccs);
                    
                  String Caption = "";              
            int iforSrc = Integer.valueOf(forSrc);
                switch (iforSrc) {
                case 1:  sqlresAccs =Accs.executeQuery(SqlAccs);
                         Caption = srcValue+" nömrəli hesab üçün qalıqlar";
                         break;
                case 2:  sqlresAccs =Accs.executeQuery(SqlBalccs);
                         Caption = srcValue+" balans hesabı üçün qalıqlar";
                         break;
                                 }
                 PrDict footer = new PrDict();
        %> 
        <table  border="0"> 
            <col width="200">
            <td> <font face="Times new roman" size="5"> DWHReports </font> </td>
            <td>  </td>
        </tr>
        <tr>

            <% out.println(footer.lMenu()); %>

            <td width="1000" valign="top"  align="center"> 

                <!--  TABLE  -->

        <center>
            <% out.println(Caption);%>
            <table border="0">
                <tr>
                    <td>

                        <table cellpadding="0" cellspacing="0" border="0" class="display" id="example" width="100%">
                            <thead>
                                <tr>
                                    <th>Tarix</th>
                                    <th>Məbləğ</th>  
                                    <th>Ekvivalent</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                            int chk=0;
                           while (sqlresAccs.next())
                                 {
                                out.println("<tr class='odd gradeA'>");
                                 for (int i = 1; i <= 3; i++)
                                        {
                                       if (i==1)
                                         out.println("<td>"+sqlresAccs.getString(1).substring(0,10)+"</td>");                          
                                        else
                                        out.println("<td>"+sqlresAccs.getString(i) +"</td>");   
                                        };
                                out.println("</tr>");
                                 }
                                 
                                     sqlresAccs.close();
                                     Accs.close();               
                                     connt.connect().close();
                                    //if (chk==0) out.println("Bu müştəri üçün seçilən tarix aralığında heç bir əməliyyat olmamışdır!");
                                %>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th>Tarix</th>
                                    <th>Məbləğ</th>  
                                    <th>Ekvivalent</th>
                                </tr>

                            </tfoot>
                        </table>
                    </td>
                </tr>
            </table>
        </center>     
        <!--  TABLE  -->
    </td>
</tr>
<tr>
    <td>  
    </td>
    <td width="500">
        <div align="left">
            <% 
            out.println(footer.ftSign());
            %>
        </div>
    </td>
</tr>

</table>          



</body>
</html>
