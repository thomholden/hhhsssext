function [nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hu_x,Hu_y]=coordinates(Am)
%function [nVI,nDHpxpy,n2MI,nVIx,nVIy,nDHpx,nDHpy,Hu_x,Hu_y]=coordinates(C)
%
% Returns values for the entropies in a cell array of matrices 
% [C] NORMALISED by the maximum entropies of the marginals [Hu_x + Hu_y]
% - for nVI, nDHpxpy and n2MI, the normalizing constant is log(n)+log(p). 
% - for nVIx, nDHpx, the normalizing constant is log(n)
% - for nVIy, nDHpy, the normalizing constant is log(p)
%
%
% Authors: JMGC, FVA

% FVA: documented briefly. Changed labels in triangle.
% FVA 25/10/2012. Moved entropic_triangle into double/coordinates, using
% double/entropies.
error(nargchk(1,1,nargin));

M = length(Am);
%%% Numbers related to entropy
nVI=zeros(M,1);
nDHpxpy=zeros(M,1);
nVIx=zeros(M,1);
nDHpx=zeros(M,1);
nVIy=zeros(M,1);
nDHpy=zeros(M,1);
n2MI=zeros(M,1);
Hu_x = zeros(M,1);
Hu_y = zeros(M,1);
for i=1:M
    [nVI(i),nDHpxpy(i),n2MI(i),nVIx(i),nVIy(i),nDHpx(i),nDHpy(i),Hu_x(i),Hu_y(i)]=coordinates(Am{i});%NORMALISED!
end
return
% 
% if (iscell(Am))
%     [n p] = cellfun(@size, Am);%Dimensions of experiment
%     Hu_x = log2(n);
%     Hu_y = log2(p);
%     Hu_xy=Hu_x + Hu_y;
%     %N = cellfun(@(c) sum(sum(c)),Am);%%number of training instances in experiment
% 
%     [H_Pxy, Hp_x,Hp_y, MI, I_Pxy, I_Px, I_Py, MI_Pxy]=entropies(Am);
%     DHpx = Hu_x - Hp_x;
%     DHpy = Hu_y - Hp_y;
%     DHpxpy = DHpx + DHpy;
%     VIx = H_Pxy - Hp_y;%=Hp_u - MI;
%     VIy = H_Pxy - Hp_x;%=Hp_y - MI;
%     VI = nVIy + NVIx;
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
% 
% % terplot;
% % % terlabel('$\emph{H}_{P_{X|Y}}, \emph{H}_{P_{Y|X}}$',...
% % %     '$\Delta \emph{{H}}_{P_X},\Delta \emph{{H}}_{P_Y}$',...
% % %     '$\emph{{MI}}_{P_{XY}}$');
% % % terlabel('$${H}_{P_{X|Y}}, {H}_{P_{Y|X}}$$',...
% % %     '$$\Delta \emph{{H}}_{P_X},\Delta \emph{{H}}_{P_Y}$$',...
% % %     '$$\emph{{MI}}_{P_{XY}}$$');
% % terlabel('H_{P_{X | Y}}/ H_{P_{Y | X}}', '\Delta_{P_X}/ \Delta_{P_Y}', 'MI_{P_{XY}}');
% % %terlabel('VI','\Delta H','2·MI')
% % ternaryc(nVI,nDHpxpy,n2MI);

