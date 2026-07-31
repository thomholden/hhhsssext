Revised: 3/30/2006

If you are reading this file, you must have unzipped the file
compecon.zip. This should be unzipped into a directory called 
COMPECON, which itself has two subdirectories
CETOOLS and CEDEMOS (directory information attached to the files) 

To use the toolbox, you must change the MATLAB path so it can
find the files. Type 
  cepath='d:\compecon\'; path([cepath 'cetools;' cepath 'cedemos'],path);
at the MATLAB command line. It is assumed that COMPECON is on the D: drive;
if not, change cepath in the line above. To have this occur automatically add this line to your matlabrc.m or startup.m files (these can be located using the which command). 

It is preferable to locate the compecon directory as a subdirectory of main matlab path; this leads MATLAB to skip checking file time stamps and leads to speedier execution.

To see a listing of all the toolbox functions, type help cetools. 
To see a listing of all the demonstration files, type help cedemos. 

This toolbox is available on the internet at
  www4.ncsu.edu/~pfackler/compecon
Please do not distribute this toolbox; instead provide the URL.

IMPORTANT NOTE:
A number of the routines provided in this toolbox are coded in C
as MEX files. A utility is provided (MEXALL.M) that will create these mex files.
It is assumed that you have a C compiler and can create mex files. The first time 
attempt to create a MEX file MATLAB will search for a C compiler. You can use the LCC 
compiler that ships with MATLAB. See MATLAB's Applications Interface documentation for details.

Ver. 5 Users:
The LCC compiler is available but the MEX function only allows you to use it if it finds a 
toolbox directory on the MATLAB path called STATEFLOW. If you create such a directory, the LCC 
compiler can be used.

