BASEDIR   = $(PWD)
CLASSES_HOME = $(BASEDIR)/classes
DOC_HOME = $(BASEDIR)/javadoc
SRC_HOME = $(BASEDIR)/src

all: create compile doc

create:
	@echo "Creating directory structure..."
	@mkdir -p $(CLASSES_HOME)
	@mkdir -p $(CLASSES_HOME)/MatlabRuntimeInterface
	@mkdir -p $(DOC_HOME)

compile:
	@echo "Compiling Java source files..."
	@javac -d $(CLASSES_HOME) -sourcepath $(SRC_HOME) $(SRC_HOME)/*.java 

doc:
	@echo "Generating Java documentation..."
	@javadoc -quiet -classpath $(SRC_HOME) -author -version -d $(DOC_HOME) \
						MatlabRuntimeInterface -footer \
						"<a href=\"http://www.mathematik.uni-stuttgart.de/ians/nmh\" target=\"_top\">IANS, University of Stuttgart</a>"
	@echo "Done!"

clean:
	@echo "Cleaning up..."
	@rm -rf $(CLASSES_HOME)
	@rm -rf $(DOC_HOME)
