function [gnuradon,gnuiradon,qtXqxy,qxyXqt]=gnufft_init_spmv(Ns,qq,tt,beta,k_r)
% function [gnuradon,gnuiradon,qtXqxy,qxyXqt]=gnufft_init(Ns,q,t,beta,k_r)
% 
% returns radon  and inverse radon trasnform operators (GPU accelerated)
% 
% input: Ns, x-y grid size 
%        q,t (polar coordinates q, theta)
%        beta, kaiser-bessel parameter, 
%        k_r, kernel width
% Output:
%        radon and inverse radon operators, 
%        also gridding and inverse gridding operators
%        cartesian grid <-> non-uniform samples
%
%
% Stefano Marchesini,  LBNL 2013

%%
% Preload the Bessel kernel (real components!)
[kblut,KB,KB1]=KBlut(k_r,beta,512);

scaling=1;
% % Normalization (density compensation factor)

gDq=KBdensity1(qq'.*scaling,tt',KB,k_r,Ns)';
%gDq=gpuArray(1./(abs(qq)+1e-1));

% anti-aliased deapodization factor, (the FT of the kernel, cropped):
dpz=deapodization(Ns,KB);
gdpz=gpuArray(single(dpz));

% polar to cartesian
%[xi,yi]=pol2cart(tt*pi/180,scaling.*qq);
[yi,xi]=pol2cart(tt*pi/180,scaling.*qq);


grid = [Ns,Ns];

xi = xi+floor((Ns+1)/2)+1;
yi = yi+floor((Ns+1)/2)+1;

%
xint=int32(xi);
yint=int32(yi);


% xint=gpuArray(xint);
% yint=gpuArray(yint);
xf=-(xi-double(xint)); %fractional shift
yf=-(yi-double(yint)); %fractional shift

% matrix from non-uniform samples to grid
nrow=prod(grid);
ncol=numel(xi);

% stencil vectors
nkr=2*k_r+1;
kstencil=int32(gpuArray.linspace(-k_r,k_r,nkr));
kkrx=reshape(kstencil,[ 1 1 2*k_r+1 1]);
kkry=reshape(kstencil,[ 1 1 1 2*k_r+1]);

%replicate over -k_r:k_r
xii=int32(bsxfun(@plus,xint,kkrx));
yii=int32(bsxfun(@plus,yint,kkry));
%valii=bsxfun(@times,KB1((-k_r:k_r)),KB((-k_r:k_r),0)');
%
% pre-compute kernel value for every sampe
gval=single(bsxfun(@times,KB1(bsxfun(@plus,xf,double(kkrx))),KB1(bsxfun(@plus,yf,double(kkry)))));

% index of where every point lands  on the image
grow=bsxfun(@plus,(xii-1)*Ns,yii); %index of where every point lands
%index of where every point comes from
gcol=repmat(int32(reshape(1:numel(qq),size(qq))),[ 1 1 nkr nkr]);
%
% remove stencils if they land outside the frame
%ii=find((xii<1) ||( xii>Ns) || (yi<1) || (yi>Ns));
%iin=find((xii>0) & ( xii<Ns+1) & (yi>0) & (yi<Ns+1));
iin=find(bsxfun(@and,(xii>0) & ( xii<=Ns) , (yii>0) & (yii<=Ns)));
if numel(iin)<numel(gval);
 grow=grow(iin);
 gcol=gcol(iin);
 gval=gval(iin);
end
clear iin

%get the array and transpose
P=gcsparse(gcol,grow,complex(gval),nrow,ncol,1);
PT=gcsparse(grow,gcol,complex(gval),ncol,nrow,1);

%%

%grmask=gpuArray(abs(qq)<Ns/6);
% mask out unphysical elements (we assume some padding)
grmask=gpuArray(abs(qq)<size(qq,1)/4*3/2);
 
% (qx,qy) <-> (q, theta) : cartesian grid <-> non-uniform samples
qxyXqt =@(Gqt) reshape(P*(Gqt(:)./gDq(:)),[Ns Ns]);
% qxyXqt =@(Gqt) reshape(P*(Gqt(:)),[Ns Ns]);
qtXqxy=@(Gqxy) reshape(PT*Gqxy(:),size(qq));
% (qx,qy) <-> (x, y) : 2D 
qxyXrxy=@(Grxy) ifftshift(fft2(fftshift(Grxy.*gdpz)));%deapodized
rxyXqxy=@(Gqxy) ifftshift(ifft2(fftshift((Gqxy)))).*gdpz; %deapodized

% (r,theta) <-> (q,theta) :  radon <-> Fourier slice
rtXqt=@(Gqt) ifftshift(ifft(fftshift(Gqt,1)),1).*grmask;
qtXrt=@(Grt) ifftshift( fft(fftshift(Grt,1)),1);

% radon transform: (x y) to (qx qy) to (q theta) to (r theta):
gnuradon=@(G) rtXqt(qtXqxy(qxyXrxy(G)));
% inverse radon transform: (r theta) to (q theta) to (qx qy) to (x y)
gnuiradon=@(GI) rxyXqxy(qxyXqt(qtXrt(GI)));
 
return
end
function [kblut, KB, KB1D]=KBlut(k_r,beta,nlut)
% lookup table
kk=linspace(0,k_r,nlut);
kblut = KB2( kk, 2*k_r, beta);
scale = (nlut-1)/k_r;

kbcrop=@(x) (abs(x)<=k_r);     %crop outer values

KBI=@(x) abs(x)*scale-floor(abs(x)*scale);

KB1D=@(x) (reshape(kblut(floor(abs(x)*scale).*kbcrop(x)+1),size(x)).*KBI(x)+...
          reshape(kblut(ceil(abs(x)*scale).*kbcrop(x)+1),size(x)).*(1-KBI(x)))...
          .*kbcrop(x);
KB=@(x,y) KB1D(x).*KB1D(y);
end

function w = KB2(x, k_r, beta)
    w = besseli(0, beta*sqrt(1-(2*x/k_r).^2)) ;
    w=w/abs(besseli(0, beta));
    w=(w.*(x<=k_r));
end
function dpz=deapodization(Ns,KB)
% function dpz=deapodization(Ns,KB)
% returns deapodization factor for kernel KB
%

xx=(1:(Ns))-Ns/2-1;%(-NsO/2:NsO/2-1);
dpz=ifftshift(ifft2(ifftshift(KB(xx,0)'*KB(xx,0))));
% assume oversampling, do not divide outside box in real space:
%msk=logical(padmat(ones(floor([1 1]*Ns/2)),[Ns Ns]));
msk=logical(padmat(ones(floor([1 1]*Ns*3/4)),[Ns Ns]));
% ii=find(~msk); clear msk
dpz=dpz./max(abs(dpz(:)));

dpz=single(dpz);
dpz(~msk)=1;            %keep the value outside box
dpz=1./dpz;            %deapodization factor truncated

end


