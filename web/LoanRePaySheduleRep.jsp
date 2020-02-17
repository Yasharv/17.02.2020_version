<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>
<%@page import="main.MemorialRep"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=8" />
        <title>DWH Reports</title>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 10mm 10mm 10mm 10mm;  /* this affects the margin in the printer settings */
            }
            .NonPrintable
            {
                display: none;
            }
        </style>
        <style type="text/css">
            .repform.table { page-break-inside:auto}
            .repform.tr {page-break-inside:avoid; page-break-after:auto}
        </style>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->


        <%
            DB db = new DB();
            Connection conn = db.connect();
            DecimalFormat df = new DecimalFormat("0.00");

            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();

            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;

            String srcValue = request.getParameter("srcValue").toString();
            String user_name = request.getParameter("uname");

            String forSrc = "1";
            if (request.getParameter("forSrc") != null) {
                forSrc = request.getParameter("forSrc");
            }
            if (forSrc.equals("2")) {
                String ParamsValue = "contractid='" + srcValue.trim() + "'";

                array[0] = 15;
                array[1] = "1";
                array[2] = "1";
                array[3] = ParamsValue;
                array[4] = user_name;

                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"), 0);
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>
        <%

        } else {

            String contract_info = "select c.*,(SELECT name FROM t_avalute where id=c.currency_id) curr_name from ("
                    + " select (SELECT name_short_az FROM vi_cust where customer_id=a.customer_id) name_short_az,"
                    + "nvl((SELECT debt_total FROM si_loan_balance where date_until='01-JAN-3000' and contract_id=a.contract_id),0) qaliq,"
                    + " a.customer_id,"
                    + " (SELECT bank FROM bankinfo_t where kod_b=a.filial_code) filial_name,a.product_id,a.currency_id,a.contract_id "
                    + " from si_loan_contract a where a.date_until='01-JAN-3000'"
                    + " union all"
                    + " select (SELECT name_short_az FROM vi_cust where customer_id=b.customer_id) name_short_az,"
                    + "nvl((SELECT nvl(debt_standard,0) + nvl(DEBT_PAST_DUE,0) + nvl(DEBT_NOT_PERFORMED_OB_LCY,0) + nvl(ARREARS_OB_BAD_DEBT_LCY,0)  FROM si_pc_loan_balance where date_until='01-JAN-3000' and contract_id=b.contract_id),0) qaliq,"
                    + " b.customer_id,"
                    + "(SELECT bank FROM bankinfo_t where kod_b=b.filial_code) filial_name,b.product_id,b.currency_id,b.contract_id from si_pc_loan_contract b where b.date_until='01-JAN-3000'"
                    + ") c where c.contract_id='" + srcValue + "'";

            String SQLText = "select to_char(act_date,'dd-MM-yyyy'),esas_mebleg,faiz_mebleg,gec_esas_mebleg,gec_faiz_mebleg,cerime,"
                    + "  CASE   WHEN  (  SLB.ARREARS_OB_STANDARD<>0 or  slb.DEBT_NOT_PERFORMED_OB<>0  or slb.INTEREST_OB_ACCRUAL <> 0 "
                    + "or slb.ARREARS_OB_PAST_DUE   <> 0 )      THEN 'FWOF'  WHEN (SLB.DEBT_PAST_DUE<>0 OR  SLB.ARREARS_B_STANDARD<> 0 "
                    + " OR  SLB.ARREARS_B_PAST_DUE<>0)       THEN  'PDO'  WHEN  (  SLB.DEBT_STANDARD<> 0  OR   SLB.INTEREST_ACCRUAL <> 0 ) "
                    + " THEN 'CURR' ELSE 'LIQ'  END STATUS,"
                    + "  (  select greatest(PAST_DUE_PR_DAYS,PAST_DUE_int_DAYS)   as gun_sayi "
                    + "  from  (    SELECT act_date,CONTRACT_ID,   PAST_DUE_PR_DAYS,PAST_DUE_int_DAYS FROM  si_loan_past_due "
                    + "   UNION   SELECT    act_date,CONTRACT_ID,   PAST_DUE_PR_DAYS,PAST_DUE_int_DAYS FROM  si_PC_loan_past_due   "
                    + " UNION     SELECT    act_date,CONTRACT_ID,   PAST_DUE_PR_DAYS,PAST_DUE_int_DAYS FROM  si_INVEST_MM_past_due      )   "
                    + "   where act_date =  A.ACT_DATE- 1 AND CONTRACT_ID = '" + srcValue + "' )    GUN_SAYI "
                    + " from ("
                    + " select COALESCE(a.act_date,b.act_date,c.act_date,d.act_date,e.act_date) act_date,"
                    + " sum(nvl(a.esas_mebleg,0)) esas_mebleg,sum(nvl(b.faiz_mebleg,0)) faiz_mebleg,"
                    + " sum(nvl(c.gec_esas_mebleg,0)) gec_esas_mebleg,sum(nvl(d.gec_faiz_mebleg,0)) gec_faiz_mebleg,"
                    + " sum(nvl(e.cerime,0)) cerime  "
                    + " from (select act_date,number_doc,sum(tr_amount_fcy_dt) esas_mebleg "
                    + " from si_transaction_account_un "
                    + " where  transaction_type='KR-5' and number_doc='" + srcValue + "'"
                    + " GROUP by act_date,number_doc ) a "
                    + " FULL OUTER JOIN"
                    + " (select act_date,number_doc ,sum(tr_amount_fcy_dt) faiz_mebleg "
                    + " from si_transaction_account_un "
                    + " where ( transaction_type='KR-7' or PAYMENT_PURPOSE LIKE  '%PAYMENT PC.IN PC%'          ) and number_doc='" + srcValue + "' "
                    + " GROUP by act_date,number_doc  ) b "
                    + " on (a.act_date=b.act_date  and a.number_doc = b.number_doc)"
                    + " FULL OUTER JOIN"
                    + " (select act_date,number_doc ,sum(tr_amount_fcy_dt) gec_esas_mebleg "
                    + " from si_transaction_account_un "
                    + " where (transaction_type IN   ('KR-6', 'KR-16') or PAYMENT_PURPOSE LIKE    '%PAYMENT PD.PR PC%'             OR PAYMENT_PURPOSE  LIKE         '%PAYMENT FWOF.PR PC%' ) and number_doc='" + srcValue + "'"
                    + " GROUP by act_date,number_doc ) c "
                    + " on (a.act_date=c.act_date and a.number_doc=c.number_doc )"
                    + " FULL OUTER JOIN"
                    + " (select act_date,number_doc ,sum(tr_amount_fcy_dt) gec_faiz_mebleg "
                    + " from si_transaction_account_un"
                    + " where (transaction_type IN ('KR-9', 'KR-17') or PAYMENT_PURPOSE LIKE    '%PAYMENT PD.IN PC%'             OR PAYMENT_PURPOSE  LIKE         '%PAYMENT FWOF.IN PC%' ) and number_doc='" + srcValue + "'"
                    + " GROUP by act_date,number_doc ) d "
                    + " ON (a.act_date=d.act_date and a.number_doc=d.number_doc ) "
                    + " FULL OUTER JOIN"
                    + " (  SELECT   act_date,number_doc, SUM (tr_amount_fcy_dt) cerime"
                    + " FROM   si_transaction_account_un"
                    + " WHERE  ( transaction_type = 'KR-8' or PAYMENT_PURPOSE LIKE        '%PAYMENT PD.PE PC%'         ) AND number_doc = '" + srcValue + "'"
                    + " GROUP BY   act_date, number_doc) e"
                    + " ON (a.act_date = e.act_date AND a.number_doc = e.number_doc) "
                    + " group by COALESCE(a.act_date,b.act_date,c.act_date,d.act_date,e.act_date)"
                    + " order by act_date )  A LEFT JOIN  "
                    + "  (    SELECT CONTRACT_ID, DATE_FROM, DATE_UNTIL,  ARREARS_OB_STANDARD, DEBT_NOT_PERFORMED_OB,INTEREST_OB_ACCRUAL ,"
                    + "ARREARS_OB_PAST_DUE, DEBT_STANDARD, INTEREST_ACCRUAL,DEBT_PAST_DUE, ARREARS_B_STANDARD, ARREARS_B_PAST_DUE "
                    + " FROM SI_LOAN_BALANCE    UNION  SELECT CONTRACT_ID, DATE_FROM, DATE_UNTIL,  ARREARS_OB_STANDARD,"
                    + " DEBT_NOT_PERFORMED_OB,INTEREST_OB_ACCRUAL ,ARREARS_OB_PAST_DUE,   DEBT_STANDARD, INTEREST_ACCRUAL,DEBT_PAST_DUE,"
                    + " ARREARS_B_STANDARD, ARREARS_B_PAST_DUE   FROM SI_PC_LOAN_BALANCE     UNION   SELECT CONTRACT_ID, DATE_FROM, DATE_UNTIL,"
                    + "  ARREARS_OB_STANDARD, DEBT_NOT_PERFORMED_OB, NULL INTEREST_OB_ACCRUAL , NULL ARREARS_OB_PAST_DUE,  DEBT_STANDARD, "
                    + "INTEREST_ACCRUAL,DEBT_PAST_DUE, ARREARS_B_STANDARD,  NULL ARREARS_B_PAST_DUE FROM SI_INVEST_MM_BALANCE     )  SLB  "
                    + "   ON   A.ACT_DATE BETWEEN SLB.DATE_FROM AND SLB.DATE_UNTIL  AND   SLB.CONTRACT_ID  = '" + srcValue + "'  ";
            //     System.out.print("SQLText");
            //System.out.print(SQLText);
            String Short_Name = "";
            String CustId = "";
            String Filial_Name = "";
            String product_id = "";
            String curr_name = "";
            Double qaliq = 0.0;

            Statement stmt_info = conn.createStatement();
            ResultSet sqlres_inf = stmt_info.executeQuery(contract_info);
            while (sqlres_inf.next()) {
                Short_Name = sqlres_inf.getString(1);
                qaliq = sqlres_inf.getDouble(2);
                CustId = sqlres_inf.getString(3);
                Filial_Name = sqlres_inf.getString(4);
                product_id = sqlres_inf.getString(5);
                curr_name = sqlres_inf.getString(8);
            }
            sqlres_inf.close();
            stmt_info.close();

            Statement stmt = conn.createStatement();
            ResultSet sqlres = stmt.executeQuery(SQLText);

        %>
        <table width="100%" border="0">
            <tr>
                <td valign="top" align="left">
                </td>
                <td>
                </td>
                <td valign="top" align="right">

                </td>
            </tr> 
            <tr>
                <td valign="top" align="left">  
                </td>
                <td valign="top" align="center">

                    <table bgcolor='white' border='1' width="900" cellspacing="1">
                        <tr>
                            <td >

                                <table bgcolor='white' border='0' width="900">
                                    <tr>
                                        <td align="left" colspan="2"> <font size="5"> "Expressbank" ASC </font></td>
                                    </tr>
                                    <tr>
                                        <td align="left" width="130px"> </td><td align="left"> </td>
                                    </tr>
                                    <tr>
                                        <td align="left">Müştəri: </td>
                                        <td align="left"><%=CustId + " - " + Short_Name%></td>
                                    </tr>  
                                    <tr>
                                        <td align="left">Müqavilə nömrəsi: </td>
                                        <td align="left"><%=srcValue%></td>
                                    </tr>  
                                    <tr>
                                        <td align="left">Valyuta: </td>
                                        <td align="left"><%=curr_name%></td>
                                    </tr> 
                                    <tr>
                                        <td align="left">Filial: </td>
                                        <td align="left"><%=Filial_Name%></td>
                                    </tr> 
                                    <tr>
                                        <td align="left">Məhsul:</td>
                                        <td align="left"><%=product_id%></td>
                                    </tr>  
                                    <tr>
                                        <td align="left" colspan="2">
                                            <br>
                                            <table border="0">
                                                <tr>
                                                    <th>Tarix</th> 
                                                    <th>Əsas borc</th>
                                                    <th>Faiz borc</th>
                                                    <th>G.Ə. borc</th>
                                                    <th>G.F. borc</th>
                                                    <th>Cərimə</th>
                                                    <th>Kreditin statusu</th>
                                                    <th>Gecikmə günü</th>
                                                    <th>Cəmi ödəniş</th>
                                                </tr>
                                                <%
                                                    String emps = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                    String emps2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                    Double cem_eb = 0.0;
                                                    Double cem_fb = 0.0;
                                                    Double cem_geb = 0.0;
                                                    Double cem_gfb = 0.0;
                                                    Double cem_cerime = 0.0;

                                                    while (sqlres.next()) {
                                                        cem_eb = cem_eb + sqlres.getDouble(2);
                                                        cem_fb = cem_fb + sqlres.getDouble(3);
                                                        cem_geb = cem_geb + sqlres.getDouble(4);
                                                        cem_gfb = cem_gfb + sqlres.getDouble(5);
                                                        cem_cerime = cem_cerime + sqlres.getDouble(6);

                                                        out.println("<tr>");
                                                        out.println("<td align='center'>" + sqlres.getString(1) + "</td>");
                                                        out.println("<td align='right'>" + df.format(sqlres.getDouble(2)) + "</td>");
                                                        out.println("<td align='right'>" + df.format(sqlres.getDouble(3)) + "</td>");
                                                        out.println("<td align='right'>" + df.format(sqlres.getDouble(4)) + "</td>");
                                                        out.println("<td align='right'>" + df.format(sqlres.getDouble(5)) + "</td>");
                                                        out.println("<td align='right'>" + df.format(sqlres.getDouble(6)) + "</td>");
                                                        out.println("<td align='right'>" + sqlres.getString(7) + "</td>");
                                                        out.println("<td align='right'>" + sqlres.getInt(8) + "</td>");
                                                        out.println("<td align='right'>" + df.format(sqlres.getDouble(2) + sqlres.getDouble(3) + sqlres.getDouble(4) + sqlres.getDouble(5) + sqlres.getDouble(6)) + "</td>");

                                                        out.println("</tr>");
                                                    }

                                                    sqlres.close();

                                                    stmt.close();
                                                    conn.close();

                                                %>
                                                <tr>
                                                    <td></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                </tr>

                                                <tr>
                                                    <td ><b>Cəmi:</b></td>
                                                    <td align='right'><b><%=df.format(cem_eb)%></b></td>
                                                    <td align='right'><b><%=df.format(cem_fb)%></b></td>
                                                    <td align='right'><b><%=df.format(cem_geb)%></b></td>
                                                    <td align='right'><b><%=df.format(cem_gfb)%></b></td>
                                                    <td align='right'><b><%=df.format(cem_cerime)%></b></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'><b><%=df.format(cem_eb + cem_fb + cem_geb + cem_gfb + cem_cerime)%></b></td>

                                                </tr>
                                                <tr>
                                                    <td height='10px'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                </tr>
                                                <tr>
                                                    <td><b>Cəmi faizdən:</b></td>
                                                    <td align='right'><b><%=df.format(cem_fb + cem_gfb + cem_cerime)%></b></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                </tr>
                                                <tr>
                                                    <td><b>Cəmi əsasdan:</b></td>
                                                    <td align='right'><b><%=df.format(cem_eb + cem_geb)%></b></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                </tr>
                                                <tr>
                                                    <td><b>Toplam:</b></td>
                                                    <td align='right'><b><%=df.format(cem_eb + cem_geb + cem_fb + cem_gfb + cem_cerime)%></b></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                </tr>
                                                <tr>
                                                    <td><b>Kreditin qalığı:</b></td>
                                                    <td align='right'><b><%=df.format(qaliq)%></b></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                    <td align='right'></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr> 
                                </table>

                            </td>
                    </table> 

                </td>
                <td valign="top" align="right">   
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>

                </td>
            </tr>    
        </table>
    </body>
</html>
<%
    }
%>