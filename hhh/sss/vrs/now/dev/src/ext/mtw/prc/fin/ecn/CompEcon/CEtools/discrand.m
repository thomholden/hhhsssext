% DISCRAND Discrete random variable simulator
% USAGE
%   d = discrand(m,p)
% INPUTS
%   m = number of occurances simulated
%   p = probability vector, where states
%       1,2,...,n occur with probabilities 
%       prob(1),prob(2),...,prob(n)
% OUTPUT
%   d = m by 1 vector of random occurances

% Copyright (c) 1997-2000, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function d = discrand(m,p)
  n = length(p);
  u = rand(m,1);
  c = [0;cumsum(reshape(p,n,1))];
  d = lookup(c,u,3);

