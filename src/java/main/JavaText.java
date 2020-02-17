/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

/**
 *
 * @author m.aliyev
 */
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.File;
import java.io.Writer;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.UnknownHostException;
import java.sql.SQLException;

public class JavaText {

    public void main(String acc_no, String acc_name, String curr_name, int CurrID, String acc_open_date, String cust_inn, String strDateB, String strDateE, String AP, String reval) throws SQLException, ClassNotFoundException, UnknownHostException {
        Writer writer = null;
        EStatement estmt = new EStatement();

        String htmltext = "";
        htmltext = "<html> <head> <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>EStatement</title></head><body> ";

        htmltext = htmltext + estmt.main(acc_no, acc_name, curr_name, CurrID, acc_open_date, cust_inn, strDateB, strDateE, AP, reval);
        htmltext = htmltext + "    </body></html>";
        String vFile = "c:/EStatm/write.html";
        File file = new File(vFile);

        try {

            BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF8"));

            out.write(htmltext);
            out.close();

        } catch (UnsupportedEncodingException ue) {
            //System.out.println("Not supported : ");
        } catch (IOException e) {
            //System.out.println(e.getMessage()); 
        }
        JavaZip jzip = new JavaZip();
        jzip.TextToZip("write");

        File f1 = new File(vFile);
        boolean success = f1.delete();
        if (!success) {
            // System.out.println("Deletion failed.");
            // System.exit(0);
        } else {
            // System.out.println("File deleted.");
        }
    }

}
