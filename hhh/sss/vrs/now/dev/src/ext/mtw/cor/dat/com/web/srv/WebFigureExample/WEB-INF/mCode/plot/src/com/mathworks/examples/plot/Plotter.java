/*
* MATLAB Compiler: 4.7 (R2007b)
* Date: Fri Sep 28 14:02:48 2007
* Arguments: "-B" "macro_default" "-W"
* "java:com.mathworks.examples.plot,Plotter" "-d"
* "C:\\Projects\\workspace\\WebFiguresExample\\m\\plot\\src" "-T" "link:lib"
* "-v"
* "class{Plotter:C:\\Projects\\workspace\\WebFiguresExample\\m\\getplot.m}" 
*/

package com.mathworks.examples.plot;

import com.mathworks.toolbox.javabuilder.*;
import java.util.*;

/**
 * The <code>Plotter</code class provides a Java interface to the M-functions
 * from the files:
 * <pre>
 * C:\Projects\workspace\WebFiguresExample\m\getplot.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a <code>Plotter</code>
 * instance when it is no longer needed to ensure that native resources
 * allocated by this class are properly freed.
 * @version 0.0
 */
public class Plotter extends MWComponentInstance<Plotter>
{
  /**
   * Tracks all instances of this class to ensure their dispose method is
   * called on shutdown.
   */
  private static Set<Disposable> sInstances = new HashSet<Disposable>();
  /**
   * Maintains information used in calling the <code>getplot</code> M-function.
   */
  private static final MWFunctionSignature sgetplotSignature = new MWFunctionSignature(1, false, "getplot", 0, false);
  /**
   * Constructs a new instance of the <code>Plotter</code> class.
   */
  public Plotter() throws MWException
  {
    super(plotMCRFactory.newInstance());
    // add this to sInstances
    synchronized(sInstances) {
      sInstances.add(this);
    }
  }
  private static MWComponentOptions getPathToComponentOptions(String path)
  {
    MWComponentOptions options = new MWComponentOptions(new MWCtfExtractLocation(path), new MWCtfDirectorySource(path));
    return options;
    
  }
  /**
   * Constructs a new instance of the <code>Plotter</code> class. Use this
   * constructor to specify a component directory other than the default
   * location.
   * @param pathToComponent Path to component directory.
   */
  public Plotter(String pathToComponent) throws MWException
  {
    super(plotMCRFactory.newInstance(getPathToComponentOptions(pathToComponent)));
    // add this to sInstances
    synchronized(sInstances){
      sInstances.add(this);
    }
  }
  /**
   * Constructs a new instance of the <code>Plotter</code> class. Use this
   * constructor to specify the options required to instantiate this component.
   * The options will be specific to the instance of this component being
   * created.
   * @param componentOptions Options specific to the component.
   */
  public Plotter(MWComponentOptions componentOptions) throws MWException
  {
    super(plotMCRFactory.newInstance(componentOptions));
    // add this to sInstances
    synchronized(sInstances){
      sInstances.add(this);
      
    }
  }
  /** Frees native resources associated with this object */
  public void dispose()
  {
    super.dispose();
    synchronized(sInstances) {
      sInstances.remove(this);
    }
  }
  /**
   * Invokes the first m-function specified by MCC, with any arguments given on
   * the command line, and prints the result.
   */
  public static void main (String[] args)
  {
    try {
      MWMCR mcr = plotMCRFactory.newInstance();
      mcr.runMain( sgetplotSignature, args);
      mcr.dispose();
      
    } catch (Throwable t) {
      t.printStackTrace();
    }
  }
  /**
   * Install a shutdown hook to call disposeAllInstances.
   */
  static
  {
    Runtime.getRuntime().addShutdownHook(new Thread(){public void run(){Plotter.disposeAllInstances();}});
  }
  /**
   * Helper for disposeAllInstances.
   */
  private static Plotter popInstance()
  {
    Plotter o = null;
    synchronized(sInstances) {
      Iterator i = sInstances.iterator();
      if (i.hasNext()) {
        o = (Plotter) i.next();
        sInstances.remove(o);
      }
    }
    return o;
  }
  /**
   * Calls dispose method for each outstanding instance of this class.
   */
  public static void disposeAllInstances()
  {
    if(null == sInstances) {
      return;
    }
    synchronized(sInstances) {
      Plotter o = popInstance();
      while (o != null) {
        o.dispose();
        o = popInstance();
      }
    }
  }
  /**
   * Provides the mlx interface for calling the <code>getplot</code>
   * M-function. 
   * @param lhs List in which to return outputs. Number of outputs (nargout) is
   * determined by allocated size of this List. Outputs are returned as
   * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
   * Each output array should be freed by calling its <code>dispose()</code>
   * method. 
   * @param rhs List containing inputs. Number of inputs (nargin) is determined
   * by the allocated size of this List. Input arguments may be passed as
   * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or
   * as arrays of any supported Java type. Arguments passed as Java types are
   * converted to MATLAB arrays according to default conversion rules. 
   * @throws MWException An error has occured during the function call. 
   */
  public void getplot(List lhs, List rhs) throws MWException
  {
    fMCR.invoke(lhs, rhs, sgetplotSignature);
  }
  /**
   * Provides the mlx interface for calling the <code>getplot</code>
   * M-function. 
   * @param lhs array in which to return outputs. Number of outputs (nargout)
   * is determined by allocated size of this array. Outputs are returned as
   * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
   * Each output array should be freed by calling its <code>dispose()</code>
   * method. 
   * @param rhs array containing inputs. Number of inputs (nargin) is
   * determined by the allocated size of this array. Input arguments may be
   * passed as sub-classes of
   * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
   * any supported Java type. Arguments passed as Java types are converted to
   * MATLAB arrays according to default conversion rules. 
   * @throws MWException An error has occured during the function call. 
   */
  public void getplot(Object[] lhs, Object[] rhs) throws MWException
  {
    fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs), sgetplotSignature);
  }
  /**
   * Provides the standard interface for calling the <code>getplot</code>
   * M-function with 0 input argument. 
   * @param nargout Number of outputs to return.
   * @param rhs The inputs to the M function.
   * @return Array of length nargout containing the function outputs. Outputs
   * are returned as sub-classes of
   * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
   * should be freed by calling its <code>dispose()</code> method.
   * @throws MWException An error has occured during the function call.
   */
  public Object[] getplot(int nargout, Object... rhs) throws MWException
  {
    Object[] lhs = new Object[nargout];
    fMCR.invoke(Arrays.asList(lhs), MWMCR.getRhsCompat(rhs, sgetplotSignature), sgetplotSignature);
    return lhs;
  }
}
