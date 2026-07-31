# Adjust the following line according to your system settings!
MATLAB_HOME=/opt/matlab

PATH=$MATLAB_HOME/bin:$PATH
export PATH

echo
echo "This approach demonstrates how to:"
echo "  - open a Matlab session using the Java Runtime class"
echo "  - send data to Matlab, and"
echo "  - receive results back."
echo "As example, Matlab is used to solve a small linear equation"
echo "system Ax = f by the Preconditioned Conjugate Gradients method."
echo

java -classpath classes Main