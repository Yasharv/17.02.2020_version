/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

/**
 *
 * @author m.aliyev
 */
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

public class JMailAdm {

    public void main(String to, String attach)
            throws Exception {

        String host = "192.168.0.44";
        String from = "stmt@expressbank.az"; //"test_statement@expressbank.az"; 
        String fileAttachment = attach;

        final String username = "stmt@expressbank.az";
        final String password = "stmtP@ssw0rd";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        //props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "192.168.0.44");
        props.put("mail.smtp.port", "25");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        // Define message
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject("Statement from Expressbank");

        // create the message part 
        MimeBodyPart messageBodyPart = new MimeBodyPart();
        MimeMultipart messageBody = new MimeMultipart("alternative");

        messageBodyPart.setContent("Hörmətli Həmkarlar,"
                + "<br>"
                + "Siz \"Expressbank\" ASC-də olan cari hesab(lar)dan çıxarışlar uğurla göndərildi."
                + " <br> "
                + "Hörmətlə,"
                + "<br>"
                + "Sizin \"Expressbank\" ASC Elektron Hesabdan çıxarış", "text/html;charset=UTF-8");
        messageBody.addBodyPart(messageBodyPart);

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(messageBodyPart);

        // Part two is attachment
        messageBodyPart = new MimeBodyPart();
        DataSource source = new FileDataSource(fileAttachment);
        messageBodyPart.setDataHandler(new DataHandler(source));
        messageBodyPart.setFileName("Statement.pdf");
        multipart.addBodyPart(messageBodyPart);

        // Put parts in message
        message.setContent(multipart);

        // Send the message
        Transport.send(message);
    }
}
