/*
 * ParamsTableModel.java
 *
 * Created on 07 August 2006, 14:31
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
public class ParamsTableModel extends AbstractTableModel {
    private static double MAX_ASSET_WEIGHT = 1.0;
    private static double MIN_ASSET_WEIGHT = 0.0;
 
    private static int MIN_WEIGHTS_INDEX = 0;
    private static int MAX_WEIGHTS_INDEX = 1;
    
    private String[] fColumnNames = {"Stock", "Use Defaults", "Expected Return", "Min Weight", "Max Weight"};
    
    private String[] fStockNames;
    private Double[] fExpRets;
    private Double[][] fWeights;
    
    private Double[] fDefaultRets;
    private Boolean[] fUseDefaults;
    

    /* Constructor */
    public ParamsTableModel()
    {
    }
    
    /* override of AbstractTableModel.getColumnCount */
    public int getColumnCount()
    {
        return fColumnNames.length;
    }
    
    /* override of AbstractTableModel.getRowCount */
    public int getRowCount()
    {
        if(fStockNames != null)
            return fStockNames.length;
        
        return 0;
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
            case 1: //Use Default
                retval = fUseDefaults[row];
                break;
            case 2: //Exp Ret
                retval = fExpRets[row];
                break;
            case 3: //Min wts
                retval = fWeights[MIN_WEIGHTS_INDEX][row];
                break;
            case 4: //Max wts
                retval = fWeights[MAX_WEIGHTS_INDEX][row];
                break;
            default:
                retval = 0;
                break;
        }
        return retval;
    }

    /* override of AbstractTableModel.getValueAt */
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
            case 1: //use Default
                useDefaults(row, (Boolean)value);
                break;
            case 2: //mean Ret
                fExpRets[row] = Double.valueOf(value.toString());
                break;
            case 3: //min wts
                fWeights[MIN_WEIGHTS_INDEX][row] = Double.valueOf(value.toString());
                break;
            case 4: //max wts
                fWeights[MAX_WEIGHTS_INDEX][row] = Double.valueOf(value.toString());
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

    /* sets the stock names for the table */
    public void setStockNames(String[] names)
    {
        fStockNames = names;
        updateTable(names.length);
    }
    
    /* sets the default return values of the table*/
    public void setDefaultReturns(double[] meanRets)
    {
        fDefaultRets = Utils.ConvertDoubleArray(meanRets);

        updateReturns();
        updateTable(meanRets.length);
    }
    
    public double[] getExpRets()
    {
        return Utils.ConvertDoubleArray((Double[])fExpRets); 
    }   

     public double[] getMinWts()
    {
        Double[] wts = fWeights[MIN_WEIGHTS_INDEX];
        return Utils.ConvertDoubleArray(wts); 
    }   

     public double[] getMaxWts()
    {
         Double[] wts = fWeights[MAX_WEIGHTS_INDEX];
        return Utils.ConvertDoubleArray(wts); 
    }   

     /* function to specify whether or not we are using the default
      weights.  If so, it updates the table*/
    public void useDefaults(int row, Boolean value)
    {
        boolean dataChanged = false;
        fUseDefaults[row] = value;
        if(fUseDefaults[row] && fDefaultRets[row] != null)
        {
            fExpRets[row] = fDefaultRets[row];
        }
        if(fUseDefaults[row] && fWeights[row] != null)
        {
            fWeights[MIN_WEIGHTS_INDEX][row] = new Double(MIN_ASSET_WEIGHT);
            fWeights[MAX_WEIGHTS_INDEX][row] = new Double(MAX_ASSET_WEIGHT);
            dataChanged = true;
        }
        if(dataChanged)
            fireTableDataChanged();
        
    }


    /*override of AbstractTableModel.isCellEditable*/
    public boolean isCellEditable(int row, int col) 
    {   
        boolean retval = false;
        switch(col)
        {
            case 0: //stock name
                //stock name is never editable
                retval = false;
                break;
            case 1: //Use defaults
                retval = true;
                break;
            case 2: // expected rets
            case 3: //min wts
            case 4: //max wts - deliberate fall through
                retval = !fUseDefaults[row];
                break;
            default:
                break;
        }
        return retval;
    }

    /*
     * JTable uses this method to determine the default renderer/
     * editor for each cell.  If we didn't implement this method,
     * then the last column would contain text ("true"/"false"),
     * rather than a check box.
     */
    public Class getColumnClass(int c) 
    {
        if(c == 1)
            return getValueAt(0, c).getClass();
        else
            return super.getColumnClass(c);
    }
    
    public void clearData()
    {
        fStockNames = null;
        fExpRets = null;
        fWeights = null;

        fDefaultRets = null;    
        fireTableDataChanged();
    }
    
    /* Ensures that the data for the whole table is initialised to the 
     correct size.  Also fires a table changed update.  Use this function 
     when there is new data for the table.  */
    private void updateTable(int numRows)
    {
        boolean dataUpdated = false;
        if(fStockNames == null || fStockNames.length != numRows)
        {
            fStockNames = new String[numRows];
            dataUpdated = true;
        }
        if(fExpRets == null || fExpRets.length != numRows)
        {
            fExpRets = new Double[numRows];
            dataUpdated = true;
        }
        if(fUseDefaults == null || fUseDefaults.length != numRows)
        {
            fUseDefaults = new Boolean[numRows];
            //set the values here too
            for(int i=0; i < fUseDefaults.length; ++i)
                fUseDefaults[i] = new Boolean(true);
            
            dataUpdated = true;
        }
        
        dataUpdated = updateWeights(numRows) || dataUpdated;

        if(dataUpdated)
            fireTableDataChanged();
    }    
    
    public boolean checkWeights()
    {
        boolean retval = true;
        for(int i=0; i < fWeights[0].length; ++i)
        {
        	// check if the weights are invalid - less than 0 or greater than 1
            if(fWeights[MIN_WEIGHTS_INDEX][i] < 0 || fWeights[MAX_WEIGHTS_INDEX][i] > 1)
            {
                retval = false;
                break;
            }
        }
        return retval;
    }
    
    private void updateReturns()
    {
        for(int i=0; i < fExpRets.length; ++i)
        {
            if(fUseDefaults[i])
                fExpRets[i] = fDefaultRets[i];
        }

    }
    
    /* Ensures that the weights are initialised to the correct size.  This function
     also maintains any existing weights in the table*/
    private boolean updateWeights(int length)
    {
        boolean update = false;
        Double[][] copyWts = null;
       
        if(fWeights == null)
        {
            fWeights = new Double[2][length];
            update = true;
        }
        
        if(fWeights[0].length != length)
        {//the weights array is the wrong length, 
            //so we must re-generate it.
            
            //some non-default data may exist in the weights array, so keep a copy
            //of it so that we can maintain the values of the weights lather
            copyWts = fWeights.clone();
            
            //re-create the weights array here.
            fWeights = new Double[2][length];
            update = true;
        }

        if(update)
        {
            //now put data into the weights array
            for(int i=0; i < length; ++i)
            {
                if(copyWts != null && i < copyWts.length && fUseDefaults[i])
                {//use the "old" values of the weights
                    fWeights[MIN_WEIGHTS_INDEX][i] = copyWts[MIN_WEIGHTS_INDEX][i];
                    fWeights[MAX_WEIGHTS_INDEX][i] = copyWts[MAX_WEIGHTS_INDEX][i];
                }
                else
                {//simply set the weights to the min and max values
                    fWeights[MIN_WEIGHTS_INDEX][i] = new Double(MIN_ASSET_WEIGHT);
                    fWeights[MAX_WEIGHTS_INDEX][i] = new Double(MAX_ASSET_WEIGHT);
                }
            }
        }
        return update;
    }
}
