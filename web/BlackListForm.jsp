<%-- 
    Document   : GoldPricingRep
    Created on : Oct 9, 2014, 3:02:35 PM
    Author     : emin.mustafayev
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
            Object[] array = new Object[5];
            WorkExcel we = new WorkExcel();
            
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;    
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            String FileNamePath = null;
            String[] contractArr = null;
            String contractId = "";
            String[] otherOfficerArr = null;
            String OtherOff = "";
            String[] ProblemDepartUserArr = null;
            String probDepUser = "";
            
            String DateB = request.getParameter("DateB");
            String DateE = request.getParameter("DateE");
            String Filial = request.getParameter("Filial");
            String productId = request.getParameter("product_id");
            String custid = request.getParameter("custid");
            String contrid = request.getParameter("contract_id");
            String status = request.getParameter("status");
            String status_real = request.getParameter("status_real");
            String PROBLEM_DEPARTMENT_USER = request.getParameter("PROBLEM_DEPARTMENT_USER");
            String other_officer = request.getParameter("other_officer");
            String user_name = request.getParameter("uname");
            
            if (Filial != null && Filial != "" && !Filial.trim().equals("")) 
            {
                Filial = Filial.equals("0") ? "" : Filial; 
            }
            
            if (productId != null && productId != "" && !productId.trim().equals("")) 
            {
                productId = productId.equals("0") ? "" : productId; 
            }
            
            if (custid != null && custid != "" && !custid.trim().equals(""))
            {
                custid = custid.isEmpty() ? "" : custid;  
            }

            if (contrid != null && contrid != "" && !contrid.trim().equals(""))
            {
                if (contrid.isEmpty())
                {
                    contrid = "";
                }
                else
                {
                    contractArr  = contrid.split(",");
                    for (int i=0; i < contractArr.length; i++)
                    {
                        contractId = contractId + ",'" + contractArr[i] + "'"; 
                    }
                    contrid = contractId.substring(1);
                }
            }

            if (PROBLEM_DEPARTMENT_USER != null && PROBLEM_DEPARTMENT_USER != "" && !PROBLEM_DEPARTMENT_USER.trim().equals(""))
            {
                if (PROBLEM_DEPARTMENT_USER.isEmpty())
                {
                    PROBLEM_DEPARTMENT_USER = "";
                }
                else
                {
                    ProblemDepartUserArr  = PROBLEM_DEPARTMENT_USER.split(",");
                    for (int i=0; i < ProblemDepartUserArr.length; i++)
                    {
                        probDepUser = probDepUser + ",'" + ProblemDepartUserArr[i] + "'"; 
                    }
                    PROBLEM_DEPARTMENT_USER = probDepUser.substring(1);
                }
            }
            
            if (other_officer != null && other_officer != "" && !other_officer.trim().equals(""))
            {
                if (other_officer.isEmpty())
                {
                    other_officer = "";
                }
                else
                {
                    otherOfficerArr  = other_officer.split(",");
                    for (int i=0; i < otherOfficerArr.length; i++)
                    {
                        OtherOff = OtherOff + ",'" + otherOfficerArr[i] + "'"; 
                    }
                    other_officer = OtherOff.substring(1);
                }
            }            

            if (status != null && status != "" && !status.trim().equals("")) 
            {
                status = status.equals("0") ? "" : "'" + status + "'"; 
            }
            
            if (status_real != null && status_real != "" && !status_real.trim().equals("")) 
            {
                status_real = status_real.equals("0") ? "" : "'" + status_real + "'"; 
            }
            
            String ParamsValue = "datesinterval=to_date('" + DateB.trim() + "','dd.mm.yyyy') and to_date('" + DateE.trim() +"','dd.mm.yyyy')/"
                               + "dateto=to_date('" + DateE.trim() +"','dd.mm.yyyy')/"
                               + "productid=" + productId.trim() + "/"
                               + "customerid=" + custid.trim() + "/"
                               + "filialcode=" + Filial.trim() + "/"
                               + "contractid=" + contrid.trim() + "/"
                               + "problemdepartment=" + status.trim() + "/"
                               + "probdepartmentreal=" + status_real.trim() + "/"
                               + "problemdeparuser=" + PROBLEM_DEPARTMENT_USER.trim() + "/"
                               + "otherofficer=" + other_officer.trim();

            array[0] = 19;
            array[1] = "1";
            array[2] = "1";
            array[3] = ParamsValue;
            array[4] = user_name;

            FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);
    %>
    <jsp:forward page="DownloadsFile">    
        <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
    </jsp:forward>
    </body>
</html>