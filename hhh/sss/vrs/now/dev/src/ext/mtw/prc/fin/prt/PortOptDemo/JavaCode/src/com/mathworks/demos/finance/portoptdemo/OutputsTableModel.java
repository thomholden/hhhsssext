/*
 * OutputsTableModel.java
 *
 * Created on 07 August 2006, 14:11
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.mathworks.demos.finance.portoptdemo;
import javax.swing.table.AbstractTableModel;
/**
 *
 * @author elwinc
 */
public class OutputsTableModel extends AbstractTableModel {
    
    private String[] fColumnNames = {"Risk", "Return"};
    
    private Double[] fRisks;
    private Double[] fReturns;
    
    /* override of AbstractTableModel.getColumnCount */
    public int getColumnCount()
    {
        return fColumnNames.length;
    }
    
    /* override of AbstractTableModel.getRowCount */
    public int getRowCount()
    {
        int a = 0;
        int b = 0;
        
        if(fRisks != null)
            a = fRisks.length;
        
        if(fReturns != null)
            b = fReturns.length;
        
        return Math.max(a, b);
    }
    
    /* override of AbstractTableModel.getValueAt */
    public Object getValueAt(int row, int col)
    {
        Object retval = 0;
        switch (col)
        {
            case 0: //Risk
                retval = fRisks[row];
                break;
            case 1: //Ret
                retval = fReturns[row];
                break;
            default:
                retval = 0;
                break;
        }
        return retval;
    }

    /* override of AbstractTableModel.getColumnName */
    public String getColumnName(int col)
    {
        return fColumnNames[col];
    }
    
    /* override of AbstractTableModel.setValueAt */
    public void setValueAt(Object value, int row, int col)
    {
        //set the data
        switch (col)
        {
            case 0: //Risks
                fRisks[row] = Double.valueOf(value.toString());
                break;
            case 1: //Ret
                fReturns[row] = Double.valueOf(value.toString());
                break;
            default:
                //do nothing
                break;
        }
        //update the table
        fireTableCellUpdated(row, col);
    }

    public void setColumnNames(String[] names)
    {
        //only change the column names if the number of columns has not changed
        if(names.length == fColumnNames.length)
        {
            fColumnNames = names;
            fireTableStructureChanged();
        }
    }
    
    /* sets the risks for the table */
    public void setRisks(double[] risks)
    {
        fRisks = Utils.ConvertDoubleArray(risks);
        updateTable(risks.length);
    }
   
    /* sets the returns for the table */ 
    public void setReturns(double[] rets)
    {
        fReturns = Utils.ConvertDoubleArray(rets);
        updateTable(rets.length);
    }
    
    /* sets all the data for the table */
    public void setData(double[] risk, double[] ret)
    {
        fRisks = Utils.ConvertDoubleArray(risk);
        fReturns = Utils.ConvertDoubleArray(ret);
        fireTableDataChanged();
    }
    
    public void clearData()
    {
        fRisks = null;
        fReturns = null;
        fireTableDataChanged();
    }
    
    /* Ensures that the data for the whole table is initialised to the 
     correct size.  Also fires a table changed update.*/
    private void updateTable(int numRows)
    {
        boolean dataUpdated = false;
        if(fRisks == null || fRisks.length != numRows)
        {
            fRisks = new Double[numRows];
            dataUpdated = true;
        }
        if(fReturns == null || fReturns.length != numRows)
        {
            fReturns = new Double[numRows];
            dataUpdated = true;
        }
        if(dataUpdated)
            fireTableDataChanged();
    }
    
}
