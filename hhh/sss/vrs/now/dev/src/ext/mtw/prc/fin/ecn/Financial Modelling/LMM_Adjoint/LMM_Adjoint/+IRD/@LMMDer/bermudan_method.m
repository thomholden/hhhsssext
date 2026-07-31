% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Nikolai Nowaczyk
%   	    Joerg Kienitz
%           Daniel Wetterau
%           
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Nikolai Nowaczyk, Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function w = bermudan_method(LD, A1, D, C, V, r)
%Adjoint Summation method
	
	if(~isempty(C))
		[m, q, N] = size(C);    %calculate dimensions
		N = N+1;
		W = V(N,:).';           %initialize W
		Wbar = zeros(q,1);      %initialize Wbar
		for n = N-1:-1:r        %run backward recursion
			Wbar = Wbar + C(:,:,n).' * W;
			W = D(:,:,n).' * W + V(n,:).';
		end
		for n = r-1:-1:1        
			Wbar = Wbar + C(:,:,n).' * W;
			W = D(:,:,n).' * W;
		end       
		w = Wbar.'; 
	else						%runs optimized version, if all C(n)=0
		m = size(D,1);    		%calculate dimensions
		N = size(D,3)+1;
		W = V(N,:).';           %initialize W
		for n = N-1:-1:r        %run backward recursion
			W = D(:,:,n).' * W + V(n,:).';
		end
		for n = r-1:-1:1        
			W = D(:,:,n).' * W;
		end       
		w = zeros(1,m);
	end

	if(~isempty(A1))		%assumes A(1)=0 otherwise
		w = w + W.' * A1; 	%calculate result    
	end
	
end
