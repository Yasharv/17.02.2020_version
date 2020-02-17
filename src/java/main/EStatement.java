package main;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.*;

public class EStatement {

    public String main(String acc_no, String acc_name, String curr_name, int CurrID, String acc_open_date, String cust_inn, String DateB, String DateE, String AP, String reval) throws SQLException, ClassNotFoundException, UnknownHostException {
        Format formatter = new SimpleDateFormat("dd-MM-yyyy");
        DecimalFormat twoDForm = new DecimalFormat("#.##");
        String TrType = "";

        if (reval == null || reval == "") {
            TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6' ";
        } else if (Integer.parseInt(reval) == 1) {
            TrType = " ";
        }

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement();
        String SQLText = "SELECT tarix,currency_cr_name qarshi_val,acct_no_cr qarshi_hesab, "
                + " abs(decode(currency_dt_id-currency_cr_id,0,tr_amount_lcy_cr,tr_amount_fcy_cr)) as D_Ammount,"
                + " abs(tr_amount_lcy_dt) as DL_Ammount,"
                + " 0 as C_Ammount,0 as cl_ammount ,"
                + " decode(transaction_type,'PL-1','Komissiya - '||payment_purpose,payment_purpose ) teyinat,"
                + " currency_dt_id,currency_cr_id "
                + " FROM vi_transaction_account a  where acct_no_dt = ('" + acc_no + "') and (tarix BETWEEN to_date('" + DateB + "','yyyy-mm-dd') AND to_date('" + DateE + "','yyyy-mm-dd'))" + TrType
                + " union all"
                + " SELECT tarix,currency_dt_name qarshi_val,acct_no_dt qarshi_hesab, "
                + " 0 as D_Ammount,"
                + " 0 as DL_Ammount,"
                + " abs(decode(currency_cr_id-currency_dt_id,0,tr_amount_lcy_dt,tr_amount_fcy_dt)) as C_Ammount,"
                + " abs(tr_amount_lcy_cr) as CL_Ammount,"
                + " decode(transaction_type,'PL-1','Komissiya - '||payment_purpose,payment_purpose ) teyinat,"
                + " currency_dt_id,currency_cr_id "
                + " FROM vi_transaction_account a  where"
                + " acct_no_cr = ('" + acc_no + "') and (tarix BETWEEN to_date('" + DateB + "','yyyy-mm-dd') AND to_date('" + DateE + "','yyyy-mm-dd'))" + TrType;

        ResultSet sqlres = stmt.executeQuery(SQLText);

        Statement stmt2 = conn.createStatement();
        String SqlText2 = "SELECT date_from,currency_id,al_type,balance_fcy_amount,balance_lcy_amount "
                + " FROM si_account_balance a where a.alt_acct_id='" + acc_no + "' and date_from="
                + " (SELECT  max(tarix) FROM   vi_transaction_account  WHERE   (acct_no_dt = '" + acc_no + "'"
                + " OR acct_no_cr = '" + acc_no + "') AND tarix < TO_DATE ('" + DateB + "', 'yyyy-mm-dd'))";

        Statement stmt3 = conn.createStatement();
        String SqlText3 = "SELECT date_from,currency_id,al_type,balance_fcy_amount,balance_lcy_amount "
                + " FROM si_account_balance a where a.alt_acct_id='" + acc_no + "' and date_from="
                + " (SELECT  max(tarix) FROM   vi_transaction_account  WHERE   (acct_no_dt = '" + acc_no + "'"
                + " OR acct_no_cr = '" + acc_no + "') AND tarix <= TO_DATE ('" + DateE + "', 'yyyy-mm-dd'))";
        //---------------------------------------------------------------------   
        Statement stmEXCRate = conn.createStatement();
        String SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                + " AND TO_DATE ('" + DateB + "','yyyy-mm-dd') BETWEEN date_from AND date_until";

        ResultSet sqlresEXCRate = stmEXCRate.executeQuery(SqlTextEXCRate);
        float EXC_RATE_B = 0;
        while (sqlresEXCRate.next()) {
            EXC_RATE_B = sqlresEXCRate.getFloat(1);
        }
        sqlresEXCRate.close();
        //  stmEXCRate.close();

        SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                + " AND TO_DATE ('" + DateE + "','yyyy-mm-dd') BETWEEN date_from AND date_until";
        sqlresEXCRate = stmEXCRate.executeQuery(SqlTextEXCRate);

        float EXC_RATE_E = 0;
        while (sqlresEXCRate.next()) {
            EXC_RATE_E = sqlresEXCRate.getFloat(1);
        }
        sqlresEXCRate.close();
        stmEXCRate.close();
//----------------------------------------------------------------------
        String first_date = "";
        //int curr_id;
        String al_type = "";
        float first_ammount = 0;
        float first_Lammount = 0;
        String fAP = AP;
        String fAmmount = "";
        ResultSet sqlres2 = stmt2.executeQuery(SqlText2);
        while (sqlres2.next()) {
            first_date = new SimpleDateFormat("dd-MM-yyyy").format(sqlres2.getDate(1));
            //curr_id = sqlres2.getInt(2);
            al_type = sqlres2.getString(3);
            first_ammount = sqlres2.getFloat(4);
            first_Lammount = sqlres2.getFloat(5);
        }
        sqlres2.close();
        stmt2.close();
        if ((AP.equals("A")) && (first_Lammount > 0)) {
            fAP = "P";
        } else if ((AP.equals("P")) && (first_Lammount < 0)) {
            fAP = "A";
        }

        if (curr_name.equals("AZN")) {
            fAmmount = "Manat: " + Math.abs(first_Lammount);
        } else {
            fAmmount = "Valyuta: " + Math.abs(first_ammount) + "<br> Manat: " + Math.abs(first_Lammount) + "<BR> Rəsmi məzənnə: " + EXC_RATE_B;
        }
        //---------------------------------------------------------------------  
        String last_date = "";
        // int curr_id;
        // String al_type = "";
        float last_ammount = 0;
        float last_Lammount = 0;
        String lAP = AP;
        String lAmmount = "";
        ResultSet sqlres3 = stmt3.executeQuery(SqlText3);
        while (sqlres3.next()) {
            // last_date = new SimpleDateFormat("dd-MM-yyyy").format(sqlres3.getDate(1));
            //curr_id = sqlres3.getInt(2);
            //al_type = sqlres3.getString(3);
            last_ammount = sqlres3.getFloat(4);
            last_Lammount = sqlres3.getFloat(5);
        }
        sqlres3.close();
        stmt3.close();
        if ((AP.equals("A")) && (last_Lammount > 0)) {
            lAP = "P";
        } else if ((AP.equals("P")) && (last_Lammount < 0)) {
            lAP = "A";
        }

        if (curr_name.equals("AZN")) {
            lAmmount = "Manat: " + Math.abs(last_Lammount);
        } else {
            lAmmount = "Valyuta: " + Math.abs(last_ammount) + "<br> Manat: " + Math.abs(last_Lammount) + "<BR> Rəsmi məzənnə: " + EXC_RATE_E;
        }

        conn.close();
//---------------------------------------------------------------------  

        String grid = " <table border='1' width='900' bgcolor='white'>"
                + "<tr>"
                + "<td>"
                + "<table bgcolor='white' border='0'>"
                + " <tr>"
                + " <td width='900' height='185' valign='top'>"
                + "     <table width='900' border='0'>"
                + "  <tr>"
                + "    <td width='200'>&nbsp;</td>"
                + "     <td width='200'>&nbsp;</td>"
                + "    <td width='160'>Hesab №</td>"
                + "    <td width='200'> " + acc_no + " </td>"
                + "    <td width='160'> (" + acc_open_date + ") </td>"
                + "  </tr>"
                + " <tr>"
                + "    <td>Hesabın adı:</td>"
                + "    <td> " + acc_name + "</td>"
                + "   <td> &nbsp;</td>"
                + "   <td>&nbsp;</td> "
                + "   <td>&nbsp;</td> "
                + "  </tr>"
                + "  <tr>"
                + "   <td>VÖEN:</td>"
                + "  <td>" + cust_inn + "</td>"
                + " <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + " </tr>"
                + " <tr>"
                + " <td>Valyuta:</td>"
                + "  <td>" + curr_name + "</td>"
                + "  <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + "   <td>&nbsp;</td>"
                + "  </tr>"
                + " <tr>"
                + " <td>Əməliyyatların tarixi:</td>"
                + " <td> " + DateB + " &ensp; " + DateE + "</td>"
                + " <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + " <td>&nbsp;</td>"
                + "  </tr>"
                + " <tr>"
                + "  <td>Əvvəlki əməliyyat tarixi:</td>"
                + " <td>" + first_date + "</td>"
                + "  <td>&nbsp;</td>"
                + " <td>&nbsp;</td>"
                + " <td>&nbsp;</td>"
                + "  </tr>"
                + " <tr>"
                + "  <td valign='top'>Günün əvvəlinə qalıq:</td>"
                + "  <td>" + fAmmount + "</td>"
                + "  <td>&nbsp;</td>"
                + " <td>&quot;Expressbank&quot; ASC</td>"
                + " <td>&nbsp;</td>"
                + " </tr>"
                + "  </table>"
                + "  </td>"
                + " <td width='70' valign='top' ><img src='http://www.vipmen.az/photos/Express_bank_logo_220711.jpg' width='120' height='100'></td>"
                + " </tr>"
                + "<tr>"
                + " <td height='109' valign='top'>"
                + " <table width='900' border='0'>"
                + "<tr>"
                + "  <td width='100'>&nbsp;</td>"
                + "  <td width='50'>&nbsp;</td>"
                + " <td width='150'>&nbsp;</td>"
                + " <td width='80'>&nbsp;</td>"
                + " <td width='25'><center>(" + fAP + ")</center></td>"
                + " <td width='80'>&nbsp;</td>"
                + " <td width='250'>&nbsp;</td>"
                + "</tr>"
                + " <tr>"
                + "  <td><hr>Tarix:</td>"
                + "  <td><hr>Val.</td>"
                + "   <td><hr>Qarşı hesab:</td>"
                + "  <td><hr><center>Debet</center></td>"
                + " <td><hr>&nbsp;</td>"
                + "  <td><hr><center>Kredit</center></td>"
                + " <td><hr>Təyinat</td>"
                + " </tr> ";
        //------- emeliyyatlar 
        float dAmount = 0;
        float dLAmount = 0;
        float SumDAmount = 0;
        float SumDLAmount = 0;

        float cAmount = 0;
        float cLAmount = 0;
        float SumCAmount = 0;
        float SumCLAmount = 0;

        String Teyinat = "";
        String DAmount = "";
        String CAmount = "";
        String SummDAmount = "";
        String SummCAmount = "";

        int dCurrID = 0;
        int cCurrID = 0;
        int trCount = 0;
        while (sqlres.next()) {
            dAmount = sqlres.getFloat(4);
            dLAmount = sqlres.getFloat(5);
            cAmount = sqlres.getFloat(6);
            cLAmount = sqlres.getFloat(7);
            Teyinat = sqlres.getString(8);
            dCurrID = sqlres.getInt(9);
            cCurrID = sqlres.getInt(10);

            SumDLAmount = SumDLAmount + dLAmount;
            SumDAmount = SumDAmount + dAmount;

            SumCLAmount = SumCLAmount + cLAmount;
            SumCAmount = SumCAmount + cAmount;

            if ((dCurrID == 944) && (cCurrID == 944)) {
                DAmount = String.valueOf(dLAmount);
                CAmount = String.valueOf(cLAmount);
                SummDAmount = String.valueOf(SumDLAmount);
                SummCAmount = String.valueOf(SumCLAmount);
            } else {
                // DAmount = String.valueOf(Math.round(dLAmount*100)/100)+"<BR>"+ String.valueOf(Math.round(dAmount*100)/100);
                // CAmount = String.valueOf(Math.round(cLAmount*100)100)+"<BR>"+ String.valueOf(Math.round(cAmount*100)/100); 
                DAmount = String.valueOf(dLAmount) + "<BR>" + String.valueOf(dAmount);
                CAmount = String.valueOf(cLAmount) + "<BR>" + String.valueOf(cAmount);

                SummDAmount = String.valueOf(Double.valueOf(twoDForm.format(SumDLAmount))) + "<BR>" + String.valueOf(Double.valueOf(twoDForm.format(SumDAmount)));
                SummCAmount = String.valueOf(Double.valueOf(twoDForm.format(SumCLAmount))) + "<BR>" + String.valueOf(Double.valueOf(twoDForm.format(SumCAmount)));

            }
            grid = grid + " <tr>"
                    + "  <td valign='top'>" + new SimpleDateFormat("dd-MM-yyyy").format(sqlres.getDate(1)) + "</td>"
                    + "  <td valign='top'>" + sqlres.getString(2) + "</td>"
                    + " <td valign='top'>" + sqlres.getString(3) + "</td>"
                    + "  <td valign='top'><center>" + DAmount + "</center></td>"
                    + "  <td>&nbsp;</td>"
                    + "  <td valign='top'><center>" + CAmount + "</center></td>"
                    + "  <td valign='top'>" + Teyinat + "</td>"
                    + "  </tr>";
            trCount++;
        }
        //------- emeliyyatlar           

        grid = grid + "  <tr>"
                + " <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + "  <td valign='top'><hr>&nbsp;</hr></td>"
                + "  <td valign='top' align='center'><hr>" + SummDAmount + "</hr></td>"
                + " <td valign='top'><hr>&nbsp;</hr></td>"
                + "  <td valign='top' align='center'><hr>" + SummCAmount + "</hr></td>"
                + "  <td valign='top'><hr>&nbsp;</hr></td>"
                + "  </tr>"
                + " </table>"
                + "  </td>"
                + "<td height='109'>&nbsp;</td>"
                + "</tr>"
                + "<tr>"
                + " <td valign='top'>"
                + " <table width='900' height='54' border='0'>"
                + "  <tr>"
                + " <td width='159' height='23' valign='top'>Günün sonuna qalıq:</td>"
                + "  <td width='159'>" + lAmmount + "</td>"
                + "  <td width='159'>&nbsp;</td>"
                + " <td width='63'>&nbsp;</td>"
                + " <td width='136'>(" + lAP + ")</td>"
                + " <td width='289'>&nbsp;</td>"
                + "</tr>"
                + "<tr>"
                + " <td height='23'>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + "   <td>&nbsp;</td>"
                + "  <td>&nbsp;</td>"
                + " <td>Sənədlərin sayı: " + trCount + "</td>"
                + "  </tr>"
                + " </table>"
                + " </td>"
                + "  <td>&nbsp;</td>"
                + " <tr>"
                + "</table>"
                + " </td>"
                + "</tr>"
                + "</table>";

        return grid;
    }
}
