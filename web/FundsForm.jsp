<%-- 
    Document   : CarPricingRepForm
    Created on : Oct 13, 2014, 12:18:16 PM
    Author     : x.daşdəmirov
--%>

<%@page import="ExcelUtility.WorkExcel"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
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
            if (request.getParameter("RepType") != null) {
                
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
            
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;

                int RepType = Integer.parseInt(request.getParameter("RepType"));

                String TarixB = request.getParameter("TrDateB");
                String TarixE = request.getParameter("TrDateE");
                String country = request.getParameter("country");
                String bank = request.getParameter("bank");
                String RSbank = request.getParameter("RSbank");
                String bic_code = request.getParameter("bic_code");
                String account = request.getParameter("account");
                String chkSelectAll = request.getParameter("chkSelectAll");
                String xohks = request.getParameter("X");
                String swift = request.getParameter("S");
                String azips = request.getParameter("A");
                String azn = request.getParameter("azn");
                String eur = request.getParameter("eur");
                String usd = request.getParameter("usd");
                String gbp = request.getParameter("gbp");
                String rub = request.getParameter("rub");
                String jpy = request.getParameter("jpy");
                String chf = request.getParameter("chf");
                String try1 = request.getParameter("try");
                String RepFilial = request.getParameter("RepFilial");
                String status = request.getParameter("status");
                String user_name = request.getParameter("uname");
                
                if (country != null && country != "" && !country.trim().equals("")) 
                {
                    country = country.equals("0") ? "" : "'" + country + "'"; 
                }
                
                if (bank != null && bank != "" && !bank.trim().equals("")) 
                {
                    bank = bank.equals("0") ? "" : "'" + bank + "'"; 
                }
                
                if (RSbank != null && RSbank != "" && !RSbank.trim().equals("")) 
                {
                    RSbank = RSbank.equals("0") ? "" : "'" + RSbank.substring(0, 8) + "'"; 
                }
                
                if (bic_code != null && bic_code != "" && !bic_code.trim().equals("")) 
                {
                    bic_code = bic_code.isEmpty() ? "" : "'" +  bic_code + "'"; 
                }
                
                if (account != null && account != "" && !account.trim().equals("")) 
                {
                    account = account.isEmpty() ? "" : "'" + account + "'"; 
                }
                
                if (chkSelectAll != null && chkSelectAll != "" && !chkSelectAll.trim().equals("")) 
                {
                    chkSelectAll = chkSelectAll.isEmpty() ? "" : chkSelectAll; 
                }
                
                if (xohks != null && xohks != "" && !xohks.trim().equals("")) 
                {
                    xohks = xohks.isEmpty() ? "" : xohks; 
                }
                
                if (swift != null && swift != "" && !swift.trim().equals("")) 
                {
                    swift = swift.isEmpty() ? "" : swift; 
                }
                
                if (azips != null && azips != "" && !azips.trim().equals("")) 
                {
                    azips = azips.isEmpty() ? "" : azips; 
                }
                
                if (azn != null && azn != "" && !azn.trim().equals(""))
                {
                    azn = azn.isEmpty() ? "0" : azn; 
                }
                
                if (eur != null && eur != "" && !eur.trim().equals("")) 
                {
                    eur = eur.isEmpty() ? "0" : eur; 
                }
                
                if (usd != null && usd != "" && !usd.trim().equals("")) 
                {
                    usd = usd.isEmpty() ? "0" : usd; 
                }
                
                if (gbp != null && gbp != "" && !gbp.trim().equals("")) 
                {
                    gbp = gbp.isEmpty() ? "0" : gbp; 
                }
                
                if (rub != null && rub != "" && !rub.trim().equals("")) 
                {
                    rub = rub.isEmpty() ? "0" : rub; 
                }
                
                if (jpy != null && jpy != "" && !jpy.trim().equals(""))
                {
                    jpy = jpy.isEmpty() ? "0" : jpy; 
                }
                
                if (chf != null && chf != "" && !chf.trim().equals("")) 
                {
                    chf = chf.isEmpty() ? "0" : chf; 
                }
                
                if (try1 != null && try1 != "" && !try1.trim().equals(""))
                {
                    try1 = try1.isEmpty() ? "0" : try1; 
                }
                
                if (RepFilial != null && RepFilial != "" && !RepFilial.trim().equals(""))
                {
                    RepFilial = RepFilial.equals("0") ? "" : RepFilial; 
                }
                
                String ParamsValue = "datesinterval=to_date('" + TarixB.trim() + "','dd.mm.yyyy') and to_date('" + TarixE  + "','dd.mm.yyyy')/"
                                   + "typepaymentsystem='"+ xohks + "','" + swift + "','" + azips + "'/"
                                   + "currencies="+azn+","+eur+","+usd+","+gbp+","+rub+","+jpy+","+chf+","+try1+"/"
                                   + "filialcode=" + RepFilial.trim() +"/"
                                   + "correspondent_bank=" + bank.trim() + "/"
                                   + "swiftbic=" + RSbank + "/"
                                   + "biccode=" + bic_code.trim() + "/"
                                   + "iban=" + account.trim() + "/"
                                   + "recipientcountry=" +country.trim() + "/" 
                                   + "sender_country=" + country.trim() + "";
                array[0] = 54;
                array[1] = status;
                array[2] = status;
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="54"/> 
            <jsp:param name="QueryStatus" value="<%=status%>"/>
            <jsp:param name="CondStatus" value="<%=status%>"/>
            <jsp:param name="Params" value="<%=ParamsValue%>"/> 
            <jsp:param name="UserName" value="<%=user_name%>"/> 
        </jsp:forward>
        <%
                break;

            }
            case 1: { FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
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
