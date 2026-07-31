package portOptDemoJava;

import com.mathworks.toolbox.javabuilder.pooling.Poolable;
import java.util.List;
import java.rmi.Remote;
import java.rmi.RemoteException;

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
public interface portOptDemoJavaClassRemote extends Poolable
{
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
  public Object[] readStockDataFromFile(int nargout, Object... rhs) throws RemoteException;
  
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
  public Object[] optimisePortfolio(int nargout, Object... rhs) throws RemoteException;
  
  /** Frees native resources associated with the remote server object */
  void dispose() throws RemoteException;
}
