/*
 * Utils.java
 *
 * Created on 07 August 2006, 15:44
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.mathworks.demos.finance.portoptdemo;
import com.mathworks.toolbox.javabuilder.*;
import java.awt.image.*;
/**
 *
 * @author elwinc
 */
public class Utils {
    
    /** Creates a new instance of Utils */
    public Utils() {
    }
    
    public static double[] ConvertDoubleArray(Double[] value)
    {
        int numData = value.length;
        double[] retval = new double[numData];
        
        for(int i=0; i < numData; ++i)
        {
            retval[i] = ((Double)value[i]).doubleValue();
        }
        return retval; 
    }
    
    public static Double[] ConvertDoubleArray(double[] value)
    {
        Double[] retval = null;
        if(value != null)
        {
            int numData = value.length;

            retval = new Double[numData];

            for (int i = 0; i < value.length; ++i)
                retval[i] = new Double(value[i]);
            return retval;
        }
        
        return retval;
    }
    
    public static double[][] ConvertDoubleArray(Double[][] value)
    {
        double[][] retval = null;
        if(value!= null && value[0] != null)
        {
            int numRows = value.length;
            int numCols = value[0].length;

            retval = new double[numRows][numCols];

            for(int i=0; i < numRows; ++i)
            {
                for (int j=0; j < numCols; ++j)
                {
                    retval[i][j] = ((Double)value[i][j]).doubleValue();
                }
            }
        }
        
        return retval;
    }

    public static Double[][] ConvertDoubleArray(double[][] value)
    {
        Double[][] retval = null;
        
        if(value != null && value[0] != null)
        {
            int numRows = value.length;
            int numCols = value[0].length;

            retval = new Double[numRows][numCols];

            for(int i=0; i < numRows; ++i)
            {
                for (int j=0; j < numCols; ++j)
                {
                    retval[i][j] = new Double(value[i][j]);
                }
            }
        }
        return retval;        
    }
    
    /** Generates an Image from a MWNumericArray containing RGB data*/
    public static BufferedImage convertImage(MWNumericArray imageData)
    {
        BufferedImage img = null;
        if(imageData != null)
        {
            //Matlab is column major, whereas java is row major
            //so "swap" the dimensions
            int[] dim = imageData.getDimensions();
            int w = dim[1];
            int h = dim[0];


            try
            {
                //convert the imageData to an array
                Object im = imageData.toArray();
                if(im instanceof byte[][][])
                {
                    byte[][][] imageArray = (byte[][][])im;

                    img = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
                    for (int y = 0; y < h ; y++)
                    {
                        for (int x = 0; x < w; x++)
                        {
                            //get the RGB components of the image.  The numbers range from
                            //-255 to 0, so add 256
                            int red = imageArray[y][x][0] + 256;
                            int green = imageArray[y][x][1] + 256;
                            int blue = imageArray[y][x][2] + 256;

                            //pixels are a 32 bit int with 8 bits representing alpha,R,G,B
                            int rgb = (255 << 24) | (red << 16) | (green << 8) | blue;
                            //now set the pixel value in the image
                            img.setRGB(x, y, rgb);
                        }
                    }
                }
            }
            catch(Exception e)
            {
                System.out.println("Exception: " + e.toString());
            }
        }        
        return img;
    }
}
