<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="javax.net.ssl.SSLEngineResult.Status"%>
<%--@page import="org.hibernate.validator.constraints.Length"--%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="main.JavaMail"%>
<%@page import="main.DB"%>
<%@page import="main.JavaPDF"%>
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
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]]
                });
            });

            function newPopup(url) {
                window.open(
                        url, 'popUpWindow', 'height=300,width=300,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
            }
            ;
        </script>

    </head>

    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
        PrDict footer = new PrDict();
        JavaMail jmail = new JavaMail();
        JavaPDF CrPdf = new JavaPDF();
        String uname = request.getParameter("uname");
        
        DB db = new DB();
        Connection conn = db.connect();
    
         CallableStatement cstmt = conn.prepareCall("{ call send_mail }");
         cstmt.execute();
         cstmt.close();
         
         CallableStatement cstmtt2 = conn.prepareCall("{ call fill_cust_mail }");
         cstmtt2.execute();
         cstmtt2.close();
     
         Statement stmt = conn.createStatement();
         ResultSet sqlres = stmt.executeQuery("select custid,e_mail,dateb,datee,periodmail,sendmail,ID from custmaillist"
                                                + " where sendmail<>1"
                                                + " order by custid");

         String vMail = "";
         String password = "";
         String vPeriod = "";
         int vCustId;
         String filename = "";
         int v_old_custid=-999;
         String strDateB="";
         String strDateE="";
         Date DateB;
         Date DateE;
         String error="";
         int Status=0;
         int ID =0;
     
         File file;       
        %>

        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td> <font face="Times new roman" size="5"> Mail Statement </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    <%=footer.lAdminMenu(uname)%>
                </td>
                <td align="left" valign="top">
                    <font size="4" color="Blue">  E-Mail -lər göndərildi!! </font>
                    <div id="demo">
                        <table cellpadding="0" cellspacing="0" border="0"  id="example" width="600">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>E-Mail</th>
                                    <th>Period</th>
                                    <th>B. Tarix</th>
                                    <th>S. Tarix</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%  
                                while (sqlres.next())
                                {
                                    vCustId = sqlres.getInt(1);
                                    vMail = sqlres.getString(2);
                                    strDateB = sqlres.getString(3).substring(0,10);
                                    strDateE = sqlres.getString(4).substring(0,10);
                                    vPeriod = sqlres.getString(5);
                                    ID=sqlres.getInt(7);
                                    password = Integer.toString(vCustId);
  
                                    filename = "/tsm/DWHReports/EStatm/"+vCustId+".pdf";
                                   //filename = "C:/EStatm/"+vCustId+".pdf";
                                    try {
                                        Status=1;
                                        error="";
                                if (v_old_custid != vCustId)
                                            { 
                                 CrPdf.createPdf(filename, vCustId, strDateB, strDateE,password);
                                            }
                                   jmail.main(vMail,filename);
       
                           } catch (Exception e){
                                    Status=2;
                                   error=e.toString();
                           }    
     
                                    String sql_res="{ call update_mail("+ID+","+Status+",'"+error+"') }";
                                try{
                                    CallableStatement cstmt2 =  conn.prepareCall(sql_res);
                                   cstmt2.execute();
                                    }   
                                    catch(Exception ex)
                                    {
                                    //    System.out.println(ex.toString());
                                      //  System.out.println(sql_res);
                                    } 
     
                                    v_old_custid = vCustId;
                              }
                           sqlres.close();
                           stmt.close();
                           
                           String log_txt="{ call log_custmaillist() }";
                           CallableStatement cstmt3 =  conn.prepareCall(log_txt);
                             try{
                                  
                                   cstmt3.execute();
                                   cstmt3.close();
                                   
                                }   
                                catch(Exception ex)
                                 {
                                    if(!cstmt3.isClosed())
                                    {
                                        cstmt3.close();
                                    }
                                 } 
                           

                                   File directory = new File("/tsm/DWHReports/EStatm");
                                   //  File directory = new File("C:/EStatm");        
                                   File[] files = directory.listFiles();
                                   for (File File : files)
                                   {
                                   if (!File.delete())
                                   {
                                 //  System.out.println("Failed to delete "+File);
                                   }
                                   }
                                  sqlres.close();
       
                                Statement stmt2 = conn.createStatement();
                                ResultSet sqlres2 = stmt2.executeQuery("select custid,e_mail,dateb,datee,periodmail,sendmail,id from custmaillist"
                                                                       + " order by custid");
    
                           while (sqlres2.next())
                                {        
                                    out.println("<tr>");
                                    out.println("<td>"+sqlres2.getInt(1)+"</td>");
                                    out.println("<td>"+sqlres2.getString(2)+"</td>");
                                    out.println("<td>"+sqlres2.getString(5)+"</td>");
                                    out.println("<td>"+sqlres2.getString(3).substring(0,10)+"</td>");
                                    out.println("<td>"+sqlres2.getString(4).substring(0,10)+"</td>");
                                   Status=sqlres2.getInt(6);
       
                                   if (Status==0) out.println("<td align='center'> <img src='images/email-new-icon.png'></td>");
                              else if (Status==1) out.println("<td align='center'> <img src='images/accept-icon.png'></td>");
                              else if (Status==2) out.println("<td align='center'> <a onclick=\"newPopup('EStatmError.jsp?errid="+sqlres2.getInt(7)+"')\"> <img src='images/error-icon.png'> </a>  </td>");
                                    out.println("</tr>");  
                              }
                                 sqlres2.close();
                                 stmt2.close();
                                 conn.close();
        
                                %>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th>ID</th>
                                    <th>E-Mail</th>
                                    <th>Period</th>
                                    <th>B. Tarix</th>
                                    <th>S. Tarix</th>
                                    <th>Status</th>
                                </tr>    
                            </tfoot>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td>  
                </td>
                <td height="40">
                    <div align="right">
                        <%=footer.ftSign()%>
                    </div>
                </td>
            </tr>

        </table>    

    </body>
</html>
