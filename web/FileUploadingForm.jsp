<%-- 
    Document   : InfoChannelForm
    Created on : Feb 15, 2018, 12:31:55 AM
    Author     : j.gazikhanov
--%>

<%@page import="java.net.URL"%>
<%@page import="beans.AccHistoryInfo"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Properties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("FilesPath.properties");
            
            File file;
            int maxFileSize = 5 * 5000 * 1024;
            int maxMemSize = 5000 * 1024;
            //String filePath = "C:/Fayllar/ExcelFile/Directory/FileUpload/";
            String filePath = properties.getProperty("FilePathCSV");
            String fileType = null;
            String userName = null;
            String contentType = request.getContentType();

            if ((contentType.indexOf("multipart/form-data") >= 0)) {
                String File_Patch_ = "";
                DiskFileItemFactory factory = new DiskFileItemFactory();
                factory.setSizeThreshold(maxMemSize);
                //factory.setRepository(new File("C:\\Fayllar\\ExcelFile\\Directory\\temp\\"));
                String rPath = AccHistoryInfo.class.getClassLoader().getResource("").getPath();
                //String rPath = File.separator+"tsm"+File.separator+"upload"+File.separator;
                File tempFile = new File(rPath);
                if(!tempFile.exists()) {
                    tempFile.mkdirs();
                }
                factory.setRepository(tempFile);
                ServletFileUpload upload = new ServletFileUpload(factory);
                upload.setSizeMax(maxFileSize);
                try {
                    List fileItems = upload.parseRequest(request);
                    Iterator i = fileItems.iterator();
                    out.println("<html>");
                    out.println("<body>");
                    while (i.hasNext()) {
                        FileItem fi = (FileItem) i.next();
                        if (!fi.isFormField()) {
                            String name = new File(fi.getName()).getName();
                            File_Patch_ = name;
                            file = new File(filePath + SplitFilePats(name));
                            fi.write(file);
                        }
                        else
                        {
                            String name = fi.getFieldName().trim();
                            String value = fi.getString().trim();
                            if(name.equals("report_id"))
                            {
                                fileType = value;
                            }
                            else if (name.equals("username")) 
                            {
                                userName = value; 
                            }
                        }
                    }
                    
                    out.println("<p>" + loadDataResult(fileType, userName,File_Patch_) + "</p>");
                    out.println("</body>");
                    out.println("</html>");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    out.println("Error =>" + ex.toString());
                }
            } else {
                out.println("<html>");
                out.println("<body>");
                out.println("<p>No file uploaded</p>");
                out.println("</body>");
                out.println("</html>");
            }
        %>
                
        <%!
            private String loadDataResult(String fileType, String userName,String fileName)
            {
                String res = null;
                WorkDatabase wdb = new WorkDatabase();
                try 
                {
                   res = wdb.loadDataFromFile(fileType, userName, fileName);
                }
                catch(Exception e)
                {
                   e.printStackTrace();
                   res = "Call Stored Procedure error!!!!!";
                }
                return res;
            }        
        %>
        
        <%!
            private String SplitFilePats(String filePath)
            {
                String res =null;
                String delims = "[+\\-*/\\^\\\\ ]+";
                String[] tokens = filePath.split(delims);
                res = tokens[tokens.length - 1];

                return res;
            }        
        %>
    </body>
</html>
