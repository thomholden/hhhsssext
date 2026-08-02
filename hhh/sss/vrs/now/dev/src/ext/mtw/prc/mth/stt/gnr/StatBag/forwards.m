function [vars] = forwards (x,t,p)

% function [vars] = forwards (x,t,p)
% Forwards selection of variables
% x	Input data
% t	Target data
% p	Stop including extra variables at this p-value
% vars  Indexes columns of x which are useful features
%
%
% This function uses various shell scripts and C-code.
% For it to work, the following commands must be on your 
% unix PATH: 
%
% fwd-linear
% make-col-ones
% abut
% forward
% nrows
% tab-to-space
% format_result
% check_result
%
% You may therefore need to edit the
% unix PATH variable in your .login file to include the
% directory where the routines are located.
% This will be the directory in which you have installed the 
% STATBAG package - unless you've moved them elsewhere.


n0=size(x,1);

% Add a column of 1s to the data
xy=[ones(n0,1),x,t];

save data_tmp xy -ascii

%fwd-linear data data 0.05

fid=fopen('matcmd','w');
fprintf(fid,'fwd-linear data_tmp data_tmp %1.4f 1 > result_tmp',p);
fclose(fid);
!chmod a+x matcmd
!matcmd

% Have a look at results
% !cat result_tmp

fid=fopen('matcmd','w');
fprintf(fid,'format_result < result_tmp > vars_tmp');
fclose(fid);
!chmod a+x matcmd
!matcmd

fid=fopen('matcmd','w');
fprintf(fid,'check_result');
fclose(fid);
!chmod a+x matcmd
!matcmd


load vars_tmp 
vars=vars_tmp(:,2);
w=vars_tmp(:,3);
v=length(vars);
if v==1
	vars=0;
else
	vars=vars(2:v);
	!rm vars_tmp
end

!rm data_tmp
!rm result_tmp
!rm matcmd


