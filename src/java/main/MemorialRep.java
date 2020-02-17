/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.sql.SQLException;
import java.text.DecimalFormat;

/**
 *
 * @author m.aliyev
 */
public class MemorialRep {

    public String main(String DVal, String DAccNo, String CVal, String CAccNo, double Ammount, double LAmmount, String DAccName, String CAccName, String DInn, String CInn, String TrName, int cnt, String iB) throws SQLException, ClassNotFoundException {
        if (DInn == null || DInn == "") {
            DInn = " ";
        };
        if (CInn == null || CInn == "") {
            CInn = " ";
        };
        DecimalFormat twoDForm = new DecimalFormat("0.00");
        String grid = "";
        grid = "<table bgcolor='white' border='0' width='900' >"
                + " <tr>"
                + " <td width='39' align='center'> " + cnt + " </td>"
                + " <td width='48' align='center'>" + DVal + " </td>"
                + " <td width='240' align='center'>" + DAccNo + "</td>"
                + " <td width='46' align='center'>" + CVal + "</td>"
                + " <td width='240' align='center'>" + CAccNo + " </td>"
                + "     <td align='center' width='100'> "
                + "                         <table bgcolor='white' border='0' width='215'>"
                + "                             <tr>"
                + "             <td align='center' width='70'>" + twoDForm.format(Ammount) + "</td>"
                + "             <td align='center' width='70'>" + twoDForm.format(LAmmount) + "</td>"
                + "                             </tr>"
                + "                         </table> "
                + "     </td>"
                + " <td width='20' align='center'>" + iB + " </td>"
                + " </tr>"
                + "    <tr>"
                + "        <td colspan='2' > </td>"
                + "        <td align='center' ><font size=2>" + DAccName + "<br>" + DInn + "</font></td>"
                + "        <td> </td>"
                + "        <td align='center' ><font size=2>" + CAccName + "<br>" + CInn + "</font></td>"
                + "        <td colspan='2'> </td>"
                + "    </tr>"
                + " </table>"
                + " <table bgcolor='white' border='0' width='900'>"
                + "     <tr>"
                + "        <td width='124'> Əməliyyatın təyinatı: </td>"
                + "        <td width='760'>" + TrName + "</td>"
                + "    </tr>"
                + " </table>"
                + " <table bgcolor='white' border='0' width='900'>"
                + "   <tr>"
                + "        <td > <hr> </td> "
                + "    </tr>"
                + " </table>";
        return grid;
    }
}
