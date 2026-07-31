Overview:
------------
csvreader is a robust comma separated value (CSV) function for MATLAB.
The built-in CSV reading in MATLAB is either for numeric data only (csvread) 
or does not handle complex strings (dataset). For example, there is no 
built-in MATLAB function that handles reading CSV files that contain quoted 
strings that may contain commas.

For example, the following CSV will be problematic for MATLAB to read 
in correctly:

Joe Demo,"2 Demo Street, Demoville, Australia. 2615",joe@someaddress.com
Jim Sample,"3 Sample Street, Sampleville, Australia. 2615",jim@sample.com
Jack Example,"1 Example Street, Exampleville, Australia. 2615",jack@example.com

The second entry of each line is an address that contains a comma.  Non-robust
 CSV parsers will fail to put the entire address in the same cell.  Further, 
csvreader will accept quoted strings that contain line breaks.

For help and example usage, type “help csvreader” from the MATLAB command window.


Installation:
------------
The csvreader function uses a Java Archive (JAR) library from the opencsv project.  
In order to be called from within MATLAB, the opencsv JAR must be placed on MATLAB’s 
Java class path.  For more information on the MATLAB java class path see
 http://www.mathworks.com/help/matlab/matlab_external/bringing-java-classes-and-methods-into-matlab-workspace.html

To install the JAR follow the following steps:
1.	Open MATLAB and change the working directory to the same folder as the opencsv-2.3.jar and installCSVReader.m
2.	Run the install script by typing ‘installCSVReader’ in the MATLAB command window

Dependencies:
------------
This project uses the opencsv java library. The opencsv project website is 
http://opencsv.sourceforge.net.

Developers:
------------
This project is being published on the MATLAB Central file share website.  
If you would like to contribute to the development of this function, you 
can fork this project from my BitBucket repository: 
https://bitbucket.org/kkusano/csvreader

Copyright Kristofer D. Kusano - 9/13/13
kusano@vt.edu