<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>

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
        <script>
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
                });
            });
        </script>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->

        <%
            DB db = new DB();
            PrDict dict = new PrDict();
       String cardType = request.getParameter("cardType");
       System.out.println("cardType  "+ cardType);
              String[] traficType = request.getParameterValues("DebFilial");
            String tr_types="";
              int Z=0;
                
                while (Z<traficType.length)
                                       {
                     tr_types=tr_types+"'"+traficType[Z]+"',";                                                
                Z++;
                }
                tr_types= tr_types.substring(0, tr_types.length()-1);
                
                            System.out.println("tr_types  "+tr_types);

              System.out.println("tr_types  "+tr_types);
            String TrDateB = request.getParameter("TrDateB");
            String Filial = request.getParameter("Filial");
            
         String TarixSQL  = "  to_date('"+TrDateB+"', 'DD-MM-YYYY')  " ;
         String FilialSql="";
          if (Filial.equals("0")) {
                FilialSql = "";
            } else {
                FilialSql = " and info.filial_code=" + Filial;
            }
        
         
             String cardTypeSql="";
          if (cardType.equals("0")) {
                cardTypeSql = "";
            } else {
                cardTypeSql = " and info.CARD_TYPE='" + cardType+"'";
            }
          
          
           String tr_typesSql="";
            if (tr_types.equals("")) {
                tr_typesSql = "";
            } else {
                tr_typesSql = " and info.product_id in (" + tr_types+")";
            } 
            
             Connection conn = db.connect();
            ResultSet rs = null;
            Statement st = null;
            String Text = "  SELECT  * FROM sql_select  where id = 32 ";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
        String SQLText =    clob.getSubString(1, (int) clob.length());
            
        SQLText=    SQLText.replaceAll("FilialSql", FilialSql);
        SQLText=      SQLText.replaceAll("cardTypeSql", cardTypeSql);
         SQLText=    SQLText.replaceAll("tr_typesSql", tr_typesSql);
            SQLText=   SQLText.replaceAll("TarixSQL", TarixSQL);
           
            System.out.println(SQLText);
   
       Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SQLText);
            session.setAttribute("sqlres", sqlres);  
        %>

        <jsp:include page="main.jsp" />


        <%
            out.println(dict.ftSign());
            sqlres.close();
            stmt.close();
             rs.close();
            st.close();
            conn.close();

        %>

    </body>
</html>
