Submitted by Bill Glenn, bglenn@zip.com.au

EDU» help spawn

 SPAWN Spawn a child process (DOS/WINDOWS)
   rval = spawn('child process','arg1','arg2',. .'arg9');
  
   child process  - any executable  
   arg1 . . arg9  - arguments passed to the child process
   rval           - return value from child process
 
   Description
   SPAWN a child process (console or windows executable).
   Use this in preference to the DOS() function if you need 
   the return value from the child process. DOS() will always 
   return 0 because it executes the child process via COMMAND.COM
   COMMAND.COM returns 0 if it has finished succesfully regardless 
   of the child process return value.
 
   See also
   DOS, ! (exclamation point) under PUNCT.


example
------------
EDU» rval = dos('edit.com') % should return 0

rval =

     0

EDU» rval = dos('@%&^%') % should return error

rval =

     0

EDU» rval = spawn('@%&^%') % should return error

rval =

    -1

EDU» rval = spawn('edit.com') % should return 0

rval =

     0


tested on 
------------

EDU» ver
--------------------------------------------------
<Student Edition> MATLAB Version 5.0.0.4073 on PCWIN
MATLAB License Identification Number: 0
--------------------------------------------------
MATLAB Toolbox                                 Version 5.0 Student Edition 31-Dec-1996
                                               Netlab              Functions
%%%%%%%%%%%%%%%%%%%%%%  Info  %%%%%%%%%%%%...  %   File Name       :     contents.m                              %%%
Neural Network Toolbox.                        Version 3.0.1  (R11) 01-Jul-1998
Soft Computing Toolbox                         Version 1.0, July 18, 1996 (For MATLAB 4.2)
Auditory Toolbox                               by Malcolm          Slaney
Control System Toolbox.                        Version 4.0 Student Edition 31-Dec-1996
Signal Processing Toolbox.                     Version 4.0 Student Edition 31-Dec-1996
Symbolic Math Toolbox.                         Version 2.0 Student Edition 18-Feb-1997

