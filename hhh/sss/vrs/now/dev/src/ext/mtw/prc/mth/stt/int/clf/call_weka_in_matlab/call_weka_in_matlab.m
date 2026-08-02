
% make sure the 'weka.jar' file is included in your Matlab's file 
% 'classpath.txt'.
% see: 
% http://math.carleton.ca/old/help/matlab/MathWorks_R13Doc/techdoc/matlab_external/ch_java4.html#30188
% 
% in my computer, the file /opt/matlab/toolbox/local/classpath.txt
% containing this line "/home/haxu/program/weka-3-5-7/weka.jar"


file = java.io.File('./wdbc.arff');  % create a Java File object (arff file is just a text file)
loader = weka.core.converters.ArffLoader;  % create an ArffLoader object
loader.setFile(file);  % using ArffLoader to load data in file wdbc.arff
insts = loader.getDataSet; % get an Instances object
insts.setClassIndex(1);  % set Instances' class index
eval = weka.classifiers.Evaluation(insts);  % create an Evaluation object
svm = weka.classifiers.functions.SMO  % create SMO object (SVM in WEKA)
eval.crossValidateModel(svm, insts, 10, java.util.Random); % apply 10-fold cross-validation


methods(eval)  % this is useful to display methods in Evaluation class

% following is just calling methods in Evaluation object to get the
% classification result
eval.toSummaryString
eval.errorRate
eval.falsePositiveRate(0)
eval.falsePositiveRate(1)

% NOTE:
%
% 1. How to call Java program in Matlab can be found here:
%    http://math.carleton.ca/old/help/matlab/MathWorks_R13Doc/techdoc/matlab_external/ch_java.html
%
% 2. The description of wdbc dataset can be found here:
%    http://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)
%
% 3. WEKA API documentation can be found here:
%    http://weka.sourceforge.net/doc/
