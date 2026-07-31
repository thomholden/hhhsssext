% path wanted subdirectories (preceded by '_')

dInfo = dir;
nD = size(dInfo,1);
clear wtdDirs, wtdDirs{nD} = '';
ixD = 0;
for i = 3:nD % skip 1&2, '.' and '..'
    if dInfo(i).isdir && dInfo(i).name(1) == '_'
        ixD = ixD+1;
        wtdDirs{ixD} = dInfo(i).name;
    end
end
subDirs{ixD} = '';
for i = 1:ixD
    subDirs{i} = wtdDirs{i};
end
clear dInfo nD ixD wtdDirs

% add to path
thisDir = pwd;
addpath(thisDir)

for i=1:size(subDirs,2)
    addpath(fullfile(thisDir, subDirs{i}))
end

clear thisDir subDirs i
colordef black
format compact
