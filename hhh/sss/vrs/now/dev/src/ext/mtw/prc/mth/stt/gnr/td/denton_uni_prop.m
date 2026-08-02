function res = denton_uni_prop(Y,x,ta,d,sc)
% PURPOSE: Temporal disaggregation: Denton method, proportional variant
% -----------------------------------------------------------------------
% SYNTAX: res = denton_uni_prop(Y,x,ta,d,sc)
% -----------------------------------------------------------------------
% OUTPUT: res: a structure
%         res.meth = 'Proportional Denton';
%         res.N     = Number of low frequency data
%         res.ta    = Type of disaggregation
%         res.sc     = Frequency conversion
%         res.d     = Degree of differencing 
%         res.y     = High frequency estimate
%         res.x     = High frequency indicator
%         res.U     = Low frequency residuals
%         res.u     = High frequency residuals
%         res.et    = Elapsed time
% -----------------------------------------------------------------------
% INPUT: Y: Nx1 ---> vector of low frequency data
%        x: nx1 ---> vector of low frequency data
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        d: objective function to be minimized: volatility of ...
%            d=0 ---> levels
%            d=1 ---> first differences
%            d=2 ---> second differences
%        sc: number of high frequency data points for each low frequency data point 
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
% -----------------------------------------------------------------------
% LIBRARY: aggreg
% -----------------------------------------------------------------------
% SEE ALSO: denton_uni, tduni_plot, tduni_print
% -----------------------------------------------------------------------
% REFERENCE: Denton, F.T. (1971) "Adjustment of monthly or quarterly 
% series to annual totals: an approach based on quadratic minimization", 
% Journal of the American Statistical Society, vol. 66, n. 333, p. 99-102.

% written by:
% Enrique M. Quilis
%  D.G. del Tesoro
%  Paseo del Prado, 6. Office 4.1-3.
%  28014 - Madrid (SPAIN)
%  <equilis@tesoro.meh.es>

% Version 1.1 [August 2006]

t0=clock;

% -----------------------------------------------------------------------
% Size of the problem

[N,M] = size(Y);
[n,m] = size(x);

if ((m > 1) | (M > 1))
    error ('*** INCORRECT DIMENSIONS ***');
else
    clear m M;
end

% -----------------------------------------------------------------------
% Generation of aggregation matrix C

C = aggreg(ta,N,sc);

% -----------------------------------------------------------
% Expanding the aggregation matrix to perform
% extrapolation if needed.

if (n > sc * N)
   pred = n - sc*N;           % Number of required extrapolations 
   C=[C zeros(N,pred)];
else
   pred = 0;
end

% -----------------------------------------------------------------------
% Temporal aggregation matrix of the indicator

X = C*x;

% -----------------------------------------------------------------------
% Computation of low frequency residuals

U = Y - X;

% -----------------------------------------------------------------------
% Computation of high frequency series = indicator + annual residuals
% temporally disaggregated by means of Boot-Feibes-Lisman

W = diag(x);

switch d
case 0
   M = W * W * C';
case 1
   R = tril(ones(n,n));
   A = R * R';
   M =  W * A * W * C';
case 2
   R = tril(ones(n,n));
   A = R * R * R'* R';
   M =  W * A * W * C';
end

u = M * inv(C * M) * U;

y = x + u;

% -----------------------------------------------------------------------
% Loading the structure
% -----------------------------------------------------------------------

% Basic parameters 

res.meth = 'Proportional Denton';
res.N = N;
res.ta= ta;
res.sc = sc;
res.pred	= pred;
res.d = d;

% -----------------------------------------------------------------------
% Series

res.y = y;
res.x = x;
res.U = U;
res.u = u;

% -----------------------------------------------------------------------
% Elapsed time

res.et = etime(clock,t0);
