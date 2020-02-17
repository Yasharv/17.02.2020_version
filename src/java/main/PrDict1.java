/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author m.aliyev
 */
public class PrDict1 {

    public String ftSign() {
        return "<font size='4' face='Times new roman'> Copyright © 2012-2013 Software Development Department ExpressBank OJSC. All rights reserved. </font>";
        //    +" <p>Mahmud Aliyev tərəfindən tərtib olunmuşdur</p> ";
    }

    public String lMenu(String uname, String br) throws UnknownHostException {
        String Query = "?uname=" + uname + "&br=" + br;
        tMenu menu = new tMenu();

        int c = 0;
        int menusize = 0;
        String[][] menu_list = null;
        try {
            menu_list = menu.getMenu(uname);
            menusize = menu_list.length;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(PrDict.class.getName()).log(Level.SEVERE, null, ex);
        }

        String ret_value = "<font size='3' face= 'Times New Roman' >" //Trebuchet MS
                + " <p> &ensp;  <BR>";
        StringBuilder a = new StringBuilder();
        a.append(ret_value);

        while (c < menusize) {
            a.append(" <A href='" + menu_list[c][1] + Query + "'> " + menu_list[c][0] + "</A> <BR>");
            c++;
        }
        a.append("</p></font>");
        return a.toString();
    }

    public String lAdminMenu(String uname) {
        String Query = "?uname=" + uname;
        return " <font size='3' face= 'Times New Roman' >" //Trebuchet MS
                + " <p> &ensp;  <BR>"
                + " <A href='index.jsp?" + uname + "'> Ana səhifə </A> <BR>"
                + " <A href='AdminMain.jsp" + Query + "'> Administration </a> <BR>"
                + " <A href='AdminUsers.jsp" + Query + "'> İstifadəçilər </a> <BR>"
                + " <A href='CheckBalance.jsp" + Query + "'> Balansı yoxla </a> <BR>"
                + " <A href='MDRReport.jsp" + Query + "'> MDR Hesabatı </a> <BR>"
                + " <A href='ITDept.jsp" + Query + "'> IT Tasks </a> <BR>"
                + " <A href='MenuSettings.jsp" + Query + "&menuNAME=ADMIN'> Menyu sazlamaları </a> <BR>"
                + " <A href='EStatement.jsp" + Query + "'> Mail Statement </a> </p>"
                + " <A href='http://172.17.81.161:8080/OnPayAdmin/'> Online Kredit Admin </a> </p>"
                + "</font>";
    }

    public String SelValute() {
        return "    <option value='944'>AZN</option>"
                + " <option value='978'>EUR</option>"
                + " <option value='840'>USD</option>"
                + " <option value='826'>GBP</option>"
                + " <option value='643'>RUB</option>"
                + " <option value='392'>JPY</option>"
                + " <option value='756'>CHF</option>"
                + " <option value='949'>TRY</option>";
    }

    public String CheckValuteDeb() {
        return " <input type='checkbox' name='DebVal' value='944'>AZN " //<br>
                + " <input type='checkbox' name='DebVal' value='978'>EUR"
                + " <input type='checkbox' name='DebVal' value='840'>USD"
                + " <input type='checkbox' name='DebVal' value='826'>GBP"
                + " <input type='checkbox' name='DebVal' value='643'>RUB"
                + " <input type='checkbox' name='DebVal' value='392'>JPY"
                + " <input type='checkbox' name='DebVal' value='756'>CHF"
                + " <input type='checkbox' name='DebVal' value='949'>TRY";
    }

    public String CheckValuteCred() {
        return " <input type='checkbox' name='CredVal' value='944'>AZN " //<br>
                + " <input type='checkbox' name='CredVal' value='978'>EUR"
                + " <input type='checkbox' name='CredVal' value='840'>USD"
                + " <input type='checkbox' name='CredVal' value='826'>GBP"
                + " <input type='checkbox' name='CredVal' value='643'>RUB"
                + " <input type='checkbox' name='CredVal' value='392'>JPY"
                + " <input type='checkbox' name='CredVal' value='756'>CHF"
                + " <input type='checkbox' name='CredVal' value='949'>TRY";
    }

