package com.mathworks.examples.plot;

import com.mathworks.toolbox.javabuilder.pooling.Poolable;
import java.util.List;
import java.rmi.Remote;
import java.rmi.RemoteException;

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
public interface PlotterRemote extends Poolable
{
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
  public Object[] getplot(int nargout, Object... rhs) throws RemoteException;
  
  /** Frees native resources associated with the remote server object */
  void dispose() throws RemoteException;
}
