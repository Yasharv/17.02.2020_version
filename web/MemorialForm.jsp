<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
--%>

<%@page import="main.PrDict"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="DBUtility.DataSource"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="main.DB"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <script type="text/javascript" language="javascript" charset="UTF-8">
            $(document).ready(function () {
                oTable = $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
                });
            });
            function validateForm()
            {
                var e = document.post.elements.length;
                var i = 0;
                var cnt = 0;
                for (i = 0; i < e; i++)
                {
                    if (document.post.elements[i].name == "ids") {
                        if (document.post.elements[i].checked)
                        {
                            cnt++;
                        }
                    }
                }
                if (cnt == 0) {
                    alert("Heç bir əməliyyat seçilməyib!");
                    return false;
                }

            }
            ;
            function checkAll(field)
            {
                var z = document.forms["post"]["chkall"].checked;

                if (z == true)
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = true;
                } else
                {
                    for (i = 0; i < field.length; i++)
                        field[i].checked = false;
                }

            }

        </script>
    </head>
    <body bgcolor=#E0EBEA>
    <center>
        <form method="post" action="MemRepPrint.jsp" name="post" target="_blank" onsubmit="return validateForm()">    
            <%
                response.setContentType("text/html; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                request.setCharacterEncoding("UTF-8");

                DataSource dataSource = new DataSource();
                Connection dbConnection = null;
                ResultSet rs = null;

                WorkDatabase wd = new WorkDatabase();

                Object[] array = new Object[5];
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;
                properties = rf.ReadConfigFile("StoredProcedureName.properties");

                DecimalFormat twoDForm = new DecimalFormat("0.00");

                String queryStatus = "1";
                String condStatus = "1";

                String debValueArr[] = null;
                String debValueParAcc = "";
                String debValueParBalans = "";

                String credValueArr[] = null;
                String credValueParAcc = "";
                String credValueParBalans = "";

                String debCategArr[] = null;
                String debCategParBalans = "";

                String credCategArr[] = null;
                String credCategParBalans = "";

                String condValue = null;

                DB db = new DB();
                Connection conn = db.connect();
                PrDict dict = new PrDict();

                String trType = "";
                String CategForSalary = "and nvl(vimemorall.debt_category,0)<>1200 and nvl(vimemorall.cred_category,0)<>1200";

                int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                int ANDOR = Integer.parseInt(request.getParameter("ANDOR"));
                int ANDOR_CR = Integer.parseInt(request.getParameter("ANDOR_CR"));

                String AndOrValue = null;
                String AndOrCategValue = null;
                String strDateB = request.getParameter("TrDateB");
                String strDateE = request.getParameter("TrDateE");
                String reval = request.getParameter("reval");
                String RepValDeb = request.getParameter("RepValDeb");
                String RepValKred = request.getParameter("RepValKred");
                String DebFil = request.getParameter("DebFil");
                String KredFil = request.getParameter("KredFil");
                int RepType = Integer.parseInt(request.getParameter("RepType"));
                int DebForm = Integer.parseInt(request.getParameter("DebForm"));
                int CredForm = Integer.parseInt(request.getParameter("CredForm"));
                String DebValue = request.getParameter("DebValue");
                String DebCateg = request.getParameter("DebCateg");
                String CredValue = request.getParameter("CredValue");
                String CredCateg = request.getParameter("CredCateg");
                String RepUser = request.getParameter("RepUser");
                String user_name = request.getParameter("uname");
                String user_branch = request.getParameter("br");

                Statement stmtUser = conn.createStatement();
                String SqlUserQuery = "select user_branch,all_filials,salary_acc from dwh_users where user_id='" + user_name + "'";
                ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

                int salary_acc = 0;
                String brForRep = "";
                while (sqlUserSel.next()) {
                    salary_acc = sqlUserSel.getInt(3);
                    brForRep = sqlUserSel.getString(1);

                }

                if (RepUser != null && !RepUser.trim().equals("")) {
                    RepUser = RepUser.equals("0") ? "" : RepUser;
                }

                if (sqlUserSel != null) {
                    sqlUserSel.close();
                }
                if (stmtUser != null) {
                    stmtUser.close();
                }

                if (conn != null) {
                    conn.close();
                }

                if (salary_acc == 1) {
                    CategForSalary = "";
                }

                if (reval == null || reval == "") {
                    trType = "'REVAL'";
                }

                if (DebValue != null) {
                    if (DebValue.trim().isEmpty()) {
                        debValueParAcc = "";
                        debValueParBalans = "";
                    } else {
                        debValueArr = DebValue.split(",");
                        for (int i = 0; i < debValueArr.length; i++) {
                            if (DebForm == 1) {
                                debValueParAcc = debValueParAcc + ",'" + debValueArr[i] + "'";
                            } else {
                                debValueParBalans = debValueParBalans + "," + debValueArr[i];
                            }
                        }

                        if (!(debValueParAcc == null || debValueParAcc.equals(""))) {
                            debValueParAcc = debValueParAcc.substring(1);
                        }

                        if (!(debValueParBalans == null || debValueParBalans.equals(""))) {
                            debValueParBalans = debValueParBalans.substring(1);
                        }
                    }
                }

                if (CredValue != null) {
                    if (CredValue.trim().isEmpty()) {
                        credValueParAcc = "";
                        credValueParBalans = "";
                    } else {
                        credValueArr = CredValue.split(",");
                        for (int i = 0; i < credValueArr.length; i++) {
                            if (CredForm == 2) {
                                credValueParBalans = credValueParBalans + "," + credValueArr[i];
                            } else {
                                credValueParAcc = credValueParAcc + ",'" + credValueArr[i] + "'";
                            }
                        }

                        if (!(credValueParAcc == null || credValueParAcc.equals(""))) {
                            credValueParAcc = credValueParAcc.substring(1);
                        }

                        if (!(credValueParBalans == null || credValueParBalans.equals(""))) {
                            credValueParBalans = credValueParBalans.substring(1);
                        }
                    }
                }

                if (DebCateg != null) {
                    if (DebCateg.trim().isEmpty()) {
                        debCategParBalans = "";
                    } else {
                        debCategArr = DebCateg.split(",");
                        for (int i = 0; i < debCategArr.length; i++) {
                            debCategParBalans = debCategParBalans + "," + debCategArr[i];
                        }
                        debCategParBalans = debCategParBalans.substring(1);
                    }
                }

                if (CredCateg != null) {
                    if (CredCateg.trim().isEmpty()) {
                        credCategParBalans = "";
                    } else {
                        credCategArr = CredCateg.split(",");
                        for (int i = 0; i < credCategArr.length; i++) {
                            credCategParBalans = credCategParBalans + "," + credCategArr[i];
                        }
                        credCategParBalans = credCategParBalans.substring(1);
                    }
                }

                if (RepValDeb != null) {
                    if (RepValDeb.trim().isEmpty()) {
                        RepValDeb = null;
                    }
                }

                if (RepValKred != null) {
                    if (RepValKred.trim().isEmpty()) {
                        RepValKred = null;
                    }
                }
                
                if (DebFil != null && DebFil != "" && !DebFil.trim().equals("")) 
                {
                    DebFil = DebFil.equals("0") ? "null" : DebFil; 
                }
                else
                {
                    DebFil = "null";
                }
                        

                if (KredFil != null && KredFil != "" && !KredFil.trim().equals("")) 
                {
                    KredFil = KredFil.equals("0") ? "null" : KredFil; 
                }
                else
                {
                    KredFil = "null";
                }
                
                if (ANDOR == 0 && (DebValue != null || !DebValue.trim().isEmpty())) {
                    AndOrValue = "and";
                } else if (ANDOR == 1 && (DebValue != null || DebValue.trim().isEmpty())) {
                    AndOrValue = "or";
                } else {
                    AndOrValue = "";
                }

                if ((ANDOR_CR == 0) && (!(DebCateg.equals("")))) {
                    AndOrCategValue = "and";
                } else if ((ANDOR_CR == 1) && (!(DebCateg.equals("")))) {
                    AndOrCategValue = "or";
                } else {
                    AndOrCategValue = "";
                }

                if (DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//1
                    condValue = "";
                } else if (!DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//2
                    if (DebForm == 1) {
                        condValue = "and vimemorall.acct_no_dt in (" + debValueParAcc + ")";
                    } else {
                        condValue = "and vimemorall.debt_balans in (" + debValueParBalans + ")";
                    }
                } else if (!DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//3
                    if (DebForm == 1) {
                        condValue = "and (vimemorall.acct_no_dt in (" + debValueParAcc + ") " + AndOrValue + " vimemorall.acct_no_cr in (" + credValueParAcc + "))";
                    } else {
                        condValue = "and (vimemorall.debt_balans in (" + debValueParBalans + ") " + AndOrValue + " vimemorall.kred_balans in (" + credValueParBalans + "))";
                    }
                } else if (!DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//4
                    if (DebForm == 1) {
                        condValue = "and (vimemorall.acct_no_dt in (" + debValueParAcc + ") " + AndOrValue + " vimemorall.acct_no_cr in (" + credValueParAcc + "))"
                                + "   and vimemorall.debt_category in (" + debCategParBalans + ")";
                    } else {
                        condValue = "and (vimemorall.debt_balans in (" + debValueParBalans + ") " + AndOrValue + " vimemorall.kred_balans in (" + credValueParBalans + "))"
                                + "   and vimemorall.debt_category in (" + debCategParBalans + ")";
                    }
                } else if (!DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && !CredCateg.trim().isEmpty()) {//5
                    if (DebForm == 1) {
                        condValue = "and (vimemorall.acct_no_dt in (" + debValueParAcc + ") " + AndOrValue + " vimemorall.acct_no_cr in (" + credValueParAcc + "))"
                                + "   and (vimemorall.debt_category in (" + debCategParBalans + ") " + AndOrCategValue + " vimemorall.cred_category in (" + credCategParBalans + ") )";
                    } else {
                        condValue = "and (vimemorall.debt_balans in (" + debValueParBalans + ") " + AndOrValue + " vimemorall.kred_balans in (" + credValueParBalans + "))"
                                + "   and (vimemorall.debt_category in (" + debCategParBalans + ") " + AndOrCategValue + " vimemorall.cred_category in (" + credCategParBalans + ") )";
                    }
                } else if (DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && !CredCateg.trim().isEmpty()) {//6
                    condValue = "   and (vimemorall.debt_category in (" + debCategParBalans + ") " + AndOrCategValue + " vimemorall.cred_category in (" + credCategParBalans + ") )";

                } else if (DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && !CredCateg.trim().isEmpty()) {//7
                    condValue = "and vimemorall.cred_category in (" + credCategParBalans + ")";
                } else if (!DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//8
                    if (DebForm == 1) {
                        condValue = "and vimemorall.acct_no_dt in (" + debValueParAcc + ") and vimemorall.debt_category in (" + debCategParBalans + ")";
                    } else {
                        condValue = "and vimemorall.debt_balans in (" + debValueParBalans + ") and vimemorall.debt_category in (" + debCategParBalans + ")";
                    }
                } else if (!DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && !CredCateg.trim().isEmpty()) {//9
                    if (DebForm == 1) {
                        condValue = "and vimemorall.acct_no_dt in (" + debValueParAcc + ") and vimemorall.cred_category in (" + credCategParBalans + ")";
                    } else {
                        condValue = "and vimemorall.debt_balans in (" + debValueParBalans + ") and vimemorall.cred_category in (" + credCategParBalans + ")";
                    }
                } else if (DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//10
                    if (CredForm == 2) {
                        condValue = "and vimemorall.kred_balans in (" + credValueParBalans + ")"; 
                    } else {
                        condValue = "and vimemorall.acct_no_cr in (" + credValueParAcc + ")";
                    }
                } else if (DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//11
                    if (CredForm == 2) {
                        condValue = "and vimemorall.kred_balans in (" + credValueParBalans + ") and vimemorall.debt_category in (" + debCategParBalans + ")";
                    } else {
                        condValue = "and vimemorall.acct_no_cr in (" + credValueParAcc + ") and vimemorall.debt_category in (" + debCategParBalans + ")";
                    }
                } else if (DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && !CredCateg.trim().isEmpty()) {//12
                    if (CredForm == 2) {
                        condValue = "and vimemorall.kred_balans in (" + credValueParBalans + ") and (vimemorall.debt_category in (" + debCategParBalans + ") "
                                + AndOrCategValue + " vimemorall.cred_category in (" + credCategParBalans + "))";
                    } else {
                        condValue = "and vimemorall.acct_no_cr in (" + credValueParAcc + ") and vimemorall.debt_category in (" + debCategParBalans + ") "
                                + AndOrCategValue + " vimemorall.cred_category in (" + credCategParBalans + "))";
                    }
                } else if (DebValue.trim().isEmpty()
                        && !CredValue.trim().isEmpty()
                        && DebCateg.trim().isEmpty()
                        && !CredCateg.trim().isEmpty()) {//13
                    if (CredForm == 2) {
                        condValue = "and vimemorall.kred_balans in (" + credValueParBalans + ") and vimemorall.cred_category in (" + credCategParBalans + ")";
                    } else {
                        condValue = "and vimemorall.acct_no_cr in (" + credValueParAcc + ") and vimemorall.cred_category in (" + credCategParBalans + ")";
                    }
                } else if (DebValue.trim().isEmpty()
                        && CredValue.trim().isEmpty()
                        && !DebCateg.trim().isEmpty()
                        && CredCateg.trim().isEmpty()) {//14
                    condValue = "and vimemorall.debt_category in (" + debCategParBalans + ")";
                }

                String ParamsValue = "datesintervals=to_date('" + strDateB.trim() + "','dd.mm.yyyy') and to_date('" + strDateE.trim() + "','dd.mm.yyyy')/"
                        + "dbfilialcode=" + DebFil + "/"
                        + "crfilialcode=" + KredFil + "/"
                        + "currencydtid=" + RepValDeb + "/"
                        + "currencycrid=" + RepValKred + "/"
                        + "revalval=" + trType + "/"
                        + "categforsalary=" + CategForSalary + "/"
                        + "inputter=" + RepUser + "/"
                        + "addcondition=" + condValue;

                switch (RepForm) {
                    case 0: {
                        if (RepType == 1) {
                            queryStatus = "1";
                            condStatus = "1";
                        } else {
                            queryStatus = "2";
                            condStatus = "2";
                        }
                        break;
                    }
                    case 1: {
                        if (RepType == 1) {
                            queryStatus = "3";
                            condStatus = "3";
                        } else {
                            queryStatus = "4";
                            condStatus = "4";
                        }
                        break;
                    }
                    
                    case 2: {
                        if (RepType == 1) {
                            queryStatus = "5";
                            condStatus = "5";
                        } else {
                            queryStatus = "6";
                            condStatus = "6";
                        }
                        break;
                    }
                    
                    case 3: {
                        if (RepType == 1) {
                            queryStatus = "1";
                            condStatus = "1";
                        } else {
                            queryStatus = "2";
                            condStatus = "2";
                        }
                        break;
                    }
                }
                
                array[0] = 3;
                array[1] = queryStatus;
                array[2] = condStatus;
                array[3] = ParamsValue;
                array[4] = user_name;

                dbConnection = dataSource.getConnection();
                rs = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, dbConnection);
                BigDecimal sumAmount = new BigDecimal("0.00");
                BigDecimal sumLAmount = new BigDecimal("0.00");
            %>
            <input type="hidden" name="f" value="<%out.print(brForRep);%>">
            <table cellpadding="0" cellspacing="0" border="0"  id="example" width="1350">
                <thead>
                    <tr>
                        <%
                            out.println("<th>" + " <input type='checkbox' name='chkall' onClick='checkAll(document.post.ids)'> " + "</th>");
                            out.println("<th>" + "TARIX" + "</th>");
                            out.println("<th>" + "DEBET" + "</th>");
                            out.println("<th>" + "DVAL" + "</th>");
                            out.println("<th>" + "DBAL" + "</th>");
                            out.println("<th>" + "KREDIT" + "</th>");
                            out.println("<th>" + "KVAL" + "</th>");
                            out.println("<th>" + "KBAL" + "</th>");
                            out.println("<th>" + "MEBLEG" + "</th>");
                            out.println("<th>" + "EKVIVALENT" + "</th>");
                            out.println("<th>" + "TEYINAT" + "</th>");
                            out.println("<th>" + "IB" + "</th>");
                            out.println("<th>" + "    " + "</th>");
                        %>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            out.println("<tr >");
                            out.println("<td width=25><input type='checkbox' name='ids' value='" + rs.getString(23) + "'> </td>");
                            //out.println("<td width=25><input type='hidden' name='uname' value='" + user_name + "'> </td>");
                            out.println("<td width=80>" + rs.getString(1).substring(0, 10) + "</td>");   //tarix                                  
                            out.println("<td width=250>" + rs.getString(2) + "</td>");                   //dhesab
                            out.println("<td width=40>" + rs.getString(3) + "</td>");                    //dval
                            out.println("<td width=50>" + rs.getString(4) + "</td>");                    //dbal
                            out.println("<td width=250>" + rs.getString(5) + "</td>");                   //kredit
                            out.println("<td width=40>" + rs.getString(6) + "</td>");                    //kval
                            out.println("<td width=60>" + rs.getString(7) + "</td>");                    //kbal
                            out.println("<td width=50>" + twoDForm.format(rs.getDouble(16)) + "</td>");  //mebleg
                            out.println("<td width=50>" + twoDForm.format(rs.getDouble(17)) + "</td>");  //ekvivalent
                            out.println("<td width=60>" + rs.getString(8) + "</td>");                    //teyinat
                            out.println("<td width=40>" + rs.getString(27) + "</td>");                   //IB
                            out.println("<td >" + "<a href='MemRepPrint.jsp?id=" + rs.getString(23) + "&brNum=" + user_branch + "&username=" + user_name +"&dtb=" + strDateB + "&dte=" + strDateE + "' target='_blank'>Print</a></td>");
                            out.println("</tr>");

                            sumAmount = sumAmount.add(rs.getBigDecimal(16));
                            sumLAmount = sumLAmount.add(rs.getBigDecimal(17));
                        }

                        if (dbConnection != null) {
                            dbConnection.close();
                        }

                        if (rs != null) {
                            rs.close();
                        }

                        if (conn != null) {
                            conn.close();
                        }

                        if (sqlUserSel != null) {
                            sqlUserSel.close();
                        }
                    %>
                </tbody>
                <tfoot>
                    <%
                        out.println("<th>" + "    " + "</th>");
                        out.println("<th>" + "TARIX" + "</th>");
                        out.println("<th>" + "DEBET" + "</th>");
                        out.println("<th>" + "DVAL" + "</th>");
                        out.println("<th>" + "DBAL" + "</th>");
                        out.println("<th>" + "KREDIT" + "</th>");
                        out.println("<th>" + "KVAL" + "</th>");
                        out.println("<th>" + "KBAL" + "</th>");
                        out.println("<th>" + "MEBLEG" + "</th>");
                        out.println("<th>" + "EKVIVALENT" + "</th>");
                        out.println("<th>" + "TEYINAT" + "</th>");
                        out.println("<th>" + "IB" + "</th>");
                        out.println("<th>" + "    " + "</th>");
                    %>
                </tfoot>
            </table>
            <table  border='1' width="100%" cellspacing="1">
                <tr>
                    <td>

                        <table  bgcolor='white' border='0' width='900'>
                            <tr>
                            <font size="4">
                            <td width="642"  align="left"> Cəmi: </td> 
                            <td width="118" align="right"> <% out.println(sumAmount);%></td>  
                            <td width="118" align="right"> <% out.println(sumLAmount);%></td>   
                            </font>
                </tr>
            </table>

            </td>
            <td>
                <input type="hidden" name="brNum" value='<%out.print(user_branch);%>'>
                <input type="hidden" name="dtb" value="<%out.print(strDateB);%>">
                <input type="hidden" name="dte" value="<%out.print(strDateE);%>">
                <input type="hidden" name="username" value="<%out.print(user_name);%>">

                <input type="submit" name="print" value="Print selected">
            </td>    
            </table>     
        </form>
    </center>
    <div align="left">
        <p>
            <%
                out.println(dict.ftSign());
            %>
        </p>
    </div>            
</body>
</html>
