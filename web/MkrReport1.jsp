<%-- 
    Document   : TransactAnalys
    Created on : Nov 8, 2012, 12:18:16 PM
    Author     : m.aliyev
--%>
<%@page import="com.sun.jersey.api.client.ClientResponse"%>
<%@page import="com.sun.jersey.api.client.WebResource"%>
<%@page import="com.sun.jersey.api.client.filter.HTTPBasicAuthFilter"%>
<%@page import="com.sun.jersey.api.client.Client"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%> 
<%@page import="java.sql.Statement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>

<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MkrReports</title>

    </head>
    <body bgcolor=#E0EBEA>
        <%     String purpose = request.getParameter("purpose");
            //  System.out.println("purpose " + purpose);
            String doctype = request.getParameter("doctype");
            // System.out.println("doctype " + doctype);
            String agreement = request.getParameter("agreement");
            // System.out.println("agreement " + agreement);
            String USER = request.getParameter("USER");

        %>
        <table border="0" width="100%" height="100%"> 
            <col width="250">
            <tr>
                <td width="200" height="60">  
                    <font face="Times new roman" size="5"> 
                    MKR-dən Çıxarış
                    </font> </td>
                <td align="right">

                </td>
            </tr>
            <tr>

                <td valign="top">    

                    <%  if (doctype.equals("shex")) {%> 
                    <form method="post" action="page1.jsp" id="test"  target="_blank" name="post"  >
                        <input type="hidden" id="purpose" name="purpose"  value="<%=purpose%>"  />
                        <input type="hidden" id="agreement" name="agreement"  value="<%=agreement%>"  />
                        <input type="hidden" id="shex" name="shex"  value="<%=doctype%>"  />
                        <input type="hidden" name="USER" value="<%=USER%>" >

                        <font  size="4" face='Times New Roman'>
                        <!-- </div> -->
                        <table width="400" height="120" border="1" >
                            <tr>
                                <td>
                                    <table width="400" height="101" border="0" bgcolor=#EBF9F9>


                                        <tr>
                                        <tr>
                                            <td height="27"> Pin kod: </td>
                                            <td>
                                                <input type="text" name="pincode" value="" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="27"> Sənədin nömrəsi:  </td>
                                            <td>
                                                <input type="text" name="doc_no" value="" />
                                            </td>
                                        </tr>


                                        <td align="center"><center> <input type="submit" name="go" id="go" value="Mövcud MKRÇ-yə bax"> </center></td>
                                <td align="center"><center> <input  type="submit" id="go1"  name="go1" value="Yeni MKRÇ-nı sorğula"> </center></td>   
                            <td>&nbsp;</td>
                            </tr>

                        </table> 
                </td>
            </tr>
        </table>
        </font >
    </form>
    <%  } %> 


    <%  if (doctype.equals("voen")) {%> 
    <form method="post" action="page1.jsp" id="test" target="_blank" name="post"  >
        <input type="hidden" id="purpose" name="purpose"  value="<%=purpose%>"  />
        <input type="hidden" id="agreement" name="agreement"  value="<%=agreement%>"  />
        <input type="hidden" name="USER" value="<%=USER%>" >

        <font  size="4" face='Times New Roman'>
        <!-- </div> -->
        <table width="400" height="120" border="1" >
            <tr>
                <td>
                    <table width="400" height="101" border="0" bgcolor=#EBF9F9>


                        <!--                  
                                          <tr>
                      <td height="27" >VÖEN Tipi: </td>
                      <td colspan="2">
                        
                    <input type="radio" name="persontype" id="persontype"  value="huq" checked>Hüquqi Şəxs
                         <input type="radio" name="persontype" id="persontype"   value="fiz">Fiziki Şəxs   -->

                </td>
            </tr> 
            <tr>
                <td height="27"> VÖEN:  </td>
                <td>
                    <input type="text" name="voen" value="" />
                </td>
            </tr>


            <td align="center"><center> <input type="submit" name="go" id="go" value="Mövcud MKRÇ-yə bax"> </center></td>
            <td align="center"><center> <input  type="submit" id="go1"  name="go1" value="Yeni MKRÇ-nı sorğula"> </center></td>   
            <td>&nbsp;</td>


        </table> 
    </td>
</tr>
</table>
</font >
</form>
<%  } %> 
<%  if (doctype.equals("vesiqe")) {%> 
<form method="post" action="page1.jsp" id="test" target="_blank" name="post"  >
    <input type="hidden" id="purpose" name="purpose"  value="<%=purpose%>"  />
    <input type="hidden" id="agreement" name="agreement"  value="<%=agreement%>"  />
    <input type="hidden" name="USER" value="<%=USER%>" >
    <font  size="4" face='Times New Roman'>
    <!-- </div> -->
    <table width="400" height="120" border="1" >
        <tr>
            <td>
                <table width="400" height="101" border="0" bgcolor=#EBF9F9>
                    <tr>
                    <tr>
                        <td height="27"> Seriya: </td>
                        <td>
                            <select id="ves_type" name="ves_type" size="1">
                                <option value="0" selected="selected" disabled="disabled">seçin</option>
                                <option value="MN">MN</option>
                                <option value="SQ">SQ</option>
                                <option value="DQ">DQ</option>
                                <option value="ZH">ZH</option>
                                <option value="GH">GH</option>
                                <option value="AD">AD</option>
                                <option value="SU">SU</option>
                                <option value="AG">AG</option>
                                <option value="AR">AR</option>
                                <option value="SX">SX</option>
                                <option value="EZ">EZ</option>
                                <option value="ZE">ZE</option>
                                <option value="MYİ">MYİ</option>
                                <option value="DYİ">DYİ</option>
                                <option value="PU">PU</option>

                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td height="27"> Nömrəsi:  </td>
                        <td>
                            <input type="text" name="nomer" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td height="27"> Doğum tarixi:  </td>
                        <td>
                            <input type="text" name="birthdate" value="" />
                        </td>
                        <td>
                            (dd/mm/yyyy)
                        </td>
                    </tr>
            <td align="center"><center> <input type="submit" name="go" id="go" value="Mövcud MKRÇ-yə bax"> </center></td>
            <td align="center"><center> <input  type="submit" id="go1"  name="go1" value="Yeni MKRÇ-nı sorğula"> </center></td>   
        <td>&nbsp;</td>
        </tr>
    </table> 
</td>
</tr>
</table>
</font >
</form>
<%  } %> 


