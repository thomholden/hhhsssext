% MCMC Methods for MLP and GP and Stuff
% Version 2.1 2005-10-24
%
% This software is distributed under the GNU General Public 
% Licence (version 2 or later); please refer to the file 
% Licence.txt, included with the software, for details.
%
% BAYESIAN MLP NETWORKS
%  Main functions
%    GIBBS       - Gibbs sampling
%    HMC2        - Hybrid Monte Carlo sampling.
%    HMC2_OPT    - Default options for Hybrid Monte Carlo sampling.
%    LAPLACE_P   - Create Laplace (double exponential) prior
%    METROP2     - Markov Chain Monte Carlo sampling with Metropolis algorithm.
%    METROP2_OPT - Default options for Metropolis sampling.
%    MLP2BKP	 - Backpropagate gradient of error function for 2-layer network.
%    MLP2B_MC    - Monte Carlo sampling for model mlp2b
%    MLP2B_MCOPT - Default options for MLP2B_MC
%    MLP2B_SIM   - Simulate a 2-layer binary logistic regression feedforward network
%    MLP2B_STEPS - Calculate heuristic stepsizes for 2-layer network.
%    MLP2C_MC    - Monte Carlo sampling for model mlpr
%    MLP2C_MCOPT - Default options for MLP2C_MC
%    MLP2C_SIM   - Simulate a 2-layer softmax regression feedforward network
%    MLP2C_STEPS - Calculate heuristic stepsizes for 2-layer network.
%    MLP2FWD	 - Forward propagation through 2-layer network.
%    MLP2FWDS	 - Forward propagation through 2-layer networks.
%    MLPSTEPS    - Calculate heuristic stepsizes for 2-layer network.
%    MLP2INDEX   - Create indexes for mlp2.
%    MLP2        - Create a 2-layer feedforward network without activation
%    MLP2NORMP   - Create Gaussian prior for mlp.
%    MLP2PAK     - Combines weights and biases into one weights vector.
%    MLP2R_MC    - Monte Carlo sampling for model mlpr
%    MLP2R_MCOPT - Default options for MLP2R_M
%    MLP2R_STEPS - Calculate heuristic stepsizes for 2-layer network.
%    MLP2UNPAK   - Separates weights vector into weight and bias matrices. 
%    NORM_P      - create Gaussian (multivariate) (hierarchical) prior
%    THIN        - Delete burn-in and thin in MCMC-chains
%    BATCH       - Batch MCMC sample chain and evaluate mean/median of batches
%    T_P         - Create student t prior
%    T_S         - Maximum log likelihood second derivatives for t-distribution
%    
%  Error and gradient functions
%    DIR_E       - compute an error term for a parameter with Dirichlet
%                  distribution (single parameter). 
%    GRADCHEK    - Checks a user-defined gradient function using 
%                  finite differences.
%    INVGAM_E    - compute an error term for a parameter with inverse
%                  gamma distribution (single parameter).
%    INVGAM_G    - compute a gradient term for a parameter with inverse
%                  gamma distribution (single parameter).
%    LAPLACE_E   - compute an error term for a parameter with Laplace
%                  distribution (single parameter). 
%    LAPLACE_G   - compute a gradient for a parameter with Laplace 
%                  distribution (single parameter).
%    MLP2B_E     - Evaluate error function for 2-layer network of type MLP2B.
%    MLP2B_G     - Evaluate gradient of error function for 2-layer network 
%                  of type MLP2B.
%    MLP2C_E     _ Evaluate error function for 2-layer network of type MLP2C.
%    MLP2C_G     - Evaluate gradient of error function for 2-layer network 
%                  of type MLP2C.
%    MLP2DERIV   - Evaluate derivatives of MLP outputs with respect to weights.
%    MLP2R_E     - Evaluate error function for 2-layer network of type MLP2R.
%    MLP2R_G     - Evaluate gradient of error function for 2-layer network 
%                  of type MLP2R.
%    MNORM_E     - compute an error term for parameters with normal
%                  distribution (multiple parameters).
%    MNORM_G     - compute a gradient for parameters with normal 
%                  distribution (multible parameters)
%    MNORM_S     - Maximum log likelihood second derivatives
%    NORM_E      - compute an error term for a parameter with normal
%                  distribution (single parameter). 
%    NORM_G      - compute a gradient for a parameter with normal 
%                  distribution (single parameter).
%    NORM_S      - Maximum log likelihood second derivatives (single variable)
%    T_E         - compute an error term for a parameter with Student's 
%                  t-distribution (single parameter). 
%    T_G         - compute a gradient for a parameter with Student's 
%                  t-distribution (single parameter).
%
%  Functions to sample from full conditional distribution
%    COND_GINVGAM_CAT    - Sample conditional distribution from 
%                          inverse gamma likelihood for a group and
%                          categorical prior. 
%    COND_GNORM_INVGAM   - Sample conditional distribution from
%                          normal likelihood for group and
%                          inverse gamma prior.
%    COND_GNORM_NORM     - Sample conditional distribution from normal
%                          likelihood for a group and normal prior.
%    COND_GT_CAT         - Sample conditional distribution from t 
%                          likelihood for a group and categorical prior.
%    COND_GT_INVGAM      - Sample conditional distribution from t 
%                          likelihood for a group and inverse gamma prior.
%    COND_INVGAM_CAT     - Sample conditional distribution from
%                          inverse gamma likelihood and categorical prior. 
%    COND_INVGAM_INVGAM  - Sample conditional distribution from
%                          inverse gamma likelihood and prior
%    COND_LAPLACE_INVGAM - Sample conditional distribution from Laplace
%                          likelihood and inverse gamma prior.
%    COND_MNORM_INVWISH  - Sample conditional distribution from normal
%                          likelihood for multiparameter group and
%                          inverse wishard prior.
%    COND_NORM_GINVGAM   - Sample conditional distribution from
%                          normal likelihood and inverse gamma prior
%                          for a group
%    COND_NORM_INVGAM    - Sample conditional distribution from
%                          normal likelihood and inverse gamma prior
%    COND_T_CAT          - Sample conditional distribution from t
%                          likelihood and categorical prior.
%    COND_T_INVGAM       - Sample conditional distribution from t
%                          likelihood and inverse gamma prior.
%
% GAUSSIAN PROCESSES
%    GP2                 - Create a Gaussian Process.
%    GP2FWD              - Forward propagation through Gaussian Process
%    GP2FWDS	         - Forward propagation through Gaussian Processes.
%    GP2PAK	         - Combine GP hyperparameters into one vector.
%    GP2B_MC             - Monte Carlo sampling for model GP2B
%    GP2R_MC             - Monte Carlo sampling for model GP2R
%    GP2R_MCOPT          - Default options for GP2R_MC
%    GP2R_STEPS          - Calculate heuristic stepsizes for Gaussain Process
%    GP2UNPAK            - Separate GP hyperparameter vector into components.
%    GPCOV               - Evaluate covarianse matrix.
%    GPEXPEDATA          - Evaluate error function for gp.
%    GPTRCOV             - Evaluate covarianse matrix.
%    GPVALUES            - Sample latent values
%    INVGAM_P            - Create inverse-Gamma prior
%
%   Error and gradient functions
%     GINVGAM_E    - Compute an error term for a parameter with inverse
%                    gamma distribution (single parameter).
%     GINVGAM_G    - Compute a gradient term for a parameter with inverse
%                    gamma distribution (single parameter).
%     GP2R_E	   - Evaluate error function for Gaussian Process.
%     GP2R_G       - Evaluate gradient of error for Gaussian Process.
%     GNORM_E      - Compute an error term for a parameter with normal
%                    distribution (single parameter). 
%     GNORM_G      - Compute a gradient for a parameter with normal 
%                    distribution (single parameter).
%     GNORM_S      - Maximum log likelihood second derivatives.
%     GT_E         - Compute an error term for a parameter with Student's
%                    t-distribution (single parameter). 
%     GT_G         - Compute a gradient for a parameter with Student's 
%                    t-distribution (single parameter).
%     GT_S         - Maximum log likelihood second derivatives for 
%                    t-distribution.
%
% PROBABILITY DENSITY FUNCTIONS
%    BETA_LPDF     - Beta log-probability density function (lpdf).
%    BETA_PDF      - Beta probability density function (pdf).
%    DIR_LPDF      - Log probability density function of uniform Dirichlet
%                    distribution
%    DIR_PDF       - Probability density function of uniform Dirichlet
%                    distribution
%    GAM_CDF       - Cumulative of Gamma probability density function (cdf).
%    GAM_LPDF      - Log of Gamma probability density function (lpdf).
%    GAM_PDF       - Gamma probability density function (pdf).
%    INVGAM_LPDF   - Inverse-Gamma log probability density function.
%    INVGAM_PDF    - Inverse-Gamma probability density function.
%    LAPLACE_LPDF  - Laplace log-probability density function (lpdf).
%    LAPLACE_PDF   - Laplace probability density function (pdf).
%    LOGN_LPDF     - Log normal log-probability density function (lpdf)
%    LOGT_LPDF     - Log probability density function (lpdf) for log Student's T
%    MNORM_LPDF    - Multivariate-Normal log-probability density function (lpdf).
%    MNORM_PDF     - Multivariate-Normal log-probability density function (lpdf).
%    NORM_LPDF     - Normal log-probability density function (lpdf).
%    NORM_PDF      - Normal probability density function (pdf).
%    POISS_LPDF    - Poisson log-probability density function.
%    POISS_PDF     - Poisson probability density function.
%    SINVCHI2_LPDF - Scaled inverse-chi log-probability density function.
%    SINVCHI2_PDF  - Scaled inverse-chi probability density function.
%    T_LPDF        - Student's T log-probability density function (lpdf)
%    T_PDF         - Student's T probability density function (pdf)
%
% RANDOM NUMBER GENERATORS
%    CATRAND       - Random matrices from categorical distribution.
%    DIRRAND       - Uniform dirichlet random vectors
%    EXPRAND       - Random matrices from exponential distribution.
%    GAMRAND       - Random matrices from gamma distribution.
%    INTRAND       - Random matrices from uniform integer distribution.
%    INVGAMRAND    - Random matrices from inverse gamma distribution
%    INVGAMRAND1   - Random matrices from inverse gamma distribution
%    INVWISHRND    - Random matrices from inverse Wishart distribution.
%    NORMLTRAND    - Random draws from a left-truncated normal
%                    distribution, with mean = mu, variance = sigma2
%    NORMRTRAND    - Random draws from a right-truncated normal
%                    distribution, with mean = mu, variance = sigma2
%    NORMTRAND     - Random draws from a normal truncated to interval
%    NORMTZRAND    - Random draws from a normal distribution truncated by zero
%    WISHRND       - Random matrices from Wishart distribution.
%    SINVCHI2RAND  - Random matrices from scaled inverse-chi distribution
%    TRAND         - Random numbers from Student's t-distribution
%    UNIFRAND      - Generate unifrom random numberm from interval [A,B]
%
% OTHER FUNCTIONS
%    BBMEAN        - Bayesian bootstrap mean
%    BBPRCTILE     - Bayesian bootstrap percentile
%    BINSGEQ       - Binary search of sorted vector.
%    GAMMALN1      - Logarithm of gamma function.
%    HMEAN         - Harmonic mean
%    KERNELP       - Kernel density estimator for one dimensional distribution.
%    LOGSIG2       - Logarithmic sigmoid transfer function.
%    NCHOOSEKS     - Multinomial coefficient
%    RANDPICK      - Pick element from x randomly
%                    If x is matrix, pick row from x randomly.
%    RESAMPDET     - Deterministic resampling
%    RESAMPRES     - Residual resampling
%    RESAMPSIM     - Simple random resampling
%    RESAMPSTR     - Stratified resampling
%    SCGES         - Scaled conjugate gradient optimization with early stopping
%    SCGES_OPT     - Default options for scaled conjugate gradient optimization
%    SCGES         - Scaled conjugate gradient optimization with early stopping (new options structure).
%    SCG2_OPT      - Default options for scaled conjugate gradient optimization (scg2) (new options structure).
%    SLS           - Markov Chain Monte Carlo sampling using Slice Sampling
%    SLS_OPT       - Default options for Slice Sampling
%    SLS1MM        - 1-dimensional fast minmax Slice Sampling
%    SLS1MM_OPT    - Default options for SLS1MM_OPT
%    SOFTMAX2      - Softmax transfer function
%    STR2FUN       - Compatibility wrapper to str2func
%    TANH_F        - Faster hyperbolic tangent.
%    WDIST2        - Evaluate weighted and squared distance matrix of two input data sets.
