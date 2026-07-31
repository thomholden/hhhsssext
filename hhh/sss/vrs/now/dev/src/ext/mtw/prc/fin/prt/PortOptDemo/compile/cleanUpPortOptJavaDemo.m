function cleanUpPortOptJavaDemo
% Cleans all output files from compilePortOptJavaDemo.m and reduces the
% demo back to the original .m and java files.


params = getPortOptJavaDemoSettings;

%delete the output directory for the mcc command 
if(exist(params.MLOutputRoot, 'dir') == 7)
    rmdir(params.MLOutputRoot, 's');
end

%delete the output directory for the javac command
if(exist(params.compiledJavaPath, 'dir') ==7)
    rmdir(params.compiledJavaPath, 's');
end

%delete the output directory for the jar
if(exist(params.FinalOutputRoot, 'dir') ==7)
    rmdir(params.FinalOutputRoot, 's');
end
