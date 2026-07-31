if (~ispc)
    error('Sorry only Win32 currently supported...');
end
disp('Note that only Visual Studio compilers are supported.');

%% Process mexopts.bat
disp('Creating cudamexopts.bat based on mexopts.bat...');
mexopts = [prefdir '/mexopts.bat'];
fid_mex = fopen(mexopts, 'r');
cudamexopts = [prefdir '/cudamexopts.bat'];
fid_cuda_mex = fopen(cudamexopts, 'w');

while (~feof(fid_mex));
    line = fgets(fid_mex);
    line = line(1:end-1);
    if (length(line) > 3 && strcmp(line(1:3), 'set'))
        [start, rest] = strtok(line);
        rest = rest(2:end);
        [name, rest] = strtok(rest, '='); 
        value = rest(2:end-1);

        if (strcmp(name, 'NAME_OBJECT'))
            value = '-o ""';
        end 
        
        if (strcmp(name, 'COMPILER'))
            value = 'nvcc';
        end 
    
        if (strcmp(name, 'COMPFLAGS'))
            value = sprintf('-c -Xcompiler "%s"', value);
        end 
        
        if (strcmp(name, 'OPTIMFLAGS') || strcmp(name, 'DEBUGFLAGS'))
            value = sprintf('-Xcompiler "%s"', value);
        end 
        
        if (strcmp(name, 'LINKFLAGS'))
            value = [value '  cudart.lib'];
        end 
        
        if (strcmp(name, 'LIB'))
            value = [value ';%CUDA_LIB_PATH%;%NVSDKCUDA_ROOT%\common\lib'];
        end
        
        if (strcmp(name, 'INCLUDE'))
            value = [value ';%CUDA_INC_PATH%;%NVSDKCUDA_ROOT%\common\inc'];
        end
        
        line = [start ' ' name '=' value];
     end
     fprintf(fid_cuda_mex, '%s\n', line);
end

fclose(fid_mex);
fclose(fid_cuda_mex);

%% Process mex.pl
disp('Creating cuda_mex.pl based on mex.pl...');
mexpl = [matlabroot '/bin/mex.pl'];
fid_mex = fopen(mexpl, 'r');
cudamexpl = [matlabroot '/bin/cuda_mex.pl'];
fid_cuda_mex = fopen(cudamexpl, 'w');

while (~feof(fid_mex));
    line = fgets(fid_mex);
    if (~isempty(strfind(line, 'mexopts.bat')))
        line = regexprep(line, 'mexopts\.bat', 'cudamexopts.bat');
    end
    if (~isempty(strfind(line, 'COMPILE_EXTENSION')))
        line = regexprep(line, 'cpp', 'cu|cpp');
    end
    fprintf(fid_cuda_mex, '%s', line);
end

fclose(fid_mex);
fclose(fid_cuda_mex);

%% Process mex.m
disp('Creating cuda_mex.m based on mex.m...');
mexm = which('mex');
fid_mex = fopen(mexm, 'r');
cudamexm = 'cuda_mex.m';
fid_cuda_mex = fopen(cudamexm, 'w');

while (~feof(fid_mex));
    line = fgets(fid_mex);
    if (~isempty(strfind(line, 'mex_helper')))
        line = regexprep(line, 'mex_helper', 'cuda_mex_helper');
    end
    fprintf(fid_cuda_mex, '%s', line);
end

fclose(fid_mex);
fclose(fid_cuda_mex);

%% Process mex_helper.m
disp('Creating cuda_mex_helper.m based on mex_helper.m...');
mexm = which('mex_helper');
fid_mex = fopen(mexm, 'r');
cudamexm = 'cuda_mex_helper.m';
fid_cuda_mex = fopen(cudamexm, 'w');

while (~feof(fid_mex));
    line = fgets(fid_mex);
    if (~isempty(strfind(line, 'mex.pl')))
        line = regexprep(line, 'mex\.pl', 'cuda_mex.pl');
    end
    fprintf(fid_cuda_mex, '%s', line);
end

fclose(fid_mex);
fclose(fid_cuda_mex);

%% Final setup
disp('Adding current directory to path...');
addpath(pwd);
savepath;

%% Test
disp('Testing:');
disp('Compiling example.cu...');
cuda_mex example.cu
x = single(rand(10, 1));
y1 = example(x);
y2 = x .^ 2;
if (norm(y1 - y2) < 1e-7)
    report = 'SUCCESS!';
else
    report = 'FAILURE!';
end
disp(sprintf('example.mexw32 vs. MATLAB: norm is %.2e -- %s\n', norm(y1 - y2), report));

