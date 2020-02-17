<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="main.tMenu"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="main.PrDict"%>
<link rel="stylesheet" href="styles/css_style.css" type="text/css">
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <title>DWH Reports</title>
        <style> 
            .t24menus {
                border:1px solid #006699;
                padding:10px 15px; 

                color: #006699;
                border-radius:25px;

                width:150px;
                font-size:11px !important;
            }

            .not_used {

                padding:5px 10px; 

                color: #006699;

                width:220px;
                font-size:14px !important;
            }
            .used {

                padding:5px 10px; 

                color: #006699;

                width:240px;
                font-size:14px !important;
            }
        </style>
        <script>
            function validateNotUseds()
            {
                var e = document.add.elements.length;
                var i = 0;
                var cnt = 0;
                for (i = 0; i < e; i++)
                {
                    if (document.add.elements[i].name == "notused") {
                        if (document.add.elements[i].checked)
                        {
                            cnt++;
                        }
                    }
                }
                if (cnt == 0) {
                    alert("Heç bir menyu seçilməyib!");
                    return false;
                }

            }
            ;
            function validateUseds()
            {
                var e = document.remove.elements.length;
                var i = 0;
                var cnt = 0;
                for (i = 0; i < e; i++)
                {
                    if (document.remove.elements[i].name == "used") {
                        if (document.remove.elements[i].checked)
                        {
                            cnt++;
                        }
                    }
                }
                if (cnt == 0) {
                    alert("Heç bir menyu seçilməyib!");
                    return false;
                }

            }
            ;
        </script>

    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->
        <%
            PrDict footer = new PrDict();
            tMenu menu = new tMenu();
            String menuID = request.getParameter("menuNAME");
            String uname=request.getParameter("uname"); 
        %>     
        <table border="0" width="100%" height="100%"> 
            <col width="200">
            <tr>
                <td> <font face="Times new roman" size="5"> Administration Users </font> </td>
                <td align="right" height="60">
                    <img src="images/logo_t.gif" width='160' height='60'>
                </td>
            </tr>
            <tr>
                <td valign="top" width="300px">
                    <%=footer.lAdminMenu(uname)%>
                </td>
                <td align="left" valign="top"> 

                    <table border="0" width="700px">
                        <tr>
                            <td colspan="4">
                                <font size="5"> T24 Menyunun adı: <%=menuID%>    </font>     
                            </td>
                        </tr>
                        <tr>

                            <td valign="top" width="240px"  align="right">
                                <form action="add_menu" method="post" name="add" onsubmit="return validateNotUseds()">
                                    <input type="image" name="add" src="images/Action-arrow-blue-double-right-icon.png"> <!--style="position:absolute;top:20%;left:36%;"-->
                                    <div  align="left"> <!--class="not_used"-->
                                        <fieldset>
                                            <legend>İstifadə olunmayan menyular</legend>
                                            <%

                                                String[][] menu_notused = menu.getNotUsedMenus(menuID);
                                                int notused_size = menu_notused.length;
                                                int v = 0;
                                                while (v < notused_size) {
                                                    out.println("<input type=\"checkbox\" name=\"notused\" value=\"" + menu_notused[v][0] + "\">" + menu_notused[v][1] + " <br> ");
                                                    v++;
                                                }
                                            %>
                                        </fieldset>
                                    </div>  
                                    <input type="hidden" name="menuID" value="<%=menuID%>">
                                </form>  
                            </td> 

                            <td valign="top" width="240px" align="left">
                                <form action="rem_menu" method="post" name="remove" onsubmit="return validateUseds()">
                                    <input type="image" name="remove" src="images/Action-arrow-blue-double-left-icon.png"  > <!--style="position:absolute;top:30%;left:36%;"-->

                                    <div >    <!--class="used"-->
                                        <fieldset>
                                            <legend>İstifadə olunan menyular</legend>
                                            <%
                                                String[][] menu_used = menu.getUsedMenus(menuID);
                                                int used_size = menu_used.length;
                                                int j = 0;
                                                while (j < used_size) {
                                                    out.println("<input type=\"checkbox\" name=\"used\" value=\"" + menu_used[j][0] + "\">" + menu_used[j][1] + " <br> ");
                                                    j++;
                                                }
                                            %>
                                        </fieldset>
                                    </div>
                                    <input type="hidden" name="menuID" value="<%=menuID%>">
                                </form>
                            </td>
                            <td valign="top">
                                <div > <!-- class="t24menus"-->
                                    <%
                                        ArrayList<String> menu_list = menu.getT24Menus();
                                        int size = menu_list.size();
                                        int i = 0;
                                        while (i < size) {
                                            out.println("<a href=\"MenuSettings.jsp?uname=MAHMUD&menuNAME=" + menu_list.get(i) + "\">" + menu_list.get(i) + "</a><br>");
                                            i++;
                                        }
                                    %>

                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="40" colspan="2">
                    <div align="left">
                        <%
                            out.println(footer.ftSign());
                        %>
                    </div>
                </td>
            </tr>

        </table>
    </body>
</html>
