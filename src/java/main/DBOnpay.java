package main;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBOnpay {

    public Connection connect() {
        Connection conn = null;
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            DBSettings dbs = new DBSettings();

            String fpath = "/tsm/DWHReports/onpaypass";
            //   fpath = "C:\\Users\\m.aliyev\\Documents\\NetBeansProjects\\DWHReports\\onpaypass";
            //  String   fpath = "D:\\onpaypass";
            String pwd = dbs.getPassWd(fpath);
            conn = DriverManager.getConnection("jdbc:oracle:thin:@172.17.90.9:1521:ONPAY", "ONPAY", pwd);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBOnpay.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBOnpay.class.getName()).log(Level.SEVERE, null, ex);
        }

        return conn;
    }

}
