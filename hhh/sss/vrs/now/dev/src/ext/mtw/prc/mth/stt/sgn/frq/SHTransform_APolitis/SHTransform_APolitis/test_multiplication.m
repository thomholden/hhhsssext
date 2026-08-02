%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test that the coefficients of a product function of two spherical
% functions are equal to the ones derived directly by employing Gaunt
% coefficients

aziRes = 10;
polarRes = 10;
dirs = grid2dirs(aziRes, polarRes);
W = ones(length(dirs),1);
X = cos(dirs(:,1)).*sin(dirs(:,2));
Y = sin(dirs(:,1)).*sin(dirs(:,2));
Z = cos(dirs(:,2));

% function 1 - 1st-order cardioid function looking at phi=0, theta=90
F = 0.5*W + 0.5*X;
N1 = 1;

% function 2 - 1st-order dipole function oriented at y axis
G = Y;
N2 = 1;

% product function
FG = F.*G;
N = N1+N2;

% get harmonic coefficients of functions and product numerically
F_N = weightedLeastSquaresSHT(1, F, dirs, 'complex', []);
G_N = weightedLeastSquaresSHT(1, G, dirs, 'complex', []);
FG_N1 = weightedLeastSquaresSHT(N, FG, dirs, 'complex', [])

% evaluate the coefficients of the product through the gaunt coefficients
G = gaunt_mtx(N);
for n=0:N
    for m=-n:n
        q = n*(n+1)+m;
        FG_N2(q+1) = 0;        
        
        for n1=0:N1
            for m1=-n1:n1
                q1 = n1*(n1+1)+m1;
                for n2=0:N2
                    for m2=-n2:n2
                        q2 = n2*(n2+1)+m2;
                        
                        FG_N2(q+1) = FG_N2(q+1) + F_N(q1+1)*G_N(q2+1)*G(q1+1,q2+1,q+1);
                    end
                end
            end
        end
    end
end

FG_N2 = FG_N2.'