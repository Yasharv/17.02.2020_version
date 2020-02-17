<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Locale"%>
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
  ResultSet sqlres = null;
        Statement stmt = null;
         ResultSet rs = null;
            Statement st = null;
        
        Connection conn = null;
        DB connt = new DB();
          conn = db.connect();
response.setCharacterEncoding("UTF-8");

   
          
            
                  SimpleDateFormat df1 = new SimpleDateFormat("dd-mm-yyyy", Locale.getDefault());
                SimpleDateFormat df2 = new SimpleDateFormat("yyyy-mm-dd", Locale.getDefault());
   String  TarixB = request.getParameter("TrDateB");
   String  TarixE = request.getParameter("TrDateE");
     String   type = request.getParameter("type"); 
        String   type1 = request.getParameter("type1");    
String   chkSelectAll = request.getParameter("chkSelectAll");
    int   wunion = Integer.parseInt(request.getParameter("wunion"));
  int   cmt = Integer.parseInt(request.getParameter("cmt"));
  int   korona = Integer.parseInt(request.getParameter("korona"));
   int    contact = Integer.parseInt(request.getParameter("contact"));
  int   lider = Integer.parseInt(request.getParameter("lider"));
  int   monex = Integer.parseInt(request.getParameter("monex"));
  int   iba_express = Integer.parseInt(request.getParameter("iba_express"));
  int   xezri = Integer.parseInt(request.getParameter("xezri"));
  
    int   wunion1 = Integer.parseInt(request.getParameter("wunion"));
  int   cmt1 = Integer.parseInt(request.getParameter("cmt"));
  int   korona1 = Integer.parseInt(request.getParameter("korona"));
   int    contact1 = Integer.parseInt(request.getParameter("contact"));
  int   lider1 = Integer.parseInt(request.getParameter("lider"));
  int   monex1 = Integer.parseInt(request.getParameter("monex"));
  int   iba_express1 = Integer.parseInt(request.getParameter("iba_express"));
  int   xezri1 = Integer.parseInt(request.getParameter("xezri"));
  String   rep = request.getParameter("rep");
   String   rep1 = request.getParameter("rep1");
   String   report = request.getParameter("report");
   String   azn = request.getParameter("azn");
  String   eur = request.getParameter("eur");
  String   usd = request.getParameter("usd");
  String   gbp = request.getParameter("gbp");
  String   rub = request.getParameter("rub");
  String   jpy = request.getParameter("jpy");
  String   chf = request.getParameter("chf");
  String RepFilial  = request.getParameter("RepFilial");
   String   country = request.getParameter("country");
      String   sender = request.getParameter("sender");
     
      Date dateB;
                Date dateE;
                 dateB = df1.parse(TarixB);
                     TarixB = df2.format(dateB);
                     dateE = df1.parse(TarixE);
                     TarixE = df2.format(dateE);
                   
             
                String FİLSQL  =  "";
         //   System.out.println("sender  " + sender);
             if (!RepFilial.equals("0"))  {
      FİLSQL  = "  and BAL.FILIAL_CODE = "+RepFilial+" ";
             }
                  String gelir_yes ="";
                     String gelir_no ="";
 if(rep.equals("1"))  {
     String TarixSQL  = "  and TR.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd') "
             + "  and comm.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd') "
             + " and PAY.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd')  ";
       wunion = wunion *17683;
       
        cmt = cmt *17685;   
         korona = korona *17687; 
          contact = contact *17688; 
           lider = lider *17690; 
            monex = monex *17692; 
             iba_express = iba_express *17693; 
             xezri = xezri *17694; 
              String CountrySql_k = "";
         String CountrySql_d = "";
              if (!country.equals("0")){
        CountrySql_k  = " and  to_char(RECIPIENT_COUNTRY) = '"+country+"'  ";
        CountrySql_d  = " and  to_char(Sender_COUNTRY)  = '"+country+"'  ";
       
        }
              String RECIPIENTSQL = "";
                 if (sender!=null){
              
               RECIPIENTSQL = " and lower(RECIPIENT_NAME)  like    lower('%"+sender+"%')  ";
                }
 String gelir_koc ="";
   if (report.equals("2"))  {
       
        String Text = "  SELECT  * FROM sql_select  where id =  360";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
           gelir_koc =    clob.getSubString(1, (int) clob.length());
          
         gelir_koc=    gelir_koc.replaceAll("wunion", "'"+wunion+ "'" );
        gelir_koc=    gelir_koc.replaceAll("cmt", "'"+cmt+ "'" );
        gelir_koc=    gelir_koc.replaceAll("korona", "'"+korona+ "'" );
        gelir_koc=    gelir_koc.replaceAll("contact", "'"+contact+ "'" );
        gelir_koc=    gelir_koc.replaceAll("lider", "'"+lider+ "'" );
        gelir_koc=    gelir_koc.replaceAll("monex", "'"+monex+ "'" );
         gelir_koc=    gelir_koc.replaceAll("iba_express", "'"+iba_express+ "'" );
            gelir_koc=    gelir_koc.replaceAll("xezri", "'"+xezri+ "'" );
         gelir_koc=    gelir_koc.replaceAll("azn", azn);
        gelir_koc=    gelir_koc.replaceAll("eur", eur );
        gelir_koc=    gelir_koc.replaceAll("usd", usd );
        gelir_koc=    gelir_koc.replaceAll("gbp", gbp );
        gelir_koc=    gelir_koc.replaceAll("rub", rub );
        gelir_koc=    gelir_koc.replaceAll("jpy", jpy);
         gelir_koc=    gelir_koc.replaceAll("chf", chf );
         gelir_koc=     gelir_koc.replaceAll("TarixB", TarixB);
         gelir_koc=      gelir_koc.replaceAll("TarixE", TarixE);
         gelir_koc=    gelir_koc.replaceAll("TarixSQL", TarixSQL);
         gelir_koc=   gelir_koc.replaceAll("FİLSQL", FİLSQL);
        
       //  System.out.println("gelir_koc   "  +gelir_koc);
   }
   
   else {
   
     String Text = "  SELECT  * FROM sql_select  where id =  360";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(4);
           gelir_koc =    clob.getSubString(1, (int) clob.length());
         
         gelir_koc=    gelir_koc.replaceAll("wunion", "'"+wunion+ "'" );
        gelir_koc=    gelir_koc.replaceAll("cmt", "'"+cmt+ "'" );
        gelir_koc=    gelir_koc.replaceAll("korona", "'"+korona+ "'" );
        gelir_koc=    gelir_koc.replaceAll("contact", "'"+contact+ "'" );
        gelir_koc=    gelir_koc.replaceAll("lider", "'"+lider+ "'" );
        gelir_koc=    gelir_koc.replaceAll("monex", "'"+monex+ "'" );
          gelir_koc=    gelir_koc.replaceAll("iba_express", "'"+iba_express+ "'" );
            gelir_koc=    gelir_koc.replaceAll("xezri", "'"+xezri+ "'" );
         gelir_koc=    gelir_koc.replaceAll("azn", azn);
        gelir_koc=    gelir_koc.replaceAll("eur", eur );
        gelir_koc=    gelir_koc.replaceAll("usd", usd );
        gelir_koc=    gelir_koc.replaceAll("gbp", gbp );
        gelir_koc=    gelir_koc.replaceAll("rub", rub );
        gelir_koc=    gelir_koc.replaceAll("jpy", jpy);
         gelir_koc=    gelir_koc.replaceAll("chf", chf );
         gelir_koc=     gelir_koc.replaceAll("TarixB", TarixB);
         gelir_koc=      gelir_koc.replaceAll("TarixE", TarixE);
         gelir_koc=    gelir_koc.replaceAll("TarixSQL", TarixSQL);
         gelir_koc=   gelir_koc.replaceAll("FİLSQL", FİLSQL);
          gelir_koc=    gelir_koc.replaceAll("CountrySql_k", CountrySql_k);
           gelir_koc=    gelir_koc.replaceAll("RECIPIENTSQL", RECIPIENTSQL);
        
        
        //  System.out.println("gelir_koc   "  +gelir_koc);
    }
        wunion = Integer.parseInt(request.getParameter("wunion"));
    cmt = Integer.parseInt(request.getParameter("cmt"));
     korona = Integer.parseInt(request.getParameter("korona"));
        contact = Integer.parseInt(request.getParameter("contact"));
       lider = Integer.parseInt(request.getParameter("lider"));
     monex = Integer.parseInt(request.getParameter("monex"));
        iba_express = Integer.parseInt(request.getParameter("iba_express"));
          xezri = Integer.parseInt(request.getParameter("xezri"));
     
        wunion = wunion *12689;
        cmt = cmt *12691;   
         korona = korona *12693; 
          contact = contact *12694; 
           lider = lider *12695; 
            monex = monex *12696;
             iba_express = iba_express *12697;
             xezri = xezri *12698;
             TarixSQL  = "  and TR.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd') "
                     + "   and PAY.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd')  ";
           String  senderSQL = "";
                 if (sender!=null){
                senderSQL = " and lower(sender_NAME)  like    lower('%"+sender+"%')  ";
                }
              String gelir_od="";
              if (report.equals("2"))  {
                  
                  String Text = "  SELECT  * FROM sql_select  where id =  360";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(5);
           gelir_od =    clob.getSubString(1, (int) clob.length());
         
         gelir_od=    gelir_od.replaceAll("wunion", "'"+wunion+ "'" );
        gelir_od=    gelir_od.replaceAll("cmt", "'"+cmt+ "'" );
        gelir_od=    gelir_od.replaceAll("korona", "'"+korona+ "'" );
        gelir_od=    gelir_od.replaceAll("contact", "'"+contact+ "'" );
        gelir_od=    gelir_od.replaceAll("lider", "'"+lider+ "'" );
        gelir_od=    gelir_od.replaceAll("monex", "'"+monex+ "'" );
           gelir_od=    gelir_od.replaceAll("iba_express", "'"+iba_express+ "'" );
               gelir_od=    gelir_od.replaceAll("xezri", "'"+xezri+ "'" );
         gelir_od=    gelir_od.replaceAll("azn", azn);
        gelir_od=    gelir_od.replaceAll("eur", eur );
        gelir_od=    gelir_od.replaceAll("usd", usd );
        gelir_od=    gelir_od.replaceAll("gbp", gbp );
        gelir_od=    gelir_od.replaceAll("rub", rub );
        gelir_od=    gelir_od.replaceAll("jpy", jpy);
         gelir_od=    gelir_od.replaceAll("chf", chf );
         gelir_od=     gelir_od.replaceAll("TarixB", TarixB);
         gelir_od=      gelir_od.replaceAll("TarixE", TarixE);
         gelir_od=    gelir_od.replaceAll("TarixSQL", TarixSQL);
         gelir_od=   gelir_od.replaceAll("FİLSQL", FİLSQL);
     
       //  System.out.println("gelir_od   "  +gelir_od); 
                  
     
              }
              
              else  {
                  
                  
                     String Text = "  SELECT  * FROM sql_select  where id =  360";
           st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
          java.sql.Clob clob = (java.sql.Clob) rs.getClob(6);
           gelir_od =    clob.getSubString(1, (int) clob.length());
         
         gelir_od=    gelir_od.replaceAll("wunion", "'"+wunion+ "'" );
        gelir_od=    gelir_od.replaceAll("cmt", "'"+cmt+ "'" );
        gelir_od=    gelir_od.replaceAll("korona", "'"+korona+ "'" );
        gelir_od=    gelir_od.replaceAll("contact", "'"+contact+ "'" );
        gelir_od=    gelir_od.replaceAll("lider", "'"+lider+ "'" );
        gelir_od=    gelir_od.replaceAll("monex", "'"+monex+ "'" );
          gelir_od=    gelir_od.replaceAll("iba_express", "'"+iba_express+ "'" );
             gelir_od=    gelir_od.replaceAll("xezri", "'"+xezri+ "'" );
         gelir_od=    gelir_od.replaceAll("azn", azn);
        gelir_od=    gelir_od.replaceAll("eur", eur );
        gelir_od=    gelir_od.replaceAll("usd", usd );
        gelir_od=    gelir_od.replaceAll("gbp", gbp );
        gelir_od=    gelir_od.replaceAll("rub", rub );
        gelir_od=    gelir_od.replaceAll("jpy", jpy);
         gelir_od=    gelir_od.replaceAll("chf", chf );
         gelir_od=     gelir_od.replaceAll("TarixB", TarixB);
         gelir_od=      gelir_od.replaceAll("TarixE", TarixE);
         gelir_od=    gelir_od.replaceAll("TarixSQL", TarixSQL);
         gelir_od=   gelir_od.replaceAll("FİLSQL", FİLSQL);
            gelir_od=   gelir_od.replaceAll("CountrySql_d", CountrySql_d);
          gelir_od=   gelir_od.replaceAll("senderSQL", senderSQL);
         
     //  System.out.println("gelir_od   "  +gelir_od); 
                }
   
         if (  type.equals("1") && type1.equals("1")  ) {
         
            gelir_yes  = gelir_koc  +  " union all "  +  gelir_od;
         }
      if (  type.equals("1") && !type1.equals("1")  )  {
         
            gelir_yes  = gelir_koc;
         }
           if (  !type.equals("1") && type1.equals("1")  )  {
         
           gelir_yes  = gelir_od;
         }
             gelir_yes = gelir_yes + " order by 1,6 ";
 //   System.out.println("gelir_yes   "  +gelir_yes); 

   
 }
    if(rep1.equals("2"))  {
     
 
       String TarixSQL  = "  and TR.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd') "
             + "  and comm.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd')"
             + "   and PAY.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd')  ";
       wunion1 = wunion1 *17683;
        cmt1 = cmt1 *17685;   
         korona1 = korona1 *17687; 
          contact1 = contact1 *17688; 
           lider1 = lider1 *17690; 
            monex1 = monex1 *17692; 
              iba_express1 = iba_express1 *17693; 
                   xezri1 = xezri1 *17694; 
            
            String gelir_koc  = "";   
     String CountrySql_k = "";
        String CountrySql_d = "";
              if (!country.equals("0")){
         CountrySql_k  = " and  to_char(RECIPIENT_COUNTRY)  = '"+country+"'  ";
        CountrySql_d  = " and  to_char(Sender_COUNTRY)  = '"+country+"'  ";
              }
                String RECIPIENTSQL = "";
                 if (sender!=null){
          //        System.out.println("xcv")  ; 
               RECIPIENTSQL = " and lower(RECIPIENT_NAME)  like    lower('%"+sender+"%')  ";
                }
    if (report.equals("2"))  {
       
      
        
          String Text = "  SELECT  * FROM sql_select  where id =  360";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(3);
           gelir_koc =    clob.getSubString(1, (int) clob.length());
          
         gelir_koc=    gelir_koc.replaceAll("wunion", "'"+wunion1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("cmt", "'"+cmt1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("korona", "'"+korona1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("contact", "'"+contact1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("lider", "'"+lider1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("monex", "'"+monex1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("iba_express", "'"+iba_express1+ "'" );
           gelir_koc=    gelir_koc.replaceAll("xezri", "'"+xezri1+ "'" );
         gelir_koc=    gelir_koc.replaceAll("azn", azn);
        gelir_koc=    gelir_koc.replaceAll("eur", eur );
        gelir_koc=    gelir_koc.replaceAll("usd", usd );
        gelir_koc=    gelir_koc.replaceAll("gbp", gbp );
        gelir_koc=    gelir_koc.replaceAll("rub", rub );
        gelir_koc=    gelir_koc.replaceAll("jpy", jpy);
         gelir_koc=    gelir_koc.replaceAll("chf", chf );
         gelir_koc=     gelir_koc.replaceAll("TarixB", TarixB);
         gelir_koc=      gelir_koc.replaceAll("TarixE", TarixE);
         gelir_koc=    gelir_koc.replaceAll("TarixSQL", TarixSQL);
         gelir_koc=   gelir_koc.replaceAll("FİLSQL", FİLSQL);
         gelir_koc=   gelir_koc.replaceAll("GEL.GELIR  is not null", "GEL.GELIR  is null");
        
         //  System.out.println("gelir_koc   "  +gelir_koc);
       }
      
       else  {
        
        
          String Text = "  SELECT  * FROM sql_select  where id =  360 ";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(4);
           gelir_koc =    clob.getSubString(1, (int) clob.length());
         
         gelir_koc=    gelir_koc.replaceAll("wunion", "'"+wunion1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("cmt", "'"+cmt1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("korona", "'"+korona1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("contact", "'"+contact1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("lider", "'"+lider1+ "'" );
        gelir_koc=    gelir_koc.replaceAll("monex", "'"+monex1+ "'" );
          gelir_koc=    gelir_koc.replaceAll("iba_express", "'"+iba_express1+ "'" );
            gelir_koc=    gelir_koc.replaceAll("xezri", "'"+xezri1+ "'" );
         gelir_koc=    gelir_koc.replaceAll("azn", azn);
        gelir_koc=    gelir_koc.replaceAll("eur", eur );
        gelir_koc=    gelir_koc.replaceAll("usd", usd );
        gelir_koc=    gelir_koc.replaceAll("gbp", gbp );
        gelir_koc=    gelir_koc.replaceAll("rub", rub );
        gelir_koc=    gelir_koc.replaceAll("jpy", jpy);
         gelir_koc=    gelir_koc.replaceAll("chf", chf );
         gelir_koc=     gelir_koc.replaceAll("TarixB", TarixB);
         gelir_koc=      gelir_koc.replaceAll("TarixE", TarixE);
         gelir_koc=    gelir_koc.replaceAll("TarixSQL", TarixSQL);
         gelir_koc=   gelir_koc.replaceAll("FİLSQL", FİLSQL);
          gelir_koc=   gelir_koc.replaceAll("GEL.GELIR  is not null", "GEL.GELIR  is null");
           gelir_koc=    gelir_koc.replaceAll("CountrySql_k", CountrySql_k);
            gelir_koc=    gelir_koc.replaceAll("RECIPIENTSQL", RECIPIENTSQL);
    //    System.out.println("gelir_koc   no  "  +gelir_koc);
    
        
    }
              
       wunion1 = Integer.parseInt(request.getParameter("wunion"));
    cmt1 = Integer.parseInt(request.getParameter("cmt"));
     korona1 = Integer.parseInt(request.getParameter("korona"));
        contact1 = Integer.parseInt(request.getParameter("contact"));
       lider1 = Integer.parseInt(request.getParameter("lider"));
     monex1 = Integer.parseInt(request.getParameter("monex"));
       iba_express1 = Integer.parseInt(request.getParameter("iba_express"));
      xezri1 = Integer.parseInt(request.getParameter("xezri"));
      
        wunion1 = wunion1 *12689;
        cmt1 = cmt1 *12691;   
         korona1 = korona1 *12693; 
          contact1 = contact1 *12694; 
           lider1 = lider1 *12695; 
            monex1 = monex1 *12696;
              iba_express1 = iba_express1 *12697;
                  xezri1 = xezri1 *12698;
             TarixSQL  = "  and TR.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd') "
                     + " and PAY.act_date   between   to_date('"+TarixB+"', 'yyyy-mm-dd')   and    to_date( '"+TarixE+"' , 'yyyy-mm-dd')  ";

             
        String gelir_od  ="";     
              String  senderSQL = "";
                 if (sender!=null){
                senderSQL = " and lower(sender_NAME)  like    lower('%"+sender+"%')  ";
                }
    if (report.equals("2"))  {
             
             
                String Text = "  SELECT  * FROM sql_select  where id =  360";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(5);
           gelir_od =    clob.getSubString(1, (int) clob.length());
         
         gelir_od=    gelir_od.replaceAll("wunion", "'"+wunion1+ "'" );
        gelir_od=    gelir_od.replaceAll("cmt", "'"+cmt1+ "'" );
        gelir_od=    gelir_od.replaceAll("korona", "'"+korona1+ "'" );
        gelir_od=    gelir_od.replaceAll("contact", "'"+contact1+ "'" );
        gelir_od=    gelir_od.replaceAll("lider", "'"+lider1+ "'" );
        gelir_od=    gelir_od.replaceAll("monex", "'"+monex1+ "'" );
           gelir_od=    gelir_od.replaceAll("iba_express", "'"+iba_express1+ "'" );
              gelir_od=    gelir_od.replaceAll("xezri", "'"+xezri1+ "'" );
         gelir_od=    gelir_od.replaceAll("azn", azn);
        gelir_od=    gelir_od.replaceAll("eur", eur );
        gelir_od=    gelir_od.replaceAll("usd", usd );
        gelir_od=    gelir_od.replaceAll("gbp", gbp );
        gelir_od=    gelir_od.replaceAll("rub", rub );
        gelir_od=    gelir_od.replaceAll("jpy", jpy);
         gelir_od=    gelir_od.replaceAll("chf", chf );
         gelir_od=     gelir_od.replaceAll("TarixB", TarixB);
         gelir_od=      gelir_od.replaceAll("TarixE", TarixE);
         gelir_od=    gelir_od.replaceAll("TarixSQL", TarixSQL);
         gelir_od=   gelir_od.replaceAll("FİLSQL", FİLSQL);
          gelir_od=   gelir_od.replaceAll("GEL.GELIR  is not null", "GEL.GELIR  is null");
        
     //  System.out.println("gelir_od   "  +gelir_od);
  
    }
    
    else  {
    
         String Text = "  SELECT  * FROM sql_select  where id =  360 ";
  st = conn.createStatement();
            rs = st.executeQuery(Text);
            rs.next();
        java.sql.Clob clob = (java.sql.Clob) rs.getClob(6);
           gelir_od =    clob.getSubString(1, (int) clob.length());
         
         gelir_od=    gelir_od.replaceAll("wunion", "'"+wunion1+ "'" );
        gelir_od=    gelir_od.replaceAll("cmt", "'"+cmt1+ "'" );
        gelir_od=    gelir_od.replaceAll("korona", "'"+korona1+ "'" );
        gelir_od=    gelir_od.replaceAll("contact", "'"+contact1+ "'" );
        gelir_od=    gelir_od.replaceAll("lider", "'"+lider1+ "'" );
        gelir_od=    gelir_od.replaceAll("monex", "'"+monex1+ "'" );
          gelir_od=    gelir_od.replaceAll("iba_express", "'"+iba_express1+ "'" );
             gelir_od=    gelir_od.replaceAll("xezri", "'"+xezri1+ "'" );
         gelir_od=    gelir_od.replaceAll("azn", azn);
        gelir_od=    gelir_od.replaceAll("eur", eur );
        gelir_od=    gelir_od.replaceAll("usd", usd );
        gelir_od=    gelir_od.replaceAll("gbp", gbp );
        gelir_od=    gelir_od.replaceAll("rub", rub );
        gelir_od=    gelir_od.replaceAll("jpy", jpy);
         gelir_od=    gelir_od.replaceAll("chf", chf );
         gelir_od=     gelir_od.replaceAll("TarixB", TarixB);
         gelir_od=      gelir_od.replaceAll("TarixE", TarixE);
         gelir_od=    gelir_od.replaceAll("TarixSQL", TarixSQL);
         gelir_od=   gelir_od.replaceAll("FİLSQL", FİLSQL);
          gelir_od=   gelir_od.replaceAll("GEL.GELIR  is not null", "GEL.GELIR  is null");
            gelir_od=   gelir_od.replaceAll("CountrySql_d", CountrySql_d);
              gelir_od=   gelir_od.replaceAll("senderSQL", senderSQL);
            
     //  System.out.println("gelir_od   "  +gelir_od); 
    
    }
          
      
         if (  type.equals("1") && type1.equals("1")  ) {
         
           gelir_no  = gelir_koc  +  " union all "  +  gelir_od;
         }
      if (  type.equals("1") && !type1.equals("1")  )  {
         
          gelir_no  = gelir_koc;
         }
           if (  !type.equals("1") && type1.equals("1")  )  {
         
             gelir_no  = gelir_od;
         }
            gelir_no = gelir_no + " order by 1,6 ";
  //System.out.println("gelir_NO  "  +gelir_no); 

    
        
  
     
 }
    String gelir = "";
    if (rep.equals("1") && rep1.equals("2") ) {
    gelir_yes = gelir_yes = gelir_yes.replaceFirst("order by 1,6", "");    
      gelir  = gelir_yes +  " union all " + gelir_no;
    //   System.out.println("gelir  " + gelir);
       stmt = conn.createStatement();
          sqlres = stmt.executeQuery(gelir);  }
    
    
    else   if (rep.equals("1") ) {
      stmt = conn.createStatement();
    //   System.out.println("gelir_yes  " + gelir_yes);
        sqlres = stmt.executeQuery(gelir_yes);}
    
     else   if (rep1.equals("2") ) {
      stmt = conn.createStatement();
       //  System.out.println("gelir_no  " + gelir_no);
          sqlres = stmt.executeQuery(gelir_no);
     }
    session.setAttribute("sqlres", sqlres); 
        %>

        <jsp:include page="main.jsp" />

        <table  border='0' width="100%" cellspacing="1">

            <tr>
                <td align="right"  >
                    <p>
                        <%
                            out.println(dict.ftSign());
                            sqlres.close();
                            stmt.close();
                            rs.close();
                            st.close();
                            conn.close();

                        %>
                    </p>
                </td></tr>
        </table>
    </body>
</html>
