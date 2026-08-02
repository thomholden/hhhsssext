function runParallelWeka
% This function runs multiple executions of a Weka machine learning algorithm
% in parallel across distributed computers.  Each execution is run on the
% same data but with different algorithm parameters, each execution as a 
% separate job.
% 
% The function returns as soon as jobs have been scheduled (asynchronous). 
% The result of each job, a classification model, is stored in a cell array, 
% and upon completion of all jobs, the models are saved to file on the local 
% machine.
%
% Before running, set variable "config" at the top of the code to the name
% of a defined job manager. (To define a job manager see "Configuring Parallel 
% Processing.txt".)  The name cannot be "local" as the local scheduler uses 
% jobs of type simplejob that do not support a job timeout parameter.
%
% Subfunctions: 
% * jobRun is the function that is executed within each job.
% * jobFinished is invoked upon completion of each job.
%
% This file and containing folder must reside at the same path on all 
% machines over which processing is distributed.
%
% Author: Jaspar Cahill, jjcahill@gmail.com. 30 Sept 2011.


% settings
config = 'localcores'; % <<< replace this with the name of defined job manager
cVals = [Inf 100 10 5 1 0.5 0.05];
timeoutMins = 2;
resultsFile = 'results.dat';
wekaJarFile = 'weka.jar';

% load dataset  
dat=dataset('XLSFile','dataset.xls', 'ReadVarNames', false); 
dat.Properties.Description = 'mydataset';

[pathstr, name, ext] = fileparts( mfilename('fullpath'));
javaaddpath([pathstr filesep wekaJarFile]);

JM=findResource('scheduler','configuration',config);
if ~isempty(JM.Jobs)
    destroy(JM.Jobs);  
end
finishedCount = 0;
models = {};
J = {};  % list of created jobs

% create and submit jobs to scheduler
for i=1:length(cVals)
    J{i} = createJob(JM, 'PathDependencies', getNonMatlabPaths(),... 
        'FinishedFcn', @jobFinished, 'Timeout', 60*timeoutMins);
    userdata.i = i; % job number
    set(J{i}, 'userdata', userdata);
    T = createTask(J{i}, @jobRun, 1, { dat cVals(i) }); 
    submit(J{i});
end

%---------------------------------------------------------------
function retVal = jobRun(dat,cVal) 
    % This function is the function that is executed within each job.  The 
    % SVM algorithm in Weka is applied to the supplied data using the 
    % specified C value.  Returned is the generated SVM model.
    % 
    % Weka performance evaluation code is unused. It can be uncommented, 
    % however, without a means of dealing with the variable length parameter
    % in method evaluateModel(..), the following java method may be
    % used instead, inserted into weka.classifiers.Evaluation:
    %
    %  public double[] evaluateModel1(Classifier classifier,
    %      Instances data)throws Exception {
    % 
    %	  return evaluateModel(  classifier,
    %            data);
    %   }
    
    % inform worker of the location of the Weka library.                 
    javaaddpath([pathstr filesep wekaJarFile]);
    
    % convert dataset to Weka format (class Instances).        
    train = datasetToWeka(dat);
    test = datasetToWeka(dat);
    
    % use Weka to train classifier
    c = weka.classifiers.functions.SMO();     
    c.setC(cVal);
    k = weka.classifiers.functions.supportVector.PolyKernel();
    %k = weka.classifiers.functions.supportVector.RBFKernel();
    k.setExponent(2);
    c.setKernel(k);  
    c.buildClassifier(train);
    
    % evaluate model (simple evaluation over training set)
    %{
    ev = weka.classifiers.Evaluation(test);
    ev.evaluateModel1(c, test);
    f = ev.fMeasure(1);
    tp = ev.truePositiveRate(1);
    fp = ev.falsePositiveRate(1);
    %}
    retVal = c;      
end

%---------------------------------------------------------------
function jobFinished(job, event)
    % This function is called at the completion of a job.  It prints some
    % job information to the command window: description, finish status
    % (ok, error, empty result, timeout), and elapsed execution time.
    % The returned result of the job is saved to the cell array "models".
    % If this is the last job to finish, "models" is saved to file on
    % the local machine.
    
    u = get(job, 'userdata');
    s=sprintf('JOB FINISHED: %s cval: %d', dat.Properties.Description, cVals(u.i));
    disp(s);
    iserror = get(job.Tasks(1), 'errormessage');           
    if isempty(iserror)          
        v = getAllOutputArguments(job);                     
        if isempty(v{1})
            disp('EMPTY RESULT RETURNED');
        end
        models{u.i} = v{1};  
    else        
        disp('ERROR OR TIMEOUT: '); disp(dat.Properties.Description);
        disp(job.Tasks(1).ErrorMessage);     
        models{u.i}= NaN;  
    end
    s=datenum(job.StartTime,'ddd mmm dd HH:MM:SS zzz yyyy');
    e=datenum(job.FinishTime,'ddd mmm dd HH:MM:SS zzz yyyy');    
    secs = (e-s) * 24 * 60 * 60;
    [h m s]=sec2hms(secs);   
    s=sprintf('%.2f:%.2f:%.2f', h, m, s);
    disp(s);
    disp('');
    destroy(job);
    finishedCount = finishedCount+1;
    if finishedCount >= length(J)  
      results.data = dat;
      results.models = models;
      save([pathstr filesep resultsFile], 'results');
    end 
end


end