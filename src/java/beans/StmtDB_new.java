/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package beans;

import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import main.*;

/**
 *
 * @author m.aliyev
 */
public class StmtDB_new {

    public double getEXCRate(int CurrID, String Dates) throws UnknownHostException {
        DB db = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        double EXC_RATE = 0.0;

        try {
            conn = db.connect();
            stmt = conn.createStatement();
            String SqlTextEXCRate = "SELECT exch_rate_bid FROM ri_currency_rate "
                    + " WHERE currency_market = 1 AND numeric_ccy_code = " + CurrID
                    + " AND TO_DATE ('" + Dates + "','dd-mm-yyyy')-1 BETWEEN date_from AND date_until";

            rs = stmt.executeQuery(SqlTextEXCRate);
            while (rs.next()) {
                EXC_RATE = rs.getDouble(1);
            }

        } catch (SQLException ex) {
            Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return EXC_RATE;
    }

    public AccHistoryInfo getAccBeginInf(String acc_no, String tarix, String AP) throws UnknownHostException {
        DB db = new DB();
        AccHistoryInfo abi = new AccHistoryInfo();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        double first_ammount = 0;
        double first_Lammount = 0;
        String fAP = AP;

        try {
            conn = db.connect();
            stmt = conn.createStatement();
            String SqlText = "SELECT (SELECT MAX (t.act_date) from vi_transaction_account_un t"
                    + " WHERE (t.acct_no_dt = '" + acc_no + "' OR t.acct_no_cr = '" + acc_no + "')"
                    + " AND t.act_date < TO_DATE ('" + tarix + "', 'dd-mm-yyyy'))"
                    + " AS act_date1,a.currency_id,a.al_type,a.balance_fcy_amount,a.balance_lcy_amount"
                    + " FROM vi_account_balance a"
                    + " WHERE a.alt_acct_id = '" + acc_no + "' AND (SELECT MAX (t.act_date) FROM vi_transaction_account_un t"
                    + " WHERE (t.acct_no_dt = '" + acc_no + "' OR t.acct_no_cr = '" + acc_no + "')"
                    + " AND t.act_date < TO_DATE ('" + tarix + "', 'dd-mm-yyyy')) BETWEEN a.date_from AND a.date_until";

            rs = stmt.executeQuery(SqlText);
            while (rs.next()) {
                first_ammount = rs.getDouble(4);
                first_Lammount = rs.getDouble(5);

                abi.setFirst_date(sdf.format(rs.getDate(1)));
                abi.setAl_type(rs.getString(3));
                abi.setFirst_ammount(rs.getDouble(4));
                abi.setFirst_Lammount(rs.getDouble(5));
            }

            if ((AP.equals("A")) && (first_Lammount > 0)) {
                fAP = "P";
            } else if ((AP.equals("P")) && (first_Lammount < 0)) {
                fAP = "A";
            }
            abi.setfAP(fAP);
        } catch (SQLException ex) {
            Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return abi;
    }

    public AccHistoryInfo getAccEndInf(String acc_no, String tarix, String AP) throws UnknownHostException {
        DB db = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        AccHistoryInfo abi = new AccHistoryInfo();

        double last_ammount = 0;
        double last_Lammount = 0;
        String lAP = AP;

        try {
            conn = db.connect();
            stmt = conn.createStatement();
            String SqlText = "SELECT (SELECT MAX (t.act_date) from vi_transaction_account_un t"
                    + " WHERE (t.acct_no_dt = '" + acc_no + "' OR t.acct_no_cr = '" + acc_no + "')"
                    + " AND t.act_date <= TO_DATE ('" + tarix + "', 'dd-mm-yyyy'))"
                    + " AS act_date1,a.currency_id,a.al_type,a.balance_fcy_amount,a.balance_lcy_amount"
                    + " FROM vi_account_balance a WHERE a.alt_acct_id = '" + acc_no + "'"
                    + " AND (SELECT MAX (t.act_date) FROM   vi_transaction_account_un t"
                    + " WHERE (t.acct_no_dt = '" + acc_no + "' OR t.acct_no_cr = '" + acc_no + "')"
                    + " AND t.act_date <= TO_DATE ('" + tarix + "', 'dd-mm-yyyy')) BETWEEN a.date_from AND  a.date_until";

            rs = stmt.executeQuery(SqlText);
            while (rs.next()) {
                abi.setFirst_ammount(rs.getDouble(4));
                abi.setFirst_Lammount(rs.getDouble(5));
                last_ammount = rs.getDouble(4);
                last_Lammount = rs.getDouble(5);
            }

            if ((AP.equals("A")) && (last_Lammount > 0)) {
                lAP = "P";
            } else if ((AP.equals("P")) && (last_Lammount < 0)) {
                lAP = "A";
            }
            abi.setfAP(lAP);

        } catch (SQLException ex) {
            Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return abi;
    }

    public int getTrCount(String acc_no, String strDateB, String strDateE, String TrType, String salary_gr) throws UnknownHostException {
        DB db = new DB();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        int cnt = 0;

        String view = "  vi_transaction_acc_salary ";

        try {
            conn = db.connect();
            stmt = conn.createStatement();
            String SqlText = "select count(*) cnt from " + view + " where "
                    + "(acct_no_dt = '" + acc_no + "' or acct_no_cr='" + acc_no + "') and (tarix BETWEEN to_date('" + strDateB + "','dd-mm-yyyy') AND to_date('" + strDateE + "','dd-mm-yyyy')) " + TrType;

            rs = stmt.executeQuery(SqlText);
            while (rs.next()) {
                cnt = rs.getInt(1);
            }

        } catch (SQLException ex) {
            Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return cnt;
    }

    public ArrayOfStmtTransactions getTransactions(String acc_no, String DateB, String DateE, String TrType, boolean insurance, String salary_gr) throws UnknownHostException {
        DB db = new DB();
        ArrayOfStmtTransactions aost = new ArrayOfStmtTransactions();

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        DecimalFormat twoDForm = new DecimalFormat("0.00");
        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");

        String teyinatSQL = "payment_purpose";
        String SqlLapNo = " ' ' ";
        if (insurance) {
            teyinatSQL = "  get_desc_for_inshurance(a.payment_purpose)  ";
            SqlLapNo = " get_lapno_for_inshurance(a.payment_purpose)  ";
        } else {
            teyinatSQL = "payment_purpose";
            SqlLapNo = "  ' ' ";
        }

        String table = "  vi_transaction_acc_salary ";

        String SqlText = "SELECT tarix,currency_cr_name qarshi_val,acct_no_cr qarshi_hesab, "
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

        String tarix = "";
        String AccNo = "";
        String val = "";
        double dAmount = 0;
        double dLAmount = 0;
        double cAmount = 0;
        double cLAmount = 0;

        String LapNo = "";
        String Teyinat = "";
        String DAmount = "";
        String CAmount = "";

        double SumDAmount = 0;
        double SumDLAmount = 0;
        double SumCAmount = 0;
        double SumCLAmount = 0;
        String SummDAmount = "";
        String SummCAmount = "";

        int dCurrID = 0;
        int cCurrID = 0;
        int Hval = 0;

        try {
            conn = db.connect();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlText);
            //System.out.println(SqlText); // Ceyhun
            while (rs.next()) {
                String SQLText1 = "  SELECT count(*)  FROM bi_account_inf_bal  "
                        + " where date_until = '01-jan-3000' and category =1200 and  ALT_ACCT_ID  = '" + rs.getString(3) + "'  ";
                ///        System.out.println("SQLText1  " + SQLText1);  
                Statement stmt1 = conn.createStatement();
                ResultSet sqlres1 = stmt1.executeQuery(SQLText1);

                sqlres1.next();
                int acc = sqlres1.getInt(1);
                //   System.out.println("acc  " + acc);
                sqlres1.close();
                stmt1.close();
                tarix = df.format(rs.getDate(1));
                val = rs.getString(2);
                if ((salary_gr.equals("0")) && (acc != 0)) {
                    AccNo = "XXXXXXX";
                } else {
                    AccNo = rs.getString(3);
                }
                dAmount = rs.getDouble(4);
                dLAmount = rs.getDouble(5);
                cAmount = rs.getDouble(6);
                cLAmount = rs.getDouble(7);
                if ((salary_gr.equals("0")) && (acc != 0)) {
                    // Teyinat = "XXXXXXXXX";
                    Teyinat = rs.getString(8);
                } else {
                    Teyinat = rs.getString(8);
                }
                LapNo = rs.getString(12);
                dCurrID = rs.getInt(9);
                cCurrID = rs.getInt(10);
                Hval = rs.getInt(11);

                StmtTransactions st = new StmtTransactions();
                if ((dCurrID == 944) && (cCurrID == 944)) {

                    st.setDebtAmount(dLAmount);
                    st.setCredAmount(cLAmount);

                    SummDAmount = String.valueOf(twoDForm.format(SumDLAmount));
                    SummCAmount = String.valueOf(twoDForm.format(SumCLAmount));
                } else {

                    st.setDebtAmount(dLAmount);
                    st.setCredAmount(cLAmount);
                    st.setDLAmount(dAmount);
                    st.setCLAmount(cAmount);

                    if (Hval == 944) {
                        SummDAmount = String.valueOf(twoDForm.format(SumDLAmount));
                        SummCAmount = String.valueOf(twoDForm.format(SumCLAmount));
                    } else {
                        SummDAmount = String.valueOf(twoDForm.format(SumDLAmount)) + "  " + String.valueOf(twoDForm.format(SumDAmount));
                        SummCAmount = String.valueOf(twoDForm.format(SumCLAmount)) + "  " + String.valueOf(twoDForm.format(SumCAmount));
                    }

                }

                st.setTarix(tarix);
                st.setValyuta(val);
                st.setAccount(AccNo);
                st.setTeyinat(Teyinat);
                st.setLapNo(LapNo);
                aost.getStmttransactions().add(st);
            }

        } catch (SQLException ex) {
            Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return aost;
    }
    
    public ArrayOfStmtTransactions getTransactionsSTPR(String acc_no, String DateB, String DateE, String TrType, boolean insurance, String salary_gr) throws UnknownHostException {
        DB db = new DB();
        ArrayOfStmtTransactions aost = new ArrayOfStmtTransactions();

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        DecimalFormat twoDForm = new DecimalFormat("0.00");
        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");

        String teyinatSQL = "payment_purpose";
        String SqlLapNo = " ' ' ";
        if (insurance) {
            teyinatSQL = "  get_desc_for_inshurance(a.payment_purpose)  ";
            SqlLapNo = " get_lapno_for_inshurance(a.payment_purpose)  ";
        } else {
            teyinatSQL = "payment_purpose";
            SqlLapNo = "  ' ' ";
        }

        String table = "  vi_transaction_acc_salary ";

        String SqlText = "select tarix, "
                         + "     currency_cr_name ,"
                         + "       case "
                         + "         when vtracsh.gl_acct_no_cr like '6%' then "
                         + "           vtracsh.acct_no_cr "
                         + "         else "
                         + "           coalesce((select i.sender_account "
                         + "                         from si_payment_in i "
                         + "                        where i.payment_id = vtracsh.number_doc), "
                         + "                     (select o.recipient_account "
                         + "                         from si_payment_out o "
                         + "                        where o.payment_id = vtracsh.number_doc),  " 
                         + "                     vtracsh.acct_no_cr) "
                         + "       end qarshi_hesab, "
                         + "       case "
                         + "         when vtracsh.gl_acct_no_cr like '6%' then "
                         + "            coalesce((select 'Komissiya -' ||i.sender_name "
                         + "                        from si_payment_in i "
                         + "                       where i.payment_id = vtracsh.number_doc), "
                         + "                     (select 'Komissiya -' ||o.recipient_name "
                         + "                        from si_payment_out o "
                         + "                       where o.payment_id = vtracsh.number_doc), "
                         + "                      vtracsh.caccount_title) "
                         + "         else "
                         + "           coalesce((select i.sender_name "
                         + "                       from si_payment_in i "
                         + "                      where i.payment_id = vtracsh.number_doc), "
                         + "                    (select o.recipient_name "
                         + "                        from si_payment_out o "
                         + "                       where o.payment_id = vtracsh.number_doc), "
                         + "                    vtracsh.caccount_title) "
                         + "       end sender_receive, "
                         + "       abs(decode(vtracsh.currency_dt_id - 944, "
                         + "                  0, "
                         + "                  vtracsh.tr_amount_fcy_cr, "
                         + "                  vtracsh.tr_amount_fcy_dt)) as d_ammount, "
                         + "       abs(vtracsh.tr_amount_lcy_dt) as dl_ammount, "
                         + "       0 as c_ammount, "
                         + "       0 as cl_ammount, "
                         + "       case "
                         + "         when vtracsh.gl_acct_no_cr like '6%' then "
                         + "           coalesce((select 'Komissiya -' ||i.payment_details "
                         + "                       from si_payment_in i "
                         + "                      where i.payment_id = vtracsh.number_doc), "
                         + "                    (select 'Komissiya -' ||o.payment_details "
                         + "                       from si_payment_out o "
                         + "                      where o.payment_id = vtracsh.number_doc), "
                         + "                    vtracsh.payment_purpose " 
                         + "                   ) "
                         + "       else "
                         + "         coalesce((select i.payment_details "
                         + "                       from si_payment_in i "
                         + "                      where i.payment_id = vtracsh.number_doc), "
                         + "                    (select o.payment_details "
                         + "                       from si_payment_out o "
                         + "                      where o.payment_id = vtracsh.number_doc), "
                         + "                    vtracsh.payment_purpose  "
                         + "                   ) "            
                         + "       end teyinat, "
                         + "       currency_dt_id, "
                         + "       currency_cr_id, "
                         + "       currency_dt_id hval, "
                         + "       ' ' lap_no"
                         + "  from vi_transaction_acc_salary_hc vtracsh "
                         + " where vtracsh.acct_no_dt = '" + acc_no + "' "
                         + "   and vtracsh.tarix between to_date('" + DateB + "', 'dd-mm-yyyy') and  to_date('" + DateE + "', 'dd-mm-yyyy') "
                         + "   and vtracsh.transaction_type <> 'REVAL' "
                         + " union all  "
                         + "select tarix, "
                         + "       currency_dt_name, "
                         + "       case " 
                         + "         when vtracsh.gl_acct_no_dt like '6%' then "
                         + "           vtracsh.acct_no_dt "
                         + "         else "
                         + "           coalesce((select i.sender_account "
                         + "                         from si_payment_in i "
                         + "                        where i.payment_id = vtracsh.number_doc), "
                         + "                     (select o.recipient_account "
                         + "                         from si_payment_out o "
                         + "                        where o.payment_id = vtracsh.number_doc), "   
                         + "                     vtracsh.acct_no_dt) "
                         + "       end qarshi_hesab, "
                         + "       case "
                         + "         when vtracsh.gl_acct_no_cr like '6%' then "
                         + "            coalesce((select 'Komissiya -' ||i.sender_name "
                         + "                        from si_payment_in i "
                         + "                       where i.payment_id = vtracsh.number_doc), "
                         + "                     (select 'Komissiya -' ||o.recipient_name "
                         + "                        from si_payment_out o "
                         + "                       where o.payment_id = vtracsh.number_doc), "
                         + "                      vtracsh.caccount_title) "
                         + "         else "
                         + "           coalesce((select i.sender_name "
                         + "                       from si_payment_in i "
                         + "                      where i.payment_id = vtracsh.number_doc), "
                         + "                    (select o.recipient_name "
                         + "                        from si_payment_out o "
                         + "                       where o.payment_id = vtracsh.number_doc), "
                         + "                    vtracsh.caccount_title) "
                         + "       end sender_receive, "
                         + "       0 as d_ammount, "
                         + "       0 as dl_ammount, "
                         + "       abs(decode(currency_cr_id - 944, "
                         + "                  0, "
                         + "                  tr_amount_fcy_dt, "
                         + "                  tr_amount_fcy_cr)) as c_ammount, "
                         + "       abs(tr_amount_lcy_cr) as cl_ammount, "
                         + "       case "
                         + "         when vtracsh.gl_acct_no_cr like '6%' then "
                         + "           coalesce((select 'Komissiya -' ||i.payment_details "
                         + "                       from si_payment_in i "
                         + "                      where i.payment_id = vtracsh.number_doc), "
                         + "                    (select 'Komissiya -' ||o.payment_details "
                         + "                       from si_payment_out o "
                         + "                      where o.payment_id = vtracsh.number_doc), "
                         + "                    vtracsh.payment_purpose "   
                         + "                   ) "
                         + "       else "
                         + "         coalesce((select i.payment_details "
                         + "                       from si_payment_in i "
                         + "                      where i.payment_id = vtracsh.number_doc), "
                         + "                    (select o.payment_details "
                         + "                       from si_payment_out o "
                         + "                      where o.payment_id = vtracsh.number_doc),"
                         + "                    vtracsh.payment_purpose"
                         + "                   )"          
                         + "       end teyinat,"
                         + "       currency_dt_id,"
                         + "       currency_cr_id,"
                         + "       currency_cr_id hval,"
                         + "       ' ' lap_no "
                         + "  from vi_transaction_acc_salary_hc vtracsh"
                         + " where vtracsh.acct_no_cr = '" + acc_no + "' "
                         + "   and vtracsh.tarix between to_date('" + DateB + "', 'dd-mm-yyyy') and  to_date('" + DateE + "', 'dd-mm-yyyy')"
                         + "   and vtracsh.transaction_type <> 'REVAL'";

        String tarix = "";
        String AccNo = "";
        String val = "";
        String sendAndRecei="";
        double dAmount = 0;
        double dLAmount = 0;
        double cAmount = 0;
        double cLAmount = 0;

        String LapNo = "";
        String Teyinat = "";
        String DAmount = "";
        String CAmount = "";

        double SumDAmount = 0;
        double SumDLAmount = 0;
        double SumCAmount = 0;
        double SumCLAmount = 0;
        String SummDAmount = "";
        String SummCAmount = "";

        int dCurrID = 0;
        int cCurrID = 0;
        int Hval = 0;

        try {
            conn = db.connect();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SqlText);

            while (rs.next()) {
                String SQLText1 = "  SELECT count(*)  FROM bi_account_inf_bal  "
                        + " where date_until = '01-jan-3000' and category =1200 and  ALT_ACCT_ID  = '" + rs.getString(3) + "'  ";
                ///        System.out.println("SQLText1  " + SQLText1);  
                Statement stmt1 = conn.createStatement();
                ResultSet sqlres1 = stmt1.executeQuery(SQLText1);

                sqlres1.next();
                int acc = sqlres1.getInt(1);
                //   System.out.println("acc  " + acc);
                sqlres1.close();
                stmt1.close();
                tarix = df.format(rs.getDate(1));
                val = rs.getString(2);
                if ((salary_gr.equals("0")) && (acc != 0)) {
                    AccNo = "XXXXXXX";
                } else {
                    AccNo = rs.getString(3);
                }
                sendAndRecei = rs.getString(4); 
                dAmount = rs.getDouble(5);
                dLAmount = rs.getDouble(6);
                cAmount = rs.getDouble(7);
                cLAmount = rs.getDouble(8);
                if ((salary_gr.equals("0")) && (acc != 0)) {
                    // Teyinat = "XXXXXXXXX";
                    Teyinat = rs.getString(9);
                } else {
                    Teyinat = rs.getString(9);
                }
                LapNo = rs.getString(12);
                dCurrID = rs.getInt(10);
                cCurrID = rs.getInt(11);
                Hval = rs.getInt(12);
                LapNo = rs.getString(13);

                StmtTransactions st = new StmtTransactions();
                if ((dCurrID == 944) && (cCurrID == 944)) {

                    st.setDebtAmount(dLAmount);
                    st.setCredAmount(cLAmount);

                    SummDAmount = String.valueOf(twoDForm.format(SumDLAmount));
                    SummCAmount = String.valueOf(twoDForm.format(SumCLAmount));
                } else {

                    st.setDebtAmount(dLAmount);
                    st.setCredAmount(cLAmount);
                    st.setDLAmount(dAmount);
                    st.setCLAmount(cAmount);

                    if (Hval == 944) {
                        SummDAmount = String.valueOf(twoDForm.format(SumDLAmount));
                        SummCAmount = String.valueOf(twoDForm.format(SumCLAmount));
                    } else {
                        SummDAmount = String.valueOf(twoDForm.format(SumDLAmount)) + "  " + String.valueOf(twoDForm.format(SumDAmount));
                        SummCAmount = String.valueOf(twoDForm.format(SumCLAmount)) + "  " + String.valueOf(twoDForm.format(SumCAmount));
                    }

                }

                st.setTarix(tarix);
                st.setValyuta(val);
                st.setAccount(AccNo);
                st.setsendAndRecei(sendAndRecei);
                st.setTeyinat(Teyinat);
                st.setLapNo(LapNo);
                aost.getStmttransactions().add(st);
            }

        } catch (SQLException ex) {
            Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(StmtDB_new.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return aost;
    }
}
