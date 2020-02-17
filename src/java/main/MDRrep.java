/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author m.aliyev
 */
public class MDRrep {

    private static String fileFolder = "c:\\MDR\\";

    public boolean createDepo(Date dateB) throws ClassNotFoundException, SQLException, IOException {
        SimpleDateFormat dtformat = new SimpleDateFormat("yymm");
        SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");
        String strDateB = dtformat2.format(dateB);
        String fnameDT = dtformat.format(dateB);

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String SqlText = "";
        SqlText = "select a.customer_id CLIENT_NO,1 ACCOUNT_TYPE,"
                + " null DEPOSIT_SYMBOL_CODE,"
                + " a.filial_code DEPOSIT_BRANCH_CODE,"
                + " a.contract_id DEPOSIT_ID_NUMBER,"
                + " (SELECT credit_total_acc_id FROM si_depo_account where contract_id=a.contract_id and "
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from AND date_until)) DEPOSIT_ACCOUNT_IBAN_NUMBER,"
                + " (SELECT name_currency FROM di_currency_info where"
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from AND date_until) "
                + " and numeric_ccy_code=a.currency_id) DEPOSIT_CURRENCY_CODE,"
                + " (select credit_total from si_depo_balance where contract_id=a.contract_id and "
                + "(TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from AND date_until)) DEPOSIT_CURRENCY_AMOUNT,"
                + " (SELECT exch_rate_bid FROM ri_currency_rate where  CURRENCY_MARKET=1 and numeric_ccy_code=a.currency_id and"
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from AND date_until) ) CURRENCY_RATE,"
                + " (select credit_total_lcy from si_depo_balance where contract_id=a.contract_id "
                + " and (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)) DEPOSIT_AZN_AMOUNT,"
                + " (SELECT interest_accrual FROM si_depo_balance where contract_id=a.contract_id and"
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)) DEPOSIT_INTEREST_AMOUNT,"
                + " to_char(a.value_date,'yyyy-MM-dd') DEPOSIT_FIRST_VALUE_DATE,"
                + " to_char(a.value_date,'yyyy-MM-dd') DEPOSIT_VALUE_DATE, "
                + " to_char(a.maturity_date,'yyyy-MM-dd') DEPOSIT_MATURITY_DATE,"
                + " (SELECT interest_rate_value FROM si_depo_interest_rate where contract_id=a.contract_id and"
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)) DEPOSIT_FIRST_PERCENT,"
                + " (SELECT interest_rate_value FROM si_depo_interest_rate where contract_id=a.contract_id and"
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)) DEPOSIT_ACTIVE_PERCENT,"
                + " null DEPOSIT_BONUS_PERCENT,"
                + " (SELECT substr(credit_total_acc_id,9,5) FROM si_depo_account where contract_id=a.contract_id and"
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)) DEPOSIT_BALANCE_ACCOUNT,"
                + " null DEPOSIT_BLOCKED_AMOUNT"
                + " from si_depo_contract a, si_person_natural b where  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between a.date_from and a.date_until) "
                + " and a.maturity_date>TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') "
                + " and a.customer_id=b.customer_id and b.sector in (4001,4003) and b.date_until='01-jan-3000' ";

        String SqlText2 = " SELECT b.customer_id client_no,2 ACCOUNT_TYPE, null deposit_symbol_code, b.filial_code deposit_branch_code,null deposit_id_number,"
                + " a.alt_acct_id deposit_account_iban_number, (SELECT name_currency FROM   di_currency_info WHERE  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)"
                + " AND numeric_ccy_code = a.currency_id) deposit_currency_code, "
                + " a.balance_fcy_amount deposit_currency_amount, "
                + " (SELECT   exch_rate_bid FROM ri_currency_rate WHERE currency_market = 1 AND numeric_ccy_code = a.currency_id"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until)) currency_rate, "
                + " a.balance_lcy_amount deposit_azn_amount,"
                + " null deposit_interest_amount, TO_CHAR (b.opening_date, 'yyyy-MM-dd') deposit_first_value_date,"
                + " null deposit_value_date,null deposit_maturity_date,null deposit_first_percent,"
                + " null deposit_active_percent,null deposit_bonus_percent,"
                + " to_nchar(a.gl_acct_no) deposit_balance_account, null deposit_blocked_amount"
                + "  FROM si_account_balance a,si_account_inf_bal b "
                + "  where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between a.date_from and a.date_until) "
                + " and (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between b.date_from and b.date_until)"
                + "  and a.gl_acct_no in (SELECT bal_cn FROM mdr_bal_cn where bal_cn not in (21070,21080,21110,21120,21210,21220,21240,21250)) and a.balance_fcy_amount<>0"
                + "  and b.alt_acct_id=a.alt_acct_id"
                //  -- depozit hesablarin cix 
                + " AND b.alt_acct_id not in (SELECT (SELECT nvl(credit_total_acc_id,'x')"
                + " FROM si_depo_account WHERE contract_id = a.contract_id"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until))"
                + " deposit_account_iban_number FROM si_depo_contract a, si_person_natural b"
                + " WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between a.date_from and a.date_until)"
                + " AND a.maturity_date > TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
                + " AND a.customer_id = b.customer_id AND b.sector in (4001,4003) AND b.date_until = '01-jan-3000')";
                //  -- kredit hesablarin cix         
        //  + " and a.gl_acct_no ";

        //-----     kredit hesablari
        String SqlText3 = "SELECT b.customer_id client_no,2 account_type, NULL deposit_symbol_code, b.filial_code deposit_branch_code,"
                + " NULL deposit_id_number, a.alt_acct_id deposit_account_iban_number,"
                + " (SELECT name_currency FROM di_currency_info WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)"
                + " AND numeric_ccy_code = a.currency_id) deposit_currency_code,"
                + " a.balance_fcy_amount deposit_currency_amount,"
                + " (SELECT exch_rate_bid FROM   ri_currency_rate WHERE currency_market = 1 AND numeric_ccy_code = a.currency_id"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)) currency_rate,"
                + " a.balance_lcy_amount deposit_azn_amount, NULL deposit_interest_amount,"
                + " TO_CHAR (b.opening_date, 'yyyy-MM-dd') deposit_first_value_date, NULL deposit_value_date, "
                + " NULL deposit_maturity_date, NULL deposit_first_percent, NULL deposit_active_percent, "
                + " NULL deposit_bonus_percent, TO_NCHAR (a.gl_acct_no) deposit_balance_account, NULL deposit_blocked_amount"
                + " FROM si_account_balance a, si_account_inf_bal b"
                + " WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN a.date_from AND  a.date_until)"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN b.date_from AND  b.date_until)"
                + " AND a.balance_fcy_amount <> 0 AND b.alt_acct_id = a.alt_acct_id"
                + " AND b.alt_acct_id IN (SELECT  (SELECT debt_standard_acc_id"
                + " FROM si_loan_account WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)"
                + " AND contract_id = b.contract_id) kredit_account_iban_number"
                + " FROM si_depo_block_amount a, si_loan_contract b"
                + " WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN a.date_from AND  a.date_until)"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN b.date_from AND  b.date_until)"
                + " AND a.loan_contract_id = b.contract_id AND b.maturity_date > TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))";

        //-----     kredit faiz hesablari 
        String SqlText4 = "SELECT b.customer_id client_no,2 account_type, NULL deposit_symbol_code, b.filial_code deposit_branch_code,"
                + " NULL deposit_id_number, a.alt_acct_id deposit_account_iban_number,"
                + " (SELECT name_currency FROM di_currency_info WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)"
                + " AND numeric_ccy_code = a.currency_id) deposit_currency_code,"
                + " a.balance_fcy_amount deposit_currency_amount,"
                + " (SELECT exch_rate_bid FROM   ri_currency_rate WHERE currency_market = 1 AND numeric_ccy_code = a.currency_id"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)) currency_rate,"
                + " a.balance_lcy_amount deposit_azn_amount, NULL deposit_interest_amount,"
                + " TO_CHAR (b.opening_date, 'yyyy-MM-dd') deposit_first_value_date, NULL deposit_value_date, "
                + " NULL deposit_maturity_date, NULL deposit_first_percent, NULL deposit_active_percent, "
                + " NULL deposit_bonus_percent, TO_NCHAR (a.gl_acct_no) deposit_balance_account, NULL deposit_blocked_amount"
                + " FROM si_account_balance a, si_account_inf_bal b"
                + " WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN a.date_from AND  a.date_until)"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN b.date_from AND  b.date_until)"
                + " AND a.balance_fcy_amount <> 0 AND b.alt_acct_id = a.alt_acct_id"
                + " AND b.alt_acct_id IN (SELECT  (SELECT nvl(interest_accrual_acc_id,'x')"
                + " FROM si_loan_account WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)"
                + " AND contract_id = b.contract_id) kredit_account_iban_number"
                + " FROM si_depo_block_amount a, si_loan_contract b"
                + " WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN a.date_from AND  a.date_until)"
                + " AND (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN b.date_from AND  b.date_until)"
                + " AND a.loan_contract_id = b.contract_id AND b.maturity_date > TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))";

        //    System.out.println(SqlText+" union all "+SqlText2);  //+" union all "+SqlText3+" union all "+SqlText4
        /*SELECT (SELECT nvl(interest_accrual_acc_id,'x')"
         + " FROM si_depo_account WHERE contract_id = a.contract_id"
         + " AND date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
         + " AND date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))"
         + " interest_accrual_acc_id FROM si_depo_contract a, si_person_natural b"
         + " WHERE a.date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
         + " AND a.date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
         + " AND a.maturity_date > TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')"
         + " AND a.customer_id = b.customer_id AND b.sector = 4001 AND b.date_until = '01-jan-3000'*/
        ResultSet sqlres = stmt.executeQuery(SqlText + " union all " + SqlText2); //+" union all "+SqlText3+" union all "+SqlText4
        sqlres.last();
        int rowcount = sqlres.getRow();
        sqlres.beforeFirst();

        // String filename = "/tsm/DWHReports/MDRFiles/"+s+".xml";
        String filename = fileFolder + "XXX" + fnameDT + "_DEP.xml";

        File f = new File(filename);
        BufferedWriter output = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), "UTF8"));
        output.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        output.append("<DEPOSITS xsi:noNamespaceSchemaLocation=\"DEPOSIT.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");
        output.append("<BANK_CODE>505099</BANK_CODE>");
        output.append("<BANK_NAME>ExpressBank ASC</BANK_NAME>");
        output.append("<ROWCOUNT>" + rowcount + "</ROWCOUNT>");

        int count = sqlres.getMetaData().getColumnCount();
        String[] StrArray;
        StrArray = new String[30];
        for (int i = 1; i <= count; i++) {
            StrArray[i] = sqlres.getMetaData().getColumnName(i);
        }

        while (sqlres.next()) {

            output.append("<DEPOSIT>");

            for (int i = 1; i <= count; i++) {

                if (((StrArray[i].equals("DEPOSIT_SYMBOL_CODE")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_BONUS_PERCENT")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_BLOCKED_AMOUNT")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_ID_NUMBER")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_INTEREST_AMOUNT")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_VALUE_DATE")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_MATURITY_DATE")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_FIRST_PERCENT")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("DEPOSIT_ACTIVE_PERCENT")) && (sqlres.getObject(i) == null))) {
                    output.append("<" + StrArray[i] + "></" + StrArray[i] + ">");
                } else {
                    output.append("<" + StrArray[i] + ">" + sqlres.getString(i) + "</" + StrArray[i] + ">");
                }

            }
            output.append("</DEPOSIT>");
        }

        output.append("</DEPOSITS>");
        output.close();
        sqlres.close();
        stmt.close();
        conn.close();

        return true;
    }

    public boolean createBalans(Date dateB) throws ClassNotFoundException, SQLException, IOException {
        SimpleDateFormat dtformat = new SimpleDateFormat("yymm");
        SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");
        String strDateB = dtformat2.format(dateB);
        String fnameDT = dtformat.format(dateB);

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String SqlText = "";
        SqlText = "select"
                + " (select bic from bankinfo_t where kod_b=bb.filial_code) BRANCH_CODE,"
                + " (select bank from bankinfo_t where kod_b=bb.filial_code) BRANCH_NAME,"
                + " bb.gl_acct_no BALANCE_ACCOUNT_NUMBER,"
                + " (select substr(balname,0,255) from bal_spr1 where bal_cn=bb.gl_acct_no) BALANCE_ACCOUNT_NAME,"
                + " (select name from T_AVALUTE where id=bb.currency_id) CURRENCY_CODE,"
                + " bb.YTD_DR,bb.YTD_CR, bb.BALANCE, bb.AZN_BALANCE"
                + "  from ("
                + " select "
                + " sum(nvl(q.balance,0)) balance,sum(nvl(q.azn_balance,0)) azn_balance,"
                + " sum(nvl(d.ytd_dr,0)) ytd_dr,sum(nvl(d.ytd_cr,0)) ytd_cr,"
                + " a.filial_code,a.currency_id,a.gl_acct_no "
                + " from"
                + " (SELECT alt_acct_id,balance_fcy_amount BALANCE,balance_lcy_amount AZN_BALANCE FROM"
                + "       SI_ACCOUNT_BALANCE WHERE date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') AND date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd')) q,"
                + " (SELECT   alt_acct_id, "
                + "    nvl(SUM (operation_acct_amount_dt),0) YTD_DR,"
                + "    nvl(SUM (operation_acct_amount_cr),0) YTD_CR"
                + "    FROM si_account_operation_bal"
                + "    WHERE (act_date BETWEEN TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') AND  TO_DATE ('" + strDateB + "', 'yyyy-mm-dd'))"
                + "    GROUP BY alt_acct_id) d, "
                + " (select  alt_acct_id,decode(filial_code,0,100,filial_code) filial_code,currency_id,gl_acct_no from si_account_inf_bal  "
                + " WHERE date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') AND date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') and closure_date is null) a"
                + " where q.alt_acct_id=d.alt_acct_id(+) and a.alt_acct_id=q.alt_acct_id(+) "
                + " group by gl_acct_no,currency_id,filial_code) bb  "
                + " where (bb.balance<>0 or bb.azn_balance<>0 or bb.ytd_dr<>0 or bb.ytd_cr<>0) and bb.gl_acct_no in (SELECT bal_cn FROM mdr_bal_cn)"
                + " order by bb.filial_code,bb.gl_acct_no,bb.currency_id";

        //   System.out.println(SqlText);
        ResultSet sqlres = stmt.executeQuery(SqlText);
        sqlres.last();
        int rowcount = sqlres.getRow();
        sqlres.beforeFirst();

        // String filename = "/tsm/DWHReports/MDRFiles/"+s+".xml";
        String filename = fileFolder + "XXX" + fnameDT + "_BLNC.xml";
        //c:\\
        File f = new File(filename);
        BufferedWriter output = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), "UTF8"));
        output.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        output.append("<BALANCE xsi:noNamespaceSchemaLocation=\"BALANCE.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");
        output.append("<BANK_CODE>505099</BANK_CODE>");
        output.append("<BANK_NAME>ExpressBank ASC</BANK_NAME>");
        output.append("<BALANCE_DATE>" + strDateB + "</BALANCE_DATE>");
        output.append("<ROWCOUNT>" + rowcount + "</ROWCOUNT>");
        int count = sqlres.getMetaData().getColumnCount();
        String[] StrArray;
        StrArray = new String[30];
        for (int i = 1; i <= count; i++) {
            StrArray[i] = sqlres.getMetaData().getColumnName(i);
        }

        while (sqlres.next()) {

            output.append("<DETAILS>");

            for (int i = 1; i <= count; i++) {
                output.append("<" + StrArray[i] + ">" + sqlres.getString(i) + "</" + StrArray[i] + ">");
            }
            output.append("</DETAILS>");
        }

        output.append("</BALANCE>");
        output.close();
        sqlres.close();
        stmt.close();
        conn.close();

        return true;
    }

    public boolean createBankInfo(Date dateB) throws ClassNotFoundException, SQLException, IOException {
        SimpleDateFormat dtformat = new SimpleDateFormat("yymm");
        SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");
        String strDateB = dtformat2.format(dateB);
        String fnameDT = dtformat.format(dateB);

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String SqlText = "SELECT a.kod_b branch_code,"
                + " a.bic branch_lisence_code,"
                + " a.bank branch_name,"
                + " a.seher branch_city,"
                + " a.adress branch_adress,"
                + " a.zip branch_zip_code,"
                + " a.tel branch_phone,"
                + " 'info@expressbank.az' branch_email,"
                + " null branch_director_cn,"
                + " a.s_fname branch_director_name,"
                + " a.s_lname branch_director_surname,"
                + " a.s_mname branch_director_fathers_name,"
                + " null branch_finance_cn,"
                + " a.b_fname branch_finance_name,"
                + " a.b_lname branch_finance_surname,"
                + " a.b_mname branch_finance_fathers_name"
                + " FROM  bankinfo_t a where a.kod_b not in (201,202)"
                + "ORDER BY a.kod_b";

        ResultSet sqlres = stmt.executeQuery(SqlText);

        sqlres.last();
        int rowcount = sqlres.getRow();
        sqlres.beforeFirst();

        // String filename = "/tsm/DWHReports/MDRFiles/"+s+".xml";
        String filename = fileFolder + "XXX" + fnameDT + "_BANK.xml";
        //c:\\
        File f = new File(filename);
        BufferedWriter output = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), "UTF8"));
        output.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        output.append("<BANK xsi:noNamespaceSchemaLocation=\"BANK.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");

        output.append("<BANK_CODE>505099</BANK_CODE>");
        output.append("<BANK_NAME>ExpressBank ASC</BANK_NAME>");
        output.append("<BANK_CITY> Bakı </BANK_CITY>");
        output.append("<BANK_ADRESS>Əcəmi Naxçıvani küç. 21</BANK_ADRESS>");
        output.append("<BANK_ZIP_CODE>AZ1130</BANK_ZIP_CODE>");

        output.append("<BANK_LICENSE_NO>119</BANK_LICENSE_NO>");
        output.append("<BANK_LICENSE_DATE>2005-04-15</BANK_LICENSE_DATE>");
        output.append("<BANK_PHONE>(+994 12) 5612288</BANK_PHONE>");
        output.append("<BANK_FAX>(+994 12) 5612688</BANK_FAX>");
        output.append("<BANK_EMAIL>info@expressbank.az</BANK_EMAIL>");
        output.append("<BANK_WEBSITE>http://www.expressbank.az/</BANK_WEBSITE>");

        output.append("<EXECUTOR_CN></EXECUTOR_CN>");
        output.append("<EXECUTOR_NAME>Mahmud</EXECUTOR_NAME>");
        output.append("<EXECUTOR_SURNAME>Əliyev</EXECUTOR_SURNAME>");
        output.append("<EXECUTOR_FATHERS_NAME>Rza</EXECUTOR_FATHERS_NAME>");

        output.append("<OWNERS>");
        output.append("<OWNER>");
        output.append("<BANK_OWNERS_CN></BANK_OWNERS_CN>");
        output.append("<BANK_OWNERS_NAME>\"ADOR\" Məhdud Məsuliyyətli Cəmiyyəti</BANK_OWNERS_NAME>");
        output.append("<BANK_OWNERS_SURNAME>Test</BANK_OWNERS_SURNAME>");
        output.append("<BANK_OWNERS_FATHERS_NAME>Test</BANK_OWNERS_FATHERS_NAME>");
        output.append("</OWNER>");

        output.append("<OWNER>");
        output.append("<BANK_OWNERS_CN></BANK_OWNERS_CN>");
        output.append("<BANK_OWNERS_NAME>\"Azenco Group\" Məhdud Məsuliyyətli Cəmiyyəti</BANK_OWNERS_NAME>");
        output.append("<BANK_OWNERS_SURNAME>Test</BANK_OWNERS_SURNAME>");
        output.append("<BANK_OWNERS_FATHERS_NAME>Test</BANK_OWNERS_FATHERS_NAME>");
        output.append("</OWNER>");

        output.append("<OWNER>");
        output.append("<BANK_OWNERS_CN></BANK_OWNERS_CN>");
        output.append("<BANK_OWNERS_NAME>\"Enerqoservis\" Məhdud Məsuliyyətli Cəmiyyəti</BANK_OWNERS_NAME>");
        output.append("<BANK_OWNERS_SURNAME>Test</BANK_OWNERS_SURNAME>");
        output.append("<BANK_OWNERS_FATHERS_NAME>Test</BANK_OWNERS_FATHERS_NAME>");
        output.append("</OWNER>");

        output.append("<OWNER>");
        output.append("<BANK_OWNERS_CN></BANK_OWNERS_CN>");
        output.append("<BANK_OWNERS_NAME>\"Avtonəqliyyatservis\" Departamenti Məhdud Məsuliyyətli Cəmiyyəti </BANK_OWNERS_NAME>");
        output.append("<BANK_OWNERS_SURNAME>Test</BANK_OWNERS_SURNAME>");
        output.append("<BANK_OWNERS_FATHERS_NAME>Test</BANK_OWNERS_FATHERS_NAME>");
        output.append("</OWNER>");
        output.append("</OWNERS>");

        output.append("<GOVS>");
        output.append("<GOV>");
        output.append("<BANK_GOV_CN></BANK_GOV_CN>");
        output.append("<BANK_GOV_NAME>Fəxrəddin</BANK_GOV_NAME>");
        output.append("<BANK_GOV_SURNAME>Bağırov</BANK_GOV_SURNAME>");
        output.append("<BANK_GOV_FATHERS_NAME>Qara</BANK_GOV_FATHERS_NAME>");
        output.append("</GOV>");

        output.append("<GOV>");
        output.append("<BANK_GOV_CN></BANK_GOV_CN>");
        output.append("<BANK_GOV_NAME>Natiq</BANK_GOV_NAME>");
        output.append("<BANK_GOV_SURNAME>Nəsibov</BANK_GOV_SURNAME>");
        output.append("<BANK_GOV_FATHERS_NAME>Astan</BANK_GOV_FATHERS_NAME>");
        output.append("</GOV>");

        output.append("<GOV>");
        output.append("<BANK_GOV_CN></BANK_GOV_CN>");
        output.append("<BANK_GOV_NAME>Ələsgər</BANK_GOV_NAME>");
        output.append("<BANK_GOV_SURNAME>Məmmədəliyev</BANK_GOV_SURNAME>");
        output.append("<BANK_GOV_FATHERS_NAME>Balakişi</BANK_GOV_FATHERS_NAME>");
        output.append("</GOV>");
        output.append("</GOVS>");

        output.append("<AUDITS>");
        output.append("<AUDIT>");
        output.append("<BANK_AUDIT_CN></BANK_AUDIT_CN>");
        output.append("<BANK_AUDIT_NAME>Ağəli</BANK_AUDIT_NAME>");
        output.append("<BANK_AUDIT_SURNAME>Yusubov</BANK_AUDIT_SURNAME>");
        output.append("<BANK_AUDIT_FATHERS_NAME>Kərim</BANK_AUDIT_FATHERS_NAME>");
        output.append("</AUDIT>");

        output.append("<AUDIT>");
        output.append("<BANK_AUDIT_CN></BANK_AUDIT_CN>");
        output.append("<BANK_AUDIT_NAME>Sədaqət</BANK_AUDIT_NAME>");
        output.append("<BANK_AUDIT_SURNAME>Məmmədova</BANK_AUDIT_SURNAME>");
        output.append("<BANK_AUDIT_FATHERS_NAME>İsrail</BANK_AUDIT_FATHERS_NAME>");
        output.append("</AUDIT>");

        output.append("<AUDIT>");
        output.append("<BANK_AUDIT_CN></BANK_AUDIT_CN>");
        output.append("<BANK_AUDIT_NAME>Rizvan</BANK_AUDIT_NAME>");
        output.append("<BANK_AUDIT_SURNAME>Ağakişiyev</BANK_AUDIT_SURNAME>");
        output.append("<BANK_AUDIT_FATHERS_NAME>Məhəmməd</BANK_AUDIT_FATHERS_NAME>");
        output.append("</AUDIT>");
        output.append("</AUDITS>");

        output.append("<COMMITES>");
        output.append("<COMMITE>");
        output.append("<BANK_COMMITE_CN></BANK_COMMITE_CN>");
        output.append("<BANK_COMMITE_NAME>Emin</BANK_COMMITE_NAME>");
        output.append("<BANK_COMMITE_SURNAME>Məmmədov</BANK_COMMITE_SURNAME>");
        output.append("<BANK_COMMITE_FATHERS_NAME>Yaşar</BANK_COMMITE_FATHERS_NAME>");
        output.append("</COMMITE>");

        output.append("<COMMITE>");
        output.append("<BANK_COMMITE_CN></BANK_COMMITE_CN>");
        output.append("<BANK_COMMITE_NAME>Əli</BANK_COMMITE_NAME>");
        output.append("<BANK_COMMITE_SURNAME>İmanov</BANK_COMMITE_SURNAME>");
        output.append("<BANK_COMMITE_FATHERS_NAME>Balazaman</BANK_COMMITE_FATHERS_NAME>");
        output.append("</COMMITE>");

        output.append("<COMMITE>");
        output.append("<BANK_COMMITE_CN></BANK_COMMITE_CN>");
        output.append("<BANK_COMMITE_NAME>İlham</BANK_COMMITE_NAME>");
        output.append("<BANK_COMMITE_SURNAME>Həbibullayev</BANK_COMMITE_SURNAME>");
        output.append("<BANK_COMMITE_FATHERS_NAME>Səbahəddin</BANK_COMMITE_FATHERS_NAME>");
        output.append("</COMMITE>");
        output.append("</COMMITES>");

        int count = sqlres.getMetaData().getColumnCount();
        String[] StrArray;
        StrArray = new String[30];
        for (int i = 1; i <= count; i++) {
            StrArray[i] = sqlres.getMetaData().getColumnName(i);
        }

        output.append("<BRANCHS>");
        output.append("<ROWCOUNT>" + rowcount + "</ROWCOUNT>");

        while (sqlres.next()) {

            output.append("<BRANCH>");
            for (int i = 1; i <= count; i++) {

                if (((StrArray[i].equals("BRANCH_DIRECTOR_CN")) && (sqlres.getObject(i) == null))
                        || ((StrArray[i].equals("BRANCH_FINANCE_CN")) && (sqlres.getObject(i) == null))) {
                    output.append("<" + StrArray[i] + "></" + StrArray[i] + ">");
                } else {
                    output.append("<" + StrArray[i] + ">" + sqlres.getString(i) + "</" + StrArray[i] + ">");
                }

            }
            output.append("</BRANCH>");
        }

        output.append("</BRANCHS>");
        output.append("</BANK>");
        output.close();
        sqlres.close();
        stmt.close();
        conn.close();

        return true;
    }

    public boolean createKred(Date dateB) throws ClassNotFoundException, SQLException, IOException {
        SimpleDateFormat dtformat = new SimpleDateFormat("yymm");
        SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");
        String strDateB = dtformat2.format(dateB);
        String fnameDT = dtformat.format(dateB);

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String SqlText1 = "";
        String SqlText2 = "";
        SqlText1 = "select b.customer_id CLIENT_NO,"
                + " b.filial_code KRD_BRANCH_CODE,"
                + " b.contract_id KREDIT_ID_NUMBER,"
                + " (SELECT debt_standard_acc_id FROM si_loan_account WHERE  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until) AND contract_id=b.contract_id) KREDIT_ACCOUNT_IBAN_NUMBER,"
                + " (select name from t_avalute where id=b.currency_id) KREDIT_CURRENCY_CODE,"
                + "  b.orig_amount KREDIT_CURRENCY_AMOUNT,"
                + " round((b.orig_amount*(SELECT exch_rate_bid FROM ri_currency_rate where  CURRENCY_MARKET=1 and numeric_ccy_code=b.currency_id and "
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until ) "
                + " )),2) KREDIT_AZN_AMOUNT,"
                + "  (select interest_accrual from si_loan_balance where date_until >= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') AND date_from <= TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') and contract_id=b.contract_id) KREDIT_INTEREST_AMOUNT,"
                + " to_char(b.value_date,'yyyy-MM-dd')  KREDIT_VALUE_DATE,"
                + " to_char(b.maturity_date,'yyyy-MM-dd') KREDIT_MATURITY_DATE, "
                + " (SELECT interest_rate_value FROM si_loan_interest_rate where  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until ) and contract_id=b.contract_id) KREDIT_PERCENT,"
                + " (SELECT substr(debt_standard_acc_id,9,5) kred_bal FROM si_loan_account WHERE  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until ) AND contract_id=b.contract_id) KREDIT_BALANCE_ACCOUNT,"
                + " (SELECT name FROM kred_source where id=nvl((SELECT finance_source from si_loan_finance_source where  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until ) and contract_id=b.contract_id),1)) KREDIT_SOURCE"
                + " FROM si_loan_contract b "
                //+ " ,si_depo_block_amount a"
                + " where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between b.date_from and b.date_until)"
                + " and b.contract_id IN (SELECT contract_id FROM si_loan_account WHERE debt_standard_acc_id IS NOT NULL"
                + " AND (TO_DATE ('" + strDateB + "','yyyy-mm-dd') BETWEEN date_from AND  date_until) "
                + " and  SUBSTR (debt_standard_acc_id, 9, 5) <>'99530') "
                // + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between a.date_from and a.date_until) and  "
                // + " and a.loan_contract_id=b.contract_id"
                + " and b.maturity_date> TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') "
                + " and b.customer_id in (select customer_id from si_person_natural where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') BETWEEN date_from AND  date_until))";
        SqlText2 = "select b.customer_id CLIENT_NO,"
                + " b.filial_code KRD_BRANCH_CODE,"
                + " b.contract_id KREDIT_ID_NUMBER,"
                + " (SELECT debt_standard_acc_id FROM si_pc_loan_account WHERE  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until) AND contract_id=b.contract_id) KREDIT_ACCOUNT_IBAN_NUMBER,"
                + " (select name from t_avalute where id=b.currency_id) KREDIT_CURRENCY_CODE,"
                + "  b.orig_amount KREDIT_CURRENCY_AMOUNT,"
                + " round((b.orig_amount*(SELECT exch_rate_bid FROM ri_currency_rate where  CURRENCY_MARKET=1 and numeric_ccy_code=b.currency_id and "
                + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until ) "
                + " )),2) KREDIT_AZN_AMOUNT,"
                + "  (select interest_accrual from si_pc_loan_balance where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until) and contract_id=b.contract_id) KREDIT_INTEREST_AMOUNT,"
                + " to_char(b.value_date,'yyyy-MM-dd')  KREDIT_VALUE_DATE,"
                + " to_char(b.maturity_date,'yyyy-MM-dd') KREDIT_MATURITY_DATE, "
                + " (SELECT interest_rate_value FROM si_pc_loan_interest_rate where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until) and contract_id=b.contract_id) KREDIT_PERCENT,"
                + " (SELECT substr(debt_standard_acc_id,9,5) kred_bal FROM si_pc_loan_account WHERE (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until) AND contract_id=b.contract_id) KREDIT_BALANCE_ACCOUNT,"
                + " (SELECT name FROM kred_source where id=nvl((SELECT finance_source from si_pc_loan_finance_source where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between date_from and date_until) and contract_id=b.contract_id),1)) KREDIT_SOURCE"
                + " FROM si_pc_loan_contract b "
                //+ " ,si_depo_block_amount a"
                + " where (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between b.date_from and b.date_until) "
                // + " (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between a.date_from and a.date_until) and  "
                // + " and a.loan_contract_id=b.contract_id"
                + " and b.maturity_date> TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') "
                + " and b.customer_id in (select customer_id from si_person_natural where (TO_DATE ('2013-09-30', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)"
                + "and b.contract_id in (select contract_id from si_pc_loan_account where debt_standard_acc_id is not null and  (TO_DATE ('2013-09-30', 'yyyy-mm-dd') BETWEEN date_from AND  date_until)))";

        //  System.out.println(SqlText1+" union all "+SqlText2);
        ResultSet sqlres = stmt.executeQuery(SqlText1 + " union all " + SqlText2);
        sqlres.last();
        int rowcount = sqlres.getRow();
        sqlres.beforeFirst();

        // String filename = "/tsm/DWHReports/MDRFiles/"+s+".xml";
        String filename = fileFolder + "XXX" + fnameDT + "_KRD.xml";
        //c:\\
        File f = new File(filename);
        BufferedWriter output = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), "UTF8"));
        output.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        output.append("<KREDITS xsi:noNamespaceSchemaLocation=\"KREDIT.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");

        output.append("<BANK_CODE>505099</BANK_CODE>");
        output.append("<BANK_NAME>ExpressBank ASC</BANK_NAME>");

        int count = sqlres.getMetaData().getColumnCount();
        String[] StrArray;
        StrArray = new String[30];
        for (int i = 1; i <= count; i++) {
            StrArray[i] = sqlres.getMetaData().getColumnName(i);
        }

        output.append("<ROWCOUNT>" + rowcount + "</ROWCOUNT>");

        while (sqlres.next()) {

            output.append("<KREDIT>");
            for (int i = 1; i <= count; i++) {
                output.append("<" + StrArray[i] + ">" + sqlres.getString(i) + "</" + StrArray[i] + ">");
            }
            output.append("</KREDIT>");
        }

        output.append("</KREDITS>");
        output.close();
        sqlres.close();
        stmt.close();
        conn.close();

        return true;
    }

    public boolean createCust(Date dateB) throws ClassNotFoundException, SQLException, IOException {
        SimpleDateFormat dtformat = new SimpleDateFormat("yymm");
        SimpleDateFormat dtformat2 = new SimpleDateFormat("yyyy-mm-dd");
        String strDateB = dtformat2.format(dateB);
        String fnameDT = dtformat.format(dateB);

        DB db = new DB();
        Connection conn = db.connect();
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String SqlText = "";
        SqlText = "SELECT a.FILIAL_CODE AS BANK_BRANCH_CODE,"
                + " a.CUSTOMER_ID AS CLIENT_NO,"
                + " 1 AS CLIENT_TYPE,"
                + " decode(a.resident,'YES','RES','GRES') AS CLIENT_NATIONALTY,"
                + " null AS CLIENT_SYMBOL_NO,"
                + " a.NAME_FIRST_AZ AS CLIENT_NAME,"
                + " a.NAME_LAST_AZ AS CLIENT_SURNAME,"
                + " a.NAME_CUST_AZ AS CLIENT_FATHERS_NAME,"
                + "  to_char(a.birth_date,'yyyy-mm-dd') AS CLIENT_DATE_BIRTH,"
                + " a.birth_place AS CLIENT_PLACE_OF_BIRTH,"
                + " (SELECT max(id) FROM identity_card where symbol=(select p.legal_doc_name from si_person_identity_card p"
                + " where p.customer_id=a.CUSTOMER_ID and p.date_from = (select max(date_from) from si_person_identity_card where customer_id=p.customer_id))) CLIENT_ID_TYPE,"
                + " null CLIENT_ID_COMMENT,"
                + " (select p.legal_doc_sr from si_person_identity_card p"
                + " where p.customer_id=a.CUSTOMER_ID and date_from = (select max(date_from) from si_person_identity_card where customer_id=p.customer_id)) CLIENT_ID_SERIAL,"
                + " (select p.legal_doc_id from si_person_identity_card p"
                + " where p.customer_id=a.CUSTOMER_ID and date_from = (select max(date_from) from si_person_identity_card where customer_id=p.customer_id)) CLIENT_ID_NUMBER,"
                + " a.pin_code CLIENT_ID_PIN,"
                + " (select to_char(p.legal_iss_dt,'yyyy-mm-dd') from si_person_identity_card p"
                + " where p.customer_id=a.CUSTOMER_ID and date_from = (select max(date_from) from si_person_identity_card where customer_id=p.customer_id)) CLIENT_ID_ISSUE_DATE,"
                + " (select p.legal_iss_auth from si_person_identity_card p"
                + " where p.customer_id=a.CUSTOMER_ID and date_from = (select max(date_from) from si_person_identity_card where customer_id=p.customer_id)) CLIENT_ID_ISSUE_PLACE,"
                + " a.reg_addr_street_az CLIENT_ID_ADDRESS, "
                + " a.reg_addr_street_az CLIENT_ID_ADDRESS_REAL,"
                + " null CLIENT_ID_EMAIL,"
                + " null CLIENT_ID_PHONE_MOBILE,"
                + " null CLIENT_ID_PHONE_HOME,"
                + " null CLIENT_ID_PHONE, "
                + " null CLIENT_ID_PERSON_DATA,"
                + " null CLIENT_ID_PERSON_RELATIONSHIP, "
                + " null CLIENT_ID_RELATIONSHIP_1, "
                + " null CLIENT_ID_PERSON_NAME, "
                + " null CLIENT_ID_PERSON_SURNAME, "
                + " null CLIENT_ID_PERSON_FATHERS_NAME, "
                + " null CLIENT_ID_PERSON_DATE_BIRTH, "
                + " null \"CLIENT_ID_PPOFB\","
                + " null CLIENT_ID_PERSON_ID,"
                + " null CLIENT_ID_PERSON_SERIAL,"
                + " null CLIENT_ID_PERSON_NUMBER,"
                + " null CLIENT_ID_PERSON_PIN,"
                + " null CLIENT_ID_PERSON_ISSUE_DATE,"
                + " null CLIENT_ID_PERSON_ISSUE_PLACE, "
                + " null CLIENT_ID_PERSON_ADDRESS,"
                + " null CLIENT_ID_PERSON_ADDRESS_REAL,"
                + " null CLIENT_ID_PERSON_EMAIL,"
                + " null CLIENT_ID_PERSON_PHONE_MOBILE,"
                + " null CLIENT_ID_PERSON_PHONE_HOME,"
                + " a.tax_pay_id VOEN,"
                + " null CLIENT_FS_ADRESS,"
                + " 1 JOINT_ACCOUNT_NUMBER,"
                + " null JOINT_ACCOUNTS,"
                + " null JOINT_ACCOUNT_TYPE,"
                + " null JOINT_ACCOUNT_NO,"
                + " null JOINT_ACCOUNT_SYMBOL_NO,"
                + " null JOINT_ACCOUNT_NAME,"
                + " null JOINT_ACCOUNT_SURNAME,"
                + " null JOINT_ACCOUNT_FATHERS_NAME,"
                + " null JOINT_ACCOUNT_DATE_BIRTH,"
                + " null JOINT_ACCOUNT_PLACE_OF_BIRTH,"
                + " null JOINT_ACCOUNT_ID_TYPE,"
                + " null JOINT_ACCOUNT_ID_COMMENT,"
                + " null JOINT_ACCOUNT_ID_SERIAL,"
                + " null JOINT_ACCOUNT_ID_NUMBER,"
                + " null JOINT_ACCOUNT_ID_PIN,"
                + " null JOINT_ACCOUNT_ID_ISSUE_DATE,"
                + " null JOINT_ACCOUNT_ID_ISSUE_PLACE,"
                + " null JOINT_ACCOUNT_ID_ADDRESS,"
                + " null JOINT_ACCOUNT_ID_ADDRESS_REAL,"
                + " null JOINT_ACCOUNT_ID_EMAIL,"
                + " null JOINT_ACCOUNT_ID_PHONE_MOBILE,"
                + " null JOINT_ACCOUNT_ID_PHONE_HOME,"
                + " null JOINT_ACCOUNT_ID_PHONE,"
                + " null JOINT_ACCOUNT_PERCENT"
                + " FROM SI_PERSON_NATURAL a "
                + " where a.sector in (4001,4003) and  (TO_DATE ('" + strDateB + "', 'yyyy-mm-dd') between a.date_from and a.date_until )";

//System.out.println(SqlText);
        ResultSet sqlres = stmt.executeQuery(SqlText);
        sqlres.last();
        int rowcount = sqlres.getRow();
        sqlres.beforeFirst();

        // String filename = "/tsm/DWHReports/MDRFiles/"+s+".xml";
        String filename = fileFolder + "XXX" + fnameDT + "_CUST.xml";
        //c:\\
        File f = new File(filename);
        BufferedWriter output = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f), "UTF8"));
        output.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        output.append("<CUSTOMERS xsi:noNamespaceSchemaLocation=\"Customer.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");

        output.append("<BANK_CODE>505099</BANK_CODE>");
        output.append("<BANK_NAME>ExpressBank ASC</BANK_NAME>");

        int count = sqlres.getMetaData().getColumnCount();
        String[] StrArray;
        StrArray = new String[70];
        for (int i = 1; i <= count; i++) {
            StrArray[i] = sqlres.getMetaData().getColumnName(i);
        }

        output.append("<ROWCOUNT>" + rowcount + "</ROWCOUNT>");

        while (sqlres.next()) {

            output.append("<CUSTOMER>");
            for (int i = 1; i <= count; i++) {

                if (StrArray[i].equals("CLIENT_ID_PPOFB")) {
                    output.append("<CLIENT_ID_PERSON_PLACE_OF_BIRTH></CLIENT_ID_PERSON_PLACE_OF_BIRTH>");
                } else if (sqlres.getObject(i) == null) {
                    output.append("<" + StrArray[i] + "></" + StrArray[i] + ">");
                } else {
                    output.append("<" + StrArray[i] + ">" + sqlres.getString(i) + "</" + StrArray[i] + ">");
                }
            }
            output.append("</CUSTOMER>");
        }

        output.append("</CUSTOMERS>");
        output.close();
        sqlres.close();
        stmt.close();
        conn.close();

        return true;
    }
}
