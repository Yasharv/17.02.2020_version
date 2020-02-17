<%-- 
    Document   : page
    Created on : Feb 21, 2017, 10:16:34 AM
    Author     : x.dashdamirov
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.sun.jersey.api.client.ClientResponse"%>
<%@page import="com.sun.jersey.api.client.WebResource"%>
<%@page import="com.sun.jersey.api.client.filter.HTTPBasicAuthFilter"%>
<%@page import="com.sun.jersey.api.client.Client"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><HTML 
    xmlns="http://www.w3.org/1999/xhtml"><HEAD><META content="IE=11.0000" 
                       http-equiv="X-UA-Compatible">
            <TITLE>Borrower Report</TITLE>         
            <META http-equiv="Content-Type" content="text/html; charset=utf-8">
                <STYLE>

                    @media screen
                    {
                        p.commandBar {}
                    }
                    @media print
                    {
                        p.commandBar {display: none}
                    }

                    fieldset { border:1px solid #d7ebf9 }

                    legend {
                        padding: 0.2em 0.5em;
                        border: #d7ebf9;
                        color:#0099CC;
                        font-size:90%;
                        text-align:right;
                    }
                    table.tab1 {
                        border:1px solid black;
                    }
                    table.tab1 td{
                        border-right:1px solid black;
                        border-bottom:1px solid black;
                        border-color :#d7ebf9;
                        padding:3px;
                    }

                    table.tab1 th{
                        border-right:1px solid black;
                        border-bottom:1px solid black;
                        border-color :#d7ebf9;
                        padding:3px;
                    }

                    table.mop td,th{
                        border:1px solid #d7ebf9;
                    }
                </STYLE>
           
                 
        
                <LINK href="https://accr.fmsa.az/rfRes/skinning.ecss.risk?db=eAHzX7!yOgAFdgJ!" 
                      rel="stylesheet" type="text/css">
                    <META name="GENERATOR" content="MSHTML 11.00.9600.18538"></HEAD>

  
                        <BODY> 
  <%
      NumberFormat formatter = new DecimalFormat("###,###.##");
      
   
      
       class DB {
           
           

    public Connection connect() {
        Connection conn = null;
        try {        
            Class.forName("oracle.jdbc.driver.OracleDriver");
         Locale.setDefault(Locale.US);

            conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.235:1521:kit", "kit", "kit");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }
  

        return conn;
    }
     

}
        String res1 ="";
           String purpose = request.getParameter("purpose");
            String agreement ="0";
            agreement = request.getParameter("agreement");
//shexsiyyet
   String USER = request.getParameter("USER");   
      System.out.println("USER " + USER);
       String shex = request.getParameter("shex");
     System.out.println("purpose "+purpose);
     System.out.println("agreement "+agreement);
      String pincode = request.getParameter("pincode");
      System.out.println("pincode "+pincode);
         String doc_no = request.getParameter("doc_no");
         System.out.println("doc_no "+doc_no);
      if(shex!=null)  {
          //PURPOSE :Sorğunun məqsədi .
          //doc_no :Sənədin nömrəsi: 
          // pincode:pin kod
        res1 = "/service/central_api/inquiryByIdCard/"+purpose+"/"+doc_no+"/"+pincode+"/true/Merkez1/200026/vusal/1";
     //   System.out.println(res1);
      }
       //voen
        String persontype = request.getParameter("persontype");
         String voen = request.getParameter("voen");
         if(voen!=null)  {
             
             //PURPOSE :Sorğunun məqsədi .
          //voen :voen nömrəsi: 
         
         res1 = "/service/central_api/inquiryByTin/"+purpose+"/"+voen+"/true/Merkez1/200026/vusal/1";
      //  System.out.println(res1);
      }
        
          //vesiqe 
        String ves_type = request.getParameter("ves_type");
         String nomer = request.getParameter("nomer");
          String birthdate = request.getParameter("birthdate");
     /*    if( birthdate !=null){
       birthdate = birthdate.replaceAll("/", "%2F");
         }  */
         if(nomer!=null)  {
             //ves_type:Seriya
         res1 = "/service/central_api/inquiryByOtherCertificates/"+purpose+"/"+nomer+"/"+birthdate+"/"+ves_type+"/true/Merkez1/200026/vusal/1";
       //   System.out.println("res1  VESIQE " + res1);
      }
         
         
          //passport
        String country = request.getParameter("country");
         String passp = request.getParameter("passp");
         
         if(passp!=null)  {
             //passp:Passport nömrəsi
         res1 = "/service/central_api/inquiryByInternIdCard/"+purpose+"/"+passp+"/"+country+"/true/Merkez1/200026/vusal/1";
     //  System.out.println(res1);
      }
         
       String go1 = request.getParameter("go1");
        String go = request.getParameter("go");
     
         
     // System.out.println(pincode);
  // System.out.println("go1  "  +go1);
     // System.out.println("purpose  "  +purpose);
     // System.out.println("agreement  "  +agreement);
    //   System.out.println("country  "  +country);
    //  System.out.println("passp  "  +passp);
      
      	//Əgər g01 fərqlidirsə null-dan yeni mkr sorğu
      if ( go1!=null  )  {
         // System.out.println("go1 "+go1);
      //  System.out.println("shex " + shex);
      
      Client client = Client.create();
client.addFilter(new HTTPBasicAuthFilter("emin", "emin"));
 String res = "";
 
 //System.out.println("voen "+voen);
 if(shex!=null)  {
          res = "http://192.168.0.236:8080/service/central_api/inquiryByIdCard/"+purpose+"/"+doc_no+"/"+pincode+"/true/Merkez1/200026/vusal/1";
           }
 if(voen!=null)  {
         res = "http://192.168.0.236:8080/service/central_api/inquiryByTin/"+purpose+"/"+voen+"/true/Merkez1/200026/vusal/1";
    // System.out.println("(Link request) "+res);
 }
 if(nomer!=null)  {
    //   res = "http://192.168.0.236:8080/service/central_api/inquiryByOtherCertificates/"+purpose+"/"+nomer+"/"+birthdate+"/"+ves_type+"/true/Merkez1/200026/vusal/0";
     res = "http://192.168.0.236:8080/service/central_api/inquiryByOtherCertificates?queryPurpose="+purpose+"&certificateCode="+nomer+"&birthDate="+birthdate+"&serialNumber="+ves_type+"&chbAgreement=true&initialOu=Merkez1&initialOuID=200026&initialUser=vusal&score=1";

      }
         
    if(passp!=null)  {
        
      res = "http://192.168.0.236:8080/service/central_api/inquiryByInternIdCard/"+purpose+"/"+passp+"/"+country+"/true/Merkez1/200026/vusal/1";
      }
  // System.out.println(res);	
WebResource webResource = client
     .resource(res);
  // .resource("http://192.168.0.236:8080/service/central_api/inquiryByOtherCertificates/001/0013337/08%2F02%2F1988/SQ/true/Merkez/200026/SecondInitialUser/1");
	  	  ClientResponse response1 = webResource.accept("application/json")
                   .get(ClientResponse.class);
                  String output = response1.getEntity(String.class);
                   System.out.println("voen "+voen);
                  System.out.println("(Link request) "+res);
                 System.out.println("Output json : voen "+res+"///////" + output);
             agreement  = "2";
      }
      //   agreement  = "2";
       String rep  = "";
      if(shex!=null) {
    rep = " select  REPORT_ID  from persons  per, PERSON_REPORTS  pr   where  "
           + "  per.id =pr.FK_PERSON  and REPORT_DATE =  (select  max(REPORT_DATE) from persons  per,"
           + " PERSON_REPORTS  pr   where fin = '"+pincode+"'  and per.id =pr.FK_PERSON ) "; 
     //  System.out.println("rep  " + rep);
      }
      
        if(voen!=null) {
    rep = " select  REPORT_ID  from persons  per, PERSON_REPORTS  pr   where  "
           + "  per.id =pr.FK_PERSON  and REPORT_DATE =  (select  max(REPORT_DATE) from persons  per,"
           + " PERSON_REPORTS  pr   where DOCUMENT_NO = '"+voen+"'  and per.id =pr.FK_PERSON ) "; 
     //   System.out.println("rep  " + rep);
      }
      
           if(nomer!=null)  {
         rep = " select  REPORT_ID  from persons  per, PERSON_REPORTS  pr   where  "
           + "  per.id =pr.FK_PERSON  and REPORT_DATE =  (select  max(REPORT_DATE) from persons  per,"
            + " PERSON_REPORTS  pr   where DOCUMENT_NO = '"+ves_type+nomer+"'  and per.id =pr.FK_PERSON ) "; 
   //   System.out.println("rep  " + rep);
      }
           
           if(passp!=null)  {
         rep = " select  REPORT_ID  from persons  per, PERSON_REPORTS  pr   where  "
           + "  per.id =pr.FK_PERSON  and REPORT_DATE =  (select  max(REPORT_DATE) from persons  per,"
            + " PERSON_REPORTS  pr   where DOCUMENT_NO = '"+passp+"'  and per.id =pr.FK_PERSON ) "; 
      //  System.out.println("rep  " + rep);
     
      }
         
            DB db = new DB();
       Connection conn = db.connect();
        Statement stmtB_1 = conn.createStatement();
      Statement stmtB = conn.createStatement();
      Statement stmt_2 = conn.createStatement();
      Statement stmt_3 = conn.createStatement();
          Statement stmt_3_z = conn.createStatement();
          Statement stmt_4= conn.createStatement();
          Statement stmt_5= conn.createStatement();
          Statement stmtrep = conn.createStatement();
          ResultSet sqlSelrep = stmtrep.executeQuery(rep);
        //    Statement stmt_6= connt.connect().createStatement();
          sqlSelrep.next(); 
         //   System.out.println("sqlSelrep.isFirst()  " + sqlSelrep.isFirst());
               String rep_id = "";
            if (sqlSelrep.isFirst()==false)  {
           %>
           <p  font size="6" >Bazada məlumat tapılmadı...</p>
         <%
            }
          
            else {
           rep_id = sqlSelrep.getString(1); 
              Statement stservice = conn.createStatement();
String  ins = "  insert into USER_REPORT(USER_ID,REP_ID,create_date)   values('" + USER + "','" + rep_id + "', sysdate )" ;
  // System.out.println("ins " + ins);
                stservice.execute(ins);
        
          
      String sql_1 = "  select p.name,  to_char(trunc(PR.REPORT_DATE),'dd/mm/yyyy' )  REPORT_DATE ,"
              + " nvl(to_char( TO_DATE (SUBSTR ( (  P.FILE_DATE), 1, 10), 'yyyy-mm-dd') ,  'dd/mm/yyyy'), ' ')  FILE_DATE, "
              + " nvl(P.DOCUMENT_NO, ' ') DOCUMENT_NO , nvl(P.REGISTERED_ADDRESS, ' ') REGISTERED_ADDRESS, nvl(P.PLACE_OF_BIRTH,' ') PLACE_OF_BIRTH , "
              + " nvl(P.DATE_OF_BIRTH, ' ' ) DATE_OF_BIRTH,"
              + " nvl( p.fin, ' ' ) fin,  nvl(count(st.id), 0 )  sorgu   from   kit.PERSON_REPORTS PR,  KIT.PERSONS   P,    ( SELECT * FROM KIT.INQUIRY_HISTORY  )"
              + " st where PR.REPORT_ID =   '" + rep_id + "'  AND PR.ID = P.ID  and   st.FK_PERSON(+) = pr.FK_PERSON   group by p.name,  "
              + "  PR.REPORT_DATE ,P.FILE_DATE,P.DOCUMENT_NO ,P.REGISTERED_ADDRESS, P.PLACE_OF_BIRTH, P.DATE_OF_BIRTH ,p.fin   ";
   // System.out.println("sql_1 " + sql_1);
      ResultSet sqlSelB = stmtB.executeQuery(sql_1);
      sqlSelB.next();

      String sql_2 = "    select   ROWNUM ID,  INQ_BANK_NAME , to_char(INQ_DATE,  'dd/mm/yyyy')  INQ_DATE , NAME_AZ  from KIT.PERSON_REPORTS pr, "
              + "  (select fk_person,  INQ_BANK_NAME ,  to_date(substr((INQ_DATE), 1,10),'yyyy-mm-dd' ) INQ_DATE, INQ_PURPOSE_CODE "
              + " from  KIT.INQUIRY_HISTORY   order by 3 desc  ) inq  , INQUIRY_PURPOSE  pur     where REPORT_ID = '" + rep_id + "' and "
              + " pr.fk_person = inq.fk_person  and pur.code = INQ_PURPOSE_CODE   ";
     // System.out.println("sql_2 " + sql_2);
      ResultSet Rsql_2 = stmt_2.executeQuery(sql_2);

      String sql_3 = "      select ROWNUM ID,   "
              + "  case  when CREDIT_TYPE= '003' "
              + " or CREDIT_TYPE = '002' "
              + " or CREDIT_TYPE = '005'  "
              + " then  LINE_AMMOUNT  else    "
              + " INITIAL_AMOUNT end  Kredit, "
              + "   OUTSTANDING_DEBT_MAIN    qaliq_mebleg,"
              + " OUTSTANDING_DEBT_INTEREST  faiz_mebleg ,"
              + " MONTHLY_PAYMENT_AMOUNT ayliq_odenish , "
              + " to_char( to_date(substr((GRANTED_ON), 1,10),'yyyy-mm-dd' ),"
              + "  'dd/mm/yyyy')  GRANTED_ON, to_char( to_date(substr((CONTRACT_DUE_ON), 1,10),'yyyy-mm-dd' ), "
              + " 'dd/mm/yyyy')  CONTRACT_DUE_ON, DAYS_MAIN_SUM_OVERDUE  es_borc_gec_gun "
              + " ,DAYS_INTEREST_OVERDUE faiz_borc_gec_gun , nvl(ct.description, ' ') description ,"
              + " nvl(COLLATERAL_MARKET_VALUE ,0) teminat_deyeri,"
              + "   nvl(COLLATERAL_ANY_INFO,' ')  tesviri, nvl(COLLATERAL_REGISTRY_AGENCY, ' ' ) qeydiyyat,"
              + "  nvl(to_char( to_date(substr((COLLATERAL_REGISTRY_DATE), 1,10),"
              + "'yyyy-mm-dd' ),  'dd/mm/yyyy') ,' ' )  qey_tarix,  "
              + " CASE WHEN ORG_TYPE ='001' AND  BANK_NAME ='XXX'  THEN BANK_NAME || '   Bank' "
                + "    WHEN ORG_TYPE <> '001' AND  BANK_NAME ='XXX'  THEN  BANK_NAME || '   BOKT' "
               + "ELSE  BANK_NAME  END  "
              + " BANK_NAME,"
              + " CURRENCY,  "
              + "  nvl(to_char( TO_DATE (SUBSTR ( (LAST_PAYMENT_DATE), 1, 10), 'yyyy-mm-dd') ,  'dd/mm/yyyy'), ' ')   son_odenish ,"
              + "  cp.description desc_p ,"
              + "    case"
              + "    when CREDIT_TYPE =3 then 'Kredit kartı' "
              + "   WHEN CREDIT_TYPE = 2 THEN 'Kredit xətti' "
              + "   WHEN CREDIT_TYPE = 5 THEN 'Overdraft xәtlәri'  "
              + "   else 'Kredit' end nov , "
              + "   pl.id pl_id "
              + " from PERSON_LOANS  pl, PERSON_REPORTS PR,  collateral_type  ct , credit_purpose cp   "
              + " where  PL.FK_PERSON = PR.FK_PERSON AND  PR.REPORT_ID = '" + rep_id + "'  and  pl.COLLATERAL_CODE = ct.id(+) "
              + "  and  pl.CREDIT_PURPOSE = cp.id(+)  "
              + "  and CREDIT_STATUS <> '001' ";
   //System.out.println("sql_3 " + sql_3);
      ResultSet Rsql_3 = stmt_3.executeQuery(sql_3);
      
        String sql_3_z = " SELECT   ROWNUM ID,    case when GUA_CREDIT_TYPE =3 then 'Kredit kartı'"
+ " WHEN GUA_CREDIT_TYPE = 2 THEN 'Kredit xətti'  "
                + " else 'Kredit' end nov   , "
                + " case  when GUA_CREDIT_TYPE= '003'  or  GUA_CREDIT_TYPE= '002'  then  GUA_LINE_AMMOUNT  else  "
                + " GUA_INITIAL_AMMOUNT end  Kredit,    GUA_CURRENCY, "
                + " CASE WHEN GUA_ORG_TYPE ='001' AND  GUA_BANK_NAME ='XXX'  THEN GUA_BANK_NAME || '   Bank' "
                + "    WHEN GUA_ORG_TYPE <> '001' AND  GUA_BANK_NAME ='XXX'  THEN  GUA_BANK_NAME || '   BOKT' "
               + "ELSE  GUA_BANK_NAME  END  "
              + " GUA_BANK_NAME,"
                  + "GUA_OUTSTANDING_DEBT, GUA_INTEREST_AMOUNT,"
                + " GUA_MONTHLY_PAYMENT_AMOUNT,   to_char( to_date(substr((GUA_GRANTED_ON), 1,10),'yyyy-mm-dd' ),  'dd/mm/yyyy') "
                + " GUA_GRANTED_ON , cp.description desc_p,    to_char( to_date(substr((GUA_CONTRACT_DUE_ON), 1,10),'yyyy-mm-dd' ), "
                + " 'dd/mm/yyyy')  GUA_CONTRACT_DUE_ON      FROM KIT.GUARANTEE_HISTORY  GUR, PERSON_REPORTS PR  , credit_purpose cp   "
                + "      WHERE PR.REPORT_ID = '" + rep_id + "'   AND  GUR.FK_PERSON = PR.FK_PERSON   and  gur.GUA_CREDIT_PURPOSE = cp.id(+)   ";
      //System.out.println("sql_3_z " + sql_3_z);
      ResultSet Rsql_3_z = stmt_3_z.executeQuery(sql_3_z);
      
       String sql_4 = "      select ROWNUM ID,     case  when (CREDIT_TYPE= '003' or CREDIT_TYPE= '002' )  then  LINE_AMMOUNT "
               + " else   INITIAL_AMOUNT end  Kredit, "
              + "   OUTSTANDING_DEBT_MAIN    qaliq_mebleg, OUTSTANDING_DEBT_INTEREST  faiz_mebleg ,"
              + " MONTHLY_PAYMENT_AMOUNT ayliq_odenish , to_char( to_date(substr((GRANTED_ON), 1,10),'yyyy-mm-dd' ),"
              + "  'dd/mm/yyyy')  GRANTED_ON, to_char( to_date(substr((CONTRACT_DUE_ON), 1,10),'yyyy-mm-dd' ), "
              + " 'dd/mm/yyyy')  CONTRACT_DUE_ON, DAYS_MAIN_SUM_OVERDUE  es_borc_gec_gun "
              + " ,DAYS_INTEREST_OVERDUE faiz_borc_gec_gun , ct.description , COLLATERAL_MARKET_VALUE teminat_deyeri,"
              + " COLLATERAL_ANY_INFO tesviri, nvl(COLLATERAL_REGISTRY_AGENCY, ' ' ) qeydiyyat, nvl(to_char( to_date(substr((COLLATERAL_REGISTRY_DATE), 1,10),"
              + "'yyyy-mm-dd' ),  'dd/mm/yyyy'),' ' )   qey_tarix,  "
                + " CASE WHEN ORG_TYPE ='001' AND  BANK_NAME ='XXX'  THEN BANK_NAME || '   Bank' "
                + "    WHEN ORG_TYPE <> '001' AND  BANK_NAME ='XXX'  THEN  BANK_NAME || '   BOKT' "
               + "ELSE  BANK_NAME  END  "
              + " BANK_NAME,"
              +  "CURRENCY,  "
              + "   nvl(to_char( TO_DATE (SUBSTR ( (LAST_PAYMENT_DATE), 1, 10), 'yyyy-mm-dd') ,  'dd/mm/yyyy'), ' ' )  son_odenish , cp.description desc_p ,"
              + "    case when CREDIT_TYPE =3 then 'Kredit kartı' WHEN CREDIT_TYPE = 2 THEN 'Kredit xətti'   else 'Kredit' end nov ,   pl.id pl_id "
              + " from PERSON_LOANS  pl, PERSON_REPORTS PR,  collateral_type  ct , credit_purpose cp "
              + " where  PL.FK_PERSON = PR.FK_PERSON AND  PR.REPORT_ID = '" + rep_id + "'  and  pl.COLLATERAL_CODE = ct.id(+) "
              + "  and  pl.CREDIT_PURPOSE = cp.id(+)  "
              + "  and CREDIT_STATUS = '001' ";
     // System.out.println("sql_4 " + sql_4);
      ResultSet Rsql_4 = stmt_4.executeQuery(sql_4);
      
        String sql_5 = "    select   nvl(ROUND(sum(nvl(qaliq_mebleg,0)),2),0)  qaliq_mebleg , nvl(count(qaliq_mebleg),0)  say ,"
                + " nvl(ROUND( sum(nvl(qaliq_kredit,0)),2),0) qaliq_kredit , nvl(count(qaliq_kredit),0) kredit_say ,"
                + "  nvl(ROUND(sum(nvl(qaliq_xett,0)),2),0) qaliq_xett,"
                + " nvl(count(qaliq_xett),0) xett_say, nvl(ROUND(sum(nvl(qaliq_qarantiya,0)),2),0) qaliq_qarantiya, "
                + " nvl(count(qaliq_qarantiya),0)  qarantiya_say,  "
                + " nvl(ROUND(sum(nvl(ayliq_odenish,0)),2),0) ayliq_odenish ,  nvl(ROUND( sum(nvl(kredit,0)),2),0) kredit ,  "
                + " nvl(count(kredit),0) kr_say , nvl(max(nvl(U_tesh_say_aktiv,0)),0) U_tesh_say_aktiv ,"
                + " nvl(max(nvl(kr_tesh_say_aktiv,0)),0) kr_tesh_say_aktiv , "
                + " nvl(max(nvl(kr_xett_tesh_say_aktiv,0)),0) kr_xett_tesh_say_aktiv , nvl( max(nvl(qar_tesh_say_aktiv,0)),0) qar_tesh_say_aktiv ,  "
                + " nvl(max(U_tesh_say_bagli),0) U_tesh_say_bagli , nvl(max(round(sum_zamin,2)),0) sum_zamin , nvl(max(count_zamin),0) count_zamin ,"
                + "  nvl(max(GUA_BANK_ID),0)  GUA_BANK_ID     "
                + "  from ( SELECT ROWNUM ID, "
                + "  CASE    when   ( CREDIT_TYPE = '003'  or CREDIT_TYPE= '002' )  AND CREDIT_STATUS = '001'   AND  PL.CURRENCY <> 'AZN'"
                + " THEN LINE_AMMOUNT * RATE    "
                + "  WHEN   ( CREDIT_TYPE = '003'  or CREDIT_TYPE= '002' )   AND CREDIT_STATUS = '001'   THEN LINE_AMMOUNT  "
                + "      when CREDIT_STATUS = '001' "
                + " and  (  CREDIT_TYPE = '001' or  CREDIT_TYPE = '004' )  AND  PL.CURRENCY <> 'AZN'  then  "
                + " INITIAL_AMOUNT*RATE        when CREDIT_STATUS = '001'  and  (  CREDIT_TYPE = '001' "
                + " or CREDIT_TYPE = '004' )  then   INITIAL_AMOUNT    END     Kredit, "
                + "  CASE   when (CREDIT_TYPE = '003' or CREDIT_TYPE= '002' )   "
                + "AND CREDIT_STATUS <> '001'  AND  PL.CURRENCY <> 'AZN' THEN OUTSTANDING_DEBT_MAIN * RATE     WHEN   "
                + " (CREDIT_TYPE = '003' or CREDIT_TYPE= '002' )   AND CREDIT_STATUS <> '001'  THEN OUTSTANDING_DEBT_MAIN    end   qaliq_xett,     "
                + "CASE when   CREDIT_TYPE = '001'   AND CREDIT_STATUS <> '001'  AND  PL.CURRENCY <> 'AZN'"
                + " THEN OUTSTANDING_DEBT_MAIN * RATE   WHEN   CREDIT_TYPE = '001'   AND CREDIT_STATUS <> '001'  "
                + " THEN OUTSTANDING_DEBT_MAIN      END   qaliq_kredit,   CASE       when   CREDIT_TYPE = '004'  "
                + " AND CREDIT_STATUS <> '001'  AND  PL.CURRENCY <> 'AZN' THEN OUTSTANDING_DEBT_MAIN * RATE    "
                + "  WHEN   CREDIT_TYPE = '004'   AND CREDIT_STATUS <> '001'  THEN OUTSTANDING_DEBT_MAIN         "
                + "    END   qaliq_qarantiya,    case  when    CREDIT_STATUS <> '001'  AND  PL.CURRENCY <> 'AZN'"
                + " THEN OUTSTANDING_DEBT_MAIN * RATE  WHEN     CREDIT_STATUS <> '001' THEN OUTSTANDING_DEBT_MAIN   "
                + " end qaliq_mebleg,  case when    CREDIT_STATUS <> '001'  AND  PL.CURRENCY <> 'AZN' THEN MONTHLY_PAYMENT_AMOUNT * RATE "
                + " WHEN     CREDIT_STATUS <> '001' THEN MONTHLY_PAYMENT_AMOUNT    end ayliq_odenish, "
                + "      ( select count ( distinct ( BANK_ID ) )  from PERSON_LOANS  pl ,   PERSON_REPORTS PR   "
                + "     where   PL.FK_PERSON = PR.FK_PERSON      AND PR.REPORT_ID =  '" + rep_id + "'  "
                + "   and     CREDIT_STATUS <> '001' ) U_tesh_say_aktiv  ,   "
                + "          ( select count ( distinct ( BANK_ID ) )  from PERSON_LOANS  pl ,   PERSON_REPORTS PR  "
                + " where   PL.FK_PERSON = PR.FK_PERSON      AND PR.REPORT_ID = '" + rep_id + "'     and     CREDIT_STATUS <> '001' "
                + " and credit_type = 1 ) kr_tesh_say_aktiv ,  "
                 + "          ( select count ( distinct ( BANK_ID ) )  from PERSON_LOANS  pl ,   PERSON_REPORTS PR  "
                + " where   PL.FK_PERSON = PR.FK_PERSON      AND PR.REPORT_ID = '" + rep_id + "'     and     CREDIT_STATUS <> '001' "
                + "     AND (credit_type = 2 or credit_type = 3 ) ) kr_xett_tesh_say_aktiv ,  "
                   + "          ( select count ( distinct ( BANK_ID ) )  from PERSON_LOANS  pl ,   PERSON_REPORTS PR  "
                + " where   PL.FK_PERSON = PR.FK_PERSON      AND PR.REPORT_ID = '" + rep_id + "'    and    CREDIT_STATUS <> '001' "
                + "     AND (credit_type = 4 ) ) qar_tesh_say_aktiv ,  "
                + " ( select count ( distinct ( BANK_ID ) ) "
                + " from PERSON_LOANS  pl ,   PERSON_REPORTS PR    where   PL.FK_PERSON = PR.FK_PERSON       AND PR.REPORT_ID = '" + rep_id + "'   "
                + "     and     CREDIT_STATUS = '001' ) U_tesh_say_bagli ,"
                + "        (   SELECT  sum(GUA_OUTSTANDING_DEBT)  FROM (   select   CASE     WHEN GUA_CURRENCY <> 'AZN'    THEN  "
                + "   GUA_OUTSTANDING_DEBT* curr.rate     ELSE      GUA_OUTSTANDING_DEBT    END  GUA_OUTSTANDING_DEBT, FK_PERSON "
                + " from  GUARANTEE_HISTORY a   ,      (SELECT CODE, RATE   FROM KIT.CURRENCY  WHERE (ID, CODE) "
                + "  IN ( select  MAX(ID) , CODE    from CURRENCY  GROUP BY CODE      )   ) CURR "
                + " where a.GUA_CURRENCY = curr.code(+)   )  pl, PERSON_REPORTS PR       WHERE PL.FK_PERSON = PR.FK_PERSON   "
                + "  AND PR.REPORT_ID = '" + rep_id + "'   )    sum_zamin, "
                    + "   ( SELECT  count(*)    FROM GUARANTEE_HISTORY pl, PERSON_REPORTS PR  WHERE  "
                + "   PL.FK_PERSON = PR.FK_PERSON     AND PR.REPORT_ID = '" + rep_id + "'   ) count_zamin ,  "
                    + "   ( SELECT  count(distinct (GUA_BANK_ID) )    FROM GUARANTEE_HISTORY pl, PERSON_REPORTS PR  WHERE  "
                + "   PL.FK_PERSON = PR.FK_PERSON     AND PR.REPORT_ID = '" + rep_id + "'   ) GUA_BANK_ID   "
                + "  FROM PERSON_LOANS pl, "
                + "   PERSON_REPORTS PR,  collateral_type ct,  credit_purpose cp,   "
                + "  (    "
                + "   select  CODE,RATE   from KIT.CURRENCY               WHERE (ID, CODE)  IN   "
                + " (  select  MAX(ID) , CODE    from CURRENCY  GROUP BY CODE       ))  CURR  "
                + " WHERE   "
                + "  PL.FK_PERSON(+) = PR.FK_PERSON  AND PR.REPORT_ID = '" + rep_id + "'    AND pl.COLLATERAL_CODE = ct.id(+)  "
                + "  AND pl.CREDIT_PURPOSE = cp.id(+)       AND pl.CURRENCY = cURR.CODE(+)  ) ";
   // System.out.println("sql_5 " + sql_5);
      ResultSet Rsql_5 = stmt_5.executeQuery(sql_5);
      
       
      
      Rsql_5.next();

  %>
  
   <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 10mm 10mm 10mm 10mm;  /* this affects the margin in the printer settings */
            }

            .NonPrintable
            {
            
            }
        </style> 
<INPUT style= "float :right;margin: 10px 20px 0px 0px;"  TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable">
    <%  if( agreement.equals("2")  ) {
     String sql_1_1 = "  select  replace ( replace ( initcap( p.name) ,  'Oğlu' , 'oğlu' ),  'Qizi' , ' qızı'  ) name , "
             + " to_char(trunc(PR.REPORT_DATE),'dd/mm/yyyy' )  REPORT_DATE ,"
              + " nvl(to_char( TO_DATE (SUBSTR ( (  P.FILE_DATE), 1, 10), 'yyyy-mm-dd') ,  'dd/mm/yyyy'), ' ')  FILE_DATE, "
              + " P.DOCUMENT_NO ,P.REGISTERED_ADDRESS, P.PLACE_OF_BIRTH, P.DATE_OF_BIRTH ,"
              + "p.fin,  count(st.id) sorgu   from   kit.PERSON_REPORTS PR,  KIT.PERSONS   P,    ( SELECT * FROM KIT.INQUIRY_HISTORY  )"
              + " st where PR.REPORT_ID =   '" + rep_id + "'  AND PR.ID = P.ID  and   st.FK_PERSON(+) = pr.FK_PERSON   group by p.name,  "
              + "  PR.REPORT_DATE ,P.FILE_DATE,P.DOCUMENT_NO ,P.REGISTERED_ADDRESS, P.PLACE_OF_BIRTH, P.DATE_OF_BIRTH ,p.fin   ";
     //     System.out.println("sql_1 " + sql_1);
      ResultSet sqlSelB1 = stmtB_1.executeQuery(sql_1_1);
      sqlSelB1.next();

    
    %>    
<body lang=AZ-LATIN>

<div class=WordSection1>

<p class=MsoNormal align=center style='text-align:center;text-autospace:none'><b><span
style='font-size:14.0pt;color:black'>&nbsp;</span></b></p>

<p class=MsoNormal align=center style='text-align:center;text-autospace:none'><b><span
style='font-size:14.0pt;color:black'>Kredit m&#601;lumatlar&#305;n&#305;n
al&#305;nmas&#305;na dair </span></b></p>

<p class=MsoNormal align=center style='text-align:center;text-autospace:none'><b><span
style='font-size:14.0pt;color:black'>Raz&#305;l&#305;q &#601;riz&#601;si</span></b></p>

<p class=MsoNormal align=center style='text-align:center;text-autospace:none'><b><span
style='color:black'>&nbsp;</span></b></p>

<p class=MsoNormal align=center style='text-align:center;text-autospace:none'><b><span
style='color:black'>&nbsp;</span></b></p>

<p class=MsoNormal style='text-autospace:none'><span style='color:black'>Tarix:
    <%=sqlSelB1.getString(2)%></span></p>
<% if (persontype == null) {   %>
<p class=MsoNormal style='text-autospace:none'><span style='color:black'>&nbsp;</span></p>


<p class=MsoNormal style='text-autospace:none'>
    <span style='color:black'>Sorğu olunan:   <%=sqlSelB1.getString(1)%> </span></p>

<p class=MsoNormal style='text-autospace:none'><span style='color:black'>Sənədin nömrəsi: 
    </span>  <span
style='color:black'> <%=sqlSelB1.getString(4)%> </span></p>


<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal align=right style='margin-left:288.0pt;text-align:right;
text-autospace:none'><span style='color:black'>   imza: ____________________</span></p>
<br>
    <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
M.Y.

<p class=MsoNormal style='text-autospace:none'><b><span style='color:black'>&nbsp;</span></b></p>
<% }  %>
<% if (persontype != null) {   %>
<p class=MsoNormal style='text-autospace:none'><b><u><span style='color:black'>Hüquqi
&#351;&#601;xs</span></u></b><b><span style='color:black'>:</span></b></p>

<p class=MsoNormal style='text-autospace:none'><span style='color:black'>ad&#305;
: <%=sqlSelB1.getString(1)%> </span></p>

<p class=MsoNormal style='text-autospace:none'><span style='color:black'>VÖEN-i 
 <%=sqlSelB1.getString(4)%>  </span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal style='text-autospace:none'><span style='color:black'>s&#601;lahiyy&#601;tli
&#351;&#601;xsin ad&#305;, soyad&#305;, atas&#305;n&#305;n ad&#305;: ________________________________</span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal style='line-height:50%;text-autospace:none'><span
style='line-height:50%;color:black'>&nbsp;</span></p>

<p class=MsoNormal align=right style='margin-left:288.0pt;text-align:right;
text-autospace:none'><span style='color:black'>   imza: ____________________</span></p>

<p class=MsoNormal align=right style='margin-left:288.0pt;text-align:right;
text-autospace:none'><span style='color:black'>&nbsp;</span></p>

<p class=MsoNormal align=right style='margin-left:288.0pt;text-align:right;
text-autospace:none'><span style='color:black'>möhür yeri</span></p>
<%  } %>
<p class=MsoNormal style='text-autospace:none'><b><span style='color:black'>&nbsp;</span></b></p>

<p class=MsoNormal style='text-autospace:none'><b><span style='color:black'>&nbsp;</span></b></p>

<p class=MsoNormal style='text-align:justify;text-autospace:none'><span
style='color:black'>Öd&#601;ni&#351; qabiliyy&#601;tinin yoxlan&#305;lmas&#305;
üçün  M&#601;rk&#601;zl&#601;&#351;dirilmi&#351;
Kredit Reyestrind&#601;n haqq&#305;mda olan bütün m&#601;lumatlar&#305;n
al&#305;nmas&#305;na raz&#305;l&#305;q verir&#601;m.</span></p>

<p class=MsoNormal style='text-align:justify;text-autospace:none'><span
style='color:black'>&nbsp;</span></p>

<p class=MsoNormal style='text-autospace:none'><b><span style='color:black'>Raz&#305;l&#305;q
veril&#601;n bank:</span></b></p>

<p class=MsoNormal style='text-autospace:none'><span style='color:black'>ad&#305;:
<b>“Expressbank” ASC</b></span></p>

<p class=MsoNormal style='text-align:justify;text-autospace:none'><span
style='color:black'>Bu raz&#305;l&#305;q kredit al&#305;nd&#305;&#287;&#305;
halda yaranm&#305;&#351; öhd&#601;liy&#601; xitam veril&#601;n&#601;d&#601;k qüvv&#601;d&#601;dir
v&#601; geri götürülm&#601;y&#601;c&#601;kdir.</span></p>

<p class=MsoNormal style='text-align:justify;text-autospace:none'><span
style='color:black'>&nbsp;</span></p>

<p class=MsoNormal>&nbsp;</p>

</div>

</body>
<br>  <br><br><br><br><br><br><br><br> 
  <br><br><br><br><br><br><br><br><br><br>
  <br><br><br><br><br><br><br><br><br><br><br>
  <br>  <br><br><br><br><br><br><br><br> 
  <br><br><br><br><br><br><br><br><br><br>
  <br><br><br><br><br><br><br><br><br><br><br>
 <br>  <br><br><br><br><br><br><br><br> 
  <br><br><br><br><br><br><br><br><br><br>
  <br><br><br><br><br><br><br><br><br><br><br>
<%    sqlSelB1.close(); stmtB_1.close(); }   %>

   
  <FORM name="j_idt6" id="j_idt6" action="/borrower_inquiry/borrowerInqReport.risk" 
        enctype="application/x-www-form-urlencoded" 
        method="post"><INPUT name="j_idt6" type="hidden" value="j_idt6">             
         <DIV style="font-family: Arial,sans-serif; font-size: 12px;"><BR><STRONG style="color: rgb(0, 112, 163); font-size: x-large;">MƏRKƏZLƏŞDİRİLMİŞ 
                      KREDİT REYESTRİNDƏN ÇIXARIŞ</STRONG>                 <BR>
                      <TABLE>
                          <TBODY>
    <TR>
        <TD style="width: 360px; font-size: large; font-weight: bold; border-right-color: black; border-right-width: 1px; border-right-style: solid;" 
            rowspan="2"><%=sqlSelB.getString(1)%> </TD>
        <TD> Tərtib olunma tarixi: <%=sqlSelB.getString(2)%> </TD></TR>
    <TR>
        <TD nowrap="nowrap">Borcalan haqqında tarixçənin açıldığı tarix:           
            <%=sqlSelB.getString(3)%>                         </TD></TR></TBODY></TABLE><!-- ***************** Borcalan&#305;n &#351;&#601;xsi m&#601;lumatlar&#305; ***************************--> 

                      <P><STRONG style="color: rgb(0, 112, 163); font-size: large;">1. Borcalanın 
    şəxsi məlumatları</STRONG><BR></P>
                      <TABLE style="font-weight: bold;" frame="hsides">
                          <TBODY>
    <TR>
        <TD>Borcalanın İD-si:</TD>
        <TD><%=sqlSelB.getString(4)%> </TD></TR>
    <TR>
        <TD>Ünvanı:</TD>
        <TD><%=sqlSelB.getString(5)%> </TD></TR>
    <TR>
        <TD><SPAN style="font-weight: bold;">Doğum yeri:</SPAN></TD>
        <TD><%=sqlSelB.getString(6)%> </TD></TR>
    <TR>
        <TD>Doğum tarixi:</TD>
        <TD><%=sqlSelB.getString(7)%> </TD></TR></TBODY></TABLE><BR><!-- ***************** Kredit Melumatlarinin icmali ***************************--> 

                          <P><STRONG style="color: rgb(0, 112, 163); font-size: large;">2. Kredit 
        məlumatlarının icmalı <SPAN 
            style="font-size: medium; font-style: italic;">(manatla)</SPAN> 
    </STRONG><BR></P>
                          <TABLE width="705" class="tab1" border="0" cellspacing="0">
    <TBODY>
        <TR bgcolor="#d7ebf9">
            <TH>N</TH>
            <TH></TH>
            <TH>Məbləğ</TH>
            <TH>Kreditlərin sayı</TH>
            <TH>Kr.təşkilatlarının sayı</TH></TR>
        <TR>
            <TH>1.</TH>
            <TD><STRONG>Aktiv kreditlərin cəmi qalıq məbləği</STRONG><BR><SPAN style="font-style: italic;">(Kredit 
                        + kredit xət(lər)inin istifadə olunmuş hissəsi)</SPAN>                     
            </TD>
             <TD width="110" align="right" style="font-weight: bold;"><%=formatter.format(Rsql_5.getDouble("QALIQ_MEBLEG"))
                 %>             
            </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("say")%>                
            </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("U_tesh_say_aktiv")%>    </TD></TR>
        <TR>
            <TH style="font-weight: normal;">1.1</TH>
            <TD>Kreditlər üzrə qalıq məbləğ</TD>
            <TD width="110" align="right" style="font-weight: bold;"><%=  formatter.format(Rsql_5.getDouble("QALIQ_KREDIT"))%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("KREDIT_SAY")%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("kr_tesh_say_aktiv")%></TD></TR>
        <TR>
            <TH style="font-weight: normal;">1.2</TH>
            <TD>Kredit xətləri üzrə qalıq məbləğ</TD>
            <TD width="110" align="right" style="font-weight: bold;"><%=formatter.format(Rsql_5.getDouble("QALIQ_XETT"))%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("XETT_SAY")%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("kr_xett_tesh_say_aktiv")%></TD></TR>
        <TR>
            <TH style="font-weight: normal;">1.3</TH>
            <TD>Qarantiya üzrə qalıq məbləğ</TD>
            <TD width="110" align="right" style="font-weight: bold;"><%=formatter.format(Rsql_5.getDouble("QALIQ_QARANTIYA"))%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("QARANTIYA_SAY")%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("qar_tesh_say_aktiv")%> </TD></TR>
        <TR>
            <TH>2</TH>
            <TD><STRONG>Cəmi aylıq ödəniş məbləği</STRONG></TD>
            <TD width="110" align="right" style="font-weight: bold;"><%=formatter.format(Rsql_5.getDouble("AYLIQ_ODENISH"))%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("SAY")%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("U_tesh_say_aktiv")%> </TD></TR>
        <TR>
            <TH>3</TH>
            <TD><STRONG>Tam ödənilmiş kreditlərin cəmi məbləği</STRONG><BR><SPAN 
                        style="font-style: italic;">(Kredit + kredit xət(lər)inin istifadə olunmuş 
                        hissəsi)</SPAN>   </TD>
            <TD width="110" align="right" style="font-weight: bold;"><%=formatter.format(Rsql_5.getDouble("kredit"))%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("kr_say")%> </TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("U_tesh_say_bagli")%></TD></TR>
        <TR>
            <TH>4</TH>
            <TD><STRONG>Zamin olduğu öhdəliyin məbləği</STRONG></TD>
            <TD width="110" align="right" style="font-weight: bold;"><%=formatter.format(Rsql_5.getDouble("sum_zamin"))%></TD>
            <TD width="110" align="center" style="font-weight: bold;"><%=Rsql_5.getString("count_zamin")%></TD>
            <TD width="110" align="center" 
                style="font-weight: bold;"><%=Rsql_5.getString("GUA_BANK_ID")%></TD></TR></TBODY></TABLE>
                          <P><STRONG style="color: rgb(0, 112, 163); font-size: large;"><SPAN style="font-size: medium;">2.1</SPAN> 
        Borcalan haqqında <%=sqlSelB.getString(9)%> dəfə sorğu olunmuşdur.</STRONG>    

    <TABLE width="710" class="tab1" style="border-color: rgb(215, 235, 249);" 
           border="0" cellspacing="0">
        <TBODY>


            <TR bgcolor="#d7ebf9">
                <TH>N</TH>
                <TH>Bankın adı</TH>
                <TH>Tarix</TH>
                <TH>Məqsəd</TH></TR>
                    <%  while (Rsql_2.next()) {%>
            <TR>
                <TD> <%=Rsql_2.getString(1)%>. </TD>
                <TD><%=Rsql_2.getString(2)%>  </TD>
                <TD><%=Rsql_2.getString(3)%>   </TD>
                <TD><%=Rsql_2.getString(4)%></TD>
            </TR>
            <% } %>

        </TBODY></TABLE>
    <P></P><!-- Active Credits -->   
    <P><STRONG style="color: rgb(0, 112, 163); font-size: large;">3. Borcalanın 
            aktiv öhdəlikləri</STRONG><BR></P>
            <% while (Rsql_3.next()) {%>
    <STRONG style="padding: 2px; font-size: medium; background-color: rgb(215, 235, 249);"><SPAN 
            style="font-size: medium;">3.<%=Rsql_3.getString(1)%></SPAN> <%=Rsql_3.getString("nov")%> -         
        <%=formatter.format(Rsql_3.getDouble("Kredit"))%> &nbsp;&nbsp;   <%=Rsql_3.getString("CURRENCY")%>                
    </STRONG>                 
    <BR><BR>
            <TABLE width="710">
                <TBODY>
                    <TR>
                        <TD><SPAN style="font-weight: bold;">Məlumat təchizatçısı :</SPAN><SPAN 
     style="font-weight: bold;"><%=Rsql_3.getString("BANK_NAME")%></SPAN>      
                        </TD>
                        <TD><SPAN style="font-weight: bold;">Hesab nömrəsi:</SPAN><SPAN style="font-weight: bold;">XXXX</SPAN> 
                        </TD></TR></TBODY></TABLE>
            <TABLE width="710" style="border: 1px solid rgb(215, 235, 249); border-image: none;" 
                   cellspacing="0">
                <TBODY>
                    <TR style="height: 30px; font-size: medium; font-weight: bold;" bgcolor="#d7ebf9">
                        <TD width="240">Kreditin qalıq məbləği</TD>
                        <TD width="160"><SPAN style="font-weight: bold;"><%=formatter.format(Rsql_3.getDouble("qaliq_mebleg"))%></SPAN></TD>
                        <TD width="240">Faiz məbləği</TD>
                        <TD width="160"><SPAN style="width: 200px;"><%=formatter.format(Rsql_3.getDouble("FAIZ_MEBLEG"))%></SPAN></TD></TR>
                    <TR>
                        <TD width="240">Aylıq ödəniş məbləği</TD>
                        <TD width="140"><%=formatter.format(Rsql_3.getDouble("AYLIQ_ODENISH"))%></TD>
                        <TD width="240">Kreditin verilmə tarixi</TD>
                        <TD width="160"><%=Rsql_3.getString("GRANTED_ON")%></TD></TR>
                    <TR bgcolor="#d7ebf9">
                        <TD width="240">Sonuncu ödəniş tarixi</TD>
                        <TD width="160"><%=Rsql_3.getString("son_odenish")%></TD>
                        <TD width="280">Kreditin ilkin müqavilə ilə bitmə tarixi</TD>
                        <TD width="100"><%=Rsql_3.getString("CONTRACT_DUE_ON")%></TD></TR>
                    <TR>
                        <TD width="180">Məqsədi</TD>
                        <TD width="240"><%=Rsql_3.getString("desc_p")%></TD>
                        <TD width="280">Kreditin son müqavilə ilə bitmə tarixi</TD>
                        <TD width="100"><%=Rsql_3.getString("CONTRACT_DUE_ON")%></TD></TR>
                    <TR bgcolor="#d7ebf9">
                        <TD width="240">Əsas borcun gecikdirildiyi günlərin sayı</TD>
                        <TD width="160"><%=Rsql_3.getString("ES_BORC_GEC_GUN")%></TD>
                        <TD width="280">Faizlərin gecikdirildiyi günlərin sayı</TD>
                        <TD width="100"><%=Rsql_3.getString("FAIZ_BORC_GEC_GUN")%></TD></TR></TBODY></TABLE><BR>
                <FIELDSET title="Təminat" style="padding: 4px; width: 700px;"><LEGEND style="font-weight: bold;">Təminatı</LEGEND> 

                    <TABLE width="700">
                        <TBODY>
 <TR>
     <TD><SPAN style="font-weight: bold;">Növü: </SPAN><%=Rsql_3.getString("DESCRIPTION")%>                 
         &nbsp;&nbsp;&nbsp;                  
         <SPAN 
             style="font-weight: bold;">Dəyəri (manatla): </SPAN><%=Rsql_3.getString("TEMINAT_DEYERI")%>                   
     </TD></TR>
 <TR>
     <TD><SPAN style="font-weight: bold;">Predmeti və təsviri: 
         </SPAN><%=Rsql_3.getString("TESVIRI")%>                   
     </TD></TR>
 <TR>
     <TD><SPAN style="font-weight: bold;">Qeydiyyata almış orqan: </SPAN>       
         <%=Rsql_3.getString("QEYDIYYAT")%> </TD>
     <TD><SPAN style="font-weight: bold;">Tarixi: </SPAN><%=Rsql_3.getString("QEY_TARIX")%>                       
     </TD></TR></TBODY></TABLE></FIELDSET>
            <BR><!--MOP--> 
<%  
       Statement stmt_6= conn.createStatement();
       Statement stmt_7= conn.createStatement();
       Statement stmt_8= conn.createStatement();
        Statement stmt_6_check= conn.createStatement();
  String sql_6 = "   select OVERDUE_PERIOD, OVERDUE_DAYS , extract(month from tarix ) ay,  tarix, nvl(color, 'default')  color "
          + " from ( select * from date_xeyal where tarix between add_months(trunc(sysdate,'mm'),-23) and  (sysdate) )  dx,"
          + " (  select   to_date(OVERDUE_PERIOD, 'yyyy-mm-dd')  OVERDUE_PERIOD, OVERDUE_DAYS,  CASE WHEN OVERDUE_DAYS=0 THEN  "
          + "'blue'  WHEN OVERDUE_DAYS between 1 and 30 THEN  'yellow'  WHEN OVERDUE_DAYS between 31 and 90 THEN  'orange'  "
          + " WHEN OVERDUE_DAYS between 91 and 180 THEN  'orange_180'   WHEN OVERDUE_DAYS between 181 and 360 THEN  'red' "
          + "  WHEN OVERDUE_DAYS >  360 THEN  'red_360'  WHEN OVERDUE_DAYS is null then 'default' end color  "
          + " from KIT.LOAN_history where FK_PERSON_LIABILITY = '"+Rsql_3.getString("pl_id")+"'  )  his   where dx.tarix =  OVERDUE_PERIOD(+)  order by tarix desc  ";
    //  System.out.println("sql_6 " + sql_6);
        ResultSet Rsql_6= stmt_6.executeQuery(sql_6);
       String sql_6_check = "   select nvl(max(OVERDUE_DAYS) ,1000)  OVERDUE_DAYS "
          + " from ( select * from date_xeyal where tarix between add_months(trunc(sysdate,'mm'),-23) and  (sysdate) )  dx,"
          + " (  select   to_date(OVERDUE_PERIOD, 'yyyy-mm-dd')  OVERDUE_PERIOD, OVERDUE_DAYS,  CASE WHEN OVERDUE_DAYS=0 THEN  "
          + "'blue'  WHEN OVERDUE_DAYS between 1 and 30 THEN  'yellow'  WHEN OVERDUE_DAYS between 31 and 90 THEN  'orange'  "
          + " WHEN OVERDUE_DAYS between 91 and 180 THEN  'orange_180'   WHEN OVERDUE_DAYS between 181 and 360 THEN  'red' "
          + "  WHEN OVERDUE_DAYS >  360 THEN  'red_360'  WHEN OVERDUE_DAYS is null then 'default' end color  "
          + " from KIT.LOAN_history where FK_PERSON_LIABILITY = '"+Rsql_3.getString("pl_id")+"'  )  his   where dx.tarix =  OVERDUE_PERIOD(+)  order by tarix desc  ";
  //    System.out.println("sql_6_check " + sql_6_check);
      ResultSet Rsql_6_check = stmt_6_check.executeQuery(sql_6_check);

 String sql_7 = "    select yr, count(*) col  from ( select   extract(year from tarix) yr  from"
         + " ( select * from date_xeyal where tarix between add_months(trunc(sysdate,'mm'),-23)"
         + " and  (sysdate) )  dx, (  select   to_date(OVERDUE_PERIOD, 'yyyy-mm-dd')  OVERDUE_PERIOD, OVERDUE_DAYS "
         + "  from KIT.LOAN_history where FK_PERSON_LIABILITY = '"+Rsql_3.getString("pl_id")+"'  )  his "
         + " where dx.tarix =  OVERDUE_PERIOD(+) )  group by yr  order by 1 desc ";
   //   System.out.println("sql_7 " + sql_7);
      ResultSet Rsql_7 = stmt_7.executeQuery(sql_7); 
       ResultSet Rsql_8 = stmt_8.executeQuery(sql_6);
       
       Rsql_6_check.next();
      
%>  
  <%   if (Rsql_6_check.getString(1).equals("1000"))  {  %>
       <%  }  else  {%>  
                    <TABLE width="706" class="mop" cellspacing="0" cellpadding="3">
                        <TBODY>
 <TR bgcolor="#007799">
     <TH style="color: white;" colspan="25">          
         Öhdəlik üzrə son 24 aylıq tarixçə və ödəniş tərzi              
     </TH>
 </TR>
 <TR bgcolor="#0099cc">
    
     <TD bgcolor="#d7ebf9"></TD>
   
      <% while (Rsql_7.next()) {
     
      
      %>
     <TD  align="center" colspan="<%=Rsql_7.getInt("col")%>"> <%=Rsql_7.getString("yr")%>
     </TD>
       <% } Rsql_7.close();
            stmt_7.close();  %>
     </TR>
 <TR bgcolor="#d7ebf9">
     <TD>Aylar</TD>
       <% while (Rsql_6.next()) { %>
     <TD   align="center"  >  <%=Rsql_6.getString(3)%>          
     </TD>
    <% } 
    %>
     </TR>
 <TR bgcolor="#0099cc">
     <TD bgcolor="#d7ebf9">Tarixçə</TD>
        <% while (Rsql_8.next()) {
        if(Rsql_8.getString("color").equals("blue"))  {
        %>
    <TH style="background-color: rgb(0, 153, 204);"><LABEL> <%=Rsql_8.getString(2)%> </LABEL>           
     </TH>
     <% }    if(Rsql_8.getString("color").equals("yellow"))  {
        %>
    <TH style="background-color: yellow;"><LABEL><%=Rsql_8.getString(2)%> </LABEL>           
     </TH>
     <% } if(Rsql_8.getString("color").equals("orange"))  {
        %>
    <TH style="background-color: #FE9A2E;"><LABEL><%=Rsql_8.getString(2)%> </LABEL>           
     </TH>
     <% } if(Rsql_8.getString("color").equals("orange_180"))  {
        %>
    <TH style="background-color:#FE642E;"><LABEL><%=Rsql_8.getString(2)%> </LABEL>           
     </TH>
     <% }
     if(Rsql_8.getString("color").equals("red"))  {
        %>
    <TH style="background-color:#DF3A01;"><LABEL><%=Rsql_8.getString(2)%> </LABEL>           
     </TH>
     <% } 
     if(Rsql_8.getString("color").equals("red_360"))  {
        %>
    <TH style="background-color:#B40404;"><LABEL><%=Rsql_8.getString(2)%> </LABEL>           
     </TH>
     <% } 
      if(Rsql_8.getString("color").equals("default"))  {
        %>
    <TH style="background-color:rgb(153, 153, 153);"><LABEL></LABEL>           
     </TH>
     <% } 
     %> 
    <% }  Rsql_8.close();
          stmt_8.close();
           Rsql_6.close();
            Rsql_6_check.close();
          stmt_6.close();
           stmt_6_check.close();
             stmt_7.close();
           Rsql_7.close();
           
     
         
    %>
 </TR></TBODY></TABLE><BR><!--End MOP--> 
   <% }   }%>





                        <!-- Closed Credits -->   
                        <P><STRONG style="color: rgb(0, 112, 163); font-size: large;">4. Borcalanın 
     bağlanmış öhdəlikləri</STRONG>   </P>
                    <%  while (Rsql_4.next())  {  %>    
                        <STRONG style="padding: 2px; font-size: medium; background-color: rgb(215, 235, 249);"><SPAN 
     style="font-size: medium;">4.<%=Rsql_4.getString("id")%></SPAN> <%=Rsql_4.getString("NOV")%> -         
 <%=formatter.format(Rsql_4.getDouble("KREDIT"))%> &nbsp;&nbsp; <%=Rsql_4.getString("CURRENCY")%>  
 <%
 // System.out.println(" NOV "+Rsql_4.getString("NOV"));  
// System.out.println(" kredit name "+formatter.format(Rsql_4.getDouble("KREDIT")));
  // System.out.println(" currency "+Rsql_4.getString("CURRENCY"));  
 
 %>
                        </STRONG>       <BR><BR>
     <FIELDSET style="padding: 4px; width: 700px;">
         <TABLE width="710">
             <TBODY>
                 <TR>
                     <TD><SPAN style="font-weight: bold;">Məlumat təchizatçısı :</SPAN><SPAN 
   style="font-weight: bold;"><%=Rsql_4.getString("BANK_NAME")%></SPAN>       
                     </TD>
                     <TD><SPAN style="font-weight: bold;">Hesab nömrəsi:</SPAN><SPAN style="font-weight: bold;">XXXX</SPAN> 
                     </TD></TR></TBODY></TABLE>
         <TABLE width="710" style="border-color: rgb(102, 153, 255);" cellspacing="0">
             <TBODY>
                 <TR bgcolor="#d7ebf9">
                     <TD width="240">Aylıq ödəniş məbləği</TD>
                     <TD width="140">-</TD>
                     <TD width="240">Kreditin verilmə tarixi</TD>
                     <TD width="140"><%=Rsql_4.getString("GRANTED_ON")%></TD></TR>
                 <TR>
                     <TD width="240">Sonuncu ödəniş tarixi</TD>
                     <TD width="140"><%=Rsql_4.getString("SON_ODENISH")%></TD>
                     <TD width="280">Kreditin ilkin müqavilə ilə bitmə tarixi</TD>
                     <TD width="100"><%=Rsql_4.getString("CONTRACT_DUE_ON")%></TD></TR>
                 <TR bgcolor="#d7ebf9">
                     <TD width="180">Məqsədi</TD>
                     <TD width="240"><%=Rsql_4.getString("DESC_P")%></TD>
                     <TD width="280">Kreditin son müqavilə ilə bitmə tarixi</TD>
                     <TD width="100"><%=Rsql_4.getString("CONTRACT_DUE_ON")%></TD></TR>
                 <TR>
                     <TD width="240">Gecikmə günlərinin sayi</TD>
                     <TD width="160"><%=Rsql_4.getString("ES_BORC_GEC_GUN")%></TD>
                     <TD width="280"></TD>
                     <TD width="100"></TD></TR></TBODY></TABLE></FIELDSET><BR><!--MOP-->              

      
                 
                 <%  
   Statement stmt_61= conn.createStatement();
    Statement stmt_61_check= conn.createStatement();
       Statement stmt_71= conn.createStatement();
        Statement stmt_81= conn.createStatement();
  String sql_61 = "   select OVERDUE_PERIOD, OVERDUE_DAYS , extract(month from tarix ) ay,  tarix, nvl(color, 'default')  color "
          + " from ( select * from date_xeyal where tarix between add_months(trunc(sysdate,'mm'),-23) and  (sysdate) )  dx,"
          + " (  select   to_date(OVERDUE_PERIOD, 'yyyy-mm-dd')  OVERDUE_PERIOD, OVERDUE_DAYS,  CASE WHEN OVERDUE_DAYS=0 THEN  "
          + "'blue'  WHEN OVERDUE_DAYS between 1 and 30 THEN  'yellow'  WHEN OVERDUE_DAYS between 31 and 90 THEN  'orange'  "
          + " WHEN OVERDUE_DAYS between 91 and 180 THEN  'orange_180'   WHEN OVERDUE_DAYS between 181 and 360 THEN  'red' "
          + "  WHEN OVERDUE_DAYS >  360 THEN  'red_360'  WHEN OVERDUE_DAYS is null then 'default' end color  "
          + " from KIT.LOAN_history where FK_PERSON_LIABILITY = '"+Rsql_4.getString("pl_id")+"'  )  his   where dx.tarix =  OVERDUE_PERIOD(+)  order by tarix desc  ";
    //  System.out.println("sql_61 " + sql_61);
      ResultSet Rsql_61 = stmt_61.executeQuery(sql_61);
     
      String sql_61_check = "   select nvl(max(OVERDUE_DAYS) ,1000)  OVERDUE_DAYS "
           + " from ( select * from date_xeyal where tarix between add_months(trunc(sysdate,'mm'),-23) and  (sysdate) )  dx,"
          + " (  select   to_date(OVERDUE_PERIOD, 'yyyy-mm-dd')  OVERDUE_PERIOD, OVERDUE_DAYS,  CASE WHEN OVERDUE_DAYS=0 THEN  "
          + "'blue'  WHEN OVERDUE_DAYS between 1 and 30 THEN  'yellow'  WHEN OVERDUE_DAYS between 31 and 90 THEN  'orange'  "
          + " WHEN OVERDUE_DAYS between 91 and 180 THEN  'orange_180'   WHEN OVERDUE_DAYS between 181 and 360 THEN  'red' "
          + "  WHEN OVERDUE_DAYS >  360 THEN  'red_360'  WHEN OVERDUE_DAYS is null then 'default' end color  "
          + " from KIT.LOAN_history where FK_PERSON_LIABILITY = '"+Rsql_4.getString("pl_id")+"'  )  his   where dx.tarix =  OVERDUE_PERIOD(+)  order by tarix desc  ";
   //  System.out.println("sql_61_check " + sql_61_check);
      ResultSet Rsql_61_check = stmt_61_check.executeQuery(sql_61_check);

 String sql_71 = "    select yr, count(*) col  from ( select   extract(year from tarix) yr  from"
         + " ( select * from date_xeyal where tarix between add_months(trunc(sysdate,'mm'),-23)"
         + " and  (sysdate) )  dx, (  select   to_date(OVERDUE_PERIOD, 'yyyy-mm-dd')  OVERDUE_PERIOD, OVERDUE_DAYS "
         + "  from KIT.LOAN_history where FK_PERSON_LIABILITY = '"+Rsql_4.getString("pl_id")+"'  )  his "
         + " where dx.tarix =  OVERDUE_PERIOD(+) )  group by yr  order by 1 desc ";
    //  System.out.println("sql_71 " + sql_71);
      ResultSet Rsql_71 = stmt_71.executeQuery(sql_71); 
       ResultSet Rsql_81 = stmt_81.executeQuery(sql_61);
       Rsql_61_check.next();
%>
   <%   if (Rsql_61_check.getString(1).equals("1000"))  {  %>
       <%  }  else  {%>  
   <TABLE width="706" class="mop" cellspacing="0" cellpadding="3">
             <TBODY>
                 <TR bgcolor="#007799">
                     <TH style="color: white;" colspan="25">          
                         Öhdəlik üzrə son 24 aylıq tarixçə və ödəniş tərzi              
                     </TH></TR>
          <TR bgcolor="#0099cc">
    
     <TD bgcolor="#d7ebf9"></TD>
    
      <% while (Rsql_71.next()) {
     
      
      %>
     <TD  align="center" colspan="<%=Rsql_71.getInt("col")%>"> <%=Rsql_71.getString("yr")%>
     </TD>
       <% } %>
     </TR>
 <TR bgcolor="#d7ebf9">
     <TD>Aylar</TD>
      <% while (Rsql_61.next()) { %>
     <TD   align="center"  >  <%=Rsql_61.getString(3)%>          
     </TD>
    <% } %>
     </TR>
 <TR bgcolor="#0099cc">
     <TD bgcolor="#d7ebf9">Tarixçə</TD>
        <% while (Rsql_81.next()) {
        if(Rsql_81.getString("color").equals("blue"))  {
        %>
    <TH style="background-color: rgb(0, 153, 204);"><LABEL> <%=Rsql_81.getString(2)%> </LABEL>           
     </TH>
     <% }    if(Rsql_81.getString("color").equals("yellow"))  {
        %>
    <TH style="background-color: yellow;"><LABEL><%=Rsql_81.getString(2)%> </LABEL>           
     </TH>
     <% } if(Rsql_81.getString("color").equals("orange"))  {
        %>
    <TH style="background-color: #FE9A2E;"><LABEL><%=Rsql_81.getString(2)%> </LABEL>           
     </TH>
     <% } if(Rsql_81.getString("color").equals("orange_180"))  {
        %>
    <TH style="background-color:#FE642E;"><LABEL><%=Rsql_81.getString(2)%> </LABEL>           
     </TH>
     <% }
     if(Rsql_81.getString("color").equals("red"))  {
        %>
    <TH style="background-color:#DF3A01;"><LABEL><%=Rsql_81.getString(2)%> </LABEL>           
     </TH>
     <% } 
     if(Rsql_81.getString("color").equals("red_360"))  {
        %>
    <TH style="background-color:#B40404;"><LABEL><%=Rsql_81.getString(2)%> </LABEL>           
     </TH>
     <% } 
      if(Rsql_81.getString("color").equals("default"))  {
        %>
    <TH style="background-color:rgb(153, 153, 153);"><LABEL></LABEL>           
     </TH>
     <% } 
     %> 
    <% } %>
 </TR></TBODY></TABLE><BR><!--End MOP--> 
           
 <%     
        
        Rsql_61.close();
           Rsql_61_check.close();
          stmt_61.close();
           stmt_61_check.close();
           stmt_71.close();
           Rsql_71.close(); 
           stmt_81.close();
           Rsql_81.close();  
       }
} %>    
                         
         <BR><!-- Guarantee Credits --> 

          <P><STRONG style="color: rgb(0, 112, 163); font-size: large;">5. Borcalanın 
          zamin olduğu öhdəliklər</STRONG><BR></P>
      <%         while(Rsql_3_z.next())  {   %>
              <STRONG style="padding: 2px; font-size: medium; background-color: rgb(215, 235, 249);"><SPAN 
           style="font-size: medium;">5.<%=Rsql_3_z.getString(1)%></SPAN> <%=Rsql_3_z.getString(2)%> -         
          <%=formatter.format(Rsql_3_z.getDouble(3))%>  &nbsp;&nbsp; <%=Rsql_3_z.getString(4)%>   
          </STRONG>       <BR><BR>
          <TABLE width="710">
          <TBODY>
          <TR>
          <TD><SPAN style="font-weight: bold;">Məlumat təchizatçısı :</SPAN><SPAN 
          style="font-weight: bold;"><%=Rsql_3_z.getString(5)%> </SPAN>      
          </TD>
          <TD><SPAN style="font-weight: bold;">Hesab nömrəsi:</SPAN><SPAN style="font-weight: bold;">XXXX</SPAN> 
          </TD></TR></TBODY></TABLE>
          <TABLE width="710" style="border: 1px solid rgb(215, 235, 249); border-image: none;" 
          cellspacing="0">
          <TBODY>
          <TR style="height: 30px; font-size: medium; font-weight: bold;" bgcolor="#d7ebf9">
          <TD width="240">Kreditin qalıq məbləği</TD>
          <TD width="160"><SPAN style="font-weight: bold;"><%=formatter.format(Rsql_3_z.getDouble(6))%></SPAN></TD>
          <TD width="240">Faiz məbləği</TD>
          <TD width="160"><SPAN style="width: 200px;"><%=formatter.format(Rsql_3_z.getDouble(7))%></SPAN></TD></TR>
          <TR>
          <TD width="240">Aylıq ödəniş məbləği</TD>
          <TD width="140"><%=formatter.format(Rsql_3_z.getDouble(8))%></TD>
          <TD width="240">Kreditin verilmə tarixi</TD>
          <TD width="160"><%=Rsql_3_z.getString(9)%></TD></TR>
          <TR>
          <TD width="180">Məqsədi</TD>
          <TD width="240"><%=Rsql_3_z.getString(10)%></TD>
          <TD width="280">Kreditin son müqavilə ilə bitmə tarixi</TD>
          <TD width="100"><%=Rsql_3_z.getString(11)%></TD></TR></TBODY></TABLE><BR><!-- END of guarantee loans --> 
          <BR>
             <%        }  %>
             <br>
                                                  
          <H4>Ödəniş tərzinin açıqlaması</H4>
          <TABLE class="tab" style="border: 1px solid gray; border-image: none; width: 706px;">
          <TBODY>
          <TR>
          <TH bgcolor="#0099cc" rowspan="3">Tarixçə </TH>
          <TD align="center" bgcolor="#0099cc">-</TD>
          <TD>məlumat yoxdur</TD>
          <TD align="center" bgcolor="#0099cc">0</TD>
          <TD>0 gün gecikmə</TD>
          <TD align="center" bgcolor="yellow">30</TD>
          <TD>1-30 gün gecikmə</TD></TR>
          <TR>
          <TD align="center" bgcolor="#fe9a2e">90</TD>
          <TD>31-90 gün gecikmə</TD>
          <TD align="center" bgcolor="#fe642e">180</TD>
          <TD>91-180 gün gecikmə</TD>
          <TD align="center" bgcolor="#df3a01">360</TD>
          <TD>181-360 gün gecikmə</TD></TR>
          <TR>
          <TD align="center" bgcolor="#b40404">361+</TD>
          <TD colspan="5">360 gündən artıq gecikmə</TD></TR></TBODY></TABLE>
          <TABLE style="width: 710px; text-align: center;" frame="hsides">
          <TBODY>
          <TR>
          <TD><SPAN style="color: rgb(0, 112, 163);">Kredit hesabatının 
          sonu</SPAN></TD></TR></TBODY></TABLE></DIV>
                              
            <%  
             stmtB.close();
             stmt_2.close();
             stmt_3.close();
             stmt_4.close();
             stmt_5.close();
           
             Rsql_2.close();
             Rsql_3.close();
             Rsql_4.close();
             Rsql_5.close();
          
             
             
          }
            %>                  
                              
                              <INPUT name="javax.faces.ViewState" id="javax.faces.ViewState" type="hidden" value="-2939335497159985382:2762042233734743950" autocomplete="off"> 
         
             
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 15 (filtered)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"MS Mincho";
	panose-1:2 2 6 9 4 2 5 8 3 4;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"\@MS Mincho";
	panose-1:2 2 6 9 4 2 5 8 3 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Tahoma",sans-serif;}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{mso-style-link:"Header Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Tahoma",sans-serif;}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{mso-style-link:"Footer Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Tahoma",sans-serif;}
span.HeaderChar
	{mso-style-name:"Header Char";
	mso-style-link:Header;
	font-family:"Tahoma",sans-serif;}
span.FooterChar
	{mso-style-name:"Footer Char";
	mso-style-link:Footer;
	font-family:"Tahoma",sans-serif;}
.MsoChpDefault
	{font-family:"Calibri",sans-serif;}
.MsoPapDefault
	{margin-bottom:8.0pt;
	line-height:107%;}
 /* Page Definitions */
 @page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
  <%      conn.close(); %>             
           </FORM></BODY>                                    
          </HTML>