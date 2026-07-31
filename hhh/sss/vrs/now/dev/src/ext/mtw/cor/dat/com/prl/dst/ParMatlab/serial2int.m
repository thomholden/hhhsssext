

function [a,ndsa,prec]=serial2int(str,dsa)
%function [a,ndsa,prec]=serial2int(str,dsa)

if ~ischar(str) error('str must be an array of char !'); end

if ~exist('dsa') dsa=1; end

fc=double(str(dsa));

if fc<128

  a=double(fc);
  ndsa=dsa+1;
  prec=1;
  
else
  prec=bitand(fc,112)/16+1;
  le=bitand(fc,15);nle=0;
  if le>7
    nle=le-8;
    le=sum(256.^[nle-1:-1:0]'.*str(dsa+1:dsa+nle));    
  end

  q=zeros(prec,le);
  q(:)=double(str(dsa+nle+1:dsa+nle+prec*le));
  a=sum((256.^[prec-1:-1:0]')*ones(1,le).*q,1)';
  
  ndsa=dsa+nle+prec*le+1;
end
