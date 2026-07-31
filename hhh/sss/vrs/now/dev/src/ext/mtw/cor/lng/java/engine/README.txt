---------------------------------------------------------------------------
Accessing Matlab from Java
---------------------------------------------------------------------------
Included are two alternatives to open and communicate with a Matlab
session from Java, "approach1" and "approach2".

Note: The make file "Makefile" and the bash script "run.sh" have been
      written and tested under Linux, and are included for your 
      convenience. However, there should be no problem in compiling
      and running the software under other operating systems
      with Java/Matlab support, given appropriate changes to the Makefile
      and creation of a similar execution script. Please note that the 
      author cannot provide any installation/set up support.

1) Compilation/Installation

Run "make" from the directory "approach1" or "approach2". 
The make file "Makefile" will be called, and all necessary
class files, objects, etc. will be created.

You may invoke "make" with the following options:

make        : Compiles the source code, and creates the HTML-documentation
              using the javadoc utility (RECOMMENDED).
make create : Creates the required subdirectories for the class files
              and the documentation (javadoc files) only.
make clean  : Removes the created class files and documentation.
make compile: Only recompile the source code.
make javadoc: Create Java documentation.


IMPORTANT: 

Approach 1 will NOT WORK ON WINDOWS, since the Windows version of MATLAB
does not support access via standard input/output streams.

The Makefile of approach 2 requires some variables to be set,
such as the Matlab path and architecture, as well as the location of
the Java installation and the Java architecture. This is required so make
can locate the right directories for C include files (.h) and libraries. 
If your operating system is NOT Linux, you will have to make additional 
adjustments to the Makefile regarding the C compiler and its settings. 
Compilation must produce a shared library. 


2) Running the demonstration:

Execute the script "run.sh" from the directory "approach1" or
"approach2". Remark: It must be possible to start Matlab with the command 
"matlab" from the command line. If this is not the case, please make
appropriate changes in the Main.java file (e.g. include the full path name),
or set the PATH variable of the operating system accordingly.
