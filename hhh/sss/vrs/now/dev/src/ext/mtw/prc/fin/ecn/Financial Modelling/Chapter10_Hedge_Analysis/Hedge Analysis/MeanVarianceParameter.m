% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function call_mv_fft = MeanVarianceParameter(model,pricer,S,K,r,d,T)

% --- Integration Parameter
dt = 0.1; 
i_ub = 3;
Strike_ub = 30*K;
Strikes = 0.01:100:Strike_ub; %0.01:1:Strike_ub;
prices = pricer.PriceAndGreeks(model,S,Strikes',T,r,d);
prices = FFTCallCorrector(prices);
levymeasure = @(x) feval(@LevyMeasureLib,model,model.params,x);
call_mv_fft = mvratio(S,Strikes,prices',K, levymeasure, dt,i_ub);

end