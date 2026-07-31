To build a MEX file with Visual Studio .NET:

1. Create a new project (C++ Win32 project) -- make sure to set the project
to build a DLL rather than an executable. Choose:
File | New Project | Visual C++ Projects | Win32 Project. Make sure to visit the
"Project Properties" page and select "DLL".

Next, you'll be setting properties of the project (right click on the project name in the
solution explorer and select "Properties")

2. Add <MATLAB>\extern\include to the include directory path

3. Add <MATLAB>\lib\win32 to the additional library directory path

4. Add libmex.lib libmx.lib libut.lib to the addtional dependencies (under Linker/Inputs)

5. Create module definition file (module.def) 

LIBRARY <your_mex_file_name>.dll
EXPORTS
	mexFunction

6. Set the module definition file property to module.def (under Linker/Inputs)

Next, add your MEX file source code (one or more .c files) to the project. These files
should NOT use the precompiled headers, so for each:

1. Right click on the file name in the solution explorer

2. Select Properties

3. Under C/C++ | Precompiled Headers, make sure that Create/Use precompiled headers" is
set to "Not Using Precompiled Headers"


