package main;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author shahin
 */
public class Card_type {

    /**
     *
     * @param type
     * @param hamisi
     */
    public String fttype() {
        return "<font size='4' face='Times new roman'> Copyright © 2012-2013 Software Development Department ExpressBank OJSC. All rights reserved. </font>";
        //    +" <p>Mahmud Aliyev tərəfindən tərtib olunmuşdur</p> ";
    }

    public String ChkTypeCard(int type, int type1) throws UnknownHostException {
        ArrayList al = new ArrayList<String>();
        al = getProducts();
        String AllCARD = "";
        int i = 0;
        if (al != null) {

            AllCARD = " <input type='checkbox' name='ALLCARD' value='0' onClick=\"checkDebAll(document.post.DebFilial)\">Bütün Kartlar<br>";
            while (i < al.size()) {
                AllCARD = AllCARD + "<input type='checkbox' name='DebFilial' value='" + al.get(i) + "'>" + al.get(i) + "<br>";
                i++;
            }

        }
        return AllCARD;
    }

    public String ChkTypeCard1(int type, int type1) throws UnknownHostException {
        ArrayList al = new ArrayList<String>();
        al = getProducts1();
        String AllCARD = "";
        int i = 0;
        if (al != null) {

            AllCARD = " <input type='checkbox' name='ALLCARD' value='0' onClick=\"checkDebAll(document.post.DebFilial)\">Hamısı<br>";
            while (i < al.size()) {
                AllCARD = AllCARD + "<input type='checkbox' name='DebFilial' value='" + al.get(i) + "'>" + al.get(i) + "<br>";
                i++;
            }

        }
        return AllCARD;
    }

    private ArrayList<String> getProducts() throws UnknownHostException {
        DB db = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        ArrayList<String> al = new ArrayList<String>();
        String sql_text = "  SELECT DISTINCT TO_NCHAR(PRODUCT_ID ) F FROM SI_CARD_INFO  "
                + " WHERE DATE_UNTIL = '01-JAN-3000'  order by 1 ";
        try {
            conn = db.connect();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql_text);
            while (rs.next()) {
                al.add(rs.getString(1));
            }
        } catch (SQLException ex) {
            Logger.getLogger(Card_type.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(Card_type.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return al;
    }

    private ArrayList<String> getProducts1() throws UnknownHostException {
        DB db = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        ArrayList<String> al = new ArrayList<String>();
        String sql_text = "select  distinct dc_type from acc_cards@dbonpay";
        try {
            conn = db.connect();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql_text);
            while (rs.next()) {
                al.add(rs.getString(1));
            }
        } catch (SQLException ex) {
            Logger.getLogger(Card_type.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(Card_type.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return al;
    }
}
