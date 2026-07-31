function varargout= rdfread(varargin)
%RDFREAD Robust Data Rile Reading (import) utility  M Boldin  October 2004 (v1.1)
%
%   DATA = RDFREAD(FILENAME) Built for comma-delimitted (csv) datafile importing.
%       Will also read tab-delimitted files. Not recommended for space-separated cases.  
%
%       Data may have missing values and character values mixed in the numeric 
%          data columns.  All non-numerics in data lines are changed to NaN.
%          This function will not properly read columns that are entirely characters.
%
%       If the firstline has no numerics, it is assumed to be a header line 
%          with variable names.  In this case a structure class is created
%          with the fields name.varnames & name.data. If there is no
%          headerline, a simple data matrix is created.
%
%       If there is no output argument (nargout=0), the results are put into 
%         base memory using filename as name.
%
%       examples       
%         RDFREAD -- no input args, uses GUI file selection (uigetfiles)
%         RDFREAD(1) -- command line version
%         RDFREAD('file_name','C:\data_path\') -- works (path is optional)
%         xdat= RDFREAD('file_name')  -- results placed in xdat 
%
%        Below is an example of a messy data file that this utilty fucntion can read.
%
%          SECID,DATE,PRC,X1
%          10001,19970131,8.625,1
%          10002,1997215,13,
%          10003,,-15,4
%          1099a,o.0,.T,NaN
%          xd,,.,1.111
%          999,2,3,6
%
%       In this case, the RDFREAD 'data' results are  
%
%        10001     19970131        8.625            1
%        10002      1997215           13          NaN
%        10003          NaN          -15            4
%          NaN          NaN          NaN          NaN
%          NaN          NaN          NaN        1.111
%          999            2            3            6
%
%       and filename.varnames= 
%
%       'SECID'    'DATE'    'PRC'    'X1'
%
%       Note that this function is considerably slower than i/o routines 
%       such as LOAD and DLMREAD because it reads and parses one line
%       at a time, but it works in a much more robust manner as long as you
%       do not need to read in 'character' columns.


%Extra paramters/switches, all set at defaults, but can be changed
outname=''; 
read_lines_limit=10E12;
skip_lines=0;
missing_value=NaN;
blockn=1E4;
make_structure=0;  %use =1 for always structure output, =-1 for never
%Lines with '***' comment flags show where these are used;
%   except missing_value which is used in numerous places;

%check output options;
if(nargout>1);
   error('Too many output arguments, 0 or 1 allowed');
end;

%Setting file selection method parameters;
if(nargin==0);
   path=[];
   fname=[];
   arg1=0;
elseif(varargin{1}==1); 
   arg1=1;
else; 
   fname=varargin{1};
   arg1=-1;
end;
if(nargin>1)
    path=varargin{2}; 
else;
    path=[];
end;

 disp 'Running RDFREAD data file reading utility';
if(arg1==0);
    % GUI method to select file;
    [fname, path] = uigetfile( ...
        { ...
            '*.txt;*.csv;*.dat', 'ASCII Test Data Files'; ...
            '*.*','All Files (*.*)' ...
        },'Pick a file to load/read');
elseif(arg1==1);
    % Command line method -- select file;
    fname=input('Input file name (ex. datafile.txt): ','s');
end;

%Open file and check to see it exists
fullname=[path fname];
[fid, message] = fopen(fullname,'r');
if isempty(fid) || (fid < 0)
    error(['File: ', fname, ' not found (in the MATLAB Path).']);
else,  disp(['Opening file: ', fname])  
end

[fn1 fn2]=strtok(fname,'.');
fext=strrep(fn2,'.','');

%set outname name;
if strcmp(outname,'');    %***;
   outname=fn1;  
end;    

fline='';
fline1=fgetl(fid);

%optional skip lines case
if skip_lines > 0;   %***;
  disp(['Skipping ' num2str(skip_lines) ' lines']);
  for ii=2:skip_lines;
    fline1=fgetl(fid);
  end;
end;  

disp 'First line:';
disp(fline1);

hcomma=strfind(fline1,',');
ss1=strread(fline1,'%s',-1,'delimiter','\t')';
htab=size(ss1,2);

if ~isempty(hcomma), 
    disp 'Comma delimitted will be assumed';
    dlm=',';
    [r n] = size(strfind(fline1,dlm));
    nv=n+1;
elseif htab > 1 
    disp 'Tab delimitted will be assumed';
    dlm='\t';
    nv=htab;
else;
    dlm=' ';
    disp 'WARNING Comma or Tab delimitted datafiles read best, but space-separated assumed';
    [r n] = size(strfind(fline1,dlm));
    nv=n+1;
end;
disp(['Number of data columns: '  num2str(nv)]);

%Count number of numerics in first line;
nv1=0;  
ss1=strread(fline1,'%s',nv,'delimiter',dlm);
for jj=1:nv;
    %vnames(jj)= ( ss1(jj) );
    try;
        x1=str2num(char(ss1(jj)));
    catch;
        x1=[];
    end;
    if isnumeric(x1) && ~isempty(x1);  nv1=nv1+1;  end;
    %increments one if item jj is numeric;
end;

%Determine if variable names in header line
if(nv1==0);
    disp 'First line assumed to be header with variable names';
    disp '    and will be skipped for data read';
    header=1;  
else;
    disp 'First line assumed to be data, not variable names';
    header=0;  
end;

if(header==1);
   fline=fgetl(fid);
   else, fline=fline1;
end;

%Initialize xdat matrix and values for data reading loop;
jjblockn=blockn;
xdat(1:jjblockn,1:nv)= missing_value;
xcheck=0;  jj=0;  keep_reading=1;

%Loop to read data lines
while(keep_reading);
    jj=jj+1;

    %Go through each data file line-- fline is assumed to be read before loop starts
    %disp(fline); %*** uncomment to display each data file line;
    
    try;
        xcheck=0;
        xx=strread(fline,'%f',nv,'delimiter',dlm,'emptyvalue',missing_value);  
    catch;
        xx=[];
        xcheck=1;
        %disp(['Problem with line: ' num2str(jj)]);
    end;
    
[rnv jc]=size(xx);
if(rnv < nv), xcheck=1; end;
    
    if(~isempty(xx) || xcheck==0);
        if(prod(size(xx))==nv-1), xx=[xx; missing_value]; end; 
        xdat(jj,:)=xx';
    else;
        %disp('Reading for str2num(ber) by column');
        xx=strread(fline,'%s',nv,'delimiter',dlm,'emptyvalue',missing_value);        
        for cc=1:nv
            try
                xxcc=str2num(char(xx(cc)));
                if ~isempty(xxcc);
                    xdat(jj,cc)=xxcc;
                else;
                    xdat(jj,cc)=missing_value;
                end;                       
            catch
                xdat(jj,cc)=missing_value;
            end;
        end;
    end;
   
    fline=fgetl(fid); %*** fline used at top of loop
    
    %Check to see if data ends or loop continue
    if(fline==-1);  
        disp('Reached end of file');
        keep_reading=0;  
        break;  
    elseif(jj >= read_lines_limit);  %***;
        disp(['*** Reached limit to rows allowed: ' num2str(jj)]);
        break;
    elseif jj== jjblockn;
       %*** Rows added to xdat block to improve the loop speed 
       xdat(jjblockn+1:jjblockn+blockn,1:nv)= missing_value;
       jjblockn=jjblockn+blockn;
       %[rows columns]=size(xdat);
       %disp(['At row ' num2str(jj) ' Rows in xdat ' num2str(rows)]);
    end;
    
    
end;

xdat=xdat(1:jj,:);
[rows columns]=size(xdat);
disp(['Number of rows sucessfully read: ' num2str(rows)]);
disp(['Number of columns in data: ' num2str(columns)]);


%*** Output steps;

if (make_structure==1) || ( (make_structure==0) && (header==1) );  %***;
    xdat=struct('data',xdat);
    if (header==1);
      xdat.varnames=cellstr(char(ss1))';
    end;  
    disp('Creating structure with varnames and data fields');  
elseif (make_structure==-1) || (header==0);
    disp('Results placed in data matrix');  
end;

if nargout==0;  %***
    %Place results into base memory
    assignin('base',outname,xdat);
    disp(['See ' outname]);
elseif nargout==1;
   %Use varargout
    varargout{1}=xdat;
end;

disp('***Done***');

