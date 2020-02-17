
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
           


  
                  String custid = request.getParameter("custid");
                    custid = custid.replace(" ", ",");
                     
               
       
        %>
        <jsp:forward page="RatingByCustID.jsp">    

            <jsp:param name="custid" value="<%=custid%>"/> 




        </jsp:forward>
        <%
             
           
                
            
        %>
    </body>
</html>
