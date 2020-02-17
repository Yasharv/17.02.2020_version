<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" title="currentStyle">
            @import "media/css/demo_page.css";
            @import "media/css/demo_table.css";
            @import "media/css/demo_table_jui.css";
            @import "media/examples_support/themes/smoothness/jquery-ui-1.8.4.custom.css";
        </style>
        <script type="text/javascript" language="javascript" src="media/js/jquery.js"></script>
        <script type="text/javascript" language="javascript" src="media/js/jquery.dataTables.js"></script>
        <script type="text/javascript" charset="utf-8">
            $(document).ready(function () {
                $('#example').dataTable({
                    "bJQueryUI": true,
                    "sPaginationType": "full_numbers",
                    "bScrollCollapse": true,
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    "bDestroy": true
                });
            });
        </script>
        <script>
            $(function () {
                $("#check").click(function () {
                    $('#loading').css('display', 'inline');
                    $("#tabledata").load("CheckMKService", function () {
                        $('#loading').css('display', 'none');
                        var oTable = $('#example').dataTable();
                        oTable.fnDestroy();
                        oTable = $('#example').dataTable({
                            "bJQueryUI": true,
                            "sPaginationType": "full_numbers",
                            "bScrollCollapse": true,
                            "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                            "bDestroy": true
                        });
                    });
                });
            });
        </script>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            PrDict dict = new PrDict();
            String user_name = request.getParameter("uname");
            String br = request.getParameter("br");
        %>     
        <table border="0" width="100%" height="100%"> 
            <tr>
                <td> <font face="Times new roman" size="5"> MKServices </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top"> <%=dict.lMenu(user_name, br)%> </td>
                <td align="left" valign="top"> 
                    <table width="700" height="120" border="1" >
                        <tr>
                            <td>
                                <table width="100%" height="100%" border="0" bgcolor=#EBF9F9>
                                    <tr>
                                        <td valign="top">
                                            <button id="check">Check online MKServices</button> 
                                            <div id="loading" style="display: none;"><img src="images/loading.gif"> Loading...</div>
                                            <br><br>
                                            <div ></div>
                                            <table cellpadding="0" cellspacing="0" border="0"  id="example" width="100%">
                                                <thead>
                                                    <tr>
                                                        <th width="200">cardaccount</th>
                                                        <th width="100">amount</th>
                                                        <th width="100">currency</th>
                                                        <th>datetime</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="tabledata">
                                                    <tr>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <th>cardaccount</th>
                                                        <th>amount</th>
                                                        <th>currency</th> 
                                                        <th>datetime</th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </td>                      
                                    </tr>
                                </table> 
                            </td>
                        </tr>
                    </table> 
                    </form>    
                </td>
            </tr>
            <tr>
                <td></td>
                <td height="40">
                    <div align="right">
                        <%=dict.ftSign()%>
                    </div>
                </td>
            </tr>

        </table>
    </body>
</html>
