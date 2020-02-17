package main;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DB {

    public Connection connect() throws UnknownHostException {
        Connection conn = null;
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            DBSettings dbs = new DBSettings();
            String host = InetAddress.getLocalHost().getCanonicalHostName();
            String fpath = "";

            if (host.substring(0, 3).equals("exb") || host.substring(0, 3).equals("EXB")) {
                fpath = "C:\\dwhpass";
            } else {
                fpath = "/tsm/DWHReports/dwhpass";
            }
            String pwd = dbs.getPassWd(fpath);

            conn = DriverManager.getConnection("jdbc:oracle:thin:@172.17.90.10:1521:dwhx", "EXBANK", pwd);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }

        return conn;
    }

}
