<%-- 
    Document   : GoldPricingRep
    Created on : Oct 9, 2014, 3:02:35 PM
    Author     : emin.mustafayev
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<%@page import="main.DB"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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
    <body bgcolor=#E0EBEA>
        <%
            String repcustomer = null;
            String repcontract = null;
            String repfilial = null;
            String repprobe = null;
            String repweight = null;
            String repamt = null;
            String reptype = null;
            DB db = new DB();
            Connection conn = db.connect();
           // DecimalFormat twoDForm = new DecimalFormat("0.00");

            Statement stmt = conn.createStatement();
           // Statement stmt2 = conn.createStatement();
            // PreparedStatement preparedStatement = null;
           // String strDateB = request.getParameter("TrDateB");
           // String strDateE = request.getParameter("TrDateE");
            repcustomer = request.getParameter("RepCustomer");
            repcontract = request.getParameter("RepContract");
            repfilial = request.getParameter("RepFilial");
            repprobe = request.getParameter("RepProbe");
            repweight = request.getParameter("RepWeight");
            repamt = request.getParameter("RepAmt");
            reptype = request.getParameter("RepType");

       
            String reptype_aktiv ="";
            if (reptype.equals("0")){
            reptype_aktiv = " ";
            }   else if (reptype.equals("1")){
            reptype_aktiv = "  AND SLC.MATURITY_DATE > SYSDATE  ";
            } else if(reptype.equals("2")){
             reptype_aktiv = "  AND SLC.MATURITY_DATE < SYSDATE  ";
            }
            String repcustomeraktiv="";
            String repcustomeraktivl="";
            String repprobeaktiv ="";
            String repamtaktiv="";
            String repweightaktiv="";
            String repfilialaktiv="";
               if (repcustomer.equals("")){
            repcustomeraktiv = "";
            repcustomeraktivl="";
            } else {
             repcustomeraktiv = "   AND    spn_kredit.customer_id="+repcustomer;
             repcustomeraktivl = "   AND   spl_kredit.customer_id="+repcustomer;
            }
            
              if (repprobe.equals("")){
            repprobeaktiv = "";
            } else {
             repprobeaktiv = "   and  SCPI.PRECIOUS_PROBE= '"+repprobe+"'";
            
            }
               if (repamt.equals("")){
            repamtaktiv = "";
            } else {
             repamtaktiv = "  and  SCPI.PRECIOUS_AMT ="+repamt;
            
            }
            
                       if (repweight.equals("")){
            repweightaktiv = "";
            } else {
             repweightaktiv = "    and  SCPI.PRECIOUS_WEIGHT="+repweight;
            
            }
            String repfilialaktiv1="";
             if (repfilial.equals("0")){
            repfilialaktiv = "";
            repfilialaktiv1 = "";
            } else {
             repfilialaktiv = "   and spn_kredit.filial_code="+repfilial;
             repfilialaktiv1 = "   and spl_kredit.filial_code="+repfilial;
            
            }
            String repcontractaktiv="";
             if (repcontract.equals("")){
            repcontractaktiv = "";
           
            } else {
             repcontractaktiv = "   AND slc.contract_id = '"+repcontract+"'";
   
            
            }

            String user_name = request.getParameter("uname");
            String user_branch = "";
            int all_filials = 0;
            int salary_acc = 0;

            Statement stmtUser = conn.createStatement();
            String SqlUserQuery = "select user_branch,all_filials,salary_acc from dwh_users where user_id='" + user_name + "'";
            ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
            while (sqlUserSel.next()) {
                user_branch = sqlUserSel.getString(1);
                all_filials = sqlUserSel.getInt(2);
                salary_acc = sqlUserSel.getInt(3);
            };
            sqlUserSel.close();
            stmtUser.close();

          





            SimpleDateFormat dtformat = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");

           /* Date dateB;
            Date dateE;

            dateB = dtformat.parse(strDateB);
            strDateB = dtformat2.format(dateB);

            dateE = dtformat.parse(strDateE);
            strDateE = dtformat2.format(dateE);*/


            //  java.sql.Date TrDateB = java.sql.Date.valueOf( strDateB );
            //  java.sql.Date TrDateE = java.sql.Date.valueOf( strDateE ); 



            String SqlQuery = " SELECT scr.CONTRACT_ID  Muqavila,"
                    + "  NVL (spn_girov.name_short_az, 'Melumat yoxdur') Girov_qoyan_A_S_A,  "
                    + "    spn_kredit.NAME_SHORT_AZ AS Kredit_goturen_A_S_A,     "
                    + "   scpi.precious_kind Metal,  "
                    + "   scpi.precious_collateral_code   Nov ,    "
                    + "   scpi.precious_description Esyanin_tesviri ,  "
                    + "     scpi.precious_count Esyanin_sayi,    "
                    + "   SCPI.PRECIOUS_PROBE Eyyar,    "
                    + "   SCPI.PRECIOUS_WEIGHT Cekisi,  "
                    + "     SCPI.PRECIOUS_PRICE Bir_qramin_deyeri,    "
                    + "   NVL(SCPI.PRECIOUS_AMT,'0' ) Umumi_deyeri,   "
                    + "    NVL(SCPI.PRECIOUS_ESTIMATOR,'Melumat yoxdur') Qiymetlendirici_sirket,   "
                    + "    NVL(SCPI.PRECIOUS_AKT,'Melumat yoxdur') Aktin_nomresi,      "
                    + " NVL(SCPI.PRECIOUS_VALIDITY_DATE,'') Qiymetlendirme_tarixi ,    "
                    + "(select GB_DESCRIPTION from di_branch db where "
                    + "db.BRANCH_ID=spn_girov.filial_code and db.date_until='01-jan-3000') Filial  "
                    + "  FROM si_collateral_precious_info scpi,      "
                    + "      si_collateral_right scr ,"
                    + "si_loan_contract slc          ,"
                    + "si_person_natural spn_girov          ,"
                    + "si_person_natural spn_kredit  WHERE    "
                    + " scpi.date_until = '01-jan-3000'  and"
                    + "  scr.date_until = '01-jan-3000'     and"
                    + " slc.date_until = '01-jan-3000'       and"
                    + " spn_girov.date_until = '01-jan-3000'   and "
                    + "spn_kredit.date_until = '01-jan-3000'      and"
                    + "  scr.COLLATERAL_CONTRACT_ID=SUBSTR (scpi.collateral_id, 1, INSTR (scpi.collateral_id, '-') - 1)       AND "
                    + " spn_girov.customer_ID =SUBSTR (scpi.collateral_id, 1, INSTR (scpi.collateral_id, '.') - 1)      AND "
                    + "spn_kredit.customer_ID =slc.customer_id       and"
                    + " slc.contract_id = scr.contract_id   "+reptype_aktiv +" "+repcustomeraktiv +" "+repprobeaktiv+" "+repamtaktiv+" "+repweightaktiv+" "+repfilialaktiv+"  "+repcontractaktiv+""
                    + " union all           "
                    + "   SELECT  "
                    + "   scr.CONTRACT_ID   Muqavila, "
                    + " NVL (spl_girov.name_short_az, 'Melumat yoxdur') Girov_qoyan_A_S_A,  "
                    + "   spl_kredit.NAME_SHORT_AZ AS Kredit_goturen_A_S_A,   "
                    + "    scpi.precious_kind Metal,    "
                    + "   scpi.precious_collateral_code Nov,    "
                    + "   scpi.precious_description Esyanin_tesviri,    "
                    + "   scpi.precious_count Esyanin_sayi,    "
                    + "   SCPI.PRECIOUS_PROBE Eyyar, "
                    + "      SCPI.PRECIOUS_WEIGHT Cekisi,  "
                    + "     SCPI.PRECIOUS_PRICE Bir_qramin_deyeri,     "
                    + "   NVL(SCPI.PRECIOUS_AMT,'0' ) Umumi_deyeri,   "
                    + "    NVL(SCPI.PRECIOUS_ESTIMATOR,'Melumat yoxdur') Qiymetlendirici_sirket,   "
                    + "    NVL(SCPI.PRECIOUS_AKT,'Melumat yoxdur')  Aktin_nomresi,      "
                    + " trunc(NVL(SCPI.PRECIOUS_VALIDITY_DATE,'')) Qiymetlendirme_tarixi ,    "
                    + "(select GB_DESCRIPTION from di_branch db where db.BRANCH_ID=spl_girov.filial_code and db.date_until='01-jan-3000') Filial  "
                    + "  FROM si_collateral_precious_info scpi,   "
                    + "     si_collateral_right scr   ,"
                    + "si_loan_contract slc   ,"
                    + "si_person_legal spl_girov    ,"
                    + "si_person_legal spl_kredit "
                    + " WHERE   "
                    + "  scpi.date_until = '01-jan-3000'  and "
                    + " scr.date_until = '01-jan-3000'     and "
                    + "slc.date_until = '01-jan-3000'    and "
                    + " spl_girov.date_until = '01-jan-3000'  and "
                    + "spl_kredit.date_until = '01-jan-3000'  and "
                    + " scr.COLLATERAL_CONTRACT_ID=SUBSTR (scpi.collateral_id, 1, INSTR (scpi.collateral_id, '-') - 1)           AND"
                    + " spl_girov.customer_ID =SUBSTR (scpi.collateral_id, 1, INSTR (scpi.collateral_id, '.') - 1)       AND"
                    + " spl_kredit.customer_ID =slc.customer_id   "
                    + "    and slc.contract_id = scr.contract_id  "+reptype_aktiv +" "+repcustomeraktivl +" "+repprobeaktiv+" "+repamtaktiv+" "+repweightaktiv+"  "+repfilialaktiv1+" "+repcontractaktiv+"";
            //System.out.println("SqlQuery " + SqlQuery);

            ResultSet sqlSel = stmt.executeQuery(SqlQuery);

   //System.out.println("SqlQuery1 " + SqlQuery);

            PrDict footer = new PrDict();
        %>    
        <table  border="0" width="1800"> 
            <tr>
                <td align="left"> 
                    <FORM  method="post" action="GoldRepExcel" name="post">
                        <input type="hidden" name="excelSql" value="<%=SqlQuery%>" />
                        <input type="submit" name="excel" value="Excel-ə at"/>
                    </FORM>
                </td>
            </tr>
            <tr>

                <td colspan="2"> 
                    <!---- CEDVEL BASHLAYIR   ------------------------class="display"--------------->              

                    <table cellpadding="0" cellspacing="0" border="0"  id="example" width="100%">
                        <thead>
                            <tr>

                                <%
                                    int count = sqlSel.getMetaData().getColumnCount();

                                    for (int i = 1; i <= count; i++) {
                                        out.println("<th>" + sqlSel.getMetaData().getColumnName(i) + "</th>");
                                    };
                                %>

                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (sqlSel.next()) {
                                    out.println("<tr >");

                                    out.println("<td width='80'>" + sqlSel.getString(1) + "</td>");
                                    out.println("<td width='220'>" + sqlSel.getString(2) + "</td>");
                                    out.println("<td width='50'>" + sqlSel.getString(3) + "</td>");
                                    out.println("<td width='50'>" + sqlSel.getString(4) + "</td>");
                                    out.println("<td width='220'>" + sqlSel.getString(5) + "</td>");
                                    out.println("<td width='60'>" + sqlSel.getString(6) + "</td>");
                                    out.println("<td width='60'>" + sqlSel.getString(7) + "</td>");
                                    out.println("<td width='50'>" + sqlSel.getString(8) + "</td>");
                                    out.println("<td width='50'>" + sqlSel.getString(9) + "</td>");
                                    out.println("<td >" + sqlSel.getString(10) + "</td>");
                                    out.println("<td width='250'>" + sqlSel.getString(11) + "</td>");
                                    out.println("<td width='250'>" + sqlSel.getString(12) + "</td>");
                                    out.println("<td width='250'>" + sqlSel.getString(13) + "</td>");
                                     out.println("<td width='250'>" + sqlSel.getString(14) + "</td>");
                                      out.println("<td width='250'>" + sqlSel.getString(15) + "</td>");
                                       
                                    out.println("</tr>");
                                };


                            %>
                        </tbody>

                    </table>
                    <!---- CEDVEL SONU   --------------------------------------->
                </td>

            </tr>
            <tr>

            </tr>
            <tr>

                <td width="500" colspan="2">
                    <div align="left">
                        <%
                            out.println(footer.ftSign());


                            sqlSel.close();

                            stmt.close();
                            conn.close();
                        %>
                    </div>
                </td>
            </tr>

        </table>
    </body>
</html>

