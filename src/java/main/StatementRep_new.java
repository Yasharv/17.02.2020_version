package main;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StatementRep_new {

    public static void main_aaaa(String args[]) throws SQLException, ClassNotFoundException, UnknownHostException {

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement();
        String SQLText = "SELECT branch_id, gb_description FROM di_branch order by branch_id";
        ResultSet sqlres = stmt.executeQuery(SQLText);

        while (sqlres.next()) {
            //         System.out.println(sqlres.getString(1) + "  " + sqlres.getString(2));
        }

        sqlres.close();
        sqlres = stmt.executeQuery(SQLText);
        while (sqlres.next()) {
            //     System.out.println(sqlres.getString(1) + "  " + sqlres.getString(2));
        }

    }

    public String main(String acc_no, String acc_name, String curr_name, int CurrID, String acc_open_date, String cust_inn, String DateB, String DateE, String AP, String reval, String br, boolean insurance, String salary_gr) throws UnknownHostException {
        PrDict dict = new PrDict();
        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
        DecimalFormat twoDForm = new DecimalFormat("0.00");
        DB db = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet sqlres = null;
        String grid = "";
        String SQLText = "";

        try {

            String teyinatSQL = "payment_purpose";
            String SqlLapNo = " ' ' ";
            if (insurance) {
                teyinatSQL = "  get_desc_for_inshurance(a.payment_purpose)  ";
                SqlLapNo = " get_lapno_for_inshurance(a.payment_purpose)  ";
            } else {
                teyinatSQL = "payment_purpose";
                SqlLapNo = "  ' ' ";
            }

            String TrType = "";

            if (reval == null || reval == "" || reval.equals("null")) {
                TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
            } else if (Integer.parseInt(reval) == 0) {
                TrType = " AND transaction_type<>'REVAL' and transaction_type<>'PL-6'";
            } else if (Integer.parseInt(reval) == 1) {
                TrType = " ";
            }
            String table = "";

            table = "  vi_transaction_acc_salary ";

            conn = db.connect();
            stmt = conn.createStatement();
            SQLText = "SELECT tarix,currency_cr_name qarshi_val,acct_no_cr qarshi_hesab, "
                    + " ABS (DECODE (currency_dt_id - 944,0,tr_amount_fcy_cr ,tr_amount_fcy_dt)) AS D_Ammount,"
                    + " abs(tr_amount_lcy_dt) as DL_Ammount,"
                    + " 0 as C_Ammount,0 as cl_ammount ,"
                    + teyinatSQL + " teyinat,"
                    + " currency_dt_id,currency_cr_id,currency_dt_id Hval,"
                    + SqlLapNo + " lap_no"
                    + " FROM " + table + " a  where acct_no_dt = ('" + acc_no + "') and (tarix BETWEEN to_date('" + DateB + "','dd-mm-yyyy') AND to_date('" + DateE + "','dd-mm-yyyy'))" + TrType
                    + " union all"
                    + " SELECT tarix,currency_dt_name qarshi_val,acct_no_dt qarshi_hesab, "
                    + " 0 as D_Ammount,0 as DL_Ammount,"
                    + " ABS (DECODE (currency_cr_id - 944,0,tr_amount_fcy_dt, tr_amount_fcy_cr)) AS C_Ammount,"
                    + " abs(tr_amount_lcy_cr) as CL_Ammount,"
                    + teyinatSQL + " teyinat,"
                    + " currency_dt_id,currency_cr_id,currency_cr_id Hval,"
                    + SqlLapNo + " lap_no"
                    + " FROM " + table + " a  where"
                    + " acct_no_cr = ('" + acc_no + "') and (tarix BETWEEN to_date('" + DateB + "','dd-mm-yyyy') AND to_date('" + DateE + "','dd-mm-yyyy'))" + TrType
                    + "  order by tarix";
            sqlres = stmt.executeQuery(SQLText);
            //         System.out.println("SQLText " + SQLText);

            Statement stmt2 = conn.createStatement();
            String SqlText2 = "";
            SqlText2 = "SELECT (SELECT   MAX (t.act_date) from vi_transaction_account_un t"
                    + "  WHERE   (t.acct_no_dt = '" + acc_no + "'"
                    + "           OR t.acct_no_cr = '" + acc_no + "')"
                    + "           AND t.act_date < TO_DATE ('" + DateB + "', 'dd-mm-yyyy'))"
                    + "    AS act_date1,a.currency_id,a.al_type,a.balance_fcy_amount,a.balance_lcy_amount"
                    + " FROM   vi_account_balance a"
                    + " WHERE   a.alt_acct_id = '" + acc_no + "'"
                    + "      AND (SELECT   MAX (t.act_date) FROM vi_transaction_account_un t"
                    + " WHERE   (t.acct_no_dt = '" + acc_no + "'"
                    + "                     OR t.acct_no_cr = '" + acc_no + "')"
                    + "                    AND t.act_date < TO_DATE ('" + DateB + "', 'dd-mm-yyyy')) BETWEEN a.date_from AND  a.date_until";
            //    System.out.println("SqlText2 "+SqlText2);
            Statement stmt3 = conn.createStatement();
            String SqlText3 = "SELECT (SELECT   MAX (t.act_date) from vi_transaction_account_un t"
                    + "  WHERE   (t.acct_no_dt = '" + acc_no + "'"
                    + "           OR t.acct_no_cr = '" + acc_no + "')"
                    + "           AND t.act_date <= TO_DATE ('" + DateE + "', 'dd-mm-yyyy'))"
                    + "    AS act_date1,a.currency_id,a.al_type,a.balance_fcy_amount,a.balance_lcy_amount"
                    + " FROM   vi_account_balance a"
                    + " WHERE   a.alt_acct_id = '" + acc_no + "'"
                    + "      AND (SELECT   MAX (t.act_date) FROM   vi_transaction_account_un t"
                    + " WHERE   (t.acct_no_dt = '" + acc_no + "'"
                    + "                     OR t.acct_no_cr = '" + acc_no + "')"
                    + "                    AND t.act_date <= TO_DATE ('" + DateE + "', 'dd-mm-yyyy')) BETWEEN a.date_from AND  a.date_until";
            //   System.out.println("SqlText3  " + SqlText3);
            //---------------------------------------------------------------------

            Statement stmEXCRate = conn.createStatement();
            String SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                    + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                    + " AND TO_DATE ('" + DateB + "','dd-mm-yyyy')-1 BETWEEN date_from AND date_until";

            ResultSet sqlresEXCRate = stmEXCRate.executeQuery(SqlTextEXCRate);
            double EXC_RATE_B = 0;
            while (sqlresEXCRate.next()) {
                EXC_RATE_B = sqlresEXCRate.getDouble(1);
            }
            sqlresEXCRate.close();
            //  stmEXCRate.close();

            SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                    + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                    + " AND TO_DATE ('" + DateE + "','dd-mm-yyyy') BETWEEN date_from AND date_until";
            sqlresEXCRate = stmEXCRate.executeQuery(SqlTextEXCRate);

            double EXC_RATE_E = 0;
            while (sqlresEXCRate.next()) {
                EXC_RATE_E = sqlresEXCRate.getDouble(1);
            }
            sqlresEXCRate.close();
            stmEXCRate.close();
//----------------------------------------------------------------------
            String first_date = "";
            //int curr_id;
            String al_type = "";
            double first_ammount = 0;
            double first_Lammount = 0;
            String fAP = AP;
            String fAmmount = "";
            ResultSet sqlres2 = stmt2.executeQuery(SqlText2);
            while (sqlres2.next()) {
                first_date = df.format(sqlres2.getDate(1));
                //curr_id = sqlres2.getInt(2);
                al_type = sqlres2.getString(3);
                first_ammount = sqlres2.getDouble(4);
                first_Lammount = sqlres2.getDouble(5);
            }
            sqlres2.close();
            stmt2.close();
            if ((AP.equals("A")) && (first_Lammount > 0)) {
                fAP = "P";
            } else if ((AP.equals("P")) && (first_Lammount < 0)) {
                fAP = "A";
            }

            if (curr_name.equals("AZN")) {
                fAmmount = "Manat: " + twoDForm.format(Math.abs(first_Lammount));
            } else {
                fAmmount = "Valyuta: " + twoDForm.format(Math.abs(first_ammount))
                        + "<br> Manat: " + twoDForm.format(Math.abs(first_Lammount))
                        + "<BR> Rəsmi məzənnə: " + EXC_RATE_B;
            }
            //---------------------------------------------------------------------
            String last_date = "";
            // int curr_id;
            // String al_type = "";
            double last_ammount = 0;
            double last_Lammount = 0;
            String lAP = AP;
            String lAmmount = "";
            ResultSet sqlres3 = stmt3.executeQuery(SqlText3);
            while (sqlres3.next()) {
                // last_date = new SimpleDateFormat("dd-MM-yyyy").format(sqlres3.getDate(1));
                //curr_id = sqlres3.getInt(2);
                //al_type = sqlres3.getString(3);
                last_ammount = sqlres3.getDouble(4);
                last_Lammount = sqlres3.getDouble(5);
            }
            sqlres3.close();
            stmt3.close();
            if ((AP.equals("A")) && (last_Lammount > 0)) {
                lAP = "P";
            } else if ((AP.equals("P")) && (last_Lammount < 0)) {
                lAP = "A";
            }

            if (curr_name.equals("AZN")) {
                //  lAmmount = "Manat: " + Math.abs(last_Lammount);
                lAmmount = "Manat: " + twoDForm.format(Math.abs(last_Lammount));
            } else {
                lAmmount = "Valyuta: " + twoDForm.format(Math.abs(last_ammount))
                        + "<br> Manat: " + twoDForm.format(Math.abs(last_Lammount))
                        + "<BR> Rəsmi məzənnə: " + EXC_RATE_E;
            }
            //---------------------------------------------------------------------

            grid = " <table border='1' width='900' bgcolor='white' >"
                    + "<tr >"
                    + "<td valign=\"top\">"
                    + " <table bgcolor='white' border='0' >"
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
                    + "    <td align='left'>Hesabın adı:</td>"
                    + "    <td align='left'> " + acc_name + "</td>"
                    + "   <td> &nbsp;</td>"
                    + "   <td>&nbsp;</td> "
                    + "   <td>&nbsp;</td> "
                    + "  </tr>"
                    + "  <tr>"
                    + "   <td align='left'>VÖEN:</td>"
                    + "  <td align='left'>" + cust_inn + "</td>"
                    + " <td>&nbsp;</td>"
                    + "  <td>&nbsp;</td>"
                    + "  <td>&nbsp;</td>"
                    + " </tr>"
                    + " <tr>"
                    + " <td align='left'>Valyuta:</td>"
                    + "  <td align='left'>" + curr_name + "</td>"
                    + "  <td>&nbsp;</td>"
                    + "  <td>&nbsp;</td>"
                    + "   <td>&nbsp;</td>"
                    + "  </tr>"
                    + " <tr>"
                    + " <td align='left'>Əməliyyatların tarixi:</td>"
                    + " <td align='left'> " + DateB + " &ensp; " + DateE + "</td>"
                    + " <td>&nbsp;</td>"
                    + "  <td>&nbsp;</td>"
                    + " <td>&nbsp;</td>"
                    + "  </tr>"
                    + " <tr>"
                    + "  <td align='left'>Əvvəlki əməliyyat tarixi:</td>"
                    + " <td align='left'>" + first_date + "</td>"
                    + "  <td>&nbsp;</td>"
                    + " <td>&nbsp;</td>"
                    + " <td>&nbsp;</td>"
                    + "  </tr>"
                    + " <tr>"
                    + "  <td valign='top' align='left'>Günün əvvəlinə qalıq:</td>"
                    + "  <td align='left'>" + fAmmount + "</td>"
                    + "  <td>&nbsp;</td>"
                    + " <td>&quot;Expressbank&quot; ASC " + dict.getFililal4Statm(Integer.parseInt(br)) + "</td>"
                    + " <td>&nbsp;</td>"
                    + " </tr>"
                    + "  </table>"
                    + "  </td>"
                    + " <td width='70' valign='top' ><img src='images/logo.jpg' width='120' height='80'></td>"
                    + " </tr>"
                    + "<tr>"
                    + " <td height='109' valign='top' colspan='2'>"
                    + " <table width='100%' border='0'>"
                    + "<tr>"
                    + "  <td width='100'>&nbsp;</td>"
                    + "  <td width='50'>&nbsp;</td>"
                    + " <td width='150'>&nbsp;</td>"
                    + " <td width='80'>&nbsp;</td>"
                    + " <td width='25'><center>(" + fAP + ")</center></td>"
                    + " <td width='80'>&nbsp;</td>"
                    + " <td width='350' colspan=2>&nbsp;</td>"
                    + "</tr>"
                    + " <tr>"
                    + "  <td><hr>Tarix:</td>"
                    + "  <td><hr>Val.</td>"
                    + "   <td><hr>Qarşı hesab:</td>"
                    + "  <td><hr><center>Debet</center></td>"
                    + " <td><hr>&nbsp;</td>"
                    + "  <td><hr><center>Kredit</center></td>"
                    + " <td colspan=2><hr>Təyinat</td>"
                    + " </tr> ";
            //------- emeliyyatlar
            double dAmount = 0;
            double dLAmount = 0;
            double SumDAmount = 0;
            double SumDLAmount = 0;

            double cAmount = 0;
            double cLAmount = 0;
            double SumCAmount = 0;
            double SumCLAmount = 0;

            String LapNo = "";
            String Teyinat = "";
            String DAmount = "";
            String CAmount = "";
            String SummDAmount = "";
            String SummCAmount = "";

            int dCurrID = 0;
            int cCurrID = 0;
            int trCount = 0;
            int Hval = 0;

            while (sqlres.next()) {
                dAmount = sqlres.getDouble(4);
                dLAmount = sqlres.getDouble(5);
                cAmount = sqlres.getDouble(6);
                cLAmount = sqlres.getDouble(7);
                Teyinat = sqlres.getString(8);

                if (sqlres.getObject(12) != null) {
                    LapNo = sqlres.getString(12);
                }

                dCurrID = sqlres.getInt(9);
                cCurrID = sqlres.getInt(10);
                Hval = sqlres.getInt(11);

                SumDLAmount = SumDLAmount + dLAmount;
                SumDAmount = SumDAmount + dAmount;

                SumCLAmount = SumCLAmount + cLAmount;
                SumCAmount = SumCAmount + cAmount;

                if ((dCurrID == 944) && (cCurrID == 944)) {
                    DAmount = String.valueOf(twoDForm.format(dLAmount));
                    CAmount = String.valueOf(twoDForm.format(cLAmount));
                    SummDAmount = String.valueOf(twoDForm.format(SumDLAmount));
                    SummCAmount = String.valueOf(twoDForm.format(SumCLAmount));
                } else {
                    // DAmount = String.valueOf(Math.round(dLAmount*100)/100)+"<BR>"+ String.valueOf(Math.round(dAmount*100)/100);
                    // CAmount = String.valueOf(Math.round(cLAmount*100)100)+"<BR>"+ String.valueOf(Math.round(cAmount*100)/100);
                    DAmount = String.valueOf(twoDForm.format(dLAmount)) + "<BR><b>" + String.valueOf(twoDForm.format(dAmount)) + "</b>";
                    CAmount = String.valueOf(twoDForm.format(cLAmount)) + "<BR><b>" + String.valueOf(twoDForm.format(cAmount)) + "</b>";

                    if (Hval == 944) {
                        SummDAmount = String.valueOf(twoDForm.format(SumDLAmount));
                        SummCAmount = String.valueOf(twoDForm.format(SumCLAmount));
                    } else {
                        SummDAmount = String.valueOf(twoDForm.format(SumDLAmount)) + "<BR><b>" + String.valueOf(twoDForm.format(SumDAmount)) + "</b>";
                        SummCAmount = String.valueOf(twoDForm.format(SumCLAmount)) + "<BR><b>" + String.valueOf(twoDForm.format(SumCAmount)) + "</<b>";
                    }

                }

                String SQLText1 = "  SELECT count(*)  FROM bi_account_inf_bal  "
                        + " where date_until = '01-jan-3000' and category =1200 and  ALT_ACCT_ID  = '" + sqlres.getString(3) + "'  ";
                ///        System.out.println("SQLText1  " + SQLText1);  
                Statement stmt1 = conn.createStatement();
                ResultSet sqlres1 = stmt1.executeQuery(SQLText1);

                sqlres1.next();
                int acc = sqlres1.getInt(1);
                //   System.out.println("acc  " + acc);
                sqlres1.close();
                stmt1.close();
                if ((salary_gr.equals("0")) && (acc != 0)) {

                    grid = grid + " <tr>"
                            + "  <td valign='top'>" + new SimpleDateFormat("dd-MM-yyyy").format(sqlres.getDate(1)) + "</td>"
                            + "  <td valign='top'>" + sqlres.getString(2) + "</td>"
                            + " <td valign='top'>XXXXXX</td>"
                            + "  <td valign='top'><center>" + DAmount + "</center></td>"
                            + "  <td>&nbsp;</td>"
                            + "  <td valign='top'><center>" + CAmount + "</center></td>"
                            //  + "  <td valign='top' align='left'>XXXXXX</td>"
                            + "  <td valign='top' align='left'>" + Teyinat + "</td>"
                            + "  <td valign='top' align='left'>" + LapNo + "</td>"
                            + "  </tr>";

                } else {

                    grid = grid + " <tr>"
                            + "  <td valign='top'>" + new SimpleDateFormat("dd-MM-yyyy").format(sqlres.getDate(1)) + "</td>"
                            + "  <td valign='top'>" + sqlres.getString(2) + "</td>"
                            + " <td valign='top'>" + sqlres.getString(3)
                            + "</td>"
                            + "  <td valign='top'><center>" + DAmount + "</center></td>"
                            + "  <td>&nbsp;</td>"
                            + "  <td valign='top'><center>" + CAmount + "</center></td>"
                            + "  <td valign='top' align='left'>" + Teyinat + "</td>"
                            + "  <td valign='top' align='left'>" + LapNo + "</td>"
                            + "  </tr>";

                }

                trCount++;
            }

            //------- emeliyyatlar
            grid = grid + "  <tr>"
                    + " <td>&nbsp;</td>"
                    + "  <td>&nbsp;</td>"
                    + "  <td valign='top'><hr>&nbsp;</td>"
                    + "  <td valign='top' align='center'><hr>" + SummDAmount + "</td>"
                    + " <td valign='top'><hr>&nbsp;</td>"
                    + "  <td valign='top' align='center'><hr>" + SummCAmount + "</td>"
                    + "  <td valign='top'><hr>&nbsp;</td>"
                    + "  </tr>"
                    + " </table>"
                    + "  </td>"
                    //  + "<td height='109'>&nbsp;</td>"
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
                    + " </tr>"
                    + "</table>"
                    + " </td>"
                    + "</tr>"
                    + "</table>";

        } catch (SQLException ex) {
            Logger.getLogger(StatementRep_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                sqlres.close();
                stmt.close();
                conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(StatementRep_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return grid;
    }
}
