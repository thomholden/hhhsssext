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



function w = adjoint_method(LD, A1, D, C, v)
%Adjoint method
	if(~isempty(C))				%General case
		[m, q, N] = size(C);    %calculate dimensions
		N = N+1;
		V=v.';                  %initialize V
		Vbar = zeros(q,1);      %initialize Vbar
		for n = N-1:-1:1        %run backward recursion
			Vbar = Vbar + C(:,:,n).' * V;
			V = D(:,:,n).' * V;
		end
		w = Vbar.';
	else						%Optimized in case C=[] (i.e. all C(n)=0)
		m = size(D,1);    		%calculate dimensions
		N = size(D,3)+1;
		V=v.';                  %initialize V
		for n = N-1:-1:1        %run backward recursion
			V = D(:,:,n).' * V;
		end
		w = zeros(1,m);
	end
	
	if(~isempty(A1))			%assumes A(1)=0 otherwise	
		w = w + V.' * A1;  		%calculate result
	end
	
end
