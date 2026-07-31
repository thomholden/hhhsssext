/*
 * CovMatTableModel.java
 *
 * Created on 09 August 2006, 12:38
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
public class CovMatTableModel extends AbstractTableModel {
    private String[] fStockNames;
    private Double[][] fCovMatrix;
    
    public void setData(String[] stockNames, double[][] covMatrix)
    {
        fStockNames = stockNames;
        fCovMatrix = Utils.ConvertDoubleArray(covMatrix);
        fireTableStructureChanged();
    }
    
    /* override of AbstractTableModel.getColumnCount */
    public int getColumnCount()
    {
        if(fStockNames != null)
            return fStockNames.length + 1;
        else
            return 0;
    }
    
    /* override of AbstractTableModel.getRowCount */
    public int getRowCount()
    {
        if(fCovMatrix != null)
            return fCovMatrix.length;
        else
            return 0;
        
    }
    
    /* override of AbstractTableModel.getValueAt */
    public Object getValueAt(int row, int col)
    {
        Object retval = null;
        if(col == 0)
        {
            if(fStockNames != null)
                retval = fStockNames[row];
        }
        else
        {
            retval = fCovMatrix[row][col-1];
        }
        return retval;
    }

    /* override of AbstractTableModel.getColumnName */
    public String getColumnName(int col)
    {
        String retval = null;
        if (col == 0)
        {
            retval = new String(" ");
        }
        else
        {
            if (fStockNames != null)
                retval = fStockNames[col-1];
        }

        return retval;
    }
    
    /* override of AbstractTableModel.setValueAt */
    public void setValueAt(Object value, int row, int col)
    {
        if(col != 0)
        {
            if(fCovMatrix != null)
                fCovMatrix[row][col-1] = Double.valueOf(value.toString());
        }
        
        //update the table
        fireTableCellUpdated(row, col);
    }
    
    public void clearData()
    {
        fStockNames = null;
        fCovMatrix = null;
        fireTableDataChanged();
        fireTableStructureChanged();
    }

}
