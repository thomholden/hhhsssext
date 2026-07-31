%% CFEVALDEMO1 
% Function |cfeval| calculates cash flows of fixed-income portfolios and structured products, 
% given a quasi-symbolic, Matlab-syntax, typically recursive description of principal and coupon
% dynamics. Combined, these descriptions are passed to |cfsim| in cell arrays of strings, whose
% rows correspond to securities, and columns to periods. 
%%
help cfeval

%% Example 1. Fixed-coupon bond
% a) set up security definitions
T = 3;
[pofun,cpfun,psfun,ppfun] = deal(cell(1,T));
%%
% * Principal outstanding: constant, normalized to 1
[pofun{:}] = deal('1');
%%
% * Coupon: 5%
[cpfun{:}] = deal('0.05*poval(i,t)');
%%
% * Principal repayment: outstanding principal at maturity
[psfun{:}] = deal('0'); psfun{T} = 'poval(i,t)'; 
%%
[ppfun{:}] = deal('0');
%%
% b) calculate total cash flows
cfeval(pofun,cpfun,psfun,ppfun)

%% Example 2. Floating-rate note
% a) set up security definitions
[pofun,cpfun,psfun,ppfun] = deal(cell(1,T));
%%
% * Principal outstanding: constant, normalized to 1
[pofun{:}] = deal('1');
%%
% * Coupon: linked to a variable rate, its path passed to |cfeval| in parameter structure |par| 
clear par
%%
par.libor  = 0.1*rand(1,T)                                 %#ok
%%
[cpfun{:}] = deal('par.libor(t)*poval(i,t)');
%%
% * Principal repayment: outstanding principal at maturity
[psfun{:}] = deal('0'); psfun{T} = 'poval(i,t)'; 
%%
[ppfun{:}] = deal('0');
%%
% b) calculate coupon payments and total cash flows
[cfval,poval,cpval] = cfeval(pofun,cpfun,psfun,ppfun,par); %#ok
%%
cpval, cfval                                               %#ok

%% Example 3. Floater and inverse floater 
% a) set up security definitions
[pofun,cpfun,psfun,ppfun] = deal(cell(2,T));
%%
% * Principal outstanding: constant, normalized to 1, split 50/50 between
% floater and inverse floater
par.w = [.5 .5];
%%
[pofun{:}] = deal('par.w(i)');
%%
% * Coupon: |(LIBOR + 2%)| for floater, |max(5%-LIBOR,0)| for inverse floater
[cpfun{1,:}] = deal('(par.libor(t) + 0.02)*poval(i,t)');
%%
[cpfun{2,:}] = deal('max(0.05 - par.libor(t),0)*poval(i,t)');
%%
% * Principal repayment: outstanding principal at maturity
[psfun{:}] = deal('0'); [psfun{:,T}] = deal('poval(i,t)'); 
%%
[ppfun{:}] = deal('0');
%%
% b) calculate coupon payments and total cash flows
[cfval,poval,cpval] = cfeval(pofun,cpfun,psfun,ppfun,par); %#ok
%%
cpval, cfval                                               %#ok

%% Example 4. CDO with senior and subordinate tranches
% a) set up security definitions
[pofun,cpfun,psfun,ppfun] = deal(cell(2,T));
%%
% * Principal: normalized to 1, split 75/25 between senior and subordinate tranches, 
%   and subsequently reduced by collateral defaults, occuring at random rate |d(t)|, 
%   so that fraction |1-d(t)| of principal outstanding in period |t| remains at |t+1|
%%
clear par
%%
par.w = [.75 .25];
%%
par.d = .1*ones(1,T);
%%
[pofun{:,1}] = deal('par.w(i)');
%%
% Credit loss on overall portfolio:
clp  = 'par.d(t-1)*sum(poval(:,t-1),1)'                    %#ok
%%
% Credit loss on senior tranche:
cls = ['max(0,' clp ' - poval(2,t-1))']                    %#ok
%%
% Subordinate tranche: principal reduced by credit losses, but cannot go negative 
[pofun{2,2:end}] = deal(['max(0,poval(2,t-1) - ' clp ')']);
%%
% Senior tranche: principal reduced only if credit losses exceed subordinate tranche's principal
[pofun{1,2:end}] = deal(['max(0,poval(1,t-1) - ' cls ')']);
%%
% * Coupon: 5% on senior tranche, 10% on subordinate tranche
par.r = [.05 .10];
%%
[cpfun{:}] = deal('par.r(i)*poval(i,t)');
%%
% * Principal repayment: outstanding principal at maturity
[psfun{:}] = deal('0'); [psfun{:,T}] = deal('poval(i,t)'); 
%%
[ppfun{:}] = deal('0');
%%
% b) calculate principal outstanding, coupon payments, and overall cash flows
[cfval,poval,cpval] = cfeval(pofun,cpfun,psfun,ppfun,par); %#ok
%%
poval, cpval, cfval                                        %#ok