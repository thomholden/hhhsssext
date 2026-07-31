% Post Classification Process
% First a MMU filter is applied and the removed pixels are refilled using a
% majority filter repeatedly.
%
% For the MMU filter, label.m is used. It is written by Damien Garcia in 
% 2010/02, revised 2011/01
% http://www.biomecardio.com
%
% INPUT
% 
% datadir: The folder that disturbance maps are stored.
% 
% algorithm: 1 – CART, 2 – SVM.
% 
% MMU: The size of the MMU in number of pixels. FIA standards specify one
% acre (4047 m2) as the MMU for forestland. Therefore, 5 Landsat pixels
% (4500 m2) should be enough.
% 
% neighbor: Specify whether use 4-connected neighbors (Castle) or
% 8-connected neighbors (Queen). Only 4 or 8 is allowed.
% 
% maxiter: The maximum number of passes allowed for the majority filter. We
% set to 500 normally.
% 
% OUTPUT
% 
% Output files are all in datadir :
% 
% One final stand-alone disturbance map. File ends with “distmappost”. For
% the pixel values, 0 is masked, 1 is persistent forest, while other values
% are the onset years of disturbances. For rapid-onset disturbances, the
% values are onset year + 1000.
% 
% Three separate disturbance maps. “finaltypemap” is the type map, in which
% 0 - unclassified, 1 – persistent, 2 - slow-onset, 3 - rapid-onset.
% “finalslowmap” is the map with the onset years for slow-onset
% disturbances. “finalrapidmap” is the map with the onset years for
% rapid-onset disturbances.
% 
% EXAMPLE
% Module_PostProcess('F:\Data\DistMap\',2, 6, 8, 500);

function Module_PostProcess(datadir, algorithm, MMU, neighbor, maxiter)
% MMU filter
algonames = {'CART', 'SVM'};
algon = char(algonames(algorithm));
[dtype,p,t,xystart,mapinfo,coodsys,index] = ...
    readenvi([datadir algon 'distmap'], false);
dtype = reshape(dtype,[p(1),p(2),p(3)]);
% find connected pixels and output is the number of connected pixels
[~,~,newdtype] = label(dtype, neighbor);
newdtype = reshape(newdtype,[p(1)*p(2),p(3)]);
dtype = reshape(dtype,[p(1)*p(2),p(3)]);
odtype = dtype;
dtype(newdtype(:,1)<=MMU & dtype(:,1)~=0,:)=-1;
clear newdtype;

% Majority Filter to refill the MMU removed gaps

dtype = reshape(dtype,[p(1),p(2),p(3)]);

newdtype = dtype;
for iter = 1:maxiter
    for i = 2:p(1)-1
        for j = 2:p(2)-1
            if dtype(i,j)==-1
                A = reshape(dtype(i-1:i+1,j-1:j+1),9,1);
                temp = mode(A(A(:,1)>0,1));
                if ~isnan(temp)
                    newdtype(i,j) = temp;
                end
            end
        end
    end
    if sum(sum(newdtype(:,:)<0)) == 0
        break;
    end
    % termination flag is when no further changes occur 
    if sum(sum(newdtype(:,:)<0)) == sum(sum(dtype(:,:)<0))
        break;
    end
    dtype = newdtype;
end
newdtype = reshape(newdtype,[p(1)*p(2),p(3)]);
newdtype(newdtype(:,1)==-1,:)=odtype(newdtype(:,1)==-1,:);
bandnames = '{CoverType}';
writeenvi([int16(newdtype)],p,[datadir algon 'distmappost'],xystart,mapinfo,coodsys,bandnames);
bandnames = '{type}';
% Seperate slow-onset and rapid-onset (value with +1000)
dtype = newdtype;
% suppose disturbances occur between 1900 and 2111
dtype(newdtype(:,1)>=1900 & newdtype(:,1)<=2111,:)=2;
% 2900 = 1900 + 1000 (for rapid)
dtype(newdtype(:,1)>=2900,:)=3;
writeenvi([uint8(dtype)],p,[datadir algon 'finaltypemap'],xystart,mapinfo,coodsys,bandnames);
bandnames = '{year of slow-onset disturbance}';
ycd = newdtype;
ycd(newdtype(:,1)<1900 | newdtype(:,1)>2111,:) = 0;
writeenvi([int16(ycd)],p,[datadir algon 'finalslowmap'],xystart,mapinfo,coodsys,bandnames);
bandnames = '{year of rapid-onset disturbance}';
yad = newdtype;
yad(newdtype(:,1)<2900,:) = 0;
yad = yad-1000;
writeenvi([int16(yad)],p,[datadir algon 'finalrapidmap'],xystart,mapinfo,coodsys,bandnames);