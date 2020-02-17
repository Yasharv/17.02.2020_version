<%-- 
    Document   : GoldPricingRep
    Created on : Oct 9, 2014, 3:02:35 PM
    Author     : emin.mustafayev
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
        if (request.getParameter("RepType") != null) {

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                 
               String DateB =  request.getParameter("DateB");
               String DateE =  request.getParameter("DateE");
               String Filial = request.getParameter("Filial");
               String product_id = request.getParameter("product_id");
               String custid = request.getParameter("custid");
               String RepUser = request.getParameter("RepUser");
               
               switch (RepType)
               {
                   case 0:{
        %>
        <jsp:forward page="GoldPricingRep.jsp">
            <jsp:param name="DateB" value="<%=DateB%>"/>
            <jsp:param name="DateE" value="<%=DateE%>"/>
            <jsp:param name="Filial" value="<%=Filial%>"/> 
            <jsp:param name="product_id" value="<%=product_id%>"/> 
            <jsp:param name="custid" value="<%=custid%>"/> 
            <jsp:param name="RepUser" value="<%=RepUser%>"/> 
        </jsp:forward>
        <%
                       break;}
      case 1:{
        %>
        <jsp:forward page="GoldRepExcel">
            <jsp:param name="DateB" value="<%=DateB%>"/>
            <jsp:param name="DateE" value="<%=DateE%>"/>
            <jsp:param name="Filial" value="<%=Filial%>"/> 
            <jsp:param name="product_id" value="<%=product_id%>"/> 
            <jsp:param name="custid" value="<%=custid%>"/> 
            <jsp:param name="RepUser" value="<%=RepUser%>"/> 
        </jsp:forward>
        <% break;}
              
                   default:{ out.println("Hazırlanır!");break;}
               }
        }
        %>
    </body>
</html>