#!/bin/sh
# script for execution of deployed applications
#
# Sets up the MCR environment for the current $ARCH and executes 
# the specified command.
#
exe_name=$0
exe_dir=`dirname $0`
echo "------------------------------------------"
if [ "x$1" = "x" ]; then
  echo Usage:
  echo    $0 \<deployedMCRroot\> args
else
  echo Setting up environment variables
  MCRROOT=$1
  echo ---
  MWE_ARCH="maci64" ;
  if [ "$MWE_ARCH" = "sol64" ] ; then
	LD_LIBRARY_PATH=.:/usr/lib/lwp:${MCRROOT}/runtime/maci64 ; 
  else
  	DYLD_LIBRARY_PATH=.:${MCRROOT}/runtime/maci64 ;
  fi
  DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${MCRROOT}/bin/maci64 ;
  DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${MCRROOT}/sys/os/maci64;
  if [ "$MWE_ARCH" = "maci" -o "$MWE_ARCH" = "maci64" ]; then
	DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries;
  else
	MCRJRE=${MCRROOT}/sys/java/jre/maci64/jre/lib/ ;
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE}/native_threads ; 
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE}/server ;
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE}/client ;
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE} ;  
  fi
  XAPPLRESDIR=${MCRROOT}/X11/app-defaults ;
  export DYLD_LIBRARY_PATH;
  export XAPPLRESDIR;
  echo DYLD_LIBRARY_PATH is ${DYLD_LIBRARY_PATH};
  shift 1
${exe_dir}/runprog.app/Contents/MacOS/runprog $*
fi
exit
