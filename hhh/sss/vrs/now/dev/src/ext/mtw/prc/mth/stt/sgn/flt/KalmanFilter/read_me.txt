Some brief notes
----------------

kfdemo.m is a Matlab script file to run a demonstration of the
Bayesian Kalman filter.  It loads file kfdemo.mat (saved as version 4
so that it will read in either v4 or v5 Matlab).

The other files are called by kf.m (the Kalman filter) or included
as they may be useful.  Normalis.m normalises data to zero-mean,
unit variance along components.  I always do this before any further
analysis.

Steve Roberts			7-2-98
