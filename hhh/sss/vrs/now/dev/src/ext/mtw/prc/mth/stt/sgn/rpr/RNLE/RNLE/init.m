function init()

% Generate and add path.
p=regexprep(mfilename('fullpath'),mfilename(),'');
addpath(genpath(p))

% Compile functions.
mex([p,'util',filesep(),'choldiff.c'],'-outdir',[p,'util'])
mex([p,'util',filesep(),'lincomb.c'],'-outdir',[p,'util'])

end