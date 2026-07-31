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
% (C) Joerg Kienitz, Daniel Wetterau and Sven Glaser
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 




%K = [-0.00558;-0.00308;-0.00058;0.00192;0.00442;0.00692;0.00942;0.01192;0.01442];
%K = [-0.007; -0.006; -0.00558;-0.00308;-0.00058;0.00192;0.00442;0.00692;0.00942;0.01192;0.01442; 0.015; 0.02];
K = -0.005:0.001:0.005; K = K';
Basis = 0.5;
N = 40;
TimeGrid = [0.5;1;1.5;2;2.5;3;3.5;4;4.5;5;5.5;6;6.5;7;7.5;8;8.5;9;9.5;10;10.5;11;11.5;12;12.5;13;13.5;14;14.5;15;15.5;16;16.5;17;17.5;18;18.5;19;19.5];
V = 1;      % initial Variance

% volatility structure given by (a+b*x).*exp(-(c*x))+d;
a = 0.04;   % parameter for volatility
b = 0.32;   % parameter for volatility
c = 1.1;    % parameter for volatility
d = 0.17;   % parameter for volatility
delta = 1;

% discount Curve example
discountRates = [0.985169904746796; 0.969603417144602;0.953519883690517; ...
    0.937072285590863;0.920373645632750;0.903510864949698; ...
    0.886552715323107;0.869554800715134;0.852562813781781; ...
    0.835614770440747;0.818742599951822;0.801973311199580; ...
    0.785329870362619; 0.768831876083534;0.752496088859194; ...
    0.736336853104236;0.720366438622605;0.704595320492679; ...
    0.689032411146406;0.673685254812677; 0.658560191951215; ...
    0.643662499478890;0.628996511260826;0.614565722355520; ...
    0.600372879766439;0.586420061893654;0.572708748450192; ...
    0.559239882275316;0.546013924216600;0.533030902047023; ...
    0.520290454219452;0.507791869129272;0.495534120449490; ...
    0.483515899015890; 0.471735641668668;0.460191557398297; ...
    0.448881651094625;0.437803745157532;0.426955499193344];

endTime1 = 10;      % Swap Tenor 1
endTime2 = 2;       % Swap Tenor 2
fixingTime = 5;
kappa = 0.15;
w = 1;
xi = 1.3;           % volatility of variance
coeff1 = 0.4;
coeff2 = 0.9;

nu=0.11;
eta=0.22;

% reference prices from paper
PriceRef = [87.7901480260511;69.3906766745565;52.3247784721528;37.5012348966940;25.9534026355587;17.9056613151066; ...
    12.5473484234984;8.94269945248970;6.47303114676323];