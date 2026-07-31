An Example to show how to compile a Matlab MEX file with OpenMP support using cmake. 
cmake is needed for compiling the MEX.

To compile the test MEX under Linux, 
first set MATLAB_ROOT environment variable to your installed matlab path,
such as 'export MATLAB_ROOT=/usr/local/MATLAB/R2012b',
then, simply do

mkdir build
cd build
cmake ../src
make
make install

To compile the test MEX under Windows,
first set MATLAB_ROOT environment variable to your installed matlab path,
then, use cmake or cmake-gui to generate building project according to installed compiler (e.g. MSVC),
then, build the generated project using this compiler.

The test MEX source code is located under /src/openmpmex/openmpAdd. The compiled test MEX 'openmpAdd' will 
be installed into /bin by default. C=openmpAdd(A,B) basically do element-by-element addition for 1D or 
2D matrix A and B using two threads, return matrix C.

To add new MEX source code, for example openmpXXX.cpp, simply do
1. add a new folder 'openmpXXX' under /src/openmpmex
2. add one line 'add_subdirectory(openmpXXX)' to CMakeLists.txt under /src/openmpmex
3. copy CMakeLists.txt under /src/openmpmex/openmpAdd to folder /src/openmpmex/openmpXXX
4. change first line to set(CPP_FILE openmpXXX) in copied CMakeLists.txt
5. follow compiling steps as described above


