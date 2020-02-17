<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page import="DBUtility.DataSource"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSetMetaData"%>
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

            @media print {
                a[href]:after {
                    content: none !important;
                }
            }

        </style>
        <style type="text/css">
            .repform.table { page-break-inside:auto}
            .repform.tr {page-break-inside:avoid; page-break-after:auto}
        </style>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->


        <%
            /*Added by Ceyhun 01.08.2019 */
            DataSource dataSource = new DataSource();
            Connection conn = null;
            conn = dataSource.getConnection();
            
            String queryStatus = null;
            String condStatus = null;
            
            String repFormValArr[] = null;
            String repFormVal = "";
            String curValue = "";
            String filialCode = null;
            
            WorkDatabase wd = new WorkDatabase();

            Object[] array = new Object[5];
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            
            //Added by Ceyhun 01.08.2019 
            
            Date d = new Date();
            DecimalFormat df = new DecimalFormat("0.00");
            PrDict dict = new PrDict();

            SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
       
            int RepForm = Integer.parseInt(request.getParameter("RepForm"));
            String strDateB = request.getParameter("TrDateB");

            String Filial = request.getParameter("Filial");
            String RepValue = request.getParameter("RepVal");
            String Valute = request.getParameter("Valute");
            String BalType = request.getParameter("BalType");
            int RepType = Integer.parseInt(request.getParameter("RepType"));
            
            /* Added by Ceyhun 01.08.2019 */
            
            if (RepValue != null) 
            {
                if (RepValue.trim().isEmpty()) 
                {
                    repFormVal = "";
                } 
                else 
                {
                    repFormValArr = RepValue.split(",");
                    for (int i = 0; i < repFormValArr.length; i++) 
                    {
                        repFormVal = repFormVal + ",'" + repFormValArr[i] + "'";
                    }
                    repFormVal = repFormVal.substring(1);
                }
            }
            
            if (Filial != null && !Filial.trim().equals("")) 
            {
                    filialCode = Filial.equals("0") ? "" : Filial; 
            }
            // Added by Ceyhun 01.08.2019
            
            String user_name = request.getParameter("uname");
            String user_branch = request.getParameter("br");

            String title = "";
            if (RepForm == 0) {
                title = "Qalıq balansı";
            }
            if (RepForm == 1) {
                title = "Qalıq-Dövriyyə balansı";
            }

            Date dateB = format.parse(strDateB);
            strDateB = format2.format(dateB);
            
            if (!(Valute.equals("0"))) 
            { 
                curValue = Valute;
            } 
            else 
            {
                BalType = "1";
            }

           if (RepType == 1) 
            {
                queryStatus = "1";
                condStatus = "1";
            } 
            else 
            {
                queryStatus = "2";
                condStatus = "2";
            }

            String ParamsValue = "datesintervals=to_date('" + strDateB.trim() + "','yyyy-mm-dd') and to_date('" + strDateB.trim() + "','yyyy-mm-dd')/"
                               + "dateuntilvalue=to_date('" + strDateB.trim() + "','yyyy-mm-dd')/"
                               + "datefromvalue=to_date('" + strDateB.trim() + "','yyyy-mm-dd')/"
                               + "infb_date_until_value=to_date('" + strDateB.trim() + "','yyyy-mm-dd')/"
                               + "infb_date_from_value=to_date('" + strDateB.trim() + "','yyyy-mm-dd')/"
                               + "gl_acct_no=" + repFormVal + "/"
                               + "filialcode=" + filialCode + "/"
                               + "currencyid=" + curValue;
            
            array[0] = 6;
            array[1] = queryStatus;
            array[2] = condStatus;
            array[3] = ParamsValue;
            array[4] = user_name;
            
            Statement stmt = conn.createStatement();
            ResultSet sqlres = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, conn);
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
                            <td>

                                <table bgcolor='white' border='0' width="900">
                                    <tr>
                                        <td align="left"> <font size="5"> "Expressbank" ASC <% out.println(dict.getFililal4Statm(Integer.parseInt(Filial)));%> </font> <br> VÖEN: 1500031691</td>
                                    </tr>  
                                    <tr>
                                        <td align="center"> <font size="5"> <% out.println(title);%> </font> </td>
                                    </tr> 
                                    <tr>
                                        <td align="center">
                                            <font size="4"> 
                                            <%
                                                String strDateB2 = format.format(dateB);
                                                out.println(strDateB2);
                                            %> 
                                            </font>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td align="center"> <font size="4"> <% out.println(dict.getValute(Integer.parseInt(Valute))); %> </font> </td>
                                    </tr> 


                                </table>
                                <table bgcolor='white' border='1' width="900" cellpadding="1" cellspacing="0" class="repform">
                                    <tr>
                                        <th rowspan="2" width="30" align="center"> Balans Nömrəsi </th>  
                                            <%
                                                if (RepForm == 0) {
                                                    out.println("<th colspan='2' width='300' align='center'> QALIQLAR </th>");
                                                }
                                                if (RepForm == 1) {
                                                    out.println("<th colspan='2' width='300' align='center'> Dövriyyələr </th>");
                                                    out.println("<th colspan='2' width='300' align='center'> Son qalıqlar </th>");
                                                }
                                            %>

                                    </tr> 
                                    <tr> 
                                        <%
                                            if (RepForm == 0) {
                                                out.println("<th width='100' align='center'> Aktiv </th>  <th width='100' align='center'> Passiv </th>");
                                            }
                                            if (RepForm == 1) {
                                                out.println("<th width='100' align='center'> Debet </th>  <th width='100' align='center'> Kredit </th>");
                                                out.println("<th width='100' align='center'> Aktiv </th>  <th width='100' align='center'> Passiv </th>");
                                            };
                                        %>
                                    </tr> 
                                    <%
                                        String BalCn = "";
                                        double DDovr = 0;
                                        double KDovr = 0;
                                        double Aktiv = 0;
                                        double Passiv = 0;
                                        double SumAktiv = 0;
                                        double SumPassiv = 0;
                                        double SumDebt = 0;
                                        double SumKred = 0;
                                        String emps = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                        String emps2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

                                        ResultSetMetaData rsmd = sqlres.getMetaData();

                                        Map data = new HashMap();
                                        int a = 0;
                                        while (sqlres.next()) {
                                            a++;
                                            Map row = new HashMap();
                                            for (int col = 1; col <= rsmd.getColumnCount(); col++) {
                                                row.put(col, sqlres.getString(col));

                                            }

                                            for (int col = 1; col <= rsmd.getColumnCount(); col++) {
                                                row.put(col, sqlres.getString(col));

                                            }
                                            data.put(a, row);

                                            out.print("<tr class=\"repform\">");

                                            BalCn = sqlres.getString(1);  //gl_acct_no
                                            if (BalType.equals("0")) {
                                                DDovr = sqlres.getDouble(4);  //dt_dovriye
                                                SumDebt = SumDebt + DDovr;
                                                KDovr = sqlres.getDouble(5);  //cr_dovriye
                                                SumKred = SumKred + KDovr;
                                                Aktiv = sqlres.getDouble(8); //aktivval
                                                SumAktiv = SumAktiv + Aktiv;
                                                Passiv = sqlres.getDouble(9); // epassivval
                                                SumPassiv = SumPassiv + Passiv;
                                            } else {
                                                DDovr = sqlres.getDouble(2); //dt_dovriye_val
                                                SumDebt = SumDebt + DDovr;
                                                KDovr = sqlres.getDouble(3); //cr_dovriye_val
                                                SumKred = SumKred + KDovr;
                                                Aktiv = sqlres.getDouble(6); //aktiv
                                                SumAktiv = SumAktiv + Aktiv;
                                                Passiv = sqlres.getDouble(7); // passiv
                                                SumPassiv = SumPassiv + Passiv;

                                            }

                                            out.println("<td align='center'>" + BalCn + "</td>");
                                            if (RepForm == 1) {
                                                out.println("<td align='right'>" + df.format(DDovr) + emps2 + "</td>");
                                                out.println("<td align='right'>" + df.format(KDovr) + emps2 + "</td>");
                                                out.println("<td align='right' >" + df.format(Aktiv) + emps + emps + "</td>");
                                                out.println("<td align='right' >" + df.format(Passiv) + emps + emps + "</td>");
                                            } else {
                                                out.println("<td align='right' >" + df.format(Aktiv) + emps + emps + emps + emps + "</td>");
                                                out.println("<td align='right' >" + df.format(Passiv) + emps + emps + emps + emps + "</td>");
                                            }
                                            out.print("</tr>");
                                        }

                                        session.setAttribute("data", data);

                                    %>
                                    <tr>
                                        <th align="center"> <font size="4">Cəmi: </font></th> 
                                            <%                                                if (RepForm == 1) {
                                                    out.println("<th align='right'>" + df.format(SumDebt) + "</th>" + "<th align='right'>" + df.format(SumKred) + "</th>");
                                                };
                                                out.println("<th align='right'>" + df.format(SumAktiv) + "</th>" + "<th align='right'>" + df.format(SumPassiv) + "</th>");
                                            %>        
                                    </tr>
                                </table>
                                <%
                                    out.println(dict.getBankInfo(Integer.parseInt(user_branch)));
                                    if (sqlres != null)
                                    {
                                        sqlres.close();
                                    }
                                    
                                    if (stmt != null)
                                    {
                                        stmt.close();
                                    }
                                    
                                    if (conn != null)
                                    {
                                        conn.close();
                                    }
                                %>
                            </td>
                    </table> 

                </td>
                <td valign="top" align="right">   
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
                    <FORM  method="post" action="TodayBalExcel" name="post">

                        <input type="hidden" name="RepForm" value="<%out.print(RepForm);%>">
                        <input type="hidden" name="BalType" value="<%out.print(BalType);%>">   

                        <input type="submit" name="excel" value="Excel-ə at" class="NonPrintable">
                    </FORM>
                </td>
            </tr>    
        </table>
    </body>
</html>
