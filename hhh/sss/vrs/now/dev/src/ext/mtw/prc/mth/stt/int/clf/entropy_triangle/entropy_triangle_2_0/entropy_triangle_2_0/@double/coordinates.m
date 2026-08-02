function [nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hu_x,Hu_y]=coordinates(Am)
%function [nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hu_x,Hu_y]=coordinates(C)
%
% Returns values for the entropies related to n x p matrix
% [C] NORMALISED by the maximum entropies of the marginals [Hu_x + Hu_y]
% - for nVI, nDHpxpy and n2MI, the normalizing constant is log(n)+log(p). 
% - for nVIx, nDHpx, the normalizing constant is log(n)
% - for nVIy, nDHpy, the normalizing constant is log(p)
%
% And plots all those values in a split entropy ternary plot!!
%
% Authors: JMGC, FVA

% FVA: documented briefly. Changed labels in triangle.
% FVA 25/10/2012. Moved entropic_triangle into coordinates, using
% double/entropies.
error(nargchk(1,1,nargin));

%if (iscell(Am))
    [M P K] = size(Am);%Dimensions of experiment
    N=sum(sum(Am));
    if (K==1)%single matrix
        A=Am./N;%Normalize into a joint distribution
    else
        A = zeros([M P K]);
        for k = 1:K
            A(:,:,k) =Am(:,:,k)./N(:,:,k);
        end
    end

    %[H_Pxy, Hp_x,Hp_y, MI, I_Pxy, I_Px, I_Py, MI_Pxy]=entropies(A);
    [H_Pxy, Hp_x,Hp_y, MI]=entropies(A);

    Hu_x = log2(M);
    Hu_y = log2(P);
    Hu_xy=Hu_x + Hu_y;
    %N = cellfun(@(c) sum(sum(c)),Am);%%number of training instances in experiment

    DHpx = Hu_x - Hp_x;
    DHpy = Hu_y - Hp_y;
    DHpxpy = DHpx + DHpy;
    VIx = H_Pxy - Hp_y;%=Hp_u - MI;
    VIy = H_Pxy - Hp_x;%=Hp_y - MI;
    VI = VIy + VIx;

    %Hu_xy=DHpxpy+2*MI+VI
    %All quantities are normalized
    nDHpxpy=DHpxpy/Hu_xy;
    nDHpx=DHpx/Hu_x;
    nDHpy=DHpy/Hu_y;
    n2MI=2*MI/Hu_xy;
    nVI=VI/Hu_xy;
    nVIx=VIx/Hu_x;
    nVIy=VIy/Hu_y;
%     
% else
%     [n,p]=size(A);
%     N=sum(sum(Am));
%     A=Am./N;%Normalize into a joint distribution
%     
%     Px=sum(A,2);
%     Py=sum(A);
%     Qxy=Px*Py;
%     
%     Px_y=A./repmat(Py,n,1);
%     Py_x=A./repmat(Px,1,p);
%     
%     MI=0;
%     Hx_y=0;
%     Hy_x=0;
%     Hpxpy=0;
%     Hxy=0;
%     for x=1:n
%         for y=1:p
%             if (A(x,y)>0)
%                 MI=MI+A(x,y)*log2(A(x,y)/(Px(x)*Py(y)));
%                 Hxy=Hxy-A(x,y).*log2(A(x,y));
%                 Hx_y=Hx_y+A(x,y)*log2(Py(y)/A(x,y));
%                 Hy_x=Hy_x+A(x,y)*log2(Px(x)/A(x,y));
%             end
%             if (Qxy(x,y)>0)
%                 Hpxpy=Hpxpy-Qxy(x,y).*log2(Qxy(x,y));
%             end
%             
%         end
%     end
%     
%     Hu_x=log2(n);
%     Hu_y=log2(p);
%     %Hu_xy=log2(n)+log2(p);
%     Hu_xy=Hu_x + Hu_y;
%     [I_Px,Hpx] = information(Px);
%     [I_Py,Hpy] = information(Py);
%     DHpxpy=Hu_xy-Hpxpy;
%     DHpx=Hu_x-Hpx;
%     DHpy=Hu_y-Hpy;
%     
%     VI=Hx_y+Hy_x;
%     VI=Hxy-MI;
%     VIx=Hpx-MI;
%     VIy=Hpy-MI;
%     
%     %Hu_xy=DHpxpy+2*MI+VI
%     %All quantities are normalized
%     nDHpxpy=DHpxpy/Hu_xy;
%     nDHpx=DHpx/Hu_x;
%     nDHpy=DHpy/Hu_y;
%     n2MI=2*MI/Hu_xy;
%     nVI=VI/Hu_xy;
%     nVIx=VIx/Hu_x;
%     nVIy=VIy/Hu_y;
%     
% end
return
