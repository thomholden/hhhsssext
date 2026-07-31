Copyright 2007-2013 MathWorks, Inc. 

This material contains the C/C++ demo component for the seminar entitled:
"Algorithm Development with MATLAB for C and C++ Programmers."

There is a configuration file (configure.h) which determines how the
code will be compiled.

NOTE: The configuration has a path to the demo location hard coded in
it - this will need to be updated for where you locate the demo.  Additionally
the file verifyLanes.cpp also has a hard coded path that will ned to be updated.

To run this demo, you will need the following products from MathWorks: 

   MATLAB
   MATLAB Coder
   MATLAB Compiler
   Image Processing Toolbox
   Computer Vision System Toolbox

The project is currently set up for Microsoft Visual Studio, and assumes
that 64-bit MATLAB R2013a is installed in C:\MATLAB\R2013a.  It will work
with other versions of MATLAB, and in different installation directories,
but you will need to set up the correct paths for the includes and the
header files within the Visual Studio project. 

The paths will also be easier to update if you unzip the demo files in 
folder C:\Demos\AlgorithmDevelopment\ as your demoroot, so you have i.e. 
<demoroot>\1-MATLAB_Intro_Lanes. You can unzip and run the demo from any 
directory you wish, but you will need to update more paths.

In the solution explorer, these “project” files need to be added:
1) Under “Engine Interface” add: libeng.lib, libmx.lib, engine.h
    These can be found in :
	<matlabroot>\extern\lib\<arch>\microsoft\libeng.lib
    <matlabroot>\extern\lib\<arch>\microsoft\libmx.lib
	<matlabroot>\extern\include\engine.h
    Where <matlabroot> is the install directory of MATLAB, i.e. 
    C:\MATLAB\R2013a\ , which can also be found by entering >>matlabroot
    at the MATLAB command prompt.
2) Under “Compiler Library” add:  mclmcrrt.lib 
    Which is found at <matlabroot>\extern\lib\<arch>\microsoft\mclmcrrt.lib

Also you will need to rebuild the Compiler components in 
\7-LanesCompilerLibrary\ and add the files from the 
\laneMarkingWithVisualization\distrib\  folder
laneMarkingAlgorithmWithVisualization.h and .lib and include them
in the "Compiler Library" folder in Visual Studio project.

In the project settings, the include paths would need to be updated:
1) Right click on the project in the Solution Explorer and select
   “Properties”
2) In the property pages, under the Configuration Properties section,
   expand “C/C++” and select “General”
3) Click in the “Additional Include Directories” and choose “<Edit…>”
4) Update all the MATLAB paths to point to your install dir.

Copy the AVI file at <matlabroot>\toolbox\vision\visiondemos\viplanedeparture.avi
to the folder <demoroot>\Data\ or the Visual Studio project will be unable to find it.

IMPORTANT:
While <matlabroot>/runtime and <matlabroot>/runtime/<arch> should already be on the
system path, you will need to add <matlabroot>/bin/<arch> for the MATLAB Engine
to work. You will also need to add 
<demoroot>\7-LanesCompilerLibrary\laneMarkingWithVisualization\distrib\ 
to your system path, where <demoroot> is the location of the 
AlgorithmDevelopment folder, i.e. C:\Demos\AlgorithmDevelopment\

Hope this helps you!