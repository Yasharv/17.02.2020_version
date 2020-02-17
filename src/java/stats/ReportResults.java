/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stats;

import DBUtility.WorkDatabase;
import DBUtility.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import ReadProperitesFile.ReadPropFile;
import java.sql.Connection;

/**
 *
 * @author r.ganiyev
 */
public class ReportResults
{
    public String getResults(String p_firstDate, String p_secondDate, String p_user)
    {
        Object[] array = new Object[5];
        
        String paramsValue = "datintvl=to_date('"+p_firstDate.trim()+"','dd.mm.yyyy') and to_date('"+p_secondDate.trim()+"','dd.mm.yyyy')";
        
        array[0] = 79; // page_id
        array[1] = 1; // query_status
        array[2] = 1;  // cond_status
        array[3] = paramsValue;
        array[4] = p_user;
        
        WorkDatabase wd = new WorkDatabase();
        
         ResultSet rs=null;
         String proc=getProcName();
         List<DwhStatistics> lst=null;
         DataSource dataSource = new DataSource();
         Connection dbConnection = null;
        try 
        {
            dbConnection = dataSource.getConnection();
            rs=wd.callOracleStoredProcCURSORParameter(array, proc, 0, dbConnection);
            lst=getStatsList(rs);
        }
        catch (SQLException ex)
        {
            Logger.getLogger(ReportResults.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try {
                if (rs!=null && !rs.isClosed()) {
                    rs.close();
                }
                 
                if (dbConnection != null)
                {
                    dbConnection.close();
                }
                
                }
            catch (SQLException ex)
            {
               
            }
        }
        
        
        StringBuilder jsonBld;
        
        if (lst!=null && !lst.isEmpty())
        {
             jsonBld=makeJson(lst);
             return jsonBld.toString();
        }
        else
        {
            System.out.println("Empty");
        }
        return null;
        
       
    }
    
     private List<DwhStatistics> getStatsList(ResultSet rs) throws SQLException
     {
        List<DwhStatistics> dwhStats=new ArrayList<DwhStatistics>();
        
        
            
            while(rs.next())
            {
               DwhStatistics dwh =new DwhStatistics();
               dwh.setPageName(rs.getString(1));
               dwh.setUserName(rs.getString(2));
               dwh.setCntByUser(rs.getInt(3));
               dwh.setCntGeneral(rs.getInt(4));
               
               dwhStats.add(dwh);
               
               dwh=null;
            }
        
        
        return dwhStats;
     }
     
     private StringBuilder makeJson(List<DwhStatistics> dwhLst)
     {
        StringBuilder bld=new StringBuilder();
        bld.append("[ ");
         for (int i = 0; i < dwhLst.size(); i++)
         {
           if(i<dwhLst.size()-1 && dwhLst.get(i).getPageName().equals(dwhLst.get(i+1).getPageName()))
           {
               continue;
           }
           else if (i==dwhLst.size()-1) 
             {
                 bld.append("{ y: "+dwhLst.get(i).getCntGeneral()+", label: \""+dwhLst.get(i).getPageName()+"\" }");
             }
            else
            {  
             bld.append("{ y: "+dwhLst.get(i).getCntGeneral()+", label: \""+dwhLst.get(i).getPageName()+"\" },");  
            }
 
             
         }
         bld.append(" ]");
        return bld;
     }
     
     private String getProcName()
     {
         ReadPropFile rf = new ReadPropFile();
         Properties properties = rf.ReadConfigFile("StoredProcedureName.properties");
         
         return properties.getProperty("ProcName");
     }
}
