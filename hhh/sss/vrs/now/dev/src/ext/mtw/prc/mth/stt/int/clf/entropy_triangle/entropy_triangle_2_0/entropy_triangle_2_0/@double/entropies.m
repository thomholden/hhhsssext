function [H_Pxy, H_Px,H_Py, EMI_Pxy, I_Pxy, I_Px, I_Py, M_Pxy]=entropies(Pxy)
%  [H_Pxy, H_Px,H_Py, EMI_Pxy, I_Pxy, I_Px, I_Py, MI_Pxy,h]=entropies(Pxy)
%
% A function to calculate and explore all possible entropies from a bivariate
% probability distribution. If Pxy is a cell array or num arrays, then the  
% outputs are also arrays with as many entries as Pxy
% 
% It obtains only:
% - the self information of X (I_Px) and Y (I_Py), and their averages, the
% marginal entropies (H_Px and H_Py).
% - the joint information distribution (I_Pxy) and its average, their 
% (expected joint) entropy (H_Pxy),
% - their pointwise mutual information (MI_Pxy) and  the
% (expected) mutual information (EMI_Pxy) 
%
%
% To calculate only the entropies and Mutual Information, do:
%  [H_Pxy, H_Px,H_Py, EMI_Pxy]=entropies(Pxy)
%
% NOTE: the relation between entropies is used to calculate the mutual
% information distribution MI_Pxy and its expectation EMI_Pxy
%
% Authors: FVA; CPM, 2009-2014

error(nargchk(1,1,nargin));

%% Obtain the entropies
if nargout > 0
    [I_Pxy,H_Pxy] = information(Pxy);
end
if nargout > 1
    if iscell(Pxy)
        Px = cellfun(@(P) sum(P,2), Pxy);
    else
        Px = sum(Pxy,2);%Column density
    end
    [I_Px,H_Px] = information(Px);
    if nargout > 2
        if iscell(Pxy)
            Py = cellfun(@sum, Pxy);
        else
            Py = sum(Pxy);%Row density
        end
        [I_Py,H_Py] = information(Py);
    end
end

%% obtain the mutual information
% the expected mutual information is obtained through the formula:
% M_Pxy = I_Px + I_Py -  I_Pxy
if nargout > 3
    EMI_Pxy = H_Px + H_Py - H_Pxy;%On average. These are arrays
    if nargout > 7
        if iscell(Pxy)
            M_Pxy=cell(1,n);
        else
            [n,p] = size(Pxy);
            M_Pxy  = repmat(I_Px,1,p) + repmat(I_Py,n,1) - I_Pxy;%Definition formula
            %FVA 2/12/2013: The following doesn't seem to be justified at all!
%             bPxy = ~logical(Pxy);%zero pattern
%             bPx = ~logical(Px);%zero pattern in Px
%             bPy = ~logical(Py);%zero pattern in Py
%             M_Pxy(bPxy) = Inf;%on places with Px=Py=0, we have infs:
%             M_Pxy(xor(bPx',bPy)) = 0;%onplaces with only one zero, we have zero.
        end
    end
end
return
