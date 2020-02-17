<%-- 
    Document   : DBBalanceRep
    Created on : Jan 14, 2013, 11:16:03 AM
    Author     : m.aliyev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page import="DBUtility.DataSource"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.Statement"%>
<%@page import="main.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 15mm 10mm 15mm 10mm;  /* this affects the margin in the printer settings */
            }
            .NonPrintable
            {
                display: none;
            }      
        </style>

    </head>
    <body bgcolor=#E0EBEA> 
        <%
            /*Added by Ceyhun 19.07.2019*/

            DataSource dataSource = new DataSource();
            Connection dbConnection = null;
            dbConnection = dataSource.getConnection();
            Statement stmt = dbConnection.createStatement();

            WorkDatabase wd = new WorkDatabase();

            Object[] array = new Object[5];
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;
            properties = rf.ReadConfigFile("StoredProcedureName.properties");

            String repFormValArr[] = null;
            String repFormVal = "";
            String glAcctNum = "";
            String accId = "";
            String catId = "";
            String groupParams = "";
            String closeAcc = "and siaccinfb.closure_date is null";

            String queryStatus = null;
            String condStatus = null;

            String user_name = request.getParameter("uname");
            String br = request.getParameter("br");
            String RepForm = request.getParameter("RepForm");
            String RepFormVal = request.getParameter("RepFormVal");
            String strDateB = request.getParameter("DateB");
            String strDateE = request.getParameter("DateE");
            int RepType = Integer.parseInt(request.getParameter("RepType"));
            int RepType1 = 0;
            int RepType2 = 0;
            if (request.getParameter("RepType1") != null) {
                RepType1 = Integer.parseInt(request.getParameter("RepType1"));
            }

            if (request.getParameter("RepType2") != null) {
                RepType2 = Integer.parseInt(request.getParameter("RepType2"));
            }
             
            String kurs_ferqi = "";
            if (RepType1 == 3) {
                kurs_ferqi = " AND ((siaccoperofb.OPERATION_ACCT_AMOUNT_DT <> 0 AND siaccoperofb.OPERATION_ACCT_AMOUNT_LCY_DT <>0 ) OR (siaccoperofb.OPERATION_ACCT_AMOUNT_CR <>0 AND siaccoperofb.OPERATION_ACCT_AMOUNT_LCY_CR <>0 )) ";

            }

            if (RepType2 == 4)
            {
                closeAcc = "";
            }
            int AmtForm = Integer.parseInt(request.getParameter("AmtForm"));

            int AccName = -1;
            if (request.getParameter("AccName") != null) {
                AccName = 1;
            }

            String[] RepVal = null;
            String RepValSql = "";
            String RepFilial = request.getParameter("RepFilial");
            String filial = RepFilial;

            if (!(request.getParameterValues("DebVal") == null)) {
                RepVal = request.getParameterValues("DebVal");
            }

            if (!(RepVal == null)) {
                for (int i = 0; i < RepVal.length; i++) {
                    RepValSql = RepValSql + "," + RepVal[i];
                }
                RepValSql = RepValSql.substring(1);
            } else {
                RepValSql = "";
            }

            SimpleDateFormat format = new SimpleDateFormat("dd-mm-yyyy");
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-mm-dd");
            Date dateB;
            Date dateE;

            dateB = format.parse(strDateB);
            strDateB = format2.format(dateB);

            dateE = format.parse(strDateE);
            strDateE = format2.format(dateE);

            if (RepFormVal != null) {
                if (RepFormVal.trim().isEmpty()) {
                    repFormVal = "";
                } else {
                    repFormValArr = RepFormVal.split(",");
                    for (int i = 0; i < repFormValArr.length; i++) {
                        repFormVal = repFormVal + ",'" + repFormValArr[i] + "'";
                    }
                    repFormVal = repFormVal.substring(1);
                }
            }

            if (RepFilial != null && RepFilial != "" && !RepFilial.trim().equals("")) {
                RepFilial = RepFilial.equals("0") ? "" : RepFilial;
            }

            glAcctNum = "";
            accId = "";
            catId = "";
            
            if (RepForm.equals("1")) {
                glAcctNum = repFormVal;
            } else if (RepForm.equals("2")) {
                accId = repFormVal;
            } else {
                catId = repFormVal;
            }

            if (RepType == 1) {
                queryStatus = "1";
                condStatus = "1";
            } else {
                queryStatus = "2";
                condStatus = "2";
            }
            String ParamsValue = "datesintervals=to_date('" + strDateB.trim() + "','yyyy-mm-dd') and to_date('" + strDateE.trim() + "','yyyy-mm-dd')/"
                    + "dateuntilvalue=to_date('" + strDateE.trim() + "','yyyy-mm-dd')/"
                    + "datefromvalue=to_date('" + strDateE.trim() + "','yyyy-mm-dd')/"
                    + "iq_date_until_value=to_date('" + strDateB.trim() + "','yyyy-mm-dd') - 1/"
                    + "iq_date_from_value=to_date('" + strDateB.trim() + "','yyyy-mm-dd') - 1/"
                    + "infb_date_until_value=to_date('" + strDateE.trim() + "','yyyy-mm-dd')/"
                    + "infb_date_from_value=to_date('" + strDateE.trim() + "','yyyy-mm-dd')/"
                    + "filialcode=" + RepFilial + "/"
                    + "currencyid=" + RepValSql + "/"
                    + "gl_acct_no=" + glAcctNum + "/"
                    + "altacctid=" + accId + "/"
                    + "category=" + catId + "/"
                    + "amtform=" + AmtForm + "/"
                    + "differcurrency=" + kurs_ferqi + "/"
                    + "with_closed_acc=" + closeAcc;

            array[0] = 4;
            array[1] = queryStatus;
            array[2] = condStatus;
            array[3] = ParamsValue;
            array[4] = user_name;

            ResultSet sqlSel = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, dbConnection);
            ResultSetMetaData rsmd = sqlSel.getMetaData();

            Map data = new HashMap();
            int a = 0;

            PrDict footer = new PrDict();
            DecimalFormat twoDForm = new DecimalFormat("0.00");
        %> 
        <table border="0" width="100%" height="100%">
            <tr>
                <td align="left" valign="top">

                </td>
                <td align="center" valign="top">

                    <table  border="1" bgcolor='white' width="900"> 
                        <tr>
                            <td>

                                <table  border="0" width="100%">
                                    <tr>
                                        <td width="150"><img src='images/logo.jpg' width='120' height='60'></td>
                                        <td width="200"><p> "ExpressBank" ASC </p> <p>VÖEN: 1500031691</p></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <%
                                                if (filial.equals("0")) {

                                                    out.println("Ümumi bank üzrə");
                                                } else {

                                                    String branch = "  select  GB_DESCRIPTION  from di_branch where date_until = '01-jan-3000' and BRANCH_ID = " + filial + "    ";
                                                    Statement stbr = dbConnection.createStatement();
                                                    ResultSet sqlbr = stbr.executeQuery(branch);
                                                    sqlbr.next();
                                                    out.println(sqlbr.getString(1));
                                                    stbr.close();
                                                    stbr.close();
                                                }
                                            %>

                                        </td>
                                        <td></td>
                                    </tr>    
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>
                                            <%
                                                String Valyuta = "";

                                                out.println(Valyuta);
                                            %>
                                        </td>
                                        <td></td>
                                    </tr>   
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td><% out.println(strDateB);%>   <% out.println(strDateE);%> </td>
                                        <td></td>
                                    </tr> 
                                </table>

                            </td>
                        </tr>

                        <tr>

                            <td width="880" valign="top" > 

                                <!---- CEDVEL BASHLAYIR   --------------------------------------->              

                                <table cellpadding="0" cellspacing="0" border="1" width="100%">
                                    <tr>
                                        <td width="250">Hesabın № </td>
                                        <td width="200" colspan="2">  Dövrün əvvəlinə qalıq  </td>
                                        <td width="200" colspan="2">  Dövr ərzində dövriyyələr  </td>
                                        <td width="200" colspan="2">  Dövrün sonuna qalıq  </td>
                                        <% if (AccName == 1) {%> <td width="250" rowspan="2" align='center'><b> Hesabın adı  </b></td>    <%}%> 
                                    </tr>
                                    <tr>
                                        <td width="250">         </td>
                                        <td width="100">  Aktiv  </td>
                                        <td width="100">  Passiv </td>
                                        <td width="100">  Debet  </td>
                                        <td width="100">  Kredit </td>
                                        <td width="100">  Aktiv  </td>
                                        <td width="100">  Passiv </td>

                                    </tr>

                                    <%
                                        Map row = null;
                                        String Accnt_Bal = null;
                                        String old_Accnt_Bal = "";
                                        ArrayList<String> columns = new ArrayList<String>(rsmd.getColumnCount());

                                        for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                                            columns.add(rsmd.getColumnName(i));
                                        }

                                        while (sqlSel.next()) {

                                            a++;
                                            row = new HashMap();
                                            for (int col = 1; col <= rsmd.getColumnCount(); col++) {
                                                row.put(col, sqlSel.getString(col));

                                            }

                                            data.put(a, row);

                                            Accnt_Bal = sqlSel.getString(8);

                                            if ((!(old_Accnt_Bal.equals(Accnt_Bal))) & (!(old_Accnt_Bal.equals("")))) {
                                                Statement stmt2 = dbConnection.createStatement();
                                                if (RepType == 1) {
                                                    queryStatus = "3";
                                                    condStatus = "3";
                                                    groupParams = "glacctno=" + old_Accnt_Bal;
                                                } else {
                                                    queryStatus = "4";
                                                    condStatus = "4";
                                                    groupParams = "glacctno=" + old_Accnt_Bal;
                                                }

                                                array[0] = 4;
                                                array[1] = queryStatus;
                                                array[2] = condStatus;
                                                array[3] = ParamsValue + "/" + groupParams;
                                                array[4] = user_name;
                                                ResultSet sqlSel2 = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, dbConnection);

                                                while (sqlSel2.next()) {
                                                    out.println("<tr>");
                                                    out.println("<td align='center'> <b>" + old_Accnt_Bal + "</b></td>");
                                                    out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(2)) + "</b></td>");
                                                    out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(3)) + "</b></td>");
                                                    out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(4)) + "</b></td>");
                                                    out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(5)) + "</b></td>");
                                                    out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(6)) + "</b></td>");
                                                    out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(7)) + "</b></td>");
                                                    if (AccName == 1) {
                                                        out.println("<td></td>");
                                                    }
                                                    out.println("</tr>");
                                                }
                                                sqlSel2.close();
                                                stmt2.close();
                                            }
                                            old_Accnt_Bal = Accnt_Bal;

                                            out.println("<tr>");
                                            out.println("<td align='center'>" + sqlSel.getString(1) + "</td>");
                                            out.println("<td align='right'>" + twoDForm.format(sqlSel.getDouble(2)) + "</td>");
                                            out.println("<td align='right'>" + twoDForm.format(sqlSel.getDouble(3)) + "</td>");
                                            out.println("<td align='right'>" + twoDForm.format(sqlSel.getDouble(4)) + "</td>");
                                            out.println("<td align='right'>" + twoDForm.format(sqlSel.getDouble(5)) + "</td>");
                                            out.println("<td align='right'>" + twoDForm.format(sqlSel.getDouble(6)) + "</td>");
                                            out.println("<td align='right'>" + twoDForm.format(sqlSel.getDouble(7)) + "</td>");
                                            if (AccName == 1) 
                                            {
                                                out.println("<td> <font size='2'>" + sqlSel.getString(9) + "</font></td>");
                                            }

                                            out.println("</tr>");

                                        }
                                        //  sonluq cem
                                        {
                                            Statement stmt2 = dbConnection.createStatement();
                                            if (RepType == 1) {
                                                queryStatus = "3";
                                                condStatus = "3";
                                                groupParams = "glacctno=" + old_Accnt_Bal;
                                            } else {
                                                queryStatus = "4";
                                                condStatus = "4";
                                                groupParams = "glacctno=" + old_Accnt_Bal;
                                            }

                                            array[0] = 4;
                                            array[1] = queryStatus;
                                            array[2] = condStatus;
                                            array[3] = ParamsValue + "/" + groupParams;
                                            array[4] = user_name;
                                            ResultSet sqlSel2 = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, dbConnection);

                                            while (sqlSel2.next()) {
                                                out.println("<tr>");
                                                out.println("<td align='center'> <b>" + old_Accnt_Bal + "</b></td>");
                                                out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(2)) + "</b></td>");
                                                out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(3)) + "</b></td>");
                                                out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(4)) + "</b></td>");
                                                out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(5)) + "</b></td>");
                                                out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(6)) + "</b></td>");
                                                out.println("<td align='right'> <b>" + twoDForm.format(sqlSel2.getDouble(7)) + "</b></td>");
                                                if (AccName == 1) {
                                                    out.println("<td> </td>");
                                                }
                                                out.println("</tr>");
                                            }
                                            sqlSel2.close();
                                            stmt2.close();
                                        }

                                        session.setAttribute("data", data);
                                        session.setAttribute("columns", columns);

                                        //  sonluq cemin sonu
                                    %>

                                </table>
                                <!---- CEDVEL SONU   --------------------------------------->
                            </td>
                        </tr>
                        <tr>

                            <td width="880">
                                <div align="left">
                                    <% out.println(footer.ftSign());
                                        sqlSel.close();
                                        stmt.close();
                                        dbConnection.close();
                                    %>
                                </div>
                            </td>
                        </tr>

                    </table>

                </td>
                <td align="right" valign="top">
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
                    <FORM  method="post" action="RestTurnOverExcel" name="post">
                        <input type="submit" name="excel" value="Excel-ə at" class="NonPrintable">
                    </FORM>
                </td>
            </tr>    
        </table>        
    </body>
</html>
