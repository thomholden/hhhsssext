function [WSMAshort,WSMAlong]=WSMA(asset,lead,lag,v,T)
%Syntax: [WSMAshort,WSMAlong]=WSMA(asset,lead,lag,v,T)
%_____________________________________________________
%
% WMA/SMA smoothing moving average and chart.
%
% WSMAshort is the leading moving average.
% WSMAlong is the lagging moving average.
% asset is the security data.
% lead is the number of samples to use in leading average calculation.
% lag is the number of samples to use in the lagging average calculation.
% v is the volume factor.
% T is the number of the smoothing iterations.
%
%
% Reference:
% Leontitsis A., Pange J. (2004): WSMA: In-between the weighted and the
% simple moving average. 17th Annual Pan-Hellenic Conference on Statistics,
% Leukada Greece, 15-17 April
%
%
% Note:
% Requires the Financial Toolbox.
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% May 26, 2003.


% The parameters asset, lead, lag, and alpha are checked within the
% function MOVAVG.


if nargin<4 | isempty(v)==1
   v=0.4;
else
   % Hot must be a scalar
   if sum(size(v))>2
      error('v must be a scalar.');
   end
end

if nargin<5 | isempty(lead)==1
   T=3;
else
   % T must be a scalar
   if sum(size(T))>2
      error('T must be a scalar.');
   end
   % T must be an integer
   if round(T)-T~=0
       error('T must be an integer');
   end
   % T must be positive
   if T<=0
       error('T must be positive');
   end
end


GDs=asset;
GDl=asset;

for i=1:T
    
    % The calculation of the short moving average
    MA1short=movavg(GDs,lead,lead+1,1);
    MA2short=movavg(GDs,lead,lead+1,0);
    GDs=MA1short*(1+v)-MA2short*v;
    
    % The calculation of the long moving average
    MA1long=movavg(GDl,lag,lag+1,1);
    MA2long=movavg(GDl,lag,lag+1,0);
    GDl=MA1long*(1+v)-MA2long*v;
    assetlong=GDl;
    
end

GDs=GDs(T*lead:end);
GDl=GDl(T*lag:end);


if nargout==0
    % If there are no output arguments, plot the moving averages 
    r=length(asset);
    rshort=length(GDs);
    rlong=length(GDl);
    plot(1:r,asset,(r-rshort+1:r),GDs,(r-rlong+1:r),GDl)
else
    WSMAshort=GDs;
    WSMAlong=GDl;
end
