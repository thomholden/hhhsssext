function [muXY,nx_y,my_x,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy)
% function [muXY,nx_y,my_x,nx,my,nmuXY] = perplexities2(n2MI,nVIx,nVIy,nDHpx,nDHpy,Hux,Huy)
%  [n_Px,m_Py, g_MIxy, n_Px_y, m_Py_x, n, m, g_Px, g_Py]=perplexities(Pxy)
% a function to calculate and explore all possible perplexities from a bivariate
% probability distribution, given the entropy values.
% 
% Once you have the entropies, it is more effective to use this primitive
% than using perplexities.m (q.v.)
%
% Authors: FVA, CPM, 2009-2014

error(nargchk(7,7,nargin));

dim = max(size(n2MI));
if (dim==1)
    n = 2^Hux;
    nx_y=2^(nVIx*Hux);
    my_x=2^(nVIy*Huy);
    nx=n/(2^(nDHpx*Hux));
    my=n/(2^(nDHpy*Huy));
    muXY=2^(n2MI*(Hux+Huy)*(1/2));
    nmuXY=muXY/n;
else
    n = 2.^Hux;
    nx_y=2.^(nVIx.*Hux);
    my_x=2.^(nVIy.*Huy);
    nx=n ./(2.^(nDHpx.*Hux));
    my=n ./(2.^(nDHpy.*Huy));
    muXY=2.^(n2MI.*(Hux+Huy)*(1/2));
    nmuXY=muXY ./ n;
end
return