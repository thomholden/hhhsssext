package MatlabNativeInterface;

import java.io.*;

/**
 * <b>Java Engine for Matlab via Java Native Interface (JNI)</b><br>
 * This class demonstrates how to call Matlab from a Java program via 
 * JNI, thereby employing Matlab as the computation engine.
 * The Matlab engine operates by running in the background as a separate
 * process from your own program.
 * <p>
 * Date: 04.04.03
 * <p>
 * Copyright (c) 2003 Andreas Klimke, Universität Stuttgart
 * <p>
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions: 
 * <p>
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * <p>
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author W. Andreas Klimke, University of Stuttgart 
 *         (klimke@ians.uni-stuttgart.de)
 * @version 0.1
 *
 */
public class Engine {
	
	/**
	 * Calls the function <code>engOpen</code> of Matlab's C Engine library. 
	 * Excerpts from the Matlab documentation:
	 * "On UNIX systems, if startcmd is NULL or the empty string, 
	 * <code>engOpen</code> starts MATLAB on the current host using the 
	 * command <code>matlab</code>. If startcmd is a hostname, <code>engOpen
	 * </code> starts MATLAB on the designated host by embedding the specified 
	 * hostname string into the larger string:
   * <code>rsh hostname \"/bin/csh -c 'setenv DISPLAY\ hostname:0; matlab'\"
	 * </code>. If startcmd is any other string (has white space in it, or 
	 * nonalphanumeric characters), the string is executed literally to start 
	 * MATLAB. On Windows, the startcmd string must be NULL."<br>	 
   * See the Matlab documentation, chapter "External Interfaces/API 
	 * Reference/C Engine Functions" for further information. 

	 * @param startcmd The start command string.
	 * @throws IOException Thrown if starting the process was not successful.
	 */
  public native void open(String startcmd) throws IOException;

	/**
	 * Calls the function <code>engClose</code> of Matlab's C Engine
	 * library.	This routine allows you to quit a MATLAB engine session.
	 * @throws IOException Thrown if Matlab could not be closed. 
	 */
	public native void close() throws IOException;

	/**
	 * Calls the function <code>engEvalString</code> of Matlab's C Engine
	 * library. Evaluates the expression contained in string for the MATLAB 
	 * engine session previously started by <code>open</code>.
   * See the Matlab documentation, chapter "External Interfaces/API 
	 * Reference/C Engine Functions" for further information. 
	 * @param str Expression to be evaluated.
	 * @throws IOException Thrown if data could not be sent to Matlab. This
	 *                     may happen if Matlab is no longer running.
	 * @see #open
	 */
  public native void evalString(String str) throws IOException;

	/**
	 *  Reads a maximum of <code>numberOfChars</code> characters from 
	 * the Matlab output buffer and returns the result as String.<br> 
	 * If the number of available characters exceeds <code>numberOfChars</code>,
	 * the additional data is discarded. The Matlab process must be opended
	 * previously with <code>open()</code>.<br>
	 * @return String containing the Matlab output.
	 * @see #open
	 * @throws IOException Thrown if data could not be received. This may
	 *                     happen if Matlab is no longer running.
	 */
  public native String getOutputString(int numberOfChars);

	/**
	 * Initialize the native shared library.
	 */
  static {
    System.loadLibrary("engineJavaMatlab");
		System.err.println("Native Matlab shared library loaded.");
  }
	
}