    public String CheckValute() {
        return " <input type='checkbox' name='azn' value='944' checked=true >AZN" //<br>
                + " <input type='checkbox' name='eur' value='978'>EUR"
                + " <input type='checkbox' name='usd' value='840'>USD"
                + " <input type='checkbox' name='gbp' value='826'>GBP"
                + " <input type='checkbox' name='rub' value='643'>RUB"
                + " <input type='checkbox' name='jpy' value='392'>JPY"
                + " <input type='checkbox' name='chf' value='756'>CHF"
                + " <input type='checkbox' name='chf' value='949'>TRY";
    }

    public String SelFilial(int user_fil, int all_br) {
        String[] StrArray;
        StrArray = new String[1000];

        StrArray[100] = "<option value='100'>Baş Ofis</option>";
        StrArray[101] = "<option value='101'>Yasamal filialı</option>";
        StrArray[102] = "<option value='102'>Qaradağ filialı</option>";
        StrArray[103] = "<option value='103'>Elmlər filialı</option>";
        StrArray[104] = "<option value='104'>Mərkəz filialı</option>";
        StrArray[105] = "<option value='105'>Nəsimi filialı</option>";
        StrArray[106] = "<option value='106'>Neftçilər filialı</option>";
        StrArray[107] = "<option value='107'>Nərimanov filialı</option>";
        StrArray[108] = "<option value='108'>Xətai filialı</option>";
        StrArray[109] = "<option value='109'>Əhmədli filialı</option>";
        StrArray[200] = "<option value='200'>Sumqayıt filialı</option>";
        StrArray[203] = "<option value='203'>Şərq filialı</option>";
        StrArray[204] = "<option value='204'>4 saylı Sumqayıt şöbəsi</option>";
        StrArray[300] = "<option value='300'>Xaçmaz filialı</option>";
        StrArray[301] = "<option value='301'>Qusar filialı</option>";
        StrArray[500] = "<option value='500'>Şirvan filialı</option>";
        StrArray[600] = "<option value='600'>Mingəçevir filialı</option>";
        StrArray[800] = "<option value='800'>Gəncə filialı</option>";
        StrArray[900] = "<option value='900'>Bərdə filialı</option>";

        String AllBranch = "<option value=\"0\">Bütün filiallar</option>  "
                + " <option value='100'>Baş Ofis</option>"
                + " <option value='101'>Yasamal filialı</option>"
                + " <option value='102'>Qaradağ filialı</option>"
                + " <option value='103'>Elmlər filialı</option>"
                + " <option value='104'>Mərkəz filialı</option>"
                + " <option value='105'>Nəsimi filialı</option>"
                + " <option value='106'>Neftçilər filialı</option>"
                + " <option value='107'>Nərimanov filialı</option>"
                + " <option value='108'>Xətai filialı</option>"
                + " <option value='109'>Əhmədli filialı</option>"
                + " <option value='200'>Sumqayıt filialı</option>"
                + " <option value='203'>Şərq filialı</option>"
                + " <option value='204'>4 saylı Sumqayıt şöbəsi</option>"
                + " <option value='300'>Xaçmaz filialı</option>"
                + " <option value='301'>Qusar filialı</option>"
                + " <option value='500'>Şirvan filialı</option>"
                + " <option value='600'>Mingəçevir filialı</option>"
                + " <option value='800'>Gəncə filialı</option>"
                + " <option value='900'>Bərdə filialı</option>";
        if (user_fil == 0) {
            return AllBranch;
        } else if (all_br == 1) {
            return "<option value=\"0\">Bütün filiallar</option>  " + StrArray[user_fil];
        } else if (all_br == 2) {
            return " <option value=\"\"> </option>  " + StrArray[user_fil];
        } else {
            return StrArray[user_fil];
        }
    }

