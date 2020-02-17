<%-- 
    Document   : DwhReportChart
    Created on : Nov 13, 2018, 9:37:35 AM
    Author     : r.ganiyev
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.Format"%>
<%@page import="java.util.Date"%>
<%@page import="stats.ReportResults"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="jqueryui191cust/development-bundle/themes/cupertino/jquery.ui.all.css">
        <script src="jqueryui191cust/development-bundle/jquery-1.8.2.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.core.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.widget.js"></script>
        <script src="jqueryui191cust/development-bundle/ui/jquery.ui.datepicker.js"></script>
        <script src="js/jquery.canvasjs.min.js" type="text/javascript"></script>
        <link rel="stylesheet" href="jqueryui191cust/development-bundle/demos/demos.css">

        <%
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;
            properties = rf.ReadConfigFile("DwhReportStats.properties");

            Cookie cookie = null;
            Cookie[] cookies = null;
            String username="";
            cookies = request.getCookies();
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++)
                {
                    cookie = cookies[i];
                    if (cookie.getName().equals("uname")) 
                    {
                      username=cookie.getValue();
                    }
                        
                }
            }

                Date d = new Date();
                Format formatter;
                String s;
                formatter = new SimpleDateFormat("dd-MM-yyyy");
                s = formatter.format(d);
                String dateFrom = s;
                String dateTo = s;
                String radio = request.getParameter("RepTypeMain");
                if (radio == null) {
                    radio = request.getParameter("RepType");
                }
                String stp = "";
                String r1Check = "checked";
                String r2Check = "unchecked";

                if (request.getParameter("ShowChart") != null || request.getParameter("goMain") != null) {
                    dateFrom = request.getParameter("TrDateBMain");
                    dateTo = request.getParameter("TrDateEMain");
                    if (dateFrom == null || dateTo == null) {
                        dateFrom = request.getParameter("TrDateB");
                        dateTo = request.getParameter("TrDateE");
                    }
                    ReportResults rpt = new ReportResults();
                    stp = rpt.getResults(dateFrom, dateTo, username);
                }
                System.out.println(stp + " " + radio);
                if (stp.length() > 0 && radio.equals("0")) {

                    r1Check = "checked";
                    r2Check = "unchecked";
        %>

        <script>
            var arr = <%= stp%>;
            window.onload = function () {

                var chart = new CanvasJS.Chart("chartContainer", {
                    animationEnabled: true,

                    title: {
                        text: "DWH Hesabatlarının Statistikası"
                    },
                    axisX: {
                        interval: 1
                    },
                    axisY2: {
                        interlacedColor: "rgba(1,77,101,.2)",
                        gridColor: "rgba(1,77,101,.1)",
                        title: "Çıxarılan Hesabatların Sayı"
                    },
                    data: [{
                            type: "bar",
                            name: "companies",
                            axisYType: "secondary",
                            color: "#014D65",
                            dataPoints: arr
                        }]
                });
                chart.render();

            };
        </script>
        <%
            }
            if (stp.length() > 0 && radio.equals("1")) {

                r1Check = "unchecked";
                r2Check = "checked";
        %>

        <script>
            var arr = <%= stp%>;
            window.onload = function () {

                var chart = new CanvasJS.Chart("chartContainer", {
                    animationEnabled: true,
                    title: {
                        text: "DWH Hesabatlarının Statistikası"
                    },
                    data: [{
                            type: "pie",
                            startAngle: 240,
                            yValueFormatString: "##0",
                            indexLabel: "{label} {y}",
                            dataPoints: arr
                        }]
                });
                chart.render();

            };
        </script>
        <%
            }
        %>
        <script>
            $(function () {
                $("#from").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    onClose: function (selectedDate) {
                        $("#to").datepicker("option", "minDate", selectedDate);
                    }
                });
                $("#to").datepicker({
                    dateFormat: "dd-mm-yy",
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    firstDay: 1,
                    onClose: function (selectedDate) {
                        $("#from").datepicker("option", "maxDate", selectedDate);
                    }
                });

            });
            function validateForm()
            {
                var x = document.forms["post"]["TrDateB"].value;
                var y = document.forms["post"]["TrDateE"].value;

                if (x == null || x == "")
                {
                    alert("Başlanğıc tarix daxil edilməlidir!");
                    return false;
                }
                if (y == null || y == "")
                {
                    alert("Son tarix daxil edilməlidir!");
                    return false;
                }
            }
        </script> 

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>


        <form action = "DwhReportChart.jsp" method="post" name="form1" id="form1" >

            <table width="535" height="101" border="0" bgcolor=#EBF9F9>

                <tr>
                    <td width="150" height="33"><%=properties.getProperty("DateFrom")%></td>

                    <td width="130"> 
                        <input type="text" id="from" name="TrDateB" value= <% out.print('"' + dateFrom + '"');%> />
                    </td>
                </tr>

                <tr>
                    <td height="31"><%=properties.getProperty("DateTo")%></td>

                    <td width="130">
                        <input type="text" id="to" name="TrDateE" value= <% out.print('"' + dateTo + '"');%> />
                    </td>
                </tr>

                <tr>
                    <td>
                        <font size="3"> <input type="radio"   name="RepType" value="0" <%=r1Check%> ><%=properties.getProperty("BarC")%><br> </font>
                    </td>
                    <td>
                        <font size="3"> <input type="radio"  name="RepType"  value="1" <%=r2Check%>><%=properties.getProperty("PayC")%></font>
                    </td>
                </tr>

                <tr>
                    <td height="31">
                        <input type="submit" name="ShowChart" value=<%=properties.getProperty("Submit")%> /> 
                    </td>

                </tr>              
            </table>

            <div style="alignment-adjust: central">

                <div id="chartContainer" style="height: 500px; max-width: 950px; margin: 0px auto;">
                    <div class="canvasjs-chart-container" style="position: relative; text-align: left; cursor: auto;">
                        <canvas class="canvasjs-chart-canvas" width="900px" height="570px" style="position: absolute;">

                        </canvas>
                        <canvas class="canvasjs-chart-canvas" width="900px" height="570px" style="position: absolute; -webkit-tap-highlight-color: transparent; cursor: default;"></canvas>
                        <div class="canvasjs-chart-toolbar" style="position: absolute; right: 1px; top: 1px; border: 1px solid transparent;"></div>
                        <div class="canvasjs-chart-tooltip" style="position: absolute; height: auto; box-shadow: rgba(0, 0, 0, 0.1) 1px 1px 2px 2px; z-index: 1000; pointer-events: none; display: none; border-radius: 0px; left: 488px; bottom: -93px;">
                            <div style="width: auto;height: auto;min-width: 50px;margin: 0px;padding: 5px;font-family:  sans-serif;font-weight: normal;font-style: normal;font-size: 14px;color: black;text-shadow: rgba(78, 12, 23, 0.1) 1px 1px 1px;text-align: left;border: 1px solid rgb(1, 77, 101);background: rgba(148, 132, 111, 0.9);text-indent: 0px;white-space: nowrap;border-radius: 0px;user-select: none;">
                                <span style="color:#014D65;">US:</span>&nbsp;&nbsp;134</div></div>

                        <span style="position: absolute; left: 0px; top: -20000px; padding: 0px; margin: 0px; border: none; white-space: pre; line-height: normal; font-family:  sans-serif; font-size: 19px; font-weight: normal; display: none;">Mpgyi</span>

                    </div>

                    <table style="width: 100%; background-color: #EBF9F9" >
                        <tr>
                            <td>

                            </td>  
                        </tr>     
                    </table>
                    </form>
                    </body>
                    </html>
