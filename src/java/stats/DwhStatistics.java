/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stats;

/**
 *
 * @author r.ganiyev
 */
public class DwhStatistics 
{
 private String pageName;
    private String userName;
    private int    cntByUser;
    private int    cntGeneral;

    public String getPageName() {
        return pageName;
    }

    public void setPageName(String pageName) 
    {
        if (pageName.length()>29)
        {
            this.pageName = pageName.substring(0,29);
        }
        else
        {
            this.pageName = pageName;
        }
        
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getCntByUser() {
        return cntByUser;
    }

    public void setCntByUser(int cntByUser) {
        this.cntByUser = cntByUser;
    }

    public int getCntGeneral() {
        return cntGeneral;
    }

    public void setCntGeneral(int cntGeneral) {
        this.cntGeneral = cntGeneral;
    }
       
}
