/*
* MATLAB Compiler: 4.7 (R2007b)
* Date: Tue Apr  1 22:11:22 2008
* Arguments: "-B" "macro_default" "-W"
* "java:portOptDemoJava,portOptDemoJavaClass" "-d"
* "/home/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/
* PortOptDemo/compile/portOptDemoJava/src" "-T" "link:lib" "-v"
* "class{portOptDemoJavaClass:/home/sholden/Business/Jacobix/Dev/Pascal-Linux/AS
* SET/dev/queued/matlab/java/PortOptDemo/matlab_src/readStockDataFromFile.m,/hom
* e/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/PortO
* ptDemo/matlab_src/optimisePortfolio.m}" 
*/

package portOptDemoJava;

import com.mathworks.toolbox.javabuilder.*;
import java.util.*;

/**
 * The <code>portOptDemoJavaClass</code class provides a Java interface to the
 * M-functions from the files:
 * <pre>
 * /home/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/
 * PortOptDemo/matlab_src/readStockDataFromFile.m
 * /home/sholden/Business/Jacobix/Dev/Pascal-Linux/ASSET/dev/queued/matlab/java/
 * PortOptDemo/matlab_src/optimisePortfolio.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a
 * <code>portOptDemoJavaClass</code> instance when it is no longer needed to
 * ensure that native resources allocated by this class are properly freed.
 * @version 0.0
 */
public class portOptDemoJavaClass extends MWComponentInstance<portOptDemoJavaClass>
{
  /**
   * Tracks all instances of this class to ensure their dispose method is
   * called on shutdown.
   */
  private static Set<Disposable> sInstances = new HashSet<Disposable>();
  /**
   * Maintains information used in calling the
   * <code>readStockDataFromFile</code> M-function.
   */
  private static final MWFunctionSignature sreadStockDataFromFileSignature = new MWFunctionSignature(5, false, "readStockDataFromFile", 1, false);
  /**
   * Maintains information used in calling the <code>optimisePortfolio</code>
   * M-function.
   */
  private static final MWFunctionSignature soptimisePortfolioSignature = new MWFunctionSignature(4, false, "optimisePortfolio", 5, false);
  /**
   * Constructs a new instance of the <code>portOptDemoJavaClass</code> class.
   */
  public portOptDemoJavaClass() throws MWException
  {
    super(portOptDemoJavaMCRFactory.newInstance());
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
   * Constructs a new instance of the <code>portOptDemoJavaClass</code> class.
   * Use this constructor to specify a component directory other than the
   * default location.
   * @param pathToComponent Path to component directory.
   */
  public portOptDemoJavaClass(String pathToComponent) throws MWException
  {
    super(portOptDemoJavaMCRFactory.newInstance(getPathToComponentOptions(pathToComponent)));
    // add this to sInstances
    synchronized(sInstances){
      sInstances.add(this);
    }
  }
  /**
   * Constructs a new instance of the <code>portOptDemoJavaClass</code> class.
   * Use this constructor to specify the options required to instantiate this
   * component.
   * The options will be specific to the instance of this component being
   * created.
   * @param componentOptions Options specific to the component.
   */
  public portOptDemoJavaClass(MWComponentOptions componentOptions) throws MWException
  {
    super(portOptDemoJavaMCRFactory.newInstance(componentOptions));
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
      MWMCR mcr = portOptDemoJavaMCRFactory.newInstance();
      mcr.runMain( sreadStockDataFromFileSignature, args);
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
    Runtime.getRuntime().addShutdownHook(new Thread(){public void run(){portOptDemoJavaClass.disposeAllInstances();}});
  }
  /**
   * Helper for disposeAllInstances.
   */
  private static portOptDemoJavaClass popInstance()
  {
    portOptDemoJavaClass o = null;
    synchronized(sInstances) {
      Iterator i = sInstances.iterator();
      if (i.hasNext()) {
        o = (portOptDemoJavaClass) i.next();
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
      portOptDemoJavaClass o = popInstance();
      while (o != null) {
        o.dispose();
        o = popInstance();
      }
    }
  }
  /**
   * Provides the mlx interface for calling the
   * <code>readStockDataFromFile</code> M-function. 
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
  public void readStockDataFromFile(List lhs, List rhs) throws MWException
  {
    fMCR.invoke(lhs, rhs, sreadStockDataFromFileSignature);
  }
  /**
   * Provides the mlx interface for calling the
   * <code>readStockDataFromFile</code> M-function. 
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
  public void readStockDataFromFile(Object[] lhs,
                                    Object[] rhs) throws MWException
  {
    fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs),
                sreadStockDataFromFileSignature);
  }
  /**
   * Provides the standard interface for calling the
   * <code>readStockDataFromFile</code> M-function with 1 input argument. 
   * Input arguments may be passed as sub-classes of
   * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
   * any supported Java type. Arguments passed as Java types are converted to
   * MATLAB arrays according to default conversion rules.
   * <pre>
   * M-documentation:
   * %
   * %Reads stock data from an Excel file.  The file contain dates in the
   * first
   * %column and the names of the stocks in the first row.
   * %
   * </pre>
   * @param nargout Number of outputs to return.
   * @param rhs The inputs to the M function.
   * @return Array of length nargout containing the function outputs. Outputs
   * are returned as sub-classes of
   * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
   * should be freed by calling its <code>dispose()</code> method.
   * @throws MWException An error has occured during the function call.
   */
  public Object[] readStockDataFromFile(int nargout, Object... rhs) throws MWException
  {
    Object[] lhs = new Object[nargout];
    fMCR.invoke(Arrays.asList(lhs), MWMCR.getRhsCompat(rhs, sreadStockDataFromFileSignature), sreadStockDataFromFileSignature);
    return lhs;
  /**
   * Provides the mlx interface for calling the <code>optimisePortfolio</code>
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
  }public void optimisePortfolio(List lhs, List rhs) throws MWException
  {
    fMCR.invoke(lhs, rhs, soptimisePortfolioSignature);
  }
  /**
   * Provides the mlx interface for calling the <code>optimisePortfolio</code>
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
  public void optimisePortfolio(Object[] lhs, Object[] rhs) throws MWException
  {
    fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs),
                soptimisePortfolioSignature);
  }
  /**
   * Provides the standard interface for calling the
   * <code>optimisePortfolio</code> M-function with 5 input arguments. 
   * Input arguments may be passed as sub-classes of
   * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
   * any supported Java type. Arguments passed as Java types are converted to
   * MATLAB arrays according to default conversion rules.
   * <pre>
   * M-documentation:
   * %performs the portfolio optimisation
   * %
   * </pre>
   * @param nargout Number of outputs to return.
   * @param rhs The inputs to the M function.
   * @return Array of length nargout containing the function outputs. Outputs
   * are returned as sub-classes of
   * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
   * should be freed by calling its <code>dispose()</code> method.
   * @throws MWException An error has occured during the function call.
   */
  public Object[] optimisePortfolio(int nargout, Object... rhs) throws MWException
  {
    Object[] lhs = new Object[nargout];
    fMCR.invoke(Arrays.asList(lhs), MWMCR.getRhsCompat(rhs, soptimisePortfolioSignature), soptimisePortfolioSignature);
    return lhs;
  }
}
