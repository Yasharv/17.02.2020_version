/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.security.spec.KeySpec;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import org.apache.commons.codec.binary.Base64;


/**
 *
 * @author m.aliyev
 */
public class DBSettings {

    protected String getPassWd(String FPath) {
        return decrypt(readFile(FPath));
    }

    private String readFile(String FPath) {
        BufferedReader in = null;
        String data = null;
        try {
            in = new BufferedReader(new FileReader(FPath));
            data = in.readLine();
            in.close();
        } catch (FileNotFoundException e1) {
            //    System.out.println("Error: " + e1.toString());
        } catch (IOException ex) {
            Logger.getLogger(DBSettings.class.getName()).log(Level.SEVERE, null, ex);
        }
        return data;
    }

    ;
    
    private String decrypt(String encryptedString) {
        String decryptedText = null;
        String UNICODE_FORMAT = "UTF8";
        String DESEDE_ENCRYPTION_SCHEME = "DESede";
        KeySpec ks;
        SecretKeyFactory skf;
        Cipher cipher;
        byte[] arrayBytes;
        String myEncryptionKey;
        String myEncryptionScheme;
        SecretKey key;
        myEncryptionKey = "Mako898ExBankMako898ExBank";
        myEncryptionScheme = DESEDE_ENCRYPTION_SCHEME;
        try {
            arrayBytes = myEncryptionKey.getBytes(UNICODE_FORMAT);
            ks = new DESedeKeySpec(arrayBytes);
            skf = SecretKeyFactory.getInstance(myEncryptionScheme);
            cipher = Cipher.getInstance(myEncryptionScheme);
            key = skf.generateSecret(ks);
            cipher.init(Cipher.DECRYPT_MODE, key);
            byte[] encryptedText = Base64.decodeBase64(encryptedString);
            byte[] plainText = cipher.doFinal(encryptedText);
            decryptedText = new String(plainText);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return decryptedText;
    }
}
