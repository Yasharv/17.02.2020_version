<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="ExcelUtility.WorkExcel"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
         <%!
         private String conValues(String[] arrayElem)
          {
             String res= "";
             for (int i = 0; i < arrayElem.length ; i++)
             {
                if (!arrayElem[i].equals("0"))
                { 
                    res = res + arrayElem[i] + ",";
                }
             }

             return res.length() == 0 ? null : res.substring(0,res.length() - 1);
          }
        %>
        <%
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
            if (request.getParameter("RepType") != null) {
                String[] categories = new String[8];
                String[] AllCur = new String[8];
                Object[] array = new Object[5];
                int queryStatus = 0; 
                int condStatus = 0;

                WorkExcel we = new WorkExcel();
                
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
                String FileNamePath = null;
                int    RepType = Integer.parseInt(request.getParameter("RepType"));
                String TarixB = request.getParameter("TrDateB");
                String TarixE = request.getParameter("TrDateE");
                String type = request.getParameter("type");
                String type1 = request.getParameter("type1");
                String chkSelectAll = request.getParameter("chkSelectAll");
                String cmt = request.getParameter("cmt");
                String korona = request.getParameter("korona");
                String upt = request.getParameter("upt"); 
                String wunion = request.getParameter("wunion");
                String contact = request.getParameter("contact");
                String lider = request.getParameter("lider");
                String monex = request.getParameter("monex");
                String iba_express = request.getParameter("iba_express");
                String xezri = request.getParameter("xezri");
                
                String rep = request.getParameter("rep");
                String rep1 = request.getParameter("rep1");
                String report = request.getParameter("report");
                String azn = request.getParameter("azn") == null ? "" : request.getParameter("azn");
                String eur = request.getParameter("eur") == null ? "" : request.getParameter("eur");
                String usd = request.getParameter("usd") == null ? "" : request.getParameter("usd");
                String gbp = request.getParameter("gbp") == null ? "" : request.getParameter("gbp");
                String rub = request.getParameter("rub") == null ? "" : request.getParameter("rub");
                String jpy = request.getParameter("jpy") == null ? "" : request.getParameter("jpy");
                String chf = request.getParameter("chf") == null ? "" : request.getParameter("chf");
                
                AllCur[0] = request.getParameter("azn") == null ? "0" : request.getParameter("azn");
                AllCur[1] = request.getParameter("eur") == null ? "0" : request.getParameter("eur");
                AllCur[2] = request.getParameter("usd") == null ? "0" : request.getParameter("usd");
                AllCur[3] = request.getParameter("gbp") == null ? "0" : request.getParameter("gbp");
                AllCur[4] = request.getParameter("rub") == null ? "0" : request.getParameter("rub");
                AllCur[5] = request.getParameter("jpy") == null ? "0" : request.getParameter("jpy");
                AllCur[6] = request.getParameter("chf") == null ? "0" : request.getParameter("chf");
                AllCur[7] = request.getParameter("try") == null ? "0" : request.getParameter("try");
                
                String country = request.getParameter("country").equals("0") ? "" : "'" + request.getParameter("country") + "'";
                String sender = request.getParameter("sender");
                String PASSP_NO = request.getParameter("PASSP_NO");
                String RepFilial = request.getParameter("RepFilial").equals("0") ? "" : request.getParameter("RepFilial");
                String username = request.getParameter("uname");
                
                String categoriesKoc  = null;
                String chekBoxValues  = null;
                String chekBoxCurrVal = null;
                String categoriesOd   = null;
                String allCurrency    = null;
                String ParamsValue    = null;
                
                if (report != null &&
                    type != null &&
                    type1 == null &&
                    rep1 == null &&
                    rep != null)
                {
                    if (report.equals("1") &&
                        type.equals("1") &&
                        type1 == null && 
                        rep.equals("1")) 
                    {
                        queryStatus = 1; 
                        condStatus = 1;
                        categories[0] = korona == null ? "0" : "17687"; 
                        categories[1] = contact == null ? "0" : "17688"; 
                        categories[2] = monex == null ? "0" : "17692"; 
                        categories[3] = xezri == null ? "0" : "17694"; 
                        categories[4] = upt == null ? "0" : "17695"; 
                        categories[5] = wunion == null ? "0" : "17683";
                        categories[6] = lider == null ? "0" : "17690";
                        categories[7] = iba_express == null ? "0" : "17693";
                        chekBoxValues = conValues(categories);
                        categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;
                        chekBoxCurrVal = conValues(AllCur);
                        allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                      
                        ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                    + "filial_code=" + RepFilial.trim() + "/"
                                    + "recipient_country=" + country.trim() + "/"
                                    + "recipient_name=" + sender.trim() + "/"
                                    + "passp_no=" + PASSP_NO.trim() + "/"
                                    + "category=" + categoriesKoc.trim() + "/"
                                    + "currencyid=" + allCurrency.trim();
                    
                    
                    }
                 }
                 else if (report != null &&
                          type == null &&
                          rep1 == null &&
                          type1 != null &&
                          rep != null)
                 {
                        if (report.equals("1") &&
                            type1.equals("1") &&
                            rep.equals("1") )   
                        {
                            queryStatus = 2; 
                            condStatus = 2;
                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "category=" + categoriesOd.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                 else if (report != null &&
                          type1 != null &&
                          type != null &&
                          rep1 == null &&
                          rep != null)
                 {
                     if (report.equals("1") &&
                         type1.equals("1") &&
                         type.equals("1") &&
                         rep.equals("1"))
                     {
                         queryStatus = 3; 
                         condStatus = 3;
                         categories[0] = korona == null ? "0" : "17687"; 
                         categories[1] = contact == null ? "0" : "17688"; 
                         categories[2] = monex == null ? "0" : "17692"; 
                         categories[3] = xezri == null ? "0" : "17694"; 
                         categories[4] = upt == null ? "0" : "17695"; 
                         categories[5] = wunion == null ? "0" : "17683";
                         categories[6] = lider == null ? "0" : "17690";
                         categories[7] = iba_express == null ? "0" : "17693";
                         chekBoxValues = conValues(categories);
                         categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                         categories[0] = korona == null ? "0" : "12693"; 
                         categories[1] = contact == null ? "0" : "12694"; 
                         categories[2] = monex == null ? "0" : "12696"; 
                         categories[3] = xezri == null ? "0" : "12698"; 
                         categories[4] = upt == null ? "0" : "12684";  
                         categories[5] = wunion == null ? "0" : "12689";
                         categories[6] = lider == null ? "0" : "12695";
                         categories[7] = iba_express == null ? "0" : "12697";
                         chekBoxValues = conValues(categories);
                         categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                         chekBoxCurrVal = conValues(AllCur);
                         allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                         ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                       + "filial_code=" + RepFilial.trim() + "/"
                                       + "recipient_country=" + country.trim() + "/"
                                       + "recipient_name=" + sender.trim() + "/"
                                       + "passp_no=" + PASSP_NO.trim() + "/"
                                       + "category=" + categoriesKoc.trim() + "/"
                                       + "categoryod=" + categoriesOd.trim() + "/"
                                       + "currencyid=" + allCurrency.trim() + "/"
                                       + "date_from=to_date('" + TarixB.trim() + "','dd.mm.yyyy')";
                     }
                 }
                 else if (report != null &&
                          type1 == null &&
                          rep1 != null &&
                          type != null &&
                          rep == null)
                 {
                     if (report.equals("1") &&
                         type.equals("1") &&
                         rep1.equals("2"))
                     {
                        queryStatus = 4; 
                        condStatus = 4;
                        categories[0] = korona == null ? "0" : "17687"; 
                        categories[1] = contact == null ? "0" : "17688"; 
                        categories[2] = monex == null ? "0" : "17692"; 
                        categories[3] = xezri == null ? "0" : "17694"; 
                        categories[4] = upt == null ? "0" : "17695";  
                        categories[5] = wunion == null ? "0" : "17683";
                        categories[6] = lider == null ? "0" : "17690";
                        categories[7] = iba_express == null ? "0" : "17693";
                        chekBoxValues = conValues(categories);
                        categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;
                        chekBoxCurrVal = conValues(AllCur);
                        allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal; 
                        ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                    + "filial_code=" + RepFilial.trim() + "/"
                                    + "recipient_country=" + country.trim() + "/"
                                    + "recipient_name=" + sender.trim() + "/"
                                    + "passp_no=" + PASSP_NO.trim() + "/"
                                    + "category=" + categoriesKoc.trim() + "/"
                                    + "currencyid=" + allCurrency.trim();
                     }
                 }
                 else if (report != null &&
                         type == null &&
                         rep1 != null &&
                         type1 != null &&
                         rep == null)
                      {
                        if (report.equals("1") &&
                            type1.equals("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 2; 
                            condStatus = 2;
                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "category=" + categoriesOd.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               rep1 != null &&
                               type1 != null &&
                               rep == null)
                      {
                          if (report.equals("1") &&
                              type1.equals("1") &&
                              type.equals("1") &&
                              rep1.equals("2"))
                          {
                              queryStatus = 5; 
                              condStatus = 5;
                              categories[0] = korona == null ? "0" : "17687"; 
                              categories[1] = contact == null ? "0" : "17688"; 
                              categories[2] = monex == null ? "0" : "17692"; 
                              categories[3] = xezri == null ? "0" : "17694"; 
                              categories[4] = upt == null ? "0" : "17695";  
                              categories[5] = wunion == null ? "0" : "17683";
                              categories[6] = lider == null ? "0" : "17690";
                              categories[7] = iba_express == null ? "0" : "17693";
                              chekBoxValues = conValues(categories);
                              categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                              categories[0] = korona == null ? "0" : "12693"; 
                              categories[1] = contact == null ? "0" : "12694"; 
                              categories[2] = monex == null ? "0" : "12696"; 
                              categories[3] = xezri == null ? "0" : "12698"; 
                              categories[4] = upt == null ? "0" : "12684";  
                              categories[5] = wunion == null ? "0" : "12689";
                              categories[6] = lider == null ? "0" : "12695";
                              categories[7] = iba_express == null ? "0" : "12697";
                              chekBoxValues = conValues(categories);
                              categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                              chekBoxCurrVal = conValues(AllCur);
                              allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                              ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                          + "filial_code=" + RepFilial.trim() + "/"
                                          + "recipient_country=" + country.trim() + "/"
                                          + "recipient_name=" + sender.trim() + "/"
                                          + "passp_no=" + PASSP_NO.trim() + "/"
                                          + "categorieskoc=" + categoriesKoc.trim() + "/"
                                          + "categoriesod=" + categoriesOd.trim() + "/"
                                          + "currencyid=" + allCurrency.trim();
                            }
                      }
                      else if (report != null &&
                               type != null &&
                               type1 != null &&
                               rep != null &&
                               rep1 != null)
                      {
                          if (report.equals("1") &&
                              type1.equals("1") &&
                              type.equals("1") &&
                              rep.equals("1") &&
                              rep1.equals("2"))
                          {
                              queryStatus = 6; 
                              condStatus = 6;
                              categories[0] = korona == null ? "0" : "17687"; 
                              categories[1] = contact == null ? "0" : "17688"; 
                              categories[2] = monex == null ? "0" : "17692"; 
                              categories[3] = xezri == null ? "0" : "17694"; 
                              categories[4] = upt == null ? "0" : "17695";  
                              categories[5] = wunion == null ? "0" : "17683";
                              categories[6] = lider == null ? "0" : "17690";
                              categories[7] = iba_express == null ? "0" : "17693";
                              chekBoxValues = conValues(categories);
                              categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                              categories[0] = korona == null ? "0" : "12693"; 
                              categories[1] = contact == null ? "0" : "12694"; 
                              categories[2] = monex == null ? "0" : "12696"; 
                              categories[3] = xezri == null ? "0" : "12698"; 
                              categories[4] = upt == null ? "0" : "12684"; 
                              categories[5] = wunion == null ? "0" : "12689";
                              categories[6] = lider == null ? "0" : "12695";
                              categories[7] = iba_express == null ? "0" : "12697";
                              chekBoxValues = conValues(categories);
                              categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                              chekBoxCurrVal = conValues(AllCur);
                              allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                              ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                          + "filial_code=" + RepFilial.trim() + "/"
                                          + "recipient_country=" + country.trim() + "/"
                                          + "recipient_name=" + sender.trim() + "/"
                                          + "passp_no=" + PASSP_NO.trim() + "/"
                                          + "categorieskoc=" + categoriesKoc.trim() + "/"
                                          + "categoriesod=" + categoriesOd.trim() + "/"
                                          + "currencyid=" + allCurrency.trim();
                            }
                      }
                      else if (report != null &&
                               type != null &&
                               type1 == null &&
                               rep1 != null &&
                               rep != null)
                     {
                         if (report.equals("1") &&
                             type.equals("1") &&
                             type1 == null && 
                             rep.equals("1") &&
                             rep1.equals("2")) 
                         {
                             queryStatus = 7; 
                             condStatus = 7;
                             categories[0] = korona == null ? "0" : "17687"; 
                             categories[1] = contact == null ? "0" : "17688"; 
                             categories[2] = monex == null ? "0" : "17692"; 
                             categories[3] = xezri == null ? "0" : "17694"; 
                             categories[4] = upt == null ? "0" : "17695";  
                             categories[5] = wunion == null ? "0" : "17683";
                             categories[6] = lider == null ? "0" : "17690";
                             categories[7] = iba_express == null ? "0" : "17693";
                             chekBoxValues = conValues(categories);
                             categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;
                             chekBoxCurrVal = conValues(AllCur);
                             allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                             ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                         + "filial_code=" + RepFilial.trim() + "/"
                                         + "recipient_country=" + country.trim() + "/"
                                         + "recipient_name=" + sender.trim() + "/"
                                         + "passp_no=" + PASSP_NO.trim() + "/"
                                         + "category=" + categoriesKoc.trim() + "/"
                                         + "currencyid=" + allCurrency.trim();


                         }
                 
                     }
                     else if (report != null &&
                              type == null &&
                              type1 != null &&
                              rep1 != null &&
                              rep != null 
                              )
                      {
                        if (report.equals("1") &&
                            type1.equals("1") &&
                            rep.endsWith("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 8; 
                            condStatus = 8;
                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684"; 
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "category=" + categoriesOd.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      if (report != null &&
                          type != null &&
                          type1 == null &&
                          rep1 == null &&
                          rep != null)
                      {
                        if (report.equals("2") &&
                            type.equals("1") &&
                            type1 == null && 
                            rep.equals("1")) 
                        {
                            queryStatus = 9; 
                            condStatus = 9;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();


                        }
                     }
                     else if (report != null &&
                              type == null &&
                              rep1 == null &&
                              type1 != null &&
                              rep != null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            rep.equals("1") )   
                        {
                            queryStatus = 10; 
                            condStatus = 10;
                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               type1 != null &&
                               rep1 == null &&
                               rep != null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            type.equals("1") &&
                            rep.equals("1") )   
                        {
                            queryStatus = 11; 
                            condStatus = 11;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684"; 
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               type1 == null &&
                               rep1 != null &&
                               rep == null)
                     {
                        if (report.equals("2") &&
                            type.equals("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 12; 
                            condStatus = 12;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695"; 
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type == null &&
                               rep1 != null &&
                               type1 != null &&
                               rep == null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 13; 
                            condStatus = 13;
                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684"; 
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               rep1 != null &&
                               type1 != null &&
                               rep == null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            type.equals("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 11; 
                            condStatus = 11;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684"; 
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               rep1 != null &&
                               type1 != null &&
                               rep == null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            type.equals("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 11; 
                            condStatus = 11;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               rep1 != null &&
                               type1 != null &&
                               rep != null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            type.equals("1") &&
                            rep.equals("1") &&
                            rep1.equals("2") )   
                        {
                            queryStatus = 14; 
                            condStatus = 14;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type != null &&
                               rep1 != null &&
                               type1 == null &&
                               rep != null)
                     {
                        if (report.equals("2") &&
                            type.equals("1") &&
                            rep.equals("1") &&
                            rep1.equals("2"))   
                        {
                            queryStatus = 15; 
                            condStatus = 15;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                      else if (report != null &&
                               type == null &&
                               rep1 != null &&
                               type1 != null &&
                               rep != null)
                     {
                        if (report.equals("2") &&
                            type1.equals("1") &&
                            rep.equals("1") &&
                            rep1.equals("2"))   
                        {
                            queryStatus = 16; 
                            condStatus = 16;
                            categories[0] = korona == null ? "0" : "17687"; 
                            categories[1] = contact == null ? "0" : "17688"; 
                            categories[2] = monex == null ? "0" : "17692"; 
                            categories[3] = xezri == null ? "0" : "17694"; 
                            categories[4] = upt == null ? "0" : "17695";  
                            categories[5] = wunion == null ? "0" : "17683";
                            categories[6] = lider == null ? "0" : "17690";
                            categories[7] = iba_express == null ? "0" : "17693";
                            chekBoxValues = conValues(categories);
                            categoriesKoc = chekBoxValues == null ? "" : chekBoxValues;

                            categories[0] = korona == null ? "0" : "12693"; 
                            categories[1] = contact == null ? "0" : "12694"; 
                            categories[2] = monex == null ? "0" : "12696"; 
                            categories[3] = xezri == null ? "0" : "12698"; 
                            categories[4] = upt == null ? "0" : "12684";  
                            categories[5] = wunion == null ? "0" : "12689";
                            categories[6] = lider == null ? "0" : "12695";
                            categories[7] = iba_express == null ? "0" : "12697";
                            chekBoxValues = conValues(categories);
                            categoriesOd = chekBoxValues == null ? "" : chekBoxValues;
                            chekBoxCurrVal = conValues(AllCur);
                            allCurrency = chekBoxCurrVal == null ? "" : chekBoxCurrVal;
                            ParamsValue = "act_date=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE.trim() + "','dd.mm.yyyy')" + "/"
                                        + "filial_code=" + RepFilial.trim() + "/"
                                        + "recipient_country=" + country.trim() + "/"
                                        + "recipient_name=" + sender.trim() + "/"
                                        + "passp_no=" + PASSP_NO.trim() + "/"
                                        + "categoriesod=" + categoriesOd.trim() + "/"
                                        + "categorieskoc=" + categoriesKoc.trim() + "/"
                                        + "currencyid=" + allCurrency.trim();
                        } 
                      }
                array[0] = 37;
                array[1] = queryStatus;
                array[2] = condStatus;
                array[3] = ParamsValue;
                array[4] = username;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="37"/> 
            <jsp:param name="QueryStatus" value="<%=queryStatus%>"/>
            <jsp:param name="CondStatus" value="<%=condStatus%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=username%>"/> 
         </jsp:forward>
        <%

                break;

            }
            case 1: {
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>
        <% break;
                    }
                }
            }
        %>
    </body>
</html>
