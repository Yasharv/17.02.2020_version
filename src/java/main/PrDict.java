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
public class PrDict {

    public String ftSign() {
        return "<font size='4' face='Times new roman'> Copyright © 2012-2017 Software Development Department ExpressBank OJSC. All rights reserved. </font>";
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
                + " <A href='ITDept.jsp" + Query + "'> Parol </a> <BR>"
                + " <A href='MenuSettings.jsp" + Query + "&menuNAME=ADMIN'> Menyu sazlamaları </a> <BR>"
                + " <A href='EStatement.jsp" + Query + "'> Mail Statement </a> </p>"
                + " <A href='http://172.17.81.161:8080/OnPayAdmin/'> Online Kredit Admin </a> </p>"
                + "</font>";
    }

    public String SelValute() throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray = null;
        StrArray = new String[1000];
        int i = 0;
        String text = "";
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select kod, name from CURRENCY_REPORTS  where kod<>0 ";
        ResultSet sqlValSel = stmtUser.executeQuery(SqlUserQuery);

        while (sqlValSel.next()) {

            text = text + "<option value='" + sqlValSel.getInt(1) + "'>" + sqlValSel.getString(2) + "</option>";
        }
        return text;
    }
    
    public String CheckValuteDeb() throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select kod, name from CURRENCY_REPORTS where kod<>0 ";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
        String AllBranch = "";
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<input type='checkbox' name='DebVal' value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2);
            AllBranch = AllBranch + StrArray[sqlUserSel.getInt(1)];
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();

        return AllBranch;
    }

    public String ExbCustMM() throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select t.name from dict_exb_cus_mm t";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserSel.next()) {
            text = text + " <option value='" + sqlUserSel.getString(1) + "'>" + sqlUserSel.getString(1) + "</option>";
        };

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return text;
    }
    
    public String SelCitizenship() throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select d.country_id,d.az_country_name from di_country d order by  d.country_id";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserSel.next()) {
            text = text + " <option value='" + sqlUserSel.getString(1) + "'>" + sqlUserSel.getString(1) + " - " + sqlUserSel.getString(2) + "</option>";
        };

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return text;
    }

    public String CheckValuteCred() throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select kod, name from CURRENCY_REPORTS  where kod<>0 ";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        String AllBranch = "";
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<input type='checkbox' name='CredVal' value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2);
            AllBranch = AllBranch + StrArray[sqlUserSel.getInt(1)];
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return AllBranch;
    }

    public String CheckValute() throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select kod,   name  from CURRENCY_REPORTS  where kod<>0 ";

        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        String AllCurrency = "";
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<input type='checkbox' name='" + sqlUserSel.getString(2).toLowerCase() + "' value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2);
            AllCurrency = AllCurrency + StrArray[sqlUserSel.getInt(1)];
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return AllCurrency;
    }
    
    public String CheckCategories() throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select category,name from vi_categories where status = '0' order by category ";

        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        String AllCategories = "";
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<input type='checkbox' name='" + sqlUserSel.getString(2) + "' value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2);
            AllCategories = AllCategories + StrArray[sqlUserSel.getInt(1)];
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return AllCategories;
    }
    
    public String SelFilial1() throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray = null;
        StrArray = new String[1000];
        int i = 0;
        String text = "<option value=\"0\">Bütün filiallar</option>";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select kod_b, bank1 from bankinfo_t order by 1";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<option value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2) + "</option>";
            text = text + "<option value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2) + "</option>";
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();

        return text;

    }

    public String SelFilial(int user_fil, int all_br) throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray = null;
        StrArray = new String[1000];
        int i = 0;
        String text = "<option value=\"0\">Bütün filiallar</option>";

        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = " select kod_b, bank1 from bankinfo_t order by 1";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<option value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2) + "</option>";
            text = text + "<option value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2) + "</option>";
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        if (user_fil == 0) {
            return text;
        } else if (all_br == 1) {
            return "<option value=\"0\">Bütün filiallar</option>  " + StrArray[user_fil];
        } else if (all_br == 2) {
            return " <option value=\"\"> </option>  " + StrArray[user_fil];
        } else {
            return StrArray[user_fil];
        }
    }

    public String ChkDebFil(int user_fil, int all_br) throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select kod_b, bank1 from bankinfo_t order by 1";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);
        StrArray[0] = " <input type='checkbox' name='DebAllFilials' value='0' onClick=\"checkDebAll(document.post.DebFilial)\">Bütün Filiallar";
        String AllBranch = StrArray[0];
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<input type='checkbox' name='DebFilial' value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2);

            AllBranch = AllBranch + "<br>" + StrArray[sqlUserSel.getInt(1)];
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();

        if (user_fil == 0) {
            return AllBranch;
        } else {
            return StrArray[user_fil];
        }
    }

    public String ChkKredFil(int user_fil, int all_br) throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select kod_b, bank1 from bankinfo_t order by 1";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        StrArray[0] = " <input type='checkbox' name='KredAllFilials' value='0' onClick=\"checkKredAll(document.post.KredFilial)\">Bütün Filiallar";
        String AllBranch = StrArray[0];
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = "<input type='checkbox' name='KredFilial' value='" + sqlUserSel.getInt(1) + "'>" + sqlUserSel.getString(2);
            AllBranch = AllBranch + "<br>" + StrArray[sqlUserSel.getInt(1)];
        }
        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        if (user_fil == 0) {
            return AllBranch;
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

    public String getFililal(int filial_id) throws ClassNotFoundException, SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();

        String[] StrArray;
        StrArray = new String[10000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select kod_b, bank1 from bankinfo_t order by 1";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        StrArray[0] = " ";
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = sqlUserSel.getString(2);

        }

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
        return StrArray[filial_id];
    }

    public String getFililal4Statm(int filial_id) throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();

        String[] StrArray;
        StrArray = new String[1000];
        Statement stmtUser = conn.createStatement();
        String SqlUserQuery = "select kod_b, bank1 from bankinfo_t order by 1";
        ResultSet sqlUserSel = stmtUser.executeQuery(SqlUserQuery);

        StrArray[0] = " ";
        while (sqlUserSel.next()) {
            StrArray[sqlUserSel.getInt(1)] = sqlUserSel.getString(2);

        }

        sqlUserSel.close();
        stmtUser.close();
        conn.close();
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

    public String getValute(int val_id) throws SQLException, UnknownHostException {

        DB db = new DB();
        Connection conn = db.connect();
        String[] StrArray;
        StrArray = new String[1000];
        int i = 0;
        Statement stmtUser = conn.createStatement();

        String SqlUserQuery = " select kod, name from CURRENCY_REPORTS where kod =   " + val_id;

        ResultSet sqlValSel = stmtUser.executeQuery(SqlUserQuery);

        sqlValSel.next();

        StrArray[sqlValSel.getInt(1)] = sqlValSel.getString(2);

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
    
    public String UserLoadFile(String userName) throws SQLException, UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String[] user_dao = null;
        String[] sign_on_name = null;
        int i = 0;
        String text = "";
        

        Statement stmtUser = conn.createStatement();
        
        String SqlUserQuery = "select r.report_id,r.report_name from fimp_reports r, fimp_users_import_file f where r.report_id = f.report_id and f.status = '0' and r.status = '0' and upper(f.user_name) = upper('" + userName + "') order by r.report_id";
        ResultSet sqlUserDao = stmtUser.executeQuery(SqlUserQuery);

        while (sqlUserDao.next()) {
            //System.out.println(sqlUserDao.getString(1));
            text = text + " <option value='" + sqlUserDao.getString(1) + "'>" + sqlUserDao.getString(1) + " " + sqlUserDao.getString(2) + "</option>";
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

        String SqlQuery = "select t.product_id,t.az_description from all_prduct_types t order by t.product_id";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString(1) + "'>" + rs.getString(1) + " " + rs.getString(2) + "</option>";
            };
        } catch (SQLException ex) {
            //    System.out.println(ex.toString());
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

    public String LoanProducts1() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        String SqlQuery = "SELECT product_id,az_description FROM di_loan_product where date_until='01-JAN-3000' and product_id in (803,809,883,889 )  order by product_id ";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString(1) + "'>" + rs.getString(1) + " " + rs.getString(2) + "</option>";
            };
        } catch (SQLException ex) {
            //    System.out.println(ex.toString());
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

    public String Country() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        String SqlQuery = "  select AZ_COUNTRY_NAME ,  COUNTRY_ID  from ST_XF_DWH.DI_COUNTRY   where date_until = '01-jan-3000' order by 1  ";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString(2) + "'>" + rs.getString(1) + "</option>";
            };
        } catch (SQLException ex) {
            //    System.out.println(ex.toString());
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
     
    public String alfaCodeCountry() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        String SqlQuery = "  select AZ_COUNTRY_NAME ,  alfa_code  from ST_XF_DWH.DI_COUNTRY   where date_until = '01-jan-3000' order by 1  ";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString(2) + "'>" + rs.getString(1) + "</option>";
            };
        } catch (SQLException ex) {
            //    System.out.println(ex.toString());
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
    
    public String bank() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        String SqlQuery = " select *  from ST_XF_DWH.SI_PERSON_BANK  where date_until = '01-jan-3000' and SWIFT_CODE is not null  order by 3  ";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString("SWIFT_CODE") + "'>" + rs.getString(5) + "</option>";
            };
        } catch (SQLException ex) {
            //    System.out.println(ex.toString());
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

    public String Mbank() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        String text = "";

        String SqlQuery = " select *  from ST_XF_DWH.SI_PERSON_BANK  where date_until = '01-jan-3000' order by 3  ";

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlQuery);

            while (rs.next()) {
                text = text + " <option value='" + rs.getString(5) + "'>" + rs.getString(5) + "</option>";
            };
        } catch (SQLException ex) {
            //    System.out.println(ex.toString());
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
    
    public String UserIDWithDaoAsanFinan(int br) throws SQLException, UnknownHostException {
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
            text = text + " <option value='" + sqlUserDao.getString(2) + "'>" + sqlUserDao.getString(2) + "</option>";
        };

        sqlUserDao.close();
        stmtUser.close();
        conn.close();
        return text;
    }

}
