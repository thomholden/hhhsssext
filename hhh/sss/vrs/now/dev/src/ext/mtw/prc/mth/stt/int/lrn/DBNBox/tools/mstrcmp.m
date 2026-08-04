function [mI]=mstrcmp(cellA,cellB);
% mI=mstrcmp(A,B);
% finds matches of A in B; A and B are cell arrays of strings; 
% If A is scalar, function returns an array of the size of B containing a one 
% where A matched B (identical to strcmp); 
% if A and B are cell vectors, the result is a matrix. The i-th rows of this
% matrix corresponds to the matches of the i-th element of  A in cell vector B;
%
if ~iscell(cellA) & ~iscell(cellB)
   error('Input arguments must be cell arrays of strings');
end;

dlB=repmat(cellA(:),1,length(cellB)); 
dlA=repmat(cellB(:)',length(cellA),1); 
[mI]=strcmp(dlB,dlA);