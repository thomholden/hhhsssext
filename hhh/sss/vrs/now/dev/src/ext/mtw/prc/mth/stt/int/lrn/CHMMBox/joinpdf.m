function [Z] = joinpdf(A,B,jdim);
%
% creates a joint conditional pdf with conditioning
% dimensions specified in <dim>
% the output array contains the cathesian product along
% the other dimensions
%

svA=size(A);
svB=size(B);
if ~isequal(svA(jdim),svB(jdim))
   error('Conditioning dimensions must be identical in size')
end;
restdim=setdiff(1:length(svA),jdim);

A=permute(A,[restdim,jdim]);
B=permute(B,[restdim,jdim]);

Ar=reshape(A,prod(svA(restdim)),prod(svA(jdim)));
Br=reshape(B,prod(svB(restdim)),prod(svB(jdim)));

for i=1:size(Ar,2),
   Z(:,:,i)=Ar(:,i)*Br(:,i)';
end;

svZ=size(Z);
Z=reshape(Z,[svZ(1),svZ(2),svA(jdim)]);
