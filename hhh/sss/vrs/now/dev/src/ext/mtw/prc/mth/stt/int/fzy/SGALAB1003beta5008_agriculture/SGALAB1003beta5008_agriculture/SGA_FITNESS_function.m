function [ fitness ] = SGA_FITNESS_function( X , Y , Z )


% /*M-FILE FUNCTION SGA_FITNESS_function MMM SGALAB */ %
% /*==================================================================================================
%  Simple Genetic Algorithm Laboratory Toolbox for Matlab 7.x
%
%  Copyright 2010 The SxLAB Family - Yi Chen - leo.chen.yi@gmail.com
% ====================================================================================================
%
%File description:
%
% [1]for both single objective and multi objective problems, 
% 
% [2]accept stand-alone variables and matrix variables, e.g.
% 
% (1) stand-alone variables, fitness(x,y,z)
% 
% (2) matrix variables,
% fitness([x,y,z;x,y,z],[x,y,z;x,y,z],[x,y,z;x,y,z])
% 
%Input:
%          User define-- in the format ( x1, x2, x3,... )
%Output:
%          fitness--     is the fitness value
% 
%Appendix comments:
%
% 02-Dec-2009   Chen Yi
% obsolete SGA__fitness_MO_evaluating.m
%          SGA_FITNESS_MO_function.m
% use      SGA__fitness_evaluating.m
%          SGA_FITNESS_function.m (for both single objective and multi
%                                  objective problems )
% 
%Usage:
%     [ fitness ] = SGA_FITNESS_function( xi,... )
%===================================================================================================
%  See Also:         
%
%===================================================================================================
% 
%===================================================================================================
%Revision -
%Date        Name    Description of Change email                 Location
%27-Jun-2003 Chen Yi Initial version       chen_yi2000@sina.com  Chongqing
%14-Jan-2005 Chen Yi update 1003           chenyi2005@gmail.com  Shanghai 
%02-Dec-2009 Chen Yi obsolete
%                     SGA__fitness_MO_evaluating.m
%                     SGA_FITNESS_MO_function.m, use
%                     SGA_FITNESS_function for both single and multi
%                     objective problems
%HISTORY$
%==================================================================================================*/
 

%SGA_FITNESS_function begin

fitness = 0;
N       = 40; % 10000
alpha   = 0.8;



for indx = 1 : 1 : length(X)
    
%%%%%%%%%%%%%%%%%%%%%%% Single objective %%%%%%%%%%%%%%%%%%%%%%%
    fitness = fitness + X(indx).*Y(indx)/(Z(indx) + alpha.*(N - Z(indx) ));
    
end

%%%%%%%%%%%%%%%%%%%%%%% Multi objectives %%%%%%%%%%%%%%%%%%%%%%%
%fitness = [ fitness, 1./fitness];

%SGA_FITNESS_function end
