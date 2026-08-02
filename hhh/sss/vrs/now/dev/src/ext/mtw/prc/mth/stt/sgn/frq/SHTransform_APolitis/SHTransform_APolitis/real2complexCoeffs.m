function C_N = real2complexCoeffs(R_N)
%REAL2COMPLEXCOEFFS Convert SH coeffs from the real to complex basis
%   
%   Converts the vector of (N+1)^2xK SH coefficients of K functions on the
%   real SH base, to the respective ones of the complex SH base. For
%   normalisations and conventions used here for each base see the README
%   file.
%
%   R_N:  matrix of (N+1)^2 x K real SH coefficients
%
%   C_N:  matrix of (N+1)^2 x K complex SH coefficients
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% maximum order
N = sqrt(size(R_N,1)) -1;
C_N = zeros(size(R_N));

% n = 0
C_N(1,:) = R_N(1,:);

if N>0
    % n >= 1
    for n=1:N
        
        nharm = 2*n+1;
        tempR = R_N(n^2 + 1: n^2 + nharm, :);
        tempC = zeros(size(tempR));

        for m = 0:n            

            if m == 0
                tempC(m+n+1,:) = tempR(m+n+1,:);
            else
                T = (1/sqrt(2)) * [-(-1)^(-m)/1i   1/1i; (-1)^m      1];
                tempC([-m+n+1 m+n+1],:) = T' * tempR([-m+n+1 m+n+1],:);
            end
        end
        
        C_N(n^2 + 1: n^2 + nharm, :) = tempC;
    end
    
end
    
end
