%TEST_GALLERY
% Test both POWERM_PADE_FRE and POWERM_PADE_FRE_REAL on test matrices
% from GALLERY.
% "The Matrix Function Toolbox" is needed to run these tests;
% it is available from                 
%  http://www.maths.manchester.ac.uk/~higham/mftoolbox/       
clc
clear all
v = ver;
if ~any(strcmp({v(1:end).Name}, 'Matrix Function Toolbox (MFT)'))
   error('POWERM_PADE_FRE:missingMFT',...
           ['Matrix Function Toolbox (MFT) must be installed.\n' ...
          'Obtain it from ' ...
          'http://www.maths.manchester.ac.uk/~higham/mftoolbox' ])
end   

% p values
pvals = [ 1/52 1/12 1/3 ];     
pvals = [pvals -pvals 1-pvals -1+pvals ]; 
pvals = sort(pvals,'ascend');
np = length(pvals);
j = 0;

for matsize = [10 20]
    n = matsize;         % matrix size
    A = randn(n);  % test matrix
    e = eig(A);
    emin = min(e(real(e)==e));
    if emin < 0
        A = A + eye(n)*(abs(emin)+1);   % avoid negative real e'vals
    end
    fprintf('\n-------------------- Test on: %g by %g random matrix -------------------\n',n,n);
    fprintf('     p       cond     complex algorithm         real algorithm   \n');
    fprintf('                          X          F           X         F   \n');
    
    for ii = 1:np  % Outer loop over different p.
        
        p = pvals(ii);        
        j = j + 1;
        
        E = randn(n);
        
        XX = expm(p*logm(A));  % 'accurate' matrix power.
%         XX = powerm_x(A,p);
        XX_big = expm(p*logm([A,E;zeros(n),A]));
%         XX_big = powerm_x([A,E;zeros(n),A],p);
        FF = XX_big(1:n,n+1:2*n);  % 'accurate' Frechet derivative.
        nrmX = norm(XX,1);
        nrmF = norm(FF,1);
        normF(j) = nrmF;
        normX(j) = nrmX;
            
        [X0,F0,cond0(j),nsq0(j),m0(j)] = powerm_pade_fre(A,p,E);
        eX0(j) = norm(X0-XX,1)/nrmX;
        eF0(j) = norm(F0-FF,1)/nrmF;     
      
        [X1,F1,cond1(j),nsq1(j),m1(j)] = powerm_pade_fre_real(A,p,E);
        eX1(j) = norm(X1-XX,1)/nrmX;
        eF1(j) = norm(F1-FF,1)/nrmF;
        
        fprintf('%9.1e %9.1e  %9.1e  %9.1e  %9.1e  %9.1e\n' , ...
                 p,  cond0(j),  eX0(j),  eF0(j), eX1(j), eF1(j))
    end  % ii loop over pvals
end


