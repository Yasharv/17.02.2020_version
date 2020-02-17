<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <body  bgcolor=#E0EBEA  >
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <script type="text/javascript" src="/javax.faces.resource/accr_util.js.risk?ln=javascript"></script>
            <head>
                <title>MKR</title>
                <style>
                    body  {

                        padding:1px;
                        margin: 0px;
                        font-size:20px
                    }
                </style>
                <table   cellspacing="0" cellpadding="1">
                    <tr>
                        <td style="vertical-align: top;width:20%;">
                        </td>
                        <td style="vertical-align: top;width:auto">
                            <div style="width:400px;display:block">
                            </div>
                            <%    String USER = request.getParameter("uname");
                                //   System.out.println("USER1 " + USER);  
                            %>  
                            <form method="post" action="MkrReport1.jsp" id="test"  name="post"  >
                                   <input type="hidden" name="uname" value=<% out.print(USER);%> >
                                <br>
                                    <input type="hidden" name="USER" value="<%=USER%>" >
                                        <div     style="width: 100%;  font-size:25px" class="rf-p-hdr " id="inqForm:j_idt93_header">MKR-dən sorğu</div><div class="rf-p-b " id="inqForm:j_idt93_body">
                                            <br>
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td  style="  font-size: 18px">Sorğunun məqsədi :</td>
                                                            <td><select id="purpose" name="purpose" size="1">
                                                                    <option value="0" selected="selected" disabled="disabled">seçin</option>
                                                                    <option value="001">Kredit müraciəti</option>
                                                                    <option value="002">Kredit xətti ücün müraciət</option>
                                                                    <option value="003">Zaminin sorğulanması</option>
                                                                    <option value="004">Təsisçinin sorğulanması</option>
                                                                    <option value="005">Cari borcalanın sorğulanması</option>
                                                                </select></td>
                                                        </tr>
                                                        <tr>
                                                            <td  style="  font-size: 18px">Sənədin tipi :</td>
                                                            <td><select id="doctype" name="doctype" size="1">
                                                                    <option value="0" selected="selected" disabled="disabled">seçin</option>
                                                                    <option value="shex">Şəxsiyyət vəsiqəsi üzrə</option>
                                                                    <option value="voen">VÖEN üzrə</option>
                                                                    <option value="vesiqe">Vəsiqələr üzrə</option>
                                                                    <option value="passport">Passportlar üzrə</option>
                                                                </select></td>
                                                        </tr>
                                                        </td>
                                                        <tr>
                                                            <td  style ="position: absolute;  left: 350px;top: 180px;   " align="right"><right> <input type="submit" name="go" id="go" value="Növbəti"> </right></td>  </tr>
                                                        </tr>   
                                                    </tbody>
                                                </table>                                              
                                                </form>
                                                </td>
                                                </tr>
                                                </table>
                                                </body>   
                                                </html>