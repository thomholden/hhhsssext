function A = gaunt_mtx(N)
%GAUNT_MTX Construct a matrix of Gaunt coefficients
%
% GAUNT_MTX constructs the (N+1)^2x(N+1)^2x(N+1)^2 matrix of Gaunt 
% coefficients which represent the instegral of three spherical harmonics 
% such as
% G^q_{q',q''} = \int_\Omega Y_{q'}Y_{q''}Y^*_{q} \mathrm{d}\Omega.
%
% With Gaunt coefficients, the spherical harmonic coefficients of the
% product of two spherical functions can be given directly as a linear
% relationship between the harmonic coefficients of the two functions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = zeros((N+1)^2, (N+1)^2, (N+1)^2);
for n = 0:N
        for m = -n:n
            q = n*(n+1)+m;
                        
            for n1 = 0:N
                for m1 = -n1:n1
                    q1 = n1*(n1+1)+m1;
                    
                    for n2 = 0:N
                        for m2 = -n2:n2
                            q2 = n2*(n2+1)+m2;
                            
                            if n<abs(n1-n2) || n>n1+n2
                                A(q1+1, q2+1, q+1) = 0;
                            else
                                wigner3jm = w3j(n1, m1, n2, m2, n, -m);
                                wigner3j0 = w3j(n1, 0, n2, 0, n, 0);
                                A(q1+1, q2+1, q+1) = (-1)^m * sqrt((2*n1+1)*(2*n2+1)*(2*n+1)/(4*pi)) * wigner3jm * wigner3j0;
                            end
                        end
                    end
                end
            end
        end
end
