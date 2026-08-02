function y = inter_xls(Y,x,ta,sc,type,ip,d,flax1,flax2,file_name)
% PURPOSE: Interface via Excel Link for univariate temporal disaggregation
% -----------------------------------------------------------------------
% SYNTAX: y = inter_xls(Y,x,ta,sc,type,ip,d,flax1,flax2,file_name);
% -----------------------------------------------------------------------
% INPUT
%           SELECTION OF THE METHOD
%
% Common parameters:
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        sc: number of high frequency data points for each low frequency data point
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
%
% Specific parameters:
%
% ==> Boot-Feibes-Lisman, Denton:
%        d: objective function to be minimized: volatility of ...
%            d=0 ---> levels
%            d=1 ---> first differences
%            d=2 ---> second differences
%
% ==> Chow-Lin, Fernandez, Litterman, Santos-Cardoso:
%           opC = -1 ---> pretesting intercept signficiance
%
% ==> Chow-Lin, Litterman, Santos-Cardoso:
%        type: estimation method: 
%            type=0 ---> weighted least squares 
%            type=1 ---> maximum likelihood
%        innovational parameter rl = [0.1 0.01 0.99]
%
% ==> Chow-Lin, Litterman, Santos-Cardoso when innovational parameter is supplied:
%         ip, such as -1 < ip < 1
%
%           INPUT DATA:
% 
% Common:  
%       Y: Nx1 --> Low-frequency time series (to be temporally disaggregated)
% Specific:
%       x: nx1 --> Denton, n=sc*N (extrapolation is not feasible)
%       x: nxp --> Fernandez, Chow-Lin, Litterman, Santos-Cardoso
%          p >= 1, n >= sc*N (extrapolation is feasible) 
%               
% -----------------------------------------------------------------------
% OUTPUT: y: nxi
%
%       i=1 brief --> only temporally disaggregated series (all procedures)
%       i=5 normal --> temporally disaggregated series, standard errors of estimates, 
%                  one-sigma upper and lower limits and residuals.
%                  Available for Fernandez, Chow-Lin, Litterman, Santos-Cardoso
%       i=5 detailed --> normal + ASCII file with model results (all
%                   procedures). A name for the output file should be supplied.
%
% -----------------------------------------------------------------------
% LIBRARY: bfl, denton_uni, fernandez, chowlin, litterman, ssc, 
% td_uni_print, td_print

% written by:
% Ana Abad(*) & Enrique M. Quilis(**)
%   (*)Instituto Nacional de Estadistica
%   c/ Rosario Pino, 14-16. Office 15.34
%   E28020 - Madrid (SPAIN)
%   (**) D.G. del Tesoro
%   Paseo del Prado, 6. Office 4.1-3.
%   E28020 - Madrid (SPAIN)

% Version 2.1 (October, 2006)

% -----------------------------------------------------------------------
% SELECTION OF THE METHOD

% Intercept pretesting
opC = -1;

% Range for grid search: default case: search is performed
% on the range [.21 .99], using .06 as step.
                 
rl = [.21 .06 .99];

switch flax1
    case 1
        % Boot-Feibes-Lisman
        res=bfl(Y,ta,d,sc);
    case 2
        % Denton
        res=denton_uni(Y,x,ta,d,sc);
    case 3
        % Fernandez
         res=fernandez(Y,x,ta,sc,opC);
     case 4
         % Chow-Lin
         res=chowlin(Y,x,ta,sc,type,opC,rl);
     case 5
         % Litterman
         res=litterman(Y,x,ta,sc,type,opC,rl);
     case 6
         % Santos-Cardoso
         res=ssc(Y,x,ta,sc,type,opC,rl);
     case 7
         % Chow-Lin, fixed innovational parameter (ip)
         res=chowlin(Y,x,ta,sc,type,opC,ip);
     case 8
         % Litterman, fixed innovational parameter (ip)
         res=litterman(Y,x,ta,sc,type,opC,ip);
     case 9
         % Santos-Cardoso, fixed innovational parameter (ip)
         res=ssc(Y,x,ta,sc,type,opC,ip);
  end
  
% -----------------------------------------------------------------------
% SELECTION OF OUTPUT

 switch flax2
     case 1 
         % Brief output
         y = res.y;
     case 2
         % Normal output
         switch res.meth
             case {'Boot-Feibes-Lisman'}
                 y = [res.y zeros(res.sc*res.N,4)];
             case {'Denton'}
                  y = [res.y zeros(res.sc*res.N,3) res.u];
             case {'Fernandez','Chow-Lin','Litterman','Santos Silva-Cardoso'}
                 y = [res.y res.y_dt res.y_lo res.y_up res.u];
         end
     case 3
         % Detailed output
         switch res.meth
             case {'Boot-Feibes-Lisman'}
                 y = [res.y zeros(res.sc*res.N,4)];
                 tduni_print(res,file_name);
             case {'Denton'}
                  y = [res.y zeros(res.sc*res.N,3) res.u];
                  tduni_print(res,file_name);
             case {'Fernandez','Chow-Lin','Litterman','Santos Silva-Cardoso'}
                 y = [res.y res.y_dt res.y_lo res.y_up res.u];
                 td_print(res,file_name);                 
         end
 end
         