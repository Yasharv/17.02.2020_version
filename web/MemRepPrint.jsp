<%-- 
    Document   : index
    Created on : Nov 8, 2012, 11:16:34 AM
    Author     : m.aliyev
--%>

<%@page import="java.math.BigDecimal"%>
<%@page import="DBUtility.WorkDatabase"%>
<%@page import="java.util.Objects"%>
<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="main.PrDict"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.*"%>
<%@page import="main.DB"%>
<%@page import="main.MemorialRep"%>
<%@page import="DBUtility.DataSource"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
        <style type="text/css" media="print">
            @page 
            {
                size: A4 portrait;   /* auto is the initial value */
                margin: 15mm 10mm 15mm 10mm;  /* this affects the margin in the printer settings */
            }
            .NonPrintable
            {
                display: none;
            }      
        </style>
    </head>
    <body bgcolor=#E0EBEA> <!--  #E8E8E8 -->

    

        <%
            DataSource dataSource = new DataSource();
            Connection dbConnection = null;
            ResultSet sqlres = null;
            
            WorkDatabase wd = new WorkDatabase();
            Object[] array = new Object[5];
            ReadPropFile rf = new ReadPropFile();
            Properties properties = null;
            properties = rf.ReadConfigFile("StoredProcedureName.properties");
            
            String dateFrom = null;
            String dateTo = null;
                
            Date d = new Date();
            PrDict dict = new PrDict();
            MemorialRep RepTrans = new MemorialRep();
            
            String[] PrIDs = null;
            
            String br = request.getParameter("brNum");
            
            if (br.equals("100")) {
                br = "0";
            }
            
            String usName = request.getParameter("username");
            String DateB = request.getParameter("dtb");
            String DateE = request.getParameter("dte");
            dateFrom = DateB;
            dateTo = DateE;
            if (DateB.equals(DateE)) {
                DateE = "";
            }

            if (Objects.nonNull(request.getParameter("id"))) 
            {
                PrIDs = request.getParameterValues("id");
            } 
            else 
            {
                PrIDs = request.getParameterValues("ids");
            }
            
            WorkDatabase wdb = new WorkDatabase();
            wdb.setMemOrederId(PrIDs,usName);
            
            String ParamsValue = "datesintervals=to_date('" + dateFrom.trim() + "','dd.mm.yyyy') and to_date('" + dateTo.trim() + "','dd.mm.yyyy')/"
                               + "users_id_value='" + usName + "'";
            
            array[0] = 3;
            array[1] = 7;
            array[2] = 7;
            array[3] = ParamsValue;
            array[4] = usName;
            
            dbConnection = dataSource.getConnection();
            sqlres = wd.callOracleStoredProcCURSORParameter(array, properties.getProperty("ProcName"), 0, dbConnection);
            BigDecimal sumAmount = new BigDecimal("0.00");
            BigDecimal sumLAmount = new BigDecimal("0.00");
                                        
        %>
        <table width="100%" border="0" align="center">
            <tr>
                <td valign="top" align="left">

                </td>
                <td>
                </td>
                <td valign="top" align="right">
                    <FORM> <INPUT TYPE="button" name=print value="Print" onClick="window.print()" class="NonPrintable"></FORM>
                </td>
            </tr> 
            <tr>
                <td valign="top" align="left">  
                </td>
                <td valign="top" align="center">

                    <table bgcolor='white' border='1' width="900" cellspacing="1">
                        <tr>
                            <td>
                                <table bgcolor='white' border='0' width="900">
                                    <tr>
                                        <td align="left"> <font size="5"> Expressbank ASC <% out.println(dict.getFililal(Integer.parseInt(br)));%> </font> <br> VÖEN: 1500031691</td>
                                    </tr>  
                                    <tr>
                                        <td align="center"> <font size="5"> Memorial Orderi </font> </td>
                                    </tr> 
                                    <tr>
                                        <td align="center">
                                            <font size="4"> 
                                            <%
                                                out.println(DateB);
                                                out.println("&nbsp;");
                                                out.println(DateE);
                                            %> 
                                            </font>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td align="center"> <font size="4"> Bütün valyutalar </font> </td>
                                    </tr> 
                                </table>
                                <table bgcolor='white' border='1' width="900" cellpadding="1" cellspacing="0">
                                    <tr>
                                        <th width="39" align="center"> Sənəd № </th>
                                        <th width="46" align="center"> Valyuta </th>
                                        <th width="240" align="center"> D E B E T hesabı </th>
                                        <th width="46" align="center"> Valyuta </th>
                                        <th width="240" align="center"> K R E D İ T hesabı </th>
                                        <th align="center" width="100"> M Ə B L Ə Ğ<BR>
                                            <table bgcolor='white' border='0' width="230">
                                                <tr>
                                                    <td align="center" width='60'>
                                                        Valyutada
                                                    </td>
                                                    <td align="center" width='60'>
                                                        Manatla
                                                    </td>
                                                </tr>
                                            </table> 
                                        </th>
                                      <th width="20" align="center"> İB </th>
                                    </tr> 
                                </table>
                                <%
                                    String DVal = "";
                                    String DAccNo = "";
                                    String CVal = "";
                                    String CAccNo = "";
                                    double Ammount = 0;
                                    double LAmmount = 0;
                                    double SumAmmount = 0;
                                    double SumLAmmount = 0;
                                    String DAccName = "";
                                    String CAccName = "";
                                    String DInn = "";
                                    String CInn = "";
                                    String TrName = "";
                                    String ib = "";
                                    int cnt = 0;

                                    while (sqlres.next()) {
                                        DVal = sqlres.getString(3);
                                        DAccNo = sqlres.getString(2);
                                        CVal = sqlres.getString(6);
                                        CAccNo = sqlres.getString(5);
                                        Ammount = sqlres.getDouble(16);
                                        LAmmount = sqlres.getDouble(17);
                                        DAccName = sqlres.getString(11);
                                        CAccName = sqlres.getString(12);
                                        DInn = sqlres.getString(18);
                                        CInn = sqlres.getString(19);
                                        TrName = sqlres.getString(8);
                                        ib = sqlres.getString(27);
                                        cnt++;
                                        sumAmount = sumAmount.add(sqlres.getBigDecimal(16));
                                        sumLAmount = sumLAmount.add(sqlres.getBigDecimal(17));
                                        out.println(RepTrans.main(DVal, DAccNo, CVal, CAccNo, Ammount, LAmmount, DAccName, CAccName, DInn, CInn, TrName, cnt, ib));
                                    }
                                    
                                    if (sqlres != null)
                                    {
                                        sqlres.close();
                                    }
                                    
                                    if (dbConnection != null)
                                    {
                                        dbConnection.close();
                                    }
                                    
                                %>

                                <table  bgcolor='white' border='0' width='900'>
                                    <tr>
                                        <td width="642"  align="left"> Cəmi: </td> 
                                        <td width="118" align="right"> <% out.println(sumAmount); %></td>  
                                        <td width="118" align="right"> <% out.println(sumLAmount);%></td>        
                                    </tr>
                                </table>
                                <table  bgcolor='white' border='0' width='900'>
                                    <tr>
                                        <td width="642"  align="center">
                                            <p>
                                                &ensp;
                                            </p>
                                            <p>  <font size="4">
                                                &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Məsul İcraçı _________________________ 
                                                </font>
                                            </p>
                                        </td>     
                                    </tr>
                                </table>
                            </td>
                    </table> 

                </td>
                <td valign="top" align="right">   
                </td>
            </tr>    
        </table>
    </body>
</html>
