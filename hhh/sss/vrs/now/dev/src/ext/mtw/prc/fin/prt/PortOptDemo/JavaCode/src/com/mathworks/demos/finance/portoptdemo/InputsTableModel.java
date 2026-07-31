/*
 * InputsTableModel.java
 *
 * Created on 07 August 2006, 11:33
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.mathworks.demos.finance.portoptdemo;

import javax.swing.table.AbstractTableModel;
import java.lang.Math;

/**
 *
 * @author elwinc
 */
public class InputsTableModel extends AbstractTableModel {
    
    private String[] fColumnNames = {"Stock", "Mean Return", "Std Return"};
    
    private String[] fStockNames;
    private Double[] fMeanRets;
    private Double[] fStdRets;
    
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
        int c = 0;
        if(fStockNames != null)
            a = fStockNames.length;
        
        if(fMeanRets != null)
            b = fMeanRets.length;
        
        if(fStdRets != null)
            c = fMeanRets.length;
        
        return Math.max(a, Math.max(b, c));
    }
    
    /* override of AbstractTableModel.getValueAt */
    public Object getValueAt(int row, int col)
    {
        Object retval = 0;
        switch (col)
        {
            case 0: //stock name
                retval = fStockNames[row];
                break;
            case 1: //mean Ret
                retval = fMeanRets[row];
                break;
            case 2: //std ret
                retval = fStdRets[row];
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
            case 0: //stock name
                fStockNames[row] = value.toString();
                break;
            case 1: //mean Ret
                fMeanRets[row] = Double.valueOf(value.toString());
                break;
            case 2: //std ret
                fStdRets[row] = Double.valueOf(value.toString());
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
    
    /* sets the stock names for the table*/
    public void setStockNames(String[] names)
    {
        fStockNames = names;
        updateTable(names.length);
    }
    
    /* sets the mean returns for the table */
    public void setMeanRets(double[] means)
    {
        fMeanRets = Utils.ConvertDoubleArray(means);
        updateTable(means.length);
    }
    
    /* sets the standard deviation of returns for the table*/
    public void setStdRets(double[] stds)
    {
        fStdRets = Utils.ConvertDoubleArray(stds);
        updateTable(stds.length);
    }
    
    /* sets all the data for the table */
    public void setData(String[] sNames, double[] meanRet, double[] stdRet)
    {
        fStockNames = sNames;
        fMeanRets = Utils.ConvertDoubleArray(meanRet);
        fStdRets = Utils.ConvertDoubleArray(stdRet);
        fireTableDataChanged();
    }
    
    public void clearData()
    {
        fStockNames = null;
        fMeanRets = null;
        fStdRets = null;
        fireTableDataChanged();
    }
    
    /* Ensures that the data for the whole table is initialised to the 
     correct size.  Also fires a table changed update.*/
    private void updateTable(int numRows)
    {
        boolean dataUpdated = false;
        if(fStockNames == null || fStockNames.length != numRows)
        {
            fStockNames = new String[numRows];
            dataUpdated = true;
        }
        if(fMeanRets == null || fMeanRets.length != numRows)
        {
            fMeanRets = new Double[numRows];
            dataUpdated = true;
        }
        if(fStdRets == null || fStdRets.length != numRows)
        {
            fStdRets = new Double[numRows];
            dataUpdated = true;
        }
        if(dataUpdated)
            fireTableDataChanged();
    }
}
