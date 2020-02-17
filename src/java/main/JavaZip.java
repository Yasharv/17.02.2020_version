/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

/**
 *
 * @author m.aliyev
 */
/*
 Create Zip File From Multiple Files using ZipOutputStream Example
 This Java example shows how create zip file containing multiple files
 using Java ZipOutputStream class.
 */
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipOutputStream;

public class JavaZip {

    public void TextToZip(String args) {
        try {
            String zipFile = "c:/EStatm/" + args + ".zip";
            String[] sourceFiles = {"c:/EStatm/" + args + ".html"};

            //create byte buffer
            byte[] buffer = new byte[1024];

            /*
             * To create a zip file, use
             *
             * ZipOutputStream(OutputStream out)
             * constructor of ZipOutputStream class.
             */
            //create object of FileOutputStream
            FileOutputStream fout = new FileOutputStream(zipFile);

            //create object of ZipOutputStream from FileOutputStream
            ZipOutputStream zout = new ZipOutputStream(fout);

            for (int i = 0; i < sourceFiles.length; i++) {

                //   System.out.println("Adding " + sourceFiles[i]);
                //create object of FileInputStream for source file
                FileInputStream fin = new FileInputStream(sourceFiles[i]);

                /*
                 * To begin writing ZipEntry in the zip file, use
                 *
                 * void putNextEntry(ZipEntry entry)
                 * method of ZipOutputStream class.
                 *
                 * This method begins writing a new Zip entry to
                 * the zip file and positions the stream to the start
                 * of the entry data.
                 */
                zout.putNextEntry(new ZipEntry(sourceFiles[i]));

                /*
                 * After creating entry in the zip file, actually
                 * write the file.
                 */
                int length;

                while ((length = fin.read(buffer)) > 0) {
                    zout.write(buffer, 0, length);
                }

                /*
                 * After writing the file to ZipOutputStream, use
                 *
                 * void closeEntry() method of ZipOutputStream class to
                 * close the current entry and position the stream to
                 * write the next entry.
                 */
                zout.closeEntry();

                //close the InputStream
                fin.close();

            }

            //close the ZipOutputStream
            zout.close();

            // System.out.println("Zip file has been created!");
        } catch (IOException ioe) {
            //  System.out.println("IOException :" + ioe);
        }

    }
}

/*
 Output of this program would be
 Adding C:/sourcefile1.doc
 Adding C:/sourcefile2.doc
 Zip file has been created!
 */