    public String ChkDebFil(int user_fil, int all_br) {
        String[] StrArray;
        StrArray = new String[1000];

        StrArray[0] = " <input type='checkbox' name='DebAllFilials' value='0' onClick=\"checkDebAll(document.post.DebFilial)\">Bütün Filiallar";
        StrArray[100] = "<input type='checkbox' name='DebFilial' value='100'>Baş Ofis";
        StrArray[101] = "<input type='checkbox' name='DebFilial' value='101'>Yasamal filialı";
        StrArray[102] = "<input type='checkbox' name='DebFilial' value='102'>Qaradağ filialı";
        StrArray[103] = "<input type='checkbox' name='DebFilial' value='103'>Elmlər filialı";
        StrArray[104] = "<input type='checkbox' name='DebFilial' value='104'>Mərkəz filialı";
        StrArray[105] = "<input type='checkbox' name='DebFilial' value='105'>Nəsimi filialı";
        StrArray[106] = "<input type='checkbox' name='DebFilial' value='106'>Neftçilər filialı";
        StrArray[107] = "<input type='checkbox' name='DebFilial' value='107'>Nərimanov filialı";
        StrArray[108] = "<input type='checkbox' name='DebFilial' value='108'>Xətai filialı";
        StrArray[109] = "<input type='checkbox' name='DebFilial' value='109'>Əhmədli filialı";
        StrArray[200] = "<input type='checkbox' name='DebFilial' value='200'>Sumqayıt filialı";

        StrArray[203] = "<input type='checkbox' name='DebFilial' value='203'>Şərq filialı";
        StrArray[204] = "<input type='checkbox' name='DebFilial' value='204'>4 saylı Sumqayıt şöbəsi";
        StrArray[300] = "<input type='checkbox' name='DebFilial' value='300'>Xaçmaz filialı";
        StrArray[301] = "<input type='checkbox' name='DebFilial' value='301'>Qusar filialı";
        StrArray[500] = "<input type='checkbox' name='DebFilial' value='500'>Şirvan filialı";
        StrArray[600] = "<input type='checkbox' name='DebFilial' value='600'>Mingəçevir filialı";
        StrArray[800] = "<input type='checkbox' name='DebFilial' value='800'>Gəncə filialı";
        StrArray[900] = "<input type='checkbox' name='DebFilial' value='900'>Bərdə filialı";
        String AllBranch = StrArray[0] + "<br>" + StrArray[100] + "<br>" + StrArray[101] + "<br>" + StrArray[102] + "<br>"
                + StrArray[103] + "<br>" + StrArray[104] + "<br>" + StrArray[105] + "<br>" + StrArray[106] + "<br>"
                + StrArray[107] + "<br>" + StrArray[108] + "<br>" + StrArray[109] + "<br>" + StrArray[200] + "<br>" + StrArray[203] + "<br>" + StrArray[204] + "<br>"
                + StrArray[300] + "<br>" + StrArray[301] + "<br>" + StrArray[500] + "<br>" + StrArray[600] + "<br>" + StrArray[800] + "<br>" + StrArray[900];

        if (user_fil == 0) {
            return AllBranch;
        } else if (all_br == 1) {
            return StrArray[user_fil];
        } else {
            return StrArray[user_fil];
        }
    }

    public String ChkKredFil(int user_fil, int all_br) {
        String[] StrArray;
        StrArray = new String[1000];

        StrArray[0] = " <input type='checkbox' name='KredAllFilials' value='0' onClick=\"checkKredAll(document.post.KredFilial)\">Bütün Filiallar";
        StrArray[100] = "<input type='checkbox' name='KredFilial' value='100'>Baş Ofis";
        StrArray[101] = "<input type='checkbox' name='KredFilial' value='101'>Yasamal filialı";
        StrArray[102] = "<input type='checkbox' name='KredFilial' value='102'>Qaradağ filialı";
        StrArray[103] = "<input type='checkbox' name='KredFilial' value='103'>Elmlər filialı";
        StrArray[104] = "<input type='checkbox' name='KredFilial' value='104'>Mərkəz filialı";
        StrArray[105] = "<input type='checkbox' name='KredFilial' value='105'>Nəsimi filialı";
        StrArray[106] = "<input type='checkbox' name='KredFilial' value='106'>Neftçilər filialı";
        StrArray[107] = "<input type='checkbox' name='KredFilial' value='107'>Nərimanov filialı";
        StrArray[108] = "<input type='checkbox' name='KredFilial' value='108'>Xətai filialı";
        StrArray[109] = "<input type='checkbox' name='KredFilial' value='109'>Əhmədli filialı";
        StrArray[200] = "<input type='checkbox' name='KredFilial' value='200'>Sumqayıt filialı";

        StrArray[203] = "<input type='checkbox' name='KredFilial' value='203'>Şərq filialı";
        StrArray[204] = "<input type='checkbox' name='KredFilial' value='204'>4 saylı Sumqayıt şöbəsi";
        StrArray[300] = "<input type='checkbox' name='KredFilial' value='300'>Xaçmaz filialı";
        StrArray[301] = "<input type='checkbox' name='KredFilial' value='301'>Qusar filialı";
        StrArray[500] = "<input type='checkbox' name='KredFilial' value='500'>Şirvan filialı";
        StrArray[600] = "<input type='checkbox' name='KredFilial' value='600'>Mingəçevir filialı";
        StrArray[800] = "<input type='checkbox' name='KredFilial' value='800'>Gəncə filialı";
        StrArray[900] = "<input type='checkbox' name='KredFilial' value='900'>Bərdə filialı";
        String AllBranch = StrArray[0] + "<br>" + StrArray[100] + "<br>" + StrArray[101] + "<br>" + StrArray[102] + "<br>"
                + StrArray[103] + "<br>" + StrArray[104] + "<br>" + StrArray[105] + "<br>" + StrArray[106] + "<br>"
                + StrArray[107] + "<br>" + StrArray[108] + "<br>" + StrArray[109] + "<br>" + StrArray[200] + "<br>" + StrArray[203] + "<br>" + StrArray[204] + "<br>"
                + StrArray[300] + "<br>" + StrArray[301] + "<br>" + StrArray[500] + "<br>" + StrArray[600] + "<br>" + StrArray[800] + "<br>" + StrArray[900];

        if (user_fil == 0) {
            return AllBranch;
        } else if (all_br == 1) {
            return StrArray[user_fil];
        } else {
            return StrArray[user_fil];
        }
    }

