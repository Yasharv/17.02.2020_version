
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

            request.setCharacterEncoding("UTF-8");
            if (request.getParameter("RepType") != null) 
            {

                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
            
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                String FileNamePath = null;
                String equalsOperatorValue = "";
                String lessOrEqualsOperatorValue = "";
                String GreatherOrEqualsOperatorValue = "";
                
                int RepType = Integer.parseInt(request.getParameter("RepType"));

                String DateB = request.getParameter("DateB");
                String DateE = request.getParameter("DateE");
                String custid = request.getParameter("custid");
                String product = request.getParameter("product");
                String branch = request.getParameter("branch");
                String amount = request.getParameter("amount");
                String amount_rel = request.getParameter("amount_rel");
                String user_name = request.getParameter("uname");

                if (custid != null && custid != "" && !custid.trim().equals(""))
                {
                    custid = custid.isEmpty() ? "" : custid;
                }

                if (product != null && product != "" && !product.trim().equals("")) 
                {
                    product = product.equals("0") ? "" : product; 
                }
                
                if (branch != null && branch != "" && !branch.trim().equals("")) 
                {
                    branch = branch.equals("0") ? "" : branch; 
                }
                
                if(!amount.isEmpty())
                {
                    if(!amount.equals("0"))
                    {
                        if(amount_rel.equals("1"))
                        {
                            equalsOperatorValue = amount.trim();
                        }
                        else if(amount_rel.equals("2"))
                        {
                            lessOrEqualsOperatorValue = amount.trim();
                        }
                        else if(amount_rel.equals("3"))
                        {
                            GreatherOrEqualsOperatorValue = amount.trim();
                        }
                    }
                }
                
                String ParamsValue = "datefrom=to_date('"+ DateB.trim() +"','dd.mm.yyyy')/"
                                   + "dateto=to_date('"+ DateE.trim() +"','dd.mm.yyyy')/"
                                   + "customerid=" + custid.trim()+ "/"
                                   + "productid=" + product.trim() +"/"
                                   + "filialcode=" + branch.trim() + "/"
                                   + "equalsoperatorvalue=" + equalsOperatorValue.trim() + "/"
                                   + "lessorequalsopervalue=" + lessOrEqualsOperatorValue.trim() + "/"
                                   + "greatherorequaloperatorval=" + GreatherOrEqualsOperatorValue.trim();
                
                array[0] = 30;
                array[1] = "1";
                array[2] = "1";
                array[3] = ParamsValue;
                array[4] = user_name;
                
                switch (RepType) {
                    case 0: {
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="30"/> 
            <jsp:param name="QueryStatus" value="1"/>
            <jsp:param name="CondStatus" value="1"/>
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
