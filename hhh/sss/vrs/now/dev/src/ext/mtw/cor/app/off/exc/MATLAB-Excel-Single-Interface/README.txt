
MATLAB-Excel Single Interface (MESI)

WHAT IS IT?
===========

MESI provides the VBA subroutine "RunInMATLAB", which allows you to call your M-code from Excel using Excel Link and .NET/COM Builder without changing your VBA code.

WHY DOES IT EXIST?
==================

A typical usage scenario for the above tools is the following. A developer is building an Excel worksheet that performs calculations in MATLAB, and during development, Excel Link is used. The developer has an installation of MATLAB and Excel Link provides an easy way to manage the interaction between the tools, stepping back and forth between the VBA and MATLAB debuggers, for example.

But the eventual goal is to deploy the worksheet, compiling the M-files into a COM dll using .NET Builder (formerly COM Builder). The way in which M-files are called from VBA using these two products is different, so different interface code must be written. MESI is an attempt to place this interface code in a single place, minimizing the changes needed on the VBA side as the application evolves.

WHAT IS IN IT?
==============

The package consists of three parts:

1. MATLABInfrastructure.bas
This is the VBA interface code. You must drag this into your VBA project.

2. matlabgateway.m
This is an M-file called by subroutines in the MATLABInfrastructure code.

3. filelist.m
This file is only used when compiling your M-files. It is not strictly necessary, but provides a way of avoiding the need to add each M-file in your .NET Builder project.

USAGE
=====

Use the demo worksheet, M-files and .NET Builder project as a guide.

STEP 0 - Install Excel Link (see the product documentation for details).

STEP 1 - In Excel, hit Alt-F11 to open the Visual Basic Editor and drag MATLABInfrastructure.bas into it.

STEP 2 - Define a named range consisting of a single cell called "UseExcelLink" and enter TRUE into that cell

STEP 3 - Add, say, a button to your worksheet (View -> Toolbars -> Control Toolbox) and in its callback function (double click on it in design mode) insert a call to your M-code using RunInMATLAB, called as follows:

Call RunInMATLAB( "commandName" ) runs the M-file "commandName" in MATLAB. No input or output arguments are used.

Call RunInMATLAB( "commandName", Array("inputRange1", "inputRange2") ) performs the same call, but this time the data in the named ranges inputRange1 and inputRange2 are used as inputs.

Call RunInMATLAB( "commandName", Array("inputRange1", "inputRange2"), _
                Array("outputRange1", "outputRange2") ) allows the M-file to return output arguments to Excel. The names ranges outputRange1 and outputRange2 must cover only a single cell and specify the top-left of the range into which the
output matrix is inserted.

 -----------------------------------------------------------------------
| You should now be up and running with Excel Link. To deploy, read on. |
 -----------------------------------------------------------------------

STEP 4 - Change the value in the UseExcelLink cell to FALSE.

STEP 5 - Build your COM dll (see the .NET Builder documentation for details). You need only add two M-files to the project - matlabgateway.m and filelist.m. filelist.m must contain a list of the M-files in your codebase.

STEP 6 - add two further configuration parameters to your worksheet - set up the single-cell named ranges "COMComponentName" and "COMClassName" and type in the corresponding strings that you chose in your .NET Builder project.

 -----------------------------------------------------------------------
| You should now be able to call your deployed code.                    |
 -----------------------------------------------------------------------

LIMITATIONS
===========

1. I am a VBA novice - the quality of the code is probably very poor and does not contain very much exception handling at all.

2. Only one COM class is allowed.

3. The interface is limited to the description above in STEP 3.

4. If you have output arguments but no input arguments, you need to supply dummy input arguments.

Author: Russell.Goyder@mathworks.co.uk
Date: 2006-08-17