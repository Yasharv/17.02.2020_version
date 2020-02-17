<%-- 
    Document   : Text
    Created on : Apr 19, 2017, 4:45:04 PM
    Author     : x.dashdamirov
--%>

<%@page import="java.sql.Statement"%>
<%@page import="main.DB"%>
<%@page import="java.sql.Connection"%>
<%@page import="main.TrippleDes"%>
<%@page import="java.io.PrintWriter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <td width="200" height="60">  
        <font face="Times new roman" size="5"> 
        Parol
        </font> </td>
    <div>
        <img src="images/c.gif" >
    </div>
    <br>
    <div>
        <img src="images/d.gif">
    </div>
    <%   
           DB db = new DB();
         Connection conn = db.connect();
           Statement stmt = conn.createStatement();
               
        String user = request.getParameter("product_id");
            String parol = request.getParameter("custid");
         //   System.out.println("user  " + user);
          //       System.out.println("parol  " + parol);
                  PrintWriter writer =null;
                 if (user.equals("Exbank") ) {
                      
              String exec = " ALTER USER exbank IDENTIFIED BY "+parol+" ";
                     System.out.println("exec  " + exec);
               //    stmt.execute(exec);    
                         
       writer = new PrintWriter("/tsm/Exbank", "UTF-8"); }
                    if (user.equals("CallCenter") ) {
                         String exec = " ALTER USER CALLCENTER IDENTIFIED BY "+parol+" ";
                     System.out.println("exec  " + exec);
                  //  stmt.execute(exec);
                            
       writer = new PrintWriter("/tsm/CallCenter", "UTF-8"); }
                       if (user.equals("QualityControl") ) {
                              String exec = " ALTER USER QUALITY_C IDENTIFIED BY "+parol+" ";
                     System.out.println("exec  " + exec);
                  //  stmt.execute(exec);
                            
       writer = new PrintWriter("/tsm/QualityControl", "UTF-8"); }
        TrippleDes td = null;
         td = new TrippleDes();
      String  encrypted = td.encrypt(parol);
    //   System.out.println("encrypted  " + encrypted);
writer.print(encrypted);
   
writer.close(); 
stmt.close();
conn.close();
    %>
</body>
</html>
