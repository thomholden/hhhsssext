@echo off
rem MSVC90ENGMATOPTS.BAT
rem
rem    Compile and link options used for building stand-alone engine or MAT 
rem    programs with Microsoft Visual C++ compiler version 9.0.
rem
rem    $Revision: 1.1.10.4 $  $Date: 2006/11/15 14:50:04 $
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************
set MATLAB=%MATLAB%
set VS90COMNTOOLS=%VS90COMNTOOLS%
set VSINSTALLDIR=%VS90COMNTOOLS%\..\..
set VCINSTALLDIR=%VSINSTALLDIR%\VC
set PATH=%VCINSTALLDIR%\BIN\;C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\SDK\v3.5\bin;%VSINSTALLDIR%\Common7\Tools;%VSINSTALLDIR%\Common7\Tools\bin;%VCINSTALLDIR%\VCPackages;%MATLAB_BIN%;%PATH%
set INCLUDE=%VCINSTALLDIR%\ATLMFC\INCLUDE;%VCINSTALLDIR%\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v6.0A\INCLUDE;%VSINSTALLDIR%\SDK\v3.5\include;%INCLUDE%
set LIB=%VCINSTALLDIR%\ATLMFC\LIB;%VCINSTALLDIR%\LIB;C:\Program Files\Microsoft SDKs\Windows\v6.0A\lib;%VSINSTALLDIR%\SDK\v3.5\lib;%MATLAB%\extern\lib\win32;%LIB%
set MW_TARGET_ARCH=win32

rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=cl
set COMPFLAGS=/c /Zp8 /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /nologo
set OPTIMFLAGS=/MD /O2 /Oy- /DNDEBUG
set DEBUGFLAGS=/MD /Zi /Fd"%OUTDIR%%MEX_NAME%.pdb"
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win32\microsoft
set LINKER=link
set LINKFLAGS=/LIBPATH:"%LIBLOC%" libmx.lib libmat.lib libeng.lib /nologo /MACHINE:X86 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug /PDB:"%OUTDIR%%MEX_NAME%.pdb" /INCREMENTAL:NO
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%.exe"
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=
set RC_LINKER=
set POSTLINK_CMDS1=mt -outputresource:"%OUTDIR%%MEX_NAME%.exe";1 -manifest "%OUTDIR%%MEX_NAME%.exe.manifest" 
set POSTLINK_CMDS2=del "%OUTDIR%%MEX_NAME%.exe.manifest" 