<%  if (doctype.equals("passport")) {

        class DB {

            public Connection connect() {
                Connection conn = null;
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    Locale.setDefault(Locale.US);

                    conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.235:1521:kit", "kit", "kit");
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
                } catch (SQLException ex) {
                    Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
                }

                return conn;
            }

        }

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmtrep = conn.createStatement();
        ResultSet sqlSelrep = stmtrep.executeQuery(" SELECT CODE, NAME_EN FROM KIT.COUNTRIES ");


%> 
<form method="post" action="page1.jsp" id="test" target="_blank" name="post"  >
    <input type="hidden" id="purpose" name="purpose"  value="<%=purpose%>"  />
    <input type="hidden" id="agreement" name="agreement"  value="<%=agreement%>"  />
    <input type="hidden" name="USER" value="<%=USER%>" >
    <font  size="4" face='Times New Roman'>
    <!-- </div> -->
    <table width="400" height="120" border="1" >
        <tr>
            <td>
                <table width="400" height="101" border="0" bgcolor=#EBF9F9>
                    <tr>
                    <tr>
                        <td height="27">Ölkə: </td>
                        <td>
                            <select name="country" >
                                <option></option>
                                <%while (sqlSelrep.next()) {%>
                                <option value="<%=sqlSelrep.getString("CODE")%>"><%=sqlSelrep.getString("NAME_EN")%>
                                </option>
                                <%}
                                    stmtrep.close();
                                    sqlSelrep.close();
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td height="27"> Passport nömrəsi:  </td>
                        <td>
                            <input type="text" name="passp" value="" />
                        </td>
                    </tr>


                    <td align="center"><center> <input type="submit" name="go" id="go" value="Mövcud MKRÇ-yə bax"> </center></td>
            <td align="center"><center> <input  type="submit" id="go1"  name="go1" value="Yeni MKRÇ-nı sorğula"> </center></td>   
        <td>&nbsp;</td>
        </tr>

    </table> 
</td>
</tr>
</table>
</font >
</form>
<%  }%> 

</td>
</tr>
<tr>
    <td>  
    </td>
    <td height="40">
        <div align="right">


        </div>
    </td>
</tr>

</table>
</body>
</html>