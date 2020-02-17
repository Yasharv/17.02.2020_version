<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : e.mustafayev
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

                // String DateB = request.getParameter("DateB");
                // String DateE = request.getParameter("DateE");
                String repcheck = request.getParameter("RepCheck");
                String custid = request.getParameter("custid");
                String contract = request.getParameter("contract");
                String color = request.getParameter("color");
                String automark = request.getParameter("automark");
                String automodel = request.getParameter("automodel");
                String transmission = request.getParameter("transmission");
                String filial = request.getParameter("filial");
                System.out.println("repcheck "+repcheck);
                System.out.println("custid "+custid);
                System.out.println("contract "+contract);
                System.out.println("color "+color);
                System.out.println("automark "+automark);
                System.out.println("automodel "+automodel);
                System.out.println("transmission "+transmission);
                System.out.println("filial "+filial);
                System.out.println(RepType);
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="CarPricingRep.jsp">    
            <jsp:param name="repcheck" value="<%=repcheck%>"/> 
            <jsp:param name="custid" value="<%=custid%>"/> 
            <jsp:param name="contract" value="<%=contract%>"/> 
            <jsp:param name="color" value="<%=color%>"/> 
            <jsp:param name="automark" value="<%=automark%>"/> 
            <jsp:param name="automodel" value="<%=automodel%>"/> 
            <jsp:param name="transmission" value="<%=transmission%>"/> 
            <jsp:param name="filial" value="<%=filial%>"/> 
        </jsp:forward>
        <%
                break;
            }
            case 1: {
        %>
        <jsp:forward page="CarExcel">  
            <jsp:param name="RepCheck" value="<%=repcheck%>"/> 
            <jsp:param name="custid" value="<%=custid%>"/> 
            <jsp:param name="contract" value="<%=contract%>"/> 
            <jsp:param name="color" value="<%=color%>"/> 
            <jsp:param name="automark" value="<%=automark%>"/> 
            <jsp:param name="automodel" value="<%=automodel%>"/> 
            <jsp:param name="transmission" value="<%=transmission%>"/> 
            <jsp:param name="filial" value="<%=filial%>"/> 
        </jsp:forward>
        <% break;
                    }

                    default: {
                        out.println("Hazırlanır!");
                        break;
                    }
                }
            }
        %>
    </body>
</html>
