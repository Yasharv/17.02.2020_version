<%-- 
    Document   : medaxil
    Created on : Apr 7, 2017, 3:44:34 PM
    Author     : x.dashdamirov
--%>


<%@page import="java.lang.String"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=utf-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!DOCTYPE html> 
<html>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="az-AZ">

        <head>

            <meta http-equiv="X-UA-Compatible" content="IE=7" />
            <style>
                html {
                    background-color: white;
                }

                body {
                    background-color: white;
                    color: black;
                    margin: 0px;
                    margin: auto;
                    width: 210mm;
                    height: 297mm;
                    font-size: 3.5mm;
                    font-family: Tahoma;
                }

                @page {
                    size: A4;
                }

                .section {
                    height: 100mm;
                    width: 210mm;
                }

                .section.small {
                    height: 97mm;
                }

                .block2 {
                    width: 128.01mm;
                    margin: 7.19mm 0mm 0mm 7.19mm;
                    height: 85.62mm;
                    float: left;
                }

                .block1 {
                    width: 60.41mm;
                    margin: 7.19mm 0mm 0mm 7.19mm;
                    height: 85.62mm;
                    float: left;
                }

                .block2 .block1 {
                    margin-top: 0!important;
                }

                .item {
                    height: 14.2mm;
                    width: 100%;
                    margin-bottom: 3.6mm;
                    overflow: hidden;
                }

                .item.small {
                    height: 14.2mm;
                    width: 26.6mm;
                    margin-bottom: 3.6mm;
                    overflow: hidden;
                    float: left;
                    margin-left: 7.19mm;
                }

                .item img {
                    display: block;
                    height: 12.4mm;
                }

                .item.sum {
                    height: 31.9mm;
                    width: 100%;
                    margin-bottom: 3.6mm;
                }

                .item.sign {
                    height: 20.14mm;
                    width: 100%;
                    margin-bottom: 3.6mm;
                    border: 0.72mm solid #f5f5f5;
                    box-sizing: border-box;
                    position: relative;
                }

                .item.sign.client > svg {
                    fill: #fafafa;
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    z-index: 0;
                }

                .item_inner {
                    height: 5.4mm;
                    width: 100%;
                    margin-top: 1.8mm;
                    margin-bottom: 0.2mm;
                    color: #999999;
                }

                .item_inner svg {
                    height: 100%;
                    width: 100%;
                }

                .item_inner text {
                    height: 100%;
                    width: 100%;
                    fill: #999999;
                }

                .item_inner.sum {
                    height: 5.4mm;
                    width: 100%;
                    margin-bottom: 2.5mm;
                    color: #999999;
                }

                .item_inner.sign {
                    height: 10.8mm;
                    width: 100%;
                    margin-top: 1.08mm;
                    margin-left: 1.4mm;
                    color: #999999;
                    z-index: 1;
                    position: relative;
                }

                .item_inner2 {
                    height: 5.4mm;
                    width: 100%;
                    margin-bottom: 0.6mm;
                    font-weight: bold;
                    color: #000000;
                }

                .item_inner2.sum {
                    height: 7.6mm;
                    font-size: 6.5mm;
                    margin-bottom: 3.5mm;
                }

                .item_inner3 {
                    height: 10.4mm;
                    width: 100%;
                    margin-bottom: -0.1mm;
                    color: #000000;
                }

                .long_num {
                    letter-spacing: -0.15mm;
                }

                .item_border {
                    height: 0.72mm;
                    width: 100%;
                    background-color: #f5f5f5;
                }

                .m0 {
                    margin: 0!important;
                }

                .mt {
                    margin-top: 5.8mm!important;
                }
            </style>
            <title>XHTML</title>
        </head>

        <body>


            <%   
           
           // String PAYER = request.getParameter("PAYER"); 

          //byte[] bytes = PAYER.getBytes(StandardCharsets.ISO_8859_1);
        //PAYER = new String(bytes, StandardCharsets.UTF_8);
                  // String PAYER = request.getParameter("PAYER");
                 //   PAYER = new String(PAYER.getBytes(), request.getCharacterEncoding());
         String PAYER = request.getParameter("PAYER");
         System.out.println(PAYER);
                  // PAYER = new String(PAYER.getBytes("UTF-8"), "UTF-8");  
                  // System.out.println(PAYER);
             String DATE= request.getParameter("DATE");
              String TT_ID= request.getParameter("TT_ID");
               String CUS_AC= request.getParameter("CUS_AC");
           //  String PAYER= request.getParameter("PAYER");
                String CUS= request.getParameter("CUS");
                 String NAR= request.getParameter("NAR");
              String AMT= request.getParameter("AMT");
               String CUR1= request.getParameter("CUR1");
                String AMT_W= request.getParameter("AMT_W");
                String CASH_AC= request.getParameter("CASH_AC");
                 String BK_CODE= request.getParameter("BK_CODE");
                //System.out.println(PAYER);
               //  String PAYER  =  request.getParameter(URLEncoder.encode("PAYER", "UTF-8"));
                //String q = "Yarməhəmmədov Yarməhəmməd Yarməhəmməd";
        //String url = "payer=" + URLEncoder.encode(q, "UTF-8");
            //http://localhost:8080/Shablon_TT/medaxil.jsp?DATE=26 yanvar 2017 il&TT_ID=TT17026HSXJZ&CUS_AC=AZ95AZEN45019000000944100039&PAYER=Yarməhəmmədov Yarməhəmməd Yarməhəmməd oğlu&CUS=Monex&NAR=Monex üzrə köçürmə&AMT=1 365 000.57&CUR1=AZN
            //http://localhost:8080/Shablon_TT/medaxil.jsp?DATE=26 yanvar 2017 il&TT_ID=TT17026HSXJZ&CUS_AC=AZ95AZEN45019000000944100039&PAYER=Yarməhəmmədov Yarməhəmməd Yarməhəmməd oğlu&CUS=Monex&NAR=Monex üzrə köçürmə&AMT=1 365 000.57&CUR1=AZN&AMT_W=Bir million üç yüz altmış beş min manat əlli yeddi qəpik&CASH_AC=10010&BK_CODE=505099
            %>






            <div class="section">
                <div class="block1">
                    <div class="item">

                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Tarix
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=DATE%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Nəğd pulun mədaxili üçün elan
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=TT_ID%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    VÖEN
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            15500031691
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Hesab
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2 long_num">
                            <%=CUS_AC%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                </div>
                <div class="block2">
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Kimdən
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=PAYER%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="block1 m0">
                        <div class="item">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Alan
                                    </text>
                                </svg>
                            </div>
                            <div class="item_inner2">
                                <%=CUS%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Təyinat
                                    </text>
                                </svg>
                            </div>
                            <div class="item_inner2">
                                <%=NAR%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item sum">
                            <div class="item_inner sum">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Məbləğ
                                    </text>
                                </svg>
                            </div>
                            <div class="item_inner2 sum">
                                <%=AMT%>  <%=CUR1%> 
                            </div>
                            <div class="item_inner3">
                                <%=AMT_W%> 
                            </div>
                            <div class="item_border"></div>
                        </div>
                    </div>
                    <div class="block1">
                        <div class="item sign">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Məsul icraçı</tspan>
                                        <tspan x="0mm" y="7.8mm">imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                        </div>
                        <div class="item  sign">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Pulu qəbul</tspan>
                                        <tspan x="0mm" y="7.8mm">edənin imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                        </div>
                        <div class="item sign client">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Ödəyənin</tspan>
                                        <tspan x="0mm" y="7.8mm">imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                            <svg>
                                <rect x="0mm" y="0mm" width="100%" height="100%"/>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
            <div class="section">
                <div class="block1">
                    <div class="item">

                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Tarix
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=DATE%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Nəğd pulun mədaxili üçün qəbz
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=TT_ID%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    VÖEN
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            15500031691
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Hesab
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2 long_num">
                            <%=CUS_AC%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                </div>
                <div class="block2">
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Kimdən
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=PAYER%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="block1 m0">
                        <div class="item">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Alan
                                    </text>
                                </svg>
                            </div>
                            <div class="item_inner2">
                                <%=CUS%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Təyinat
                                    </text>
                                </svg>
                            </div>
                            <div class="item_inner2">
                                <%=NAR%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item sum">
                            <div class="item_inner sum">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Məbləğ
                                    </text>
                                </svg>
                            </div>
                            <div class="item_inner2 sum">
                                <%=AMT%>  <%=CUR1%> 
                            </div>
                            <div class="item_inner3">
                                <%=AMT_W%> 
                            </div>
                            <div class="item_border"></div>
                        </div>
                    </div>
                    <div class="block1">
                        <div class="item sign">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Məsul icraçı</tspan>
                                        <tspan x="0mm" y="7.8mm">imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                        </div>
                        <div class="item  sign">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Pulu qəbul</tspan>
                                        <tspan x="0mm" y="7.8mm">edənin imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                        </div>
                        <div class="item sign client">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Ödəyənin</tspan>
                                        <tspan x="0mm" y="7.8mm">imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                            <svg>
                                <rect x="0mm" y="0mm" width="100%" height="100%"/>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
            <div class="section small">
                <div class="block1">
                    <div class="item">

                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Tarix
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=DATE%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Nəğd pulun mədaxili üçün order
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=TT_ID%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    VÖEN
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            15500031691
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Kredit hesabı
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2 long_num">
                            <%=CUS_AC%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                </div>
                <div class="block2">
                    <div class="item">
                        <div class="item_inner">
                            <svg height="100%" width="100%">
                                <text x="0mm" y="3.4mm">
                                    Kimdən
                                </text>
                            </svg>
                        </div>
                        <div class="item_inner2">
                            <%=PAYER%>
                        </div>
                        <div class="item_border"></div>
                    </div>
                    <div class="block1 m0">
                        <div class="item">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Alan</text>
                                </svg>
                            </div>
                            <div class="item_inner2">
                                <%=CUS%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Təyinat</text>
                                </svg>
                            </div>
                            <div class="item_inner2">
                                <%=NAR%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item sum">
                            <div class="item_inner sum">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Məbləğ</text>
                                </svg>
                            </div>
                            <div class="item_inner2 sum">
                                <%=AMT%>  <%=CUR1%> 
                            </div>
                            <div class="item_inner3">
                                <%=AMT_W%> 
                            </div>
                            <div class="item_border"></div>
                        </div>
                    </div>
                    <div class="block1">
                        <div class="item sign">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Məsul icraçı</tspan>
                                        <tspan x="0mm" y="7.8mm">imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                        </div>
                        <div class="item sign">
                            <div class="item_inner sign">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        <tspan>Pulu qəbul</tspan>
                                        <tspan x="0mm" y="7.8mm">edənin imzası</tspan>
                                    </text>
                                </svg>
                            </div>
                        </div>
                        <div class="item small m0 mt">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Debet hesabı</text>
                                </svg>
                            </div>
                            <div class="item_inner2 long_num">
                                <%=CASH_AC%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                        <div class="item small mt">
                            <div class="item_inner">
                                <svg height="100%" width="100%">
                                    <text x="0mm" y="3.4mm">
                                        Bank kodu</text>
                                </svg>
                            </div>
                            <div class="item_inner2 long_num">
                                <%=BK_CODE%>
                            </div>
                            <div class="item_border"></div>
                        </div>
                    </div>
                </div>
            </div>
        </body>

    </html>
</html>
