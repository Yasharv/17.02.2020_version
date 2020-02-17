<%-- 
    Document   : ControlTapeRepForms
    Created on : Jan 8, 2014, 12:53:05 PM
    Author     : m.aliyev
--%>

<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.util.Properties"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            if (request.getParameter("RepForm") != null) {
                
                /*--- Added by Ceyhun 09.04.2019 -- */
                WorkExcel we = new WorkExcel();
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                
                String closedAccs = "";
                String currencies = "";
                String srcvalueArr[] = null;
                String srcValueNew = "";
                String srcvalue = "";
                String srcval = "";
                String customersId = "";
                String custId = "";
                String glsAcctNoin = "";
                String glAcctN = "";
                String voensValue = "";
                String voenVal = "";
                /*--- Added by Ceyhun 09.04.2019 -- */
                
                int RepForm = Integer.parseInt(request.getParameter("RepForm"));
                PrDict dict = new PrDict();
                String uname = request.getParameter("uname");
                String br = request.getParameter("br");

                String srcValue = request.getParameter("srcValue");
                String forSrc = request.getParameter("forSrc");
                int repType = Integer.parseInt(request.getParameter("repType"));
                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                String reval = request.getParameter("reval");
                String Filial = request.getParameter("Filial");
                String sigorta = request.getParameter("sigorta");
                
                /*--- Added by Ceyhun 09.04.2019 -- */
                closedAccs = request.getParameter("closedaccs");
                srcValueNew = srcValue;
                /*--- Added by Ceyhun 09.04.2019 -- */

                String turnover = "1";
                String closedaccs = "1";
                if (request.getParameter("turnover") == null || request.getParameter("turnover").equals("null")) {
                    turnover = "0";
                }
                String isClosed = "";
                if (request.getParameter("closedaccs") == null || request.getParameter("closedaccs").equals("null")) {
                    isClosed = " AND b.closure_date is null";
                }

                String[] DVal1 = null;
                String DVal = "";
                if (repType == 1) {
                    srcValue = srcValue.replace(",", "','");
                }

                if (!(request.getParameterValues("DebVal") == null)) {
                    DVal1 = request.getParameterValues("DebVal");
                }

                if (!(DVal1 == null)) {
                    for (int i = 0; i < DVal1.length; i++) {
                        DVal = DVal + "," + DVal1[i];
                    };
                    DVal = DVal.substring(1);
                    currencies = DVal; // Added by Ceyhun 09.04.2019
                    DVal = " and a.currency_id in (" + DVal + ")";
                } else {
                    DVal = "";
                }

                String salary_gr = dict.SelUserInfo(uname, 6);
                String CategForSalary = " AND nvl(b.category,0)<>1200";
                if (salary_gr.equals("1")) {
                    CategForSalary = " ";
                }

                String SqlAccs = "SELECT b.date_from, b.alt_acct_id, b.customer_id, a.gl_acct_no, "
                        + " a.account_title,a.curr_name,a.currency_id,a.opening_date,a.ap,a.filial_code,nvl(b.voen,' ')"
                        + " FROM bi_account_inf_bal b, vi_account_inf_bal a  ";

                int iforSrc = Integer.valueOf(forSrc);
                switch (iforSrc) {
                    case 1:
                        SqlAccs = SqlAccs + " where b.customer_id in (" + srcValue + ")";
                        break;
                    case 2:
                        if (repType == 1) {
                            SqlAccs = SqlAccs + " where b.alt_acct_id in ('" + srcValue + "')";
                        } else {
                            SqlAccs = SqlAccs + " where b.alt_acct_id like ('%" + srcValue + "%')";
                        }
                        break;
                    case 3:
                        SqlAccs = SqlAccs + " where a.gl_acct_no in ('" + srcValue + "')";
                        break;

                    case 4:
                        SqlAccs = SqlAccs + " where b.VOEN in (" + srcValue + ")";
                        break;
                }

                SqlAccs = SqlAccs + " AND b.date_from = a.date_from"
                        + " AND a.alt_acct_id = b.alt_acct_id"
                        + " AND a.customer_id = b.customer_id  " + DVal + " and a.filial_code like('%" + Filial + "%')" + isClosed + CategForSalary
                        + "  order by a.gl_acct_no  ";

                //System.out.println("SqlAccs   " + SqlAccs);
                
                /*--- Added by Ceyhun 09.04.2019 -- */
                if (srcValueNew != null)
                {
                    if (srcValueNew.trim().isEmpty())
                    {
                        srcvalue = "";
                        customersId = "";
                        glsAcctNoin = "";
                        voensValue = "";
                    }
                    else
                    {
                        srcvalueArr  = srcValueNew.split(",");
                        for (int i = 0; i < srcvalueArr.length; i++)
                        {
                            switch (iforSrc) 
                            {
                                case 1:
                                    custId = custId + "," + srcvalueArr[i];
                                    break;
                                case 2:
                                    srcval = srcval + ",'" + srcvalueArr[i] + "'";
                                    break;
                                case 3:
                                    glAcctN = glAcctN + "," + srcvalueArr[i];
                                    break;

                                case 4:
                                    voenVal = voenVal + ",'" + srcvalueArr[i] + "'";
                                    break;
                            }
                        }
                        if (!(custId == null || custId.equals("")))
                        {
                            customersId = custId.substring(1);
                        }
                        
                        if (!(srcval == null || srcval.equals("")))
                        {
                            srcvalue = srcval.substring(1);
                        }
                        
                        if (!(glAcctN == null || glAcctN.equals("")))
                        {
                            glsAcctNoin = glAcctN.substring(1);
                        }
                        
                        if (!(voenVal == null || voenVal.equals("")))
                        {
                            voensValue = voenVal.substring(1);
                        }
                    }
                }
                /*--- Added by Ceyhun 09.04.2019 -- */
                
                /*--- Added by Ceyhun 09.04.2019 -- */
                if (Filial != null && !Filial.trim().equals("")) 
                {
                    Filial = Filial.equals("0") ? "" : Filial; 
                }
                /*--- Added by Ceyhun 09.04.2019 -- */
                
                switch (RepForm) {
                    case 1: {

                        break;
                    }
                    case 2: {FileNamePath = we.ExportDataToExcelForStatement("to_date('"+ DateB +"','dd.mm.yyyy')", //strDateB
                                                                      "to_date('"+ DateE +"','dd.mm.yyyy')", //strDateE
                                                                      br, // br
                                                                      reval, // reval
                                                                      turnover, // turnover
                                                                      sigorta, // sigorta
                                                                      closedAccs, // closedaccs
                                                                      Filial, // filialcode
                                                                      currencies, // currencies
                                                                      srcvalue, // srcValue
                                                                      customersId, // customersId
                                                                      glsAcctNoin, // glsAcctNoin,
                                                                      voensValue, // voensValue,
                                                                      uname, // userName,
                                                                      "87",
                                                                      properties.getProperty("ProcName"),
                                                                      0);
                        //System.out.println("StmtExcelSTPRnew1");
%>
<%--
        <jsp:forward page="StmtExcelSTPRnew1">
            <jsp:param name="DateB" value="<%=DateB%>"/>
            <jsp:param name="DateE" value="<%=DateE%>"/>
            <jsp:param name="br" value="<%=br%>"/>
            <jsp:param name="reval" value="<%=reval%>"/>
            <jsp:param name="sigorta" value="<%=sigorta%>"/>
            <jsp:param name="turnover" value="<%=turnover%>"/>
            <jsp:param name="SqlAccs" value="<%=SqlAccs%>"/>
            <jsp:param name="salary_gr" value="<%=salary_gr%>"/>
        </jsp:forward>
--%>
        <jsp:forward page="DownloadsFile">    
           <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>
        <% break;
            }
            case 3: {
        %>
        <% break;
                    }
                }
            }
        %>
    </body>
</html>