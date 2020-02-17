/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package beans;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author m.aliyev
 */
public class ArrayOfStmtTransactions {

    public List<StmtTransactions> stmttransactions;

    public List<StmtTransactions> getStmttransactions() {
        if (stmttransactions == null) {
            stmttransactions = new ArrayList<StmtTransactions>();
        }
        return this.stmttransactions;
    }
}
