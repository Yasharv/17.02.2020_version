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

public class JavaMail {

    public void main(String to, String attach)
            throws Exception {

        String host = "192.168.0.150";
        String from = "stmt@expressbank.az"; //"test_statement@expressbank.az"; 
        String fileAttachment = attach;

        final String username = "stmt@expressbank.az";
        final String password = "stmtP@ssw0rd";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        //props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "192.168.0.150");
        props.put("mail.smtp.port", "42524");

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

        messageBodyPart.setContent("Hörmətli Müştəri,"
                + "<br>"
                + "Siz \"Expressbank\" ASC-də olan cari hesab(lar)dan çıxarışınıza əlavədə baxa bilərsiniz."
                + "<br>"
                + "Əgər bu email Sizə səhvən gəlibsə zəhmət olmasa silin."
                + "<br>"
                + "Əgər Siz bank hesabdan çıxarışı almaq istəmirsinizsə, zəhmət olmasa aşağıda göstərilən elektron ünvanına (unsubscribe@expressbank.az) bu barədə məlumat verin."
                + "<p>"
                + "Hörmətlə,"
                + "<br>"
                + "Sizin \"Expressbank\" ASC"
                + "</p>"
                + "Dear Customer,"
                + "<br>"
                + "Please find attached statement(s) file for your \"Expressbank\"'s current account(s)."
                + "<br>"
                + "If the received file doesn't belong to you, please delete it."
                + "<br>"
                + "If you do not wish to receive this type of email from \"Expressbank\" ASC in the future, please send email to the link below to unsubscribe (unsubscribe@expressbank.az)."
                + "<p>"
                + "Regards,"
                + "<br>"
                + "Yours \"Expressbank\" OJSC", "text/html;charset=UTF-8");
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
