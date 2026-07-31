/*
 * PortOptFileFilter.java
 *
 * Created on 07 August 2006, 09:52
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.mathworks.demos.finance.portoptdemo;

import java.io.File;
import javax.swing.filechooser.FileFilter;

/**
 *
 * @author elwinc
 */
public class PortOptFileFilter extends FileFilter {
    
    //Accept all directories and all xls files.
    public boolean accept(File f) 
    {
        if (f.isDirectory()) 
            return true;

        String extension = getExtension(f);
        if (extension != null) 
        {
            if (extension.equals("xls"))
                return true;
            else
                return false;
        }

        return false;
    }

    //The description of this filter
    public String getDescription() 
    {
        return "Excel Files";
    }
    
    // gets the file extension from a file
    public static String getExtension(File f) 
    {
        String ext = null;
        String s = f.getName();
        int i = s.lastIndexOf('.');

        if (i > 0 &&  i < s.length() - 1) 
            ext = s.substring(i+1).toLowerCase();

        return ext;
    }   
}
