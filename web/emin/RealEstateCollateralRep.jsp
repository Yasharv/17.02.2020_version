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


            /*  String DateB = request.getParameter("DateB");
             String DateE = request.getParameter("DateE");*/
            String repcheck = request.getParameter("repcheck");
            String custid = request.getParameter("custid");
            String contract = request.getParameter("contract");
            String color = request.getParameter("color");
            String automark = request.getParameter("automark");
            String automodel = request.getParameter("automodel");
            String transmission = request.getParameter("transmission");
            String filial = request.getParameter("filial");
            
            
                System.out.println("repcheck25 "+repcheck);
                System.out.println("custid25 "+custid);
                System.out.println("contract25 "+contract);
                System.out.println("color25 "+color);
                System.out.println("automark25 "+automark);
                System.out.println("automodel25 "+automodel);
                System.out.println("transmission25 "+transmission);
                System.out.println("filial25 "+filial);
            /**
             * **********************************
             */
            String repcheck1 = "";
            String custid1 = "";
            String custid2 = "";
            String contract1 = "";
            String color1 = "";
            String automark1 = "";
            String automodel1 = "";
            String transmission1 = "";
            String filial1 = "";
            String filial2 = "";

            /**
             * **********************************
             */
             if (repcheck.equals("0")) {
                repcheck1 = " ";
            } else if (repcheck.equals("1")) {
                repcheck1 = "  AND SLC.MATURITY_DATE > SYSDATE  ";
            } else if (repcheck.equals("2")) {
                repcheck1 = "  AND SLC.MATURITY_DATE < SYSDATE  ";
            }
            if (custid.equals("")) {
                custid1 = "";
                custid2 = "";
            } else {
                custid1 = "   AND    spn_kredit.customer_id = " + custid;
                custid2 = "   AND   spl_kredit.customer_id = " + custid;
            }
            if (contract.equals("")) {
                contract1 = "";
            } else {
                contract1 = "   and  slc.contract_id= '" + contract + "'";
            }
            if (color.equals("")) {
                color1 = "";
            } else {
                color1 = "   sccri.avt_colour ='" + color+"'";
            }
            if (automark.equals("")) {
                automark1 = "";
            } else {
                automark1 = "    and   sccri.avt_marka like '" + automark+"'";
            }
            if (filial.equals("0")) {
                filial1 = "";
                filial2 = "";
            } else {
                filial1 = "   and spn_kredit.filial_code=" + filial;
                filial2 = "   and spl_kredit.filial_code=" + filial;
            }
            if (automodel.equals("")) {
                automodel1 = "";
            } else {
                automodel1 = "   AND sccri.avt_model =  '" + automodel + "'";
            }
            if (transmission.equals("")) {
                transmission1 = "";
            } else {
                transmission1 = "   AND sccri.avt_transmission_mode = '" + transmission + "'";
            }
            String SQLText = "SELECT    NVL (spn_girov.name_short_az, 'Məlumat yoxdur') \"Girov qoyan A.S.A\",  "
                    + "   nvl( spn_kredit.NAME_SHORT_AZ ,'Məlumat yoxdur')\"Kredit götürən A.S.A\",    "
                    + "  nvl( sccri.avt_marka,'Məlumat yoxdur' )\"Marka\",  "
                    + "     nvl(sccri.avt_model,'Məlumat yoxdur' )\"Model\",    "
                    + "   nvl(sccri.avt_manuf_country_id ,'Məlumat yoxdur')\"İstehsalçı ölkə\",  "
                    + "    nvl( sccri.avt_working_state ,'Məlumat yoxdur')\"İstismar vəziyyəti\",  "
                    + "    nvl( sccri.avt_transport_type ,'Məlumat yoxdur')\"Tipi\",     "
                    + "  (   select dcc.gb_description from DI_COLLATERAL_CODE dcc where dcc.date_until='01-jan-3000' "
                    + " and dcc.COLLATERAL_TYPES= 300     and sccri.AVT_TRANSPORT_TYPE =dcc.COLLATERAL_CODE_ID  )  \"Təyinatı\","
                    + "      nvl( sccri.avt_kuzov_type,'Məlumat yoxdur' )\"Banın növü\", "
                    + "     nvl( sccri.avt_transmission_mode,'Məlumat yoxdur' )\"Surət qutusu\",   "
                    + "   nvl( sccri.avt_fuel ,'Məlumat yoxdur')\"Yanacaq növü\",    "
                    + "  nvl( sccri.avt_colour ,'Məlumat yoxdur')\"Rəngi\", "
                    + "      sccri.avt_year \"Buraxılış ili\",   "
                    + "   nvl( sccri.avt_estimate_akt ,'Məlumat yoxdur')\"Aktın nömrəsi\",     "
                    + " nvl( sccri.avt_displacement,'0' )\"Mühərrikin həcmi\",    "
                    + "  nvl( sccri.AVT_COLLATERAL_AMT,'0' )\"Likvid dəyəri\",   "
                    + "   nvl( sccri.avt_mileage,'0'  )\"Yürüş\",   "
                    + "   nvl( sccri.avt_estimator,'Məlumat yoxdur' )\"Qiymətləndirici şirkət\",   "
                    + "   nvl( sccri.avt_market_cost,'0' )\"Bazar dəyəri\",    "
                     + "   nvl(((sccri.AVT_COLLATERAL_AMT / sccri.avt_market_cost) * 100),'0') \"Nisbət\",   "
                    + "     nvl( sccri.avt_insur_polic_amt,'0' )\"Sığorta dəyəri\",    "
                   + "    to_char( sccri.avt_estim_date,'DD-MM-YYYY') \"Qiymətləndirmə tarixi\",   "
                    + "    nvl( sccri.avt_estimator_int,'0' )\"Daxili qiymətləndirmə\",     "
                    + "  nvl(sccri.avt_market_cost_int,'0' )\"D.Q bazar dəyəri\",     "
                    + " nvl( sccri.avt_liquidity_cost_int,'0' )\"D.Q Likvid dəyəri\",    "
                    + "   nvl((sccri.AVT_COLLATERAL_AMT - sccri.avt_liquidity_cost_int),'0') \"Fərq\",   "
                    + "   nvl( sccri.avt_regist_num,'Məlumat yoxdur' )\"Qeydiyyat nişanı\", "
                      + "slc.contract_id \"Müqavilə\" "
                    + " FROM si_collateral_car_info sccri  ,  "
                    + "si_collateral_right scr ,"
                    + "si_loan_contract slc    ,"
                    + "si_person_natural spn_girov     ,"
                    + " si_person_natural spn_kredit "
                    + " WHERE    "
                    + " sccri.date_until = '01-jan-3000'   "
                    + "  AND scr.date_until = '01-jan-3000'  "
                    + " AND slc.date_until = '01-jan-3000'   "
                    + " AND spn_girov.date_until = '01-jan-3000'   "
                    + " AND spn_kredit.date_until = '01-jan-3000'     "
                    + " AND scr.COLLATERAL_CONTRACT_ID = sccri.collateral_id     "
                    + "  AND spn_girov.customer_ID = SUBSTR (sccri.collateral_id, 1, INSTR (sccri.collateral_id, '.') - 1)  "
                    + "   AND spn_kredit.customer_ID = slc.customer_id   "
                    + "  AND slc.contract_id = scr.contract_id  " + repcheck1 + " " + custid1 + " " + contract1 + " " + color1 + " " + automark1 + " " + filial1 + "  " + automodel1 + " " + transmission1 + " "
                    + " UNION   "
                    + " SELECT   "
                    + "  NVL (spl_girov.name_short_az, 'Melumat yoxdur') \"Girov qoyan A.S.A\",    "
                    + "nvl( spl_kredit.NAME_SHORT_AZ,'Məlumat yoxdur' )\"Kredit götürən A.S.A\",      "
                    + " nvl(sccri.avt_marka,'Məlumat yoxdur' )\"Marka\",     "
                    + " nvl( sccri.avt_model ,'Məlumat yoxdur')\"Model\",     "
                    + " nvl( sccri.avt_manuf_country_id,'Məlumat yoxdur' )\"İstehsalçı ölkə\",     "
                    + " nvl( sccri.avt_working_state,'Məlumat yoxdur' )\"İstismar vəziyyəti\",    "
                    + "  nvl( sccri.avt_transport_type,'Məlumat yoxdur' )\"Tipi\",  "
                    + " (   select dcc.gb_description from DI_COLLATERAL_CODE dcc where dcc.date_until='01-jan-3000' "
                    + " and dcc.COLLATERAL_TYPES= 300     and sccri.AVT_TRANSPORT_TYPE=dcc.COLLATERAL_CODE_ID   )        "
                    + "   \"Təyinatı\",   "
                    + "   nvl( sccri.avt_kuzov_type,'Məlumat yoxdur' )\"Banın növü\",     "
                    + " nvl( sccri.avt_transmission_mode,'Məlumat yoxdur' )\"Surət qutusu\",  "
                    + "   nvl(  sccri.avt_fuel,'Məlumat yoxdur'  )\"Yanacaq növü\",     "
                    + "  nvl(sccri.avt_colour,'Məlumat yoxdur' )\"Rəngi\",   "
                    + "    sccri.avt_year \"Buraxılış ili\",   "
                    + "   nvl( sccri.avt_estimate_akt,'Məlumat yoxdur' )\"Aktın nömrəsi\",   "
                    + "   nvl( sccri.avt_displacement,'0' )\"Mühərrikin həcmi\",   "
                    + "   nvl( sccri.AVT_COLLATERAL_AMT,'0' )\"Likvid dəyəri\",     "
                    + "  nvl(sccri.avt_mileage,'0' )\"Yürüş\",   "
                    + "   nvl( sccri.avt_estimator,'Məlumat yoxdur' )\"Qiymətləndirici şirkət\",  "
                    + "   nvl(  sccri.avt_market_cost,'0' )\"Bazar dəyəri\",    "
                    + "   nvl(((sccri.AVT_COLLATERAL_AMT / sccri.avt_market_cost) * 100),'0') \"Nisbət\",   "
                    + "   nvl( sccri.avt_insur_polic_amt,'0' )\"Sığorta dəyəri\",  "
                    + "    to_char( sccri.avt_estim_date,'DD-MM-YYYY') \"Qiymətləndirmə tarixi\",   "
                    + "    nvl(sccri.avt_estimator_int,'0' )\"Daxili qiymətləndirmə\",   "
                    + "   nvl( sccri.avt_market_cost_int ,'0')\"D.Q bazar dəyəri\",    "
                    + "   nvl(sccri.avt_liquidity_cost_int,'0' )\"D.Q Likvid dəyəri\",   "
                    + "    nvl((sccri.AVT_COLLATERAL_AMT - sccri.avt_liquidity_cost_int ),'0')\"Fərq\",   "
                    + "   nvl( sccri.avt_regist_num,'Məlumat yoxdur' )\"Qeydiyyat nişanı\", "
                      + "slc.contract_id \"Müqavilə\" "
                    + " FROM si_collateral_car_info sccri,    "
                    + "   si_collateral_right scr,    "
                    + "   si_loan_contract slc,  "
                    + "    si_person_legal spl_girov,     "
                    + "  si_person_legal spl_kredit   WHERE   "
                    + "  sccri.date_until = '01-jan-3000'    "
                    + "  AND scr.date_until = '01-jan-3000'    "
                    + "  AND slc.date_until = '01-jan-3000'     "
                    + " AND spl_girov.date_until = '01-jan-3000'    "
                    + " AND spl_kredit.date_until = '01-jan-3000'   "
                    + "   AND scr.COLLATERAL_CONTRACT_ID = sccri.collateral_id    "
                    + "   AND spl_girov.customer_ID =  SUBSTR (sccri.collateral_id,   1, INSTR (sccri.collateral_id, '.') - 1)"
                    + "      AND spl_kredit.customer_ID = slc.customer_id   "
                    + "    AND slc.contract_id = scr.contract_id      " + repcheck1 + " " + custid2 + " " + contract1 + " " + color1 + " " + automark1 + " " + filial2 + "  " + automodel1 + " " + transmission1 + "";
           System.out.println(SQLText);

            Connection conn = db.connect();
            Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SQLText);
        %>
        <table border="0" width="100%" > <tr> <td>
                    <table cellpadding="0" cellspacing="0" border="0"  id="example" width="100%" >
                        <thead>
                            <tr>
                                <%
                                    int count = sqlres.getMetaData().getColumnCount();

                                    for (int i = 1; i <= count; i++) {
                                        out.println("<th>" + sqlres.getMetaData().getColumnName(i) + "</th>");
                                    };
                                %>

                            </tr>
                        </thead>
                        <tbody>

                            <%
                                while (sqlres.next()) {
                                    out.println("<tr align='center' >");

                                    out.println("<td width='40'>" + sqlres.getString(1) + "</td>");
                                    out.println("<td width='120'>" + sqlres.getString(2) + "</td>");
                                    out.println("<td width='40'>" + sqlres.getString(3) + "</td>");
                                    out.println("<td width='220'>" + sqlres.getString(4) + "</td>");
                                    out.println("<td width='40'>" + sqlres.getString(5) + "</td>");
                                    out.println("<td width='60'>" + sqlres.getString(6) + "</td>");
                                    out.println("<td width='60'>" + sqlres.getString(7) + "</td>");
                                    out.println("<td width='20'>" + sqlres.getString(8) + "</td>");
                                    out.println("<td width='100'>" + sqlres.getString(9) + "</td>");
                                    out.println("<td width='100'>" + sqlres.getString(10) + "</td>");
                                    out.println("<td>" + sqlres.getString(11) + "</td>");
                                    out.println("<td>" + sqlres.getString(12) + "</td>");
                                    out.println("<td>" + sqlres.getString(13) + "</td>");
                                    out.println("<td>" + sqlres.getString(14) + "</td>");
                                    out.println("<td>" + sqlres.getString(15) + "</td>");
                                    out.println("<td>" + sqlres.getString(16) + "</td>");
                                    out.println("<td>" + sqlres.getString(17) + "</td>");
                                    out.println("<td>" + sqlres.getString(18) + "</td>");
                                    out.println("<td>" + sqlres.getString(19) + "</td>");
                                    out.println("<td>" + sqlres.getString(20) + "</td>");
                                     out.println("<td>" + sqlres.getString(21) + "</td>");
                                      out.println("<td>" + sqlres.getString(22) + "</td>");
                                       out.println("<td>" + sqlres.getString(23) + "</td>");
                                        out.println("<td>" + sqlres.getString(24) + "</td>");
                                         out.println("<td>" + sqlres.getString(25) + "</td>");
                                          out.println("<td>" + sqlres.getString(26) + "</td>");
                                           out.println("<td>" + sqlres.getString(27) + "</td>");
                                           out.println("<td>" + sqlres.getString(28) + "</td>");
                                    out.println("</tr>");
                                };
                            %>
                        </tbody>
                        <tfoot>
                            <tr>
                                <%

                                    for (int i = 1; i <= count; i++) {
                                        out.println("<th>" + sqlres.getMetaData().getColumnName(i) + "</th>");
                                    };

                                %>
                            </tr>

                        </tfoot>
                    </table> </td>



            </tr></table>
        <table  border='0' width="100%" cellspacing="1">

            <tr>
                <td align="right"  >
                    <p>
                        <%
                            out.println(dict.ftSign());
                            sqlres.close();
                            stmt.close();
                            conn.close();

                        %>
                    </p>
                </td></tr>
        </table>
    </body>
</html>
