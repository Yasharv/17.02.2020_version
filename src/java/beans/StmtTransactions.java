/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package beans;

/**
 *
 * @author m.aliyev
 */
public class StmtTransactions {

    private String tarix;
    private String valyuta;
    private String account;
    private String sendAndRecei;
    private double DebtAmount;
    private double DLAmount;
    private double CredAmount;
    private double CLAmount;
    private String teyinat;
    private String LapNo;
    private double mebleg;
    private double mebleg_lcy;

    public String getTarix() {
        return tarix;
    }

    public void setTarix(String tarix) {
        this.tarix = tarix;
    }

    public String getValyuta() {
        return valyuta;
    }

    public void setValyuta(String valyuta) {
        this.valyuta = valyuta;
    }

    public String getAccount() {
        return account;
    }
    
    public void setAccount(String account) {
        this.account = account;
    }
    
    public String getsendAndRecei() {
        return sendAndRecei;
    }
    
    public void setsendAndRecei(String sendAndRecei) {
        this.sendAndRecei = sendAndRecei;
    }
    
    public double getDebtAmount() {
        return DebtAmount;
    }

    public void setDebtAmount(double DebtAmount) {
        this.DebtAmount = DebtAmount;
    }

    public double getDLAmount() {
        return DLAmount;
    }

    public void setDLAmount(double DLAmount) {
        this.DLAmount = DLAmount;
    }

    public double getCredAmount() {
        return CredAmount;
    }

    public void setCredAmount(double CredAmount) {
        this.CredAmount = CredAmount;
    }

    public double getCLAmount() {
        return CLAmount;
    }

    public void setCLAmount(double CLAmount) {
        this.CLAmount = CLAmount;
    }

    public String getTeyinat() {
        return teyinat;
    }

    public void setTeyinat(String teyinat) {
        this.teyinat = teyinat;
    }

    public String getLapNo() {
        return LapNo;
    }

    public void setLapNo(String LapNo) {
        this.LapNo = LapNo;
    }

    public double getMebleg() {
        return mebleg;
    }

    public void setMebleg(double mebleg) {
        this.mebleg = mebleg;
    }

    public double getMebleg_lcy() {
        return mebleg_lcy;
    }

    public void setMebleg_lcy(double mebleg_lcy) {
        this.mebleg_lcy = mebleg_lcy;
    }

}
