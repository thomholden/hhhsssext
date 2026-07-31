/*
 * PortOptWrapper.java
 *
 * Created on 28 July 2006, 17:31
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.mathworks.demos.finance.portoptdemo;

import com.mathworks.toolbox.javabuilder.*;
import portOptDemoJava.*;
import java.awt.image.*;
import java.awt.Image; 

/**
 * This class is a simple wrapper around the MATLAB-generated class which performs
 * the portfolio optimisation.  
 * @author elwinc
 */
public class PortOptWrapper {
    
    /**
     * Creates a new instance of PortOptWrapper
     */
    public PortOptWrapper() {
    	
    	try
    	{
    		fPortOptimiser = new portOptDemoJavaClass();
    	}
    	catch(Exception ex)
    	{
    		System.out.println("Exception: " + ex.toString());
    	}
    }
    
    /* Imports the data from the specified file.  This also gets the data stats for the file*/
    public void importFile(String filename)
    {
        Object[] results = null;
        MWCellArray stockNames = null;
        MWNumericArray imageData = null;

        try
        {
            results = fPortOptimiser.readStockDataFromFile(5, filename);
            stockNames = (MWCellArray)results[0];
 
            //Convert the Stock names from a cell array to strings
            int numElements = stockNames.numberOfElements();
            fStockNames = new String[numElements];
            for (int i=0 ; i < numElements; ++i)
                { //NB index from 1 for ML arrays
                fStockNames[i] = new String(stockNames.getCell(i+1).toString());
            }
            
            
            fMeanReturns = (double[])((MWNumericArray)results[1]).getData();
            fStdReturns = (double[])((MWNumericArray)results[2]).getData();
            fCovMatrix = (double[][])((MWNumericArray)results[3]).toArray();
            
            imageData = (MWNumericArray)results[4];
            fPricesPlot = Images.renderArrayData(imageData);
//            fPricesPlot = Utils.convertImage(imageData);
        }
        catch(Exception e)
        {
            System.out.println("Exception: " + e.toString());
        }
        finally
        {
            MWArray.disposeArray(results);
            stockNames.dispose();
            imageData.dispose();
        }
   }
    /* Performs the portfolio optimisation.  Also generates a plot of the efficient frontier*/
    public void optimisePortfolio(double[] expRets, double[] minWts, double[] maxWts)
    {
        Object[] results = null;
        MWNumericArray imageData = null;
        try
        {
            results = fPortOptimiser.optimisePortfolio(4, expRets, fCovMatrix, minWts, maxWts);
            
            fPortRisks = (double[])((MWNumericArray)results[0]).getData();
            fPortReturns = (double[])((MWNumericArray)results[1]).getData();
            fPortWeights = (double[][])((MWNumericArray)results[2]).toArray();
            
            imageData = (MWNumericArray)results[3];
            fEFrontierPlot = Images.renderArrayData(imageData);
//            fEFrontierPlot = Utils.convertImage(imageData);
        }
        catch(Exception e)
        {       
            System.out.println("Exception: " + e.toString());
        }
        finally
        {
            MWArray.disposeArray(results);
            imageData.dispose();
        }
    }

    /*Get/set functions for the member variables*/
    public Image getPricesImage()
    {
        return (Image)fPricesPlot;
    }
    
    public Image getEfficientFrontierImage()
    {
        return (Image)fEFrontierPlot;
    }
    
    public double[] getMeanReturns()
    {
        return fMeanReturns;
    }
    
    public double[] getStdReturns()
    {
        return fStdReturns;
    }
    public String[] getStockNames()
    {
        return fStockNames;
    }
    public double[][] getCovarianceMat()
    {
        return fCovMatrix;
    }
    public double[] getPortRisks()
    {
        return fPortRisks;
    }
    public double[] getPortReturns()
    {
        return fPortReturns;
    }
    public double[][] getPortWeights()
    {
        return fPortWeights;
    }
    
    public void dispose()
    {
        if(fPortOptimiser != null)
            fPortOptimiser.dispose();
    }
    
    private portOptDemoJavaClass    fPortOptimiser;
    
    //input data
    private double[]          fMeanReturns;
    private double[]          fStdReturns;
    private double[][]        fCovMatrix;
    private String[]          fStockNames;
    
    private RenderedImage     fPricesPlot;
    private RenderedImage     fEFrontierPlot;
    
    //output data
    private double[]          fPortRisks;
    private double[]          fPortReturns;
    private double[][]        fPortWeights;
}
