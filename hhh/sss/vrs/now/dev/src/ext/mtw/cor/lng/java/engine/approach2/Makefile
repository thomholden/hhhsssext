# Adjust the following lines according to your system settings!
JAVA_HOME = /opt/j2sdk1.4.1_01
JAVA_ARCH = linux

MATLAB_HOME = /opt/matlab
MATLAB_ARCH = glnx86

COMPILER = gcc
COMPILER_ARGUMENTS = -o $(LIB_HOME)/lib$(LIBNAME).so \
		$(SOURCE_HOME)/$(SOURCES) \
		-shared \
    -nostartfiles \
	  -L$(MATLAB_HOME)/extern/lib/$(MATLAB_ARCH) -leng -lmx -lm \
		-ansi -D_GNU_SOURCE\
		-I$(MATLAB_HOME)/extern/include \
		-I$(JAVA_HOME)/include \
		-I$(JAVA_HOME)/include/$(JAVA_ARCH) \
		-I$(INCLUDE_HOME)
# Note: Finding the correct settings for your compiler can be tricky. 
# The above settings are tested under gcc version 2.95.4 20010319.
# It might help to have a look at the MATLAB C engine compilation 
# options with your operating system. 
# Under MATLAB version 6.5 R13, you can do this with the command:
#   mex -v $(MATLAB_HOME)/bin/engopts.sh

# No changes required below this line.
OBJS      = Engine.o
SOURCES   = MatlabNativeInterface/Engine.c
LIBNAME   = engineJavaMatlab

BASEDIR   = $(PWD)
LIB_HOME  = $(BASEDIR)/lib
OBJ_HOME  = $(BASEDIR)/obj
CLASSES_HOME = $(BASEDIR)/classes
SOURCE_HOME  = $(BASEDIR)/src
INCLUDE_HOME = $(BASEDIR)/include
DOC_HOME     = $(BASEDIR)/javadoc

JNI_CLASSES = MatlabNativeInterface.Engine

all: create compile doc

compile:	lib$(LIBNAME).so

create:
	@echo "Creating directory structure..."
	@mkdir -p $(LIB_HOME)
	@mkdir -p $(OBJ_HOME)
	@mkdir -p $(CLASSES_HOME)
	@mkdir -p $(INCLUDE_HOME)
	@mkdir -p $(DOC_HOME)

# compile the Java source files
execjavac:
	@echo "Compiling Java source files..."	
	@javac -d $(CLASSES_HOME) -sourcepath $(SOURCE_HOME) $(SOURCE_HOME)/*.java

# create the JNI header file
execjavah: execjavac
	@echo "Creating JNI header file..."
	@javah -jni -d $(INCLUDE_HOME) -classpath $(CLASSES_HOME) \
         $(JNI_CLASSES) 

# create the shared library
lib$(LIBNAME).so: execjavah
	@echo "Creating shared library using C compiler..."
	@$(COMPILER) $(COMPILER_ARGUMENTS)

# create HTML documentation
doc:
	@echo "Generating Java documentation..."
	@javadoc -quiet -classpath $(SOURCE_HOME) -author -version -d $(DOC_HOME) \
						MatlabNativeInterface -footer \
						"<a href=\"http://www.mathematik.uni-stuttgart.de/ians/nmh\" target=\"_top\">IANS, University of Stuttgart</a>"
	@echo "Done!"

clean:
	@echo "Cleaning up..."
	@rm -rf $(LIB_HOME)
	@rm -rf $(OBJ_HOME)
	@rm -rf $(CLASSES_HOME)
	@rm -rf $(INCLUDE_HOME)
	@rm -rf $(DOC_HOME)
