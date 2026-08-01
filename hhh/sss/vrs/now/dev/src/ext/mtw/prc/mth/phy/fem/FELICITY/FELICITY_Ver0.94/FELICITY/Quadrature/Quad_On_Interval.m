function [Points, Weights] = Quad_On_Interval(Num_Quad)
%Quad_On_Triangle
%
%   This routine gives the standard Gauss quadrature rule for integrating
%   on the unit interval: [0, 1].
%
%   [Points, Weights] = Quad_On_Interval(Num_Quad);

% Copyright (c) 02-08-2008,  Shawn W. Walker

% on the unit interval [0, 1]
[Points, Weights] = GaussQuad(Num_Quad,0,1);

% END %