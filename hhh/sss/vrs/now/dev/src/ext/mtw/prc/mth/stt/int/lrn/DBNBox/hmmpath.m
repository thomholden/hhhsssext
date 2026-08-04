global HMMBOX_HOME
HMMBOX_HOME = '/users/irezek/matlab/hmmbox';

files = {'tools','VarParModels','MapParModels','MlParModels','HStateModels','demos'};
 
eval(sprintf('addpath %s', HMMBOX_HOME));
for i=1:length(files)
  f = files{i};
  eval(sprintf('addpath %s/%s -end', HMMBOX_HOME, f));
end

clear f files HMMBOX_HOME i

if isempty(findstr('netlab',path))
    disp(' Warning: HMMBox requires Netlab Routines - Netlab not found in path');
end

