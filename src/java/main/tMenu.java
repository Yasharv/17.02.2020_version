/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

/**
 *
 * @author m.aliyev
 */
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class tMenu {

    public String[][] getMenu(String uname) throws ClassNotFoundException, UnknownHostException {
        String[][] menu_pages = null;
        DB db = new DB();
        Connection conn = db.connect();
        Statement st = null;
        ResultSet rec = null;
        try {

            st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rec = st.executeQuery("SELECT name,link FROM T_MENU"
                    + " where id in (SELECT dwh_menu_id FROM t_users_menu "
                    + " where t24_menu_name = (SELECT nvl(user_init_application,'ADMIN') user_init_application"
                    + " FROM dwh_users where date_until='01-JAN-3000' and user_id='" + uname + "'))"
                    + " order by id");
            rec.last();
            int rowcount = rec.getRow();
            rec.beforeFirst();

            int i = 0;
            menu_pages = new String[rowcount][2];
            while (rec.next()) {

                menu_pages[i][0] = rec.getString(1);
                menu_pages[i][1] = rec.getString(2);

                i++;
            }

        } catch (SQLException e) {
            //       System.out.println("Yuklenmedi sehf: " + "SQLException: " + e.getMessage());
            while ((e = e.getNextException()) != null) {
                //  System.out.println(e.getMessage());
            }
        } finally {
            try {
                if (rec != null) {
                    rec.close();
                }
                if (st != null) {
                    st.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(tMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return menu_pages;
    }

    public ArrayList<String> getT24Menus() throws UnknownHostException {
        DB db = new DB();
        Connection conn = db.connect();
        Statement st = null;
        ResultSet rec = null;
        ArrayList<String> Menu_List = new ArrayList<String>();
        try {

            st = conn.createStatement();
            rec = st.executeQuery("select distinct nvl(user_init_application,'ADMIN') T24_MENUS from dwh_users  "
                    + " where date_until='01-JAN-3000' ORDER BY T24_MENUS");

            while (rec.next()) {
                Menu_List.add(rec.getString(1));
            }

        } catch (SQLException e) {
            //      System.out.println("Yuklenmedi sehf: " + "SQLException: " + e.getMessage());
            while ((e = e.getNextException()) != null) {
                //  System.out.println(e.getMessage());
            }
        } finally {
            try {
                if (rec != null) {
                    rec.close();
                }
                if (st != null) {
                    st.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(tMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return Menu_List;
    }

    public String[][] getUsedMenus(String t24MenuID) throws UnknownHostException {

        String[][] menu_pages = null;
        DB db = new DB();
        Connection conn = db.connect();
        Statement st = null;
        ResultSet rec = null;

        try {

            st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rec = st.executeQuery("select m.id,name from t_menu m where m.id in (select m.dwh_menu_id"
                    + " from t_users_menu m where m.T24_MENU_NAME =  ('" + t24MenuID + "')) order by m.id");

            rec.last();
            int rowcount = rec.getRow();
            rec.beforeFirst();

            int i = 0;
            menu_pages = new String[rowcount][2];
            while (rec.next()) {
                menu_pages[i][0] = rec.getString(1);
                menu_pages[i][1] = rec.getString(2);
                i++;
            }

        } catch (SQLException e) {
            //         System.out.println("Yuklenmedi sehf: " + "SQLException: " + e.getMessage());
            while ((e = e.getNextException()) != null) {
                //       System.out.println(e.getMessage());
            }
        } finally {
            try {
                if (rec != null) {
                    rec.close();
                }
                if (st != null) {
                    st.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(tMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return menu_pages;
    }

    public String[][] getNotUsedMenus(String t24MenuID) throws UnknownHostException {

        String[][] menu_pages = null;
        DB db = new DB();
        Connection conn = db.connect();
        Statement st = null;
        ResultSet rec = null;

        try {

            st = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rec = st.executeQuery("select m.id,name from t_menu m where m.id not in (select m.dwh_menu_id"
                    + " from t_users_menu m where m.T24_MENU_NAME =  ('" + t24MenuID + "')) order by m.id");

            rec.last();
            int rowcount = rec.getRow();
            rec.beforeFirst();

            int i = 0;
            menu_pages = new String[rowcount][2];
            while (rec.next()) {
                menu_pages[i][0] = rec.getString(1);
                menu_pages[i][1] = rec.getString(2);
                i++;
            }

        } catch (SQLException e) {
            //     System.out.println("Yuklenmedi sehf: " + "SQLException: " + e.getMessage());
            while ((e = e.getNextException()) != null) {
                //       System.out.println(e.getMessage());
            }
        } finally {
            try {
                if (rec != null) {
                    rec.close();
                }
                if (st != null) {
                    st.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(tMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return menu_pages;
    }

    public void add_menu(String t24MenuID, int DWHMenuID) throws UnknownHostException {

        DB db = new DB();
        Connection conn = db.connect();
        Statement st = null;
        ResultSet rec = null;

        try {

            st = conn.createStatement();
            rec = st.executeQuery("insert into t_users_menu (t24_menu_name,dwh_menu_id) values ('" + t24MenuID + "'," + DWHMenuID + ")");

        } catch (SQLException e) {
            //       System.out.println("Yuklenmedi sehf: " + "SQLException: " + e.getMessage());
            while ((e = e.getNextException()) != null) {
                //       System.out.println(e.getMessage());
            }
        } finally {
            try {
                if (rec != null) {
                    rec.close();
                }
                if (st != null) {
                    st.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(tMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }

    public void remove_menu(String t24MenuID, int DWHMenuID) throws UnknownHostException {

        DB db = new DB();
        Connection conn = db.connect();
        Statement st = null;
        ResultSet rec = null;

        try {

            st = conn.createStatement();
            rec = st.executeQuery("delete t_users_menu where t24_menu_name='" + t24MenuID + "' and dwh_menu_id=" + DWHMenuID);

        } catch (SQLException e) {
            //     System.out.println("Yuklenmedi sehf: " + "SQLException: " + e.getMessage());
            while ((e = e.getNextException()) != null) {
                //      System.out.println(e.getMessage());
            }
        } finally {
            try {
                if (rec != null) {
                    rec.close();
                }
                if (st != null) {
                    st.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(tMenu.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }
}
