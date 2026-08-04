function [ndata,refval] = normalise(data,type,refval)
% [ndata,refval] = normalise(data,type,refval)
%
%NORMALISE Normalises a data sequence along columns
%       Normalisation type maybe with respect to 
%       - variance/sd     set type to 's' ; makes std(data)=1 
%       - amplitude       set type to 'a' ; makes 0<= data <=1 
%       - sum             set type to 't' ; makes sum(data,1)=1
%
% and with respect to a particular value
%
% default is 's'

if nargin<3
  refval=[];
end

if (nargin<2) 
  type='s'; 
end



switch lower(type)
 case 's'
  [ndata,refval]=unitstd(data,refval);
 case 'a'
  ndata=unitamp(data,refval);
 case 't'
  [ndata,refval]=unitsum(data);
 otherwise
  error('No normalisation type specified');
end;


return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ndata,refval]=unitstd(data,refval);

if isempty(refval),
  refval(1,:)=mean(data);
  refval(2,:)=std(data);
elseif size(refval,1)~=2
  error('Need mean and variance values for each column for normalisation');
end

ndata=data;
ndata=data-repmat(refval(1,:),size(ndata,1),1);
ndata=ndata./repmat(refval(2,:),size(ndata,1),1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ndata=unitamp(data,refval);

data=detrend(data,0);
amin=abs(min(data));
data=amin(ones(size(data,1),1),:)+data;

amax=max(data);
ndata=data./amax(ones(size(data,1),1),:)*refval;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ndata,refval]=unitsum(data,refval);

refval=csum(data);
ndata=cdiv(data,refval);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% column sum
% function Z=csum(X)

function Z=csum(X)

Z=rsum(X')';


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% row sum
% function Z=rsum(X)

function Z=rsum(X)

Z=zeros(size(X(:,1)));

for i=1:length(X(1,:))
  Z=Z+X(:,i);
end


% function Z=cdiv(X,Y)
%
% column division: Z = X / Y column-wise
% Y must have one row 

function Z=cdiv(X,Y)

Z=rdiv(X',Y')';

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function Z=rdiv(X,Y)
%
% row division: Z = X / Y row-wise
% Y must have one column 

function Z=rdiv(X,Y)

if(length(X(:,1)) ~= length(Y(:,1)) | length(Y(1,:)) ~=1)
  disp('Error in RDIV');
  return;
end

Z=zeros(size(X));

for i=1:length(X(1,:))
  Z(:,i)=X(:,i)./Y;
end
