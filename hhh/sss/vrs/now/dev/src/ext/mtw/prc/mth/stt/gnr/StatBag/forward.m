function [vars] = forward (c0,c1,p)

% function [vars] = forward (c0,c1,p)
% Linear discriminant with forwards selection of variables
% c0	Class0
% c1 	Class1
% p	Stop including extra variables at this p-value
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

n0=size(c0,1);
n1=size(c1,1);
% 0,1 targets
t=[zeros(n0,1); ones(n1,1)];
x=[c0;c1];

vars=forwards(x,t,p);

