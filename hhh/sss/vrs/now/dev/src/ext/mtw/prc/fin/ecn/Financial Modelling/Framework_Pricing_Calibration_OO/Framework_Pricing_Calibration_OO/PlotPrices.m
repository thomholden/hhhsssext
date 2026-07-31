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
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function PlotPrices(P_struct,fftpricer, S_bestval)
    prices = fftpricer.price(P_struct.dataT, ...
                  P_struct.t_star, ...
                  P_struct.S0, ...
                  P_struct.d, ...
                  P_struct.df, ...
                  S_bestval, ...
                  P_struct.dataK, ...
                  P_struct.dataOptType);
    figure
    marketprices = plot(P_struct.dataK,P_struct.dataOpt,'ro'); %market prices
    hold on
    modelprices = plot(P_struct.dataK,prices,'b+'); %model prices
    marketgroup = hggroup;
    modelgroup = hggroup;
    set(marketprices,'Parent',marketgroup);
    set(modelprices,'Parent',modelgroup);
    set(get(get(marketgroup,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');
    set(get(get(modelgroup,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on');
 	xlabel('strike')
    ylabel('option price')
    title('market and model option prices')
    legend('market prices','model prices')
  end