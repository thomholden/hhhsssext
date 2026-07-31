MatInfo: Windows Explorer tooltips for MAT-files.

A shell extension which shows a summary of the contents of the MAT-file in the Windows Explorer tooltip.

By default, the tooltip which is shown in Windows Explorer when you hold the mouse over a MAT-file icon does not contain much information.  With this shell extension, the Windows Explorer provides significantly more information: the names, sizes and data types of all variables in the file.

Full source code is provided, including a Visual Studio 6.0 project.  For reasons not fully understood by the auther, compilation fails in Visual Studio.NET.  The supplied DLL was linked against the libraries in MATLAB R2006a, though any post-R14 version should do.

It has been tested on Windows XP and Windows 2000, using Microsoft Visual Studio 6.0, and linking against the libraries in MATLAB R2006a.  It will be necessary to edit the project file (MatInfo.dsp) if your installation of MATLAB is in a location other than D:\MATLAB\R2006a.
  
This shell extension is based heavily on an example published in The Code Project's "Idiot's Guide to Writing Shell Extensions":
http://www.codeproject.com/shell/shellextguide1.asp

The main addition is the MATLAB-specific code in "matfilesummary.cpp".  For information on the functions used in this file, see the documentation on the "MAT-File Access" functions in the "C and FORTRAN functions section of the MATLAB documentation.

Also included in the ZIP file is the pre-compiled DLL, MatInfo.dll.  To use this without compiling it yourself, copy it to a permanent location on your machine and run the DOS command: "regsvr32 MatInfo.dll" in the directory containing the DLL.  An installation of MATLAB will need to be on your system path.

To uninstall the extension run "regsvr32 /U MatInfo.dll".

