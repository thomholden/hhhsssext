/*
 * WeightsTableModel.java
 *
 * Created on 09 August 2006, 14:18
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
public class WeightsTableModel extends AbstractTableModel {
    
    private String[] fColumnNames = {"Stock", "Weight"};

    private String[] fStockNames;
    private Double[][] fAllWeights;
    private Double[] fCurrWeights;
    
    private int fCurrSelected;
   
       
    /* override of AbstractTableModel.getColumnCount */
    public int getColumnCount()
    {
        return fColumnNames.length;
    }
    
    /* override of AbstractTableModel.getRowCount */
    public int getRowCount()
    {
        if(fAllWeights != null)
            return fAllWeights[0].length;
        else
            return 0;
        
    }
    
    /* override of AbstractTableModel.getValueAt */
    public Object getValueAt(int row, int col)
    {
        Object retval = null;
        
        switch(col)
        {
            case 0: //stock name
                retval = fStockNames[row];
                break;
            case 1: //weight
                retval = fCurrWeights[row];
                break;
            default:
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
        switch(col)
        {
            case 0: //stock name
                fStockNames[row] = value.toString();
                break;
            case 1: //weight
                fCurrWeights[row] = Double.valueOf(value.toString());
                break;
            default:
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

    /* sets all the data for the table */
    public void setWeights(double[][] mat)
    {
        fAllWeights = Utils.ConvertDoubleArray(mat);
        updateTable(fAllWeights.length);
    }

    /* sets all the data for the table */
    public void setData(String[] names, double[][] mat)
    {
        fStockNames = (String[])names;
        fAllWeights = Utils.ConvertDoubleArray(mat);
        
        selectData(fCurrSelected);
    }
    
    public void clearData()
    {
        fStockNames = null;
        fAllWeights = null;
        fCurrWeights = null;
        
        fireTableDataChanged();
    }
    
    /* selects which set of weights e are interested in*/
    public void selectData(int i)
    {
        fCurrSelected = i;
        fCurrWeights = fAllWeights[i];
        fireTableDataChanged();
    }
    
    
    public String[] getStockNames()
    {
        return fStockNames;
    }
     
    public Double[] getCurrentWeights()
    {
        return fCurrWeights;
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
        if(fCurrWeights == null || fCurrWeights.length != numRows)
        {
            fCurrWeights = new Double[numRows];
            dataUpdated = true;
        }

        if(dataUpdated)
            fireTableDataChanged();
    }
    
}
