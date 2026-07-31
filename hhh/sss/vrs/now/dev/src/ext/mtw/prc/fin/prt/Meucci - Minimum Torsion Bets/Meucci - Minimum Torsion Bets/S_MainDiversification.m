%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this script computes Diversification Distribution and the Effective Number of Bets with
% 1) Principal Components Bets
% 2) Minimum Torsion Bets
% and computes the Marginal Contribution to Risk for an equal-weight portfolio of stocks in the S&P500
% see A. Meucci, A. Santangelo, R. Deguest - "Measuring Portfolio Diversification Based on Optimized Uncorrelated Factors" to appear (2013)
%
% Last version of code and article available at http://symmys.com/node/599
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

% load db
load LinRet 

% equally weighted exposures (weights) to factors (returns)
n_ = size(LinRet, 1);
b = ones( n_, 1 ) / n_;

% Sample covariance matrix
Sigma = cov( LinRet' ) ;

% PCA decomposition
[e, lambda] = eig(Sigma);

% PCA torsion matrix and exposures for ew portfolio
t_PC = torsion(Sigma, 'pca');

% Minimum-Torsion matrix and exposures for ew portfolio
t_MT = torsion(Sigma, 'minimum-torsion', 'exact');

% Diversification Distribition and NEB using PCA torsion matrix
[ENB_PC, DiverDistr_PC] = EffectiveBets(b, Sigma, t_PC);

% Diversification Distribition and NEB using Minimum-Torsion matrix
[ENB_MT, DiverDistr_MT] = EffectiveBets(b, Sigma, t_MT);

% Marginal Risk Contribution
MargContrs = b.*(Sigma*b)/(b'*Sigma*b);
