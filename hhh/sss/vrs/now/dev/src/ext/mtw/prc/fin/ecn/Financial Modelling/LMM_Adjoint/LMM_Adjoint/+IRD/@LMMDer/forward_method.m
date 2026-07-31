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



function [w A] = forward_method(LD, A1, D, C, v)
%Forward method
	if(~isempty(C))
		[m, q, N] = size(C);        %calculate dimensions
		N = N+1;
		A = zeros(m,q,N);           %initialize A
		A(:,:,1)=A1;
		for n = 1:N-1               %run forward recursion
			A(:,:,n+1) = D(:,:,n)*A(:,:,n) + C(:,:,n);
		end
	else							%assumes that all C(n)=0
		m = size(D,1);		        %calculate dimensions
		N = size(D,3)+1;
		A = zeros(m,m,N);           %initialize A
		A(:,:,1)=A1;
		for n = 1:N-1               %run forward recursion
			A(:,:,n+1) = D(:,:,n)*A(:,:,n);
		end
	end
	if(~isempty(v))                 %calculate result
		w = v * A(:,:,N);           
	end
end
