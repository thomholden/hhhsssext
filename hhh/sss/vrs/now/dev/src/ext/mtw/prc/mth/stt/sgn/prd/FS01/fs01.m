function Xt_plus_1=fs01(Xt,w);
%The local linear approximation method of the first order to predict a chaotic time series, after Farmer and Sidorowich,1987
%modified with help of constrained linear least square problem solved by
%lsqlin.
%This algorithm was tested to predict the difference between decadal
%average sunspot number, which is mostly a sunspot number derived from tree ring radiocarbon content by Solanki, S. K., Usoskin, I. G., Kromer, B., Sch?ssler, M. and Beer, J.: 2004, Nature, 431, 1084., continued by group sunspot number by Hoyt, D. V. and Schatten, K. H.: 1996, Solar Phys., 165, 181.
%Volobuev, D.M., Makarenko, N.G. FORECAST OF THE DECADAL AVERAGE SUNSPOT NUMBER. Submitted to Solar Physics,2007.

%Algorithm consists of 3 parts:
%Step 1: to reconstruct the structure space with ts1
%Step 2: to find the lorenz analogs (nearest neighbors) in the reconstructed space
%Step 3: lsqlin

%Input
%Xt - time series (learn set), please remove trend, remove
%average and normalize it by its sigma before use. Time step
%is also assumed to be equal.
%w- dimension= the length of the analog
%
%Output
% Xt_plus_1 -  Xt(end+1) - a predicted point


%1- reconstructing of the structure space with ts1
xr=ts1(Xt,w);
xs0=xr(end,:);c=[];c0=[];%this is the analog to be compared and predicted
%__________________________________________________
%2 - finding of nearest analogs
for j=1:w
    c1=((xr(1:end-1,j)-xs0(j))).^2;%calculates squared distances,
    c=[c c1];%collects the matrix of squared distances
end
cmetr=c';%this matrix contains also metric information
[o,ini]=sort((mean(cmetr)));%sorts the squared distances to find min
ini=ini(1:w+1);%w+1 is a minimum number, it works better for the time series of the limited length
A=xr(ini,:);%a matrix of nearest analogs
Xf=xr(ini+1,1);%next point of nearest analogs
%__________________________________________________________________________
%3 -constrained linear least square problem
opt = struct( ...
    'Algorithm','interior-point', ...
    'Diagnostics','off', ...
    'Display','none', ...
    'JacobMult',[], ...
    'LargeScale','on', ...
    'MaxIter',200, ...
    'MaxPCGIter','max(1,floor(numberOfVariables/2))', ...
    'PrecondBandWidth',0, ...
    'TolCon',1e-8, ...
    'TolFun',1e-8, ...
    'TolX', 1e-12, ...
    'TolFunValue',100*eps, ...
    'TolPCG',0.1, ...
    'TypicalX','ones(numberOfVariables,1)' ...
    );
[g,rn,res] = lsqlin(A,Xf,[],[],[],[],-1*ones(1,w),1*ones(1,w),[],opt);%optimizes the local linear model
% G=[G g];
Xt_plus_1=xr(end,:)*g;%continuation of the most recent analog with optimum linear model
if abs(Xt_plus_1)>2
    Xt_plus_1=mean(Xf);%returns to 0-order approximation if any 2*sigma outlier
end