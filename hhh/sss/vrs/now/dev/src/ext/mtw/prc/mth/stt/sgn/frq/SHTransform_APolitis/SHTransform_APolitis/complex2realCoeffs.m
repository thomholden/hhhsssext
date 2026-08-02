function R_N = complex2realCoeffs(C_N)
%COMPLEX2REALCOEFFS Convert SH coeffs from the complex to real basis
%   
%   Converts the vector of (N+1)^2xK SH coefficients of K functions on the
%   complex SH base, to the respective ones of the real SH base. For
%   normalisations and conventions used here for each base see the README
%   file.
%
%   C_N:  matrix of (N+1)^2 x K complex SH coefficients
%
%   R_N:  matrix of (N+1)^2 x K real SH coefficients
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% maximum order
N = sqrt(length(C_N)) -1;
R_N = zeros(size(C_N));

% n = 0
R_N(1,:) = C_N(1,:);

if N>0
    % n >= 1
    for n=1:N
        
        nharm = 2*n+1;
        tempC = C_N(n^2 + 1: n^2 + nharm, :);
        tempR = zeros(size(tempC));
        
%         for m = -n:n
%             
%             if m < 0
%                 T = 1/(1i*sqrt(2)) * [-(-1)^m   1];
%                 tempR(m+n+1,:) = T * tempC([m+n+1 -m+n+1],:);                
%             elseif m == 0
%                 tempR(m+n+1,:) = tempC(m+n+1,:);
%             else
%                 T = 1/sqrt(2) * [(-1)^m      1];
%                 tempR(m+n+1,:) = T * tempC([-m+n+1 m+n+1],:);
%             end

        % equivalent as the formulation above, but with less 
        for m = 0:n            

            if m == 0
                tempR(m+n+1,:) = tempC(m+n+1,:);
            else
                T = (1/sqrt(2)) * [-(-1)^(-m)/1i   1/1i; (-1)^m      1];
                
                tempR([-m+n+1 m+n+1],:) = T * tempC([-m+n+1 m+n+1],:);
            end
        end
        
        R_N(n^2 + 1: n^2 + nharm, :) = real(tempR);
    end
    
end
    
end
