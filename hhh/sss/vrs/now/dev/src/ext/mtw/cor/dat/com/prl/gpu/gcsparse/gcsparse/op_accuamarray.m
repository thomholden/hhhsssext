function P=op_accuamarray(indx,nmax)
%  P=op_accuamarray(indx[,nmax])
%  returns sparse matrix P
%  so that we can compute 
%  y=acummaray(indx,val,[nmax]);
%  by SPMV:
%  y=P*val;
%
% S. Marchesini, LBNL 2013.

grow=gpuArray(int32(indx));
nnz=numel(indx);
ncol=nnz;
nrow=max(grow(:));
%%
 if nargin>2
     nrow=max(nmax,max(grow(:)));
 end
    
gcol=gpuArray(int32((1:nnz)-1));

% dummy entries of 1, (real and complex)
gval=gpuArray.ones([nnz 1],'single');

P=gcsparse(gcol,grow,gval,nrow,ncol,1);
end