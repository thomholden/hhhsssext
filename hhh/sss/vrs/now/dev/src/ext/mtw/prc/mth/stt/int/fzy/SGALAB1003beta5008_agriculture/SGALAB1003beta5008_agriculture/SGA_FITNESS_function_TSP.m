function [ fitness ] = SGA_FITNESS_function_TSP(  path_array , TSP_cost_matrix)

% /*M-FILE FUNCTION SGA_FITNESS_function_TSP MMM SGALAB */ %
% /*==================================================================================================
%  Simple Genetic Algorithm Laboratory Toolbox for Matlab 7.x
%
%  Copyright 2007 The SxLAB Family - Yi Chen - chenyi2005@gmail.com
% ====================================================================================================
%
%File description:
%
%        to define the fitness function for TSP
%
%Input:
%            path_code_string --  is the decimal space pool
%            TSP_cost_matrix  -- TSP_cost_matrix is the cost list given as an
%                            initial condition ,
%                            in TSP_cost_matrix:
%                            a(i,j) is the travelling cost from city i to city j
%                            (1) if there is no path from city i to city j, a(i,j) = NaN
%                            (2) if from i to j  , a(i,j) =  xxx.xx ( > 0 )
%                                if from j to i  , a(i,j) = -xxx.xx ( < 0 ) and a(j,i) = xxx.xx( >0 )
%                            (3) if i = j , in same city a(i,i)  = 0
%Output:
%          fitness--     is the fitness value, fitness is to get MAX value
%
%Appendix comments:
%
%Example:
% path_array      = [ 2 5 3 4 1]
%             TSP_cost_matrix = [ 0 1 1 1   1;
%                                 1 0 1 1   3;
%                                 1 1 0 4 1;
%                                 1 1 1 0   1;
%                                 1 1 1 1   0;
%                                              ];
%    [ fitness ] = SGA_FITNESS_function_TSP( path_array,TSP_cost_matrix )
%
% path_array =
%
%      2     5     3     4     1
%
%
% fitness =
%
%     0.1000
%===================================================================================================
%  See Also:         SGA_FITNESS_function_TSP ,
%                    SGA__TSP_cost_evaluating ,
%
%===================================================================================================
%
%===================================================================================================
%Revision -
%Date        Name    Description of Change email                 Location
%27-Jun-2003 Chen Yi Initial version       chen_yi2000@sina.com  Chongqing
%14-Jan-2005 Chen Yi update 1003           chenyi2005@gmail.com  Shanghai
%HISTORY$
%==================================================================================================*/

%SGA_FITNESS_function_TSP begin

%User can design their own fitness function here in Matlab style

% get traveling cost
path_cost  = SGA__TSP_cost_evaluating( path_array, TSP_cost_matrix );

% fitness is to get max value, and path_cost need min value,
% so we use 1/(cost+eps) , eps is to avoid 1/0
fitness =  1./(path_cost + eps);
%
%SGA_FITNESS_function_TSP end