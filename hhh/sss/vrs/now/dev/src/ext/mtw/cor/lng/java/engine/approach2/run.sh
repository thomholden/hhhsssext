# Adjust the following lines according to your system settings!
MATLAB_HOME=/opt/matlab
MATLAB_ARCH=glnx86

# Set the dynamic library path
LD_LIBRARY_PATH=lib:$MATLAB_HOME/bin/$MATLAB_ARCH:$MATLAB_HOME/extern/lib/$MATLAB_ARCH
export LD_LIBRARY_PATH

# Include Matlab to the PATH variable
PATH=$MATLAB_HOME/bin:$PATH
export PATH

# Uncomment this line to check the shared library dependencies
# ldd lib/libengineJavaMatlab.so

echo
echo "This approach demonstrates how to:"
echo "  - open a Matlab session using the Java Native Interface (JNI)"
echo "  - send data to Matlab, and"
echo "  - receive results back."
echo "As example, Matlab is used to solve a small linear equation"
echo "system Ax = f by the Preconditioned Conjugate Gradients method."
echo

java  -classpath classes Main