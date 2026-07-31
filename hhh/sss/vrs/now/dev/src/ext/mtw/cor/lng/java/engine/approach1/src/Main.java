import MatlabRuntimeInterface.*;
import java.io.*;

/**
 * Demonstration program for connecting Java with Matlab using the Java 
 * Runtime class. Communication is achieved by acquiring Matlab's standard
 * input and output streams.
 **/
public class Main {
	public static void main(String[] args) {
	  Engine engine = new MatlabRuntimeInterface.Engine();
		try {
			// Matlab start command:
			engine.open("matlab -nosplash -nojvm");
			// Display output:
			System.out.println(engine.getOutputString(500));
      // Example: Solve the system of linear equations Ax = f with
			// Matlab's Preconditioned Conjugate Gradients method.
			engine.evalString("A = gallery('lehmer',10);");  // Define Matrix A
			engine.evalString("f = ones(10,1);");            // Define vector f
			engine.evalString("pcg(A,f,1e-5)");              // Compute x
			// Retrieve output:
			System.out.println(engine.getOutputString(500));
			// Close the Matlab session:
			engine.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