    public String SelCashSimvol() {
        return "<option value='0'>Bütün simvollar</option> ";
    }

    public String SelUsers() throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select user_dao,sign_on_name from dwh_users order by sign_on_name";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserSel.next()) {
            text = text + " <option value='" + sqlUserSel.getString(1) + "'>" + sqlUserSel.getString(2) + "</option>";
        };

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return text;
    }

    public String SelUsers1() throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select user_dao, user_id from DI_T24_USER   WHERE DATE_UNTIL = '01-JAN-3000'  order by user_id";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserSel.next()) {
            text = text + " <option value='" + sqlUserSel.getString(1) + "'>" + sqlUserSel.getString(2) + "</option>";
        };

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return text;
    }

    public String getFililal(int filial_id) {
        String[] StrArray;
        StrArray = new String[1000];

        StrArray[0] = " ";
        StrArray[100] = "Expressbank ASC";
        StrArray[101] = "Yasamal filialı";
        StrArray[102] = "Qaradağ filialı";
        StrArray[103] = "Elmlər filialı";
        StrArray[104] = "Mərkəz filialı";
        StrArray[105] = "Nəsimi filialı";
        StrArray[106] = "Neftçilər filialı";
        StrArray[107] = "Nərimanov filialı";
        StrArray[108] = "Xətai filialı";
        StrArray[109] = "Əhmədli filialı";
        StrArray[200] = "Sumqayıt filialı";

        StrArray[203] = "Şərq filialı";
        StrArray[204] = "4 saylı Sumqayıt şöbəsi";
        StrArray[300] = "Xaçmaz filialı";
        StrArray[301] = "Qusar filialı";
        StrArray[500] = "Şirvan filialı";
        StrArray[600] = "Mingəçevir filialı";
        StrArray[800] = "Gəncə filialı";
        StrArray[900] = "Bərdə filialı";

        return StrArray[filial_id];
    }

    public String getFililal4Statm(int filial_id) {
        String[] StrArray;
        StrArray = new String[1000];

        StrArray[0] = " ";
        StrArray[100] = "Expressbank ASC";
        StrArray[101] = "Yasamal filialı";
        StrArray[102] = "Qaradağ filialı";
        StrArray[103] = "Elmlər filialı";
        StrArray[104] = "Mərkəz filialı";
        StrArray[105] = "Nəsimi filialı";
        StrArray[106] = "Neftçilər filialı";
        StrArray[107] = "Nərimanov filialı";
        StrArray[108] = "Xətai filialı";
        StrArray[109] = "Əhmədli filialı";
        StrArray[200] = "Sumqayıt filialı";

        StrArray[203] = "Şərq filialı";
        StrArray[204] = "4 saylı Sumqayıt şöbəsi";
        StrArray[300] = "Xaçmaz filialı";
        StrArray[301] = "Qusar filialı";
        StrArray[500] = "Şirvan filialı";
        StrArray[600] = "Mingəçevir filialı";
        StrArray[800] = "Gəncə filialı";
        StrArray[900] = "Bərdə filialı";

        return StrArray[filial_id];
    }

    public String SelUserInfo(String uname, int vfield) throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select user_dao,user_id,sign_on_name, user_branch,all_filials,salary_acc "
                + " from dwh_users where user_id='" + uname + "' order by sign_on_name";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserSel.next()) {
            text = sqlUserSel.getString(vfield);
        };

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return text;
    }

    public String getBankInfo(int fil_id) throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        if (fil_id == 0) {
            fil_id = 100;
        }
        Statement stmt = conn.createStatement();
        String SqlQuery = "SELECT a.kod_b, a.sedr,a.buhaltr,a.managertitle,a.accountanttitle FROM bankinfo_t a where a.kod_b=" + fil_id;
        ResultSet sqlSel = stmt.executeQuery(SqlQuery);

        String sedr = "";
        String buxalter = "";
        String managertitle = "";
        String accountanttitle = "";
        while (sqlSel.next()) {
            sedr = sqlSel.getString(2);
            buxalter = sqlSel.getString(3);
            managertitle = sqlSel.getString(4);
            accountanttitle = sqlSel.getString(5);
        };

        sqlSel.close();
        stmt.close();
        conn.close();

        String text = "         <table  bgcolor='white' border='0' width='900'>\n"
                + "    <tr>"
                + "     <td width=\"642\"  align=\"left\">"
                + "         <p>  <font size=\"4\">"
                + "             &emsp;&emsp;&emsp; " + managertitle
                + "             </font>"
                + "         </p>"
                + "         <p>  <font size=\"4\">"
                + "             &emsp;&emsp;&emsp; " + accountanttitle
                + "             </font>"
                + "         </p>"
                + "     </td> "
                + "     <td width=\"642\"  align=\"center\">"
                + "     </td>"
                + "     <td width=\"642\"  align=\"left\">"
                + "        <p>  <font size=\"4\">"
                + "             &emsp;&emsp;&emsp;" + sedr
                + "             </font>"
                + "         </p>"
                + "         <p>  <font size=\"4\">"
                + "             &emsp;&emsp;&emsp;" + buxalter
                + "             </font>"
                + "         </p> "
                + "     </td>"
                + "    </tr>"
                + "    </table>";
        return text;
    }

    public String getValute(int val_id) {
        String[] StrArray;
        StrArray = new String[1000];

        StrArray[0] = " Bütün valyutalar";
        StrArray[944] = "AZN";
        StrArray[978] = "EUR";
        StrArray[840] = "USD";
        StrArray[826] = "GBP";
        StrArray[643] = "RUB";
        StrArray[392] = "JPY";
        StrArray[756] = "CHF";
        StrArray[949] = "TRY";
        return StrArray[val_id];
    }

    public String getDate() {
        Date d = new Date();
        Format formatter;
        formatter = new SimpleDateFormat("dd-MM-yyyy");
        return formatter.format(d);
    }

    public String UserDao(int br) throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";
        String SqlWhere = "";

        Statement stmtUser = conn.createStatement();
        if (br != 0) {
            SqlWhere = " where user_branch=" + br;
        }
        String SqlUserQuery = "select distinct user_id from di_t24_user " + SqlWhere + " order by user_ID";
        ResultSet sqlUserDao = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserDao.next()) {
            text = text + " <option value='" + sqlUserDao.getString(1) + "'>" + sqlUserDao.getString(1) + "</option>";
        };

        sqlUserDao.close();
        stmtUser.close();
        conn.close();
        return text;
    }

    public String LoanProducts() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        String SqlQuery = "SELECT product_id,az_description FROM di_loan_product where date_until='01-JAN-3000' order by product_id";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString(1) + "'>" + rs.getString(1) + " " + rs.getString(2) + "</option>";
            };
        } catch (SQLException ex) {
            //   System.out.println(ex.toString());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(PrDict.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return text;
    }

    public String UserIDWithDao(int br) throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";
        String SqlWhere = "";

        Statement stmtUser = conn.createStatement();
        if (br != 0) {
            SqlWhere = " and user_branch=" + br;
        }
        String SqlUserQuery = "select user_dao,user_id from di_t24_user where date_until='01-JAN-3000' " + SqlWhere + " order by user_ID";
        ResultSet sqlUserDao = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserDao.next()) {
            text = text + " <option value='" + sqlUserDao.getString(1) + "'>" + sqlUserDao.getString(2) + "</option>";
        };

        sqlUserDao.close();
        stmtUser.close();
        conn.close();
        return text;
    }

}
