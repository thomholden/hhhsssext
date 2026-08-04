% /*M-FILE SCRIPT SGALAB_demo_SO_mendel MMM SGALAB */ %
% /*==================================================================================================
%  Simple Genetic Algorithm Laboratory Toolbox for Matlab 7.x
%
%  Copyright 2010 The SxLAB Family - Yi Chen - leo.chen.yi@gmail.com
% ====================================================================================================
% File description:
% We can run SGALAB by key-in "SGALAB_demo_SO_mendel" in Matlab command window
%
%Input(1):
%            options[10]:
%                      options(1)-- en-/de-coding method
%                                   'Binary' ,'b' :  binary encoding method
%                                   'Real'   ,'r' :  real number encoding method
%                                   'Literal','l' :  literal permutation encoding method
%                                   'Gray'   ,'g' :  Gray encoding method
%                                   'DNA'    ,'d' :  DNA encoding method
%                                   'Messy'  ,'m'  :  Messy encoding method
%
%                      options(2)-- selection method
%                                    'Roulettewheel', 'Roulette','Wheel','r' : Roulette wheel selection method
%                                    'Stochastic','s'                        : Stochastic selection method
%                                    'TSP_Roulettewheel','tsp_rw','tsprw'    : TSP Roulette wheel selection
%
%                      options(3)-- crossover method
%                                   'singlepoint','single'
%                                   'twopoint','two'
%                                   'N = n','n'
%                                   'random','r'
%                                   'EAX':   Travel Salesman Problem--TSP Operator
%                                            Edge Assembly Crossover( EAX ) is to do
%                                            Edge Recombination Crossover(ERX) With double edge marker,
%                                            Briefly:
%                                                    EAX = ERX + Edge_Marker
%                                    'CX' :         TSP - Cycle Crossover, CX
%                                    'OX' :         TSP - Ordered Crossover operation, OX
%                                    'PMX':         TSP - Partially Matched Crossover, PMX
%                                    'BOOLMATRIX':  TSP - Matrix Representations and Operators
%                      options(4)-- mutation  method
%                                   'singlepoint','single'
%                                   'twopoint','two'
%                                   'N = n','n'
%                                   'random','r'
%                                   'ReciprocalExchange', (Reciprocal
%                                                           Exchange. Swap two cities.)
%                                   'Displacement' , Displacement. Select a
%                                                    subtour and insert it in a random place.
%                                   'Insertion',     Select a city and
%                                                    insert it in a random place
%                                   'Inversion',      Select two points along the permutation, cut it at these points and re-insert the reversed string.
%                                                   	(1 2 | 3 4 5 6 | 7 8 9) ? (1 2 | 6 5 4 3 | 7 8 9)
%                      options(5)-- constraint_status
%                                   'with'    ,'1'--have constraint conditions
%                                   'without' ,'0'--have no constraint
%                                   conditions
%                      options(6)-- Multi-Objects option
%                                   'NON_MO'    -- Non-Multi-Objective problem
%                                   'VEGA'      -- Vector Evaluated Genetic Algorithms,J. D. Schaffer
%                                   'MOGA'      -- Multiobjective Genetic Algorithm (moGA: Fonseca and Fleming, 1993)
%                                   'NSGA'      -- Non-dominated Sorting Genetic Algorithm(NSGA Srinivas, N. and K. Deb -1994 )
%                                   'NSGAII'    -- Non-dominated Sorting Genetic Algorithm - II
%                                   'muGA'      -- Micro-genetic algorithm
%                      options(7)-- Pareto ranking method
%                                   'Goldberg','G'               -- Goldberg's method: rank = rank + 1;
%                                   'Fonceca','Fleming','MO','F' -- Fonceca and Fleming's ranking method
%                                                                   current rank
%                                                                   =  the number of its dominating individulas + 1
%                      options(8)-- Save each generation fitness data
%                                   '1', -- Save; Pareto front neet this
%                                   '0', -- Not Save,only get last results
%                      options(9)-- % mutation switcher, for Micro-GA ONLY
%                                   '1', -- invoke mutation operator
%                                   '0', -- NOT invoke mutation operator
%
%                      options(10)-- accept matrix variables
%                                   '1', -- matrix variables, same initial
%                                           range, dimension is defined in
%                                           INPUT_MATRIX_dimension.txt
%                                   '0', -- matrix variables,
%                                           with different initial values,
%                                   '-1',-- array variable, default,
%                                           no need
%                                           INPUT_MATRIX_dimension.txt
%Appendix comments:
%
%Usage:
%
%===================================================================================================
%  See Also:         SGA_ENCODING ,
%                    SGA_DECODING ,
%                    SGA_SELECTION ,
%                    SGA_CROSSOVER,
%                    SGA_MUTATION,
%                    SGA_FITNESS_FUNCTION,
%                    SGA_FITNESS_EVALUATING,
%                    SGA_BENCHMARK_FUNCS,
%                    SGALAB
%
%===================================================================================================
%
%
%===================================================================================================
%Revision -
%Date        Name    Description of Change  email                 Location
%27-Jun-2003 Chen Yi Initial version        chen_yi2000@sina.com  Chongqing
%14-Jan-2005 Chen Yi update 1003            leo.chen.yi@gmail.com  Shanghai
%28-May-2007,Chen Yi add SGA_FITNESS_plot() leo.chen.yi@gmail.com  Glasgow
%07-Feb-2009 Chen Yi add fitness_data       leo.chen.yi@gmail.com  Glasgow
%15-Oct-2009 Chen Yi add n points crossover
%                    and mutation           leo.chen.yi@gmail.com  Glasgow
%02-Dec-2009 Chen Yi obsolete
%                     SGA__fitness_MO_evaluating.m
%                     SGA_FITNESS_MO_function.m, use
%                     SGA_FITNESS_function for both single and multi
%                     objective problems
%HISTORY$
%==================================================================================================*/

% SGALAB_demo_SO_mendel Begin

%% set screen


% fresh
clear ;
close ('all');
warning off
% to delete old output_*.txt
!del OUTPUT_*.txt
% set working path
%cd SGALAB_Funcs
%      SGA_set_working_paths

%% begin to count time during calculating
home ;
tic % timer start >>

% data preparation

%% open data files

%%%input data files
fid1  = fopen('INPUT_min_confines.txt' , 'r' );
fid2  = fopen('INPUT_max_confines.txt' , 'r' );
fid3  = fopen('INPUT_probability_crossover.txt' , 'r' );
fid4  = fopen('INPUT_probability_mutation.txt' , 'r' );
fid5  = fopen('INPUT_population.txt' , 'r' );
fid6  = fopen('INPUT_steps.txt' , 'r' );
fid7  = fopen('INPUT_max_generation.txt' , 'r' );
fid8  = fopen('INPUT_convergence_method.txt' , 'r' );
fid9  = fopen('INPUT_max_no_change_probability_crossover_generation.txt','r');
fid10 = fopen('INPUT_deta_fitness_max.txt','r');
fid11 = fopen('INPUT_max_probability_crossover.txt','r');
fid12 = fopen('INPUT_probability_crossover_step.txt','r');
fid13 = fopen('INPUT_max_no_change_fitness_generation.txt','r');
fid14 = fopen('INPUT_mendel_number_percent.txt','r');


% Basic math function database
fid15 = fopen('INPUT_AEG_math_function_database.txt','r');

fid22 = fopen('INPUT_tournament_size.txt','r');

%output data files
fid104 = fopen('OUTPUT_bestfitness.txt','w+');
fid105 = fopen('OUTPUT_maxfitness.txt','w+');
fid106 = fopen('OUTPUT_minfitness.txt','w+');
fid107 = fopen('OUTPUT_meanfitness.txt','w+');
fid108 = fopen('OUTPUT_best_result_space.txt','w+');
fid109 = fopen('OUTPUT_best_coding_space.txt','w+');
fid200 = fopen('OUTPUT_now_generation.txt','w+');
fid201 = fopen('OUTPUT_now_probability_crossover.txt','w+');


% begin to load data from file

%% read data from these files
disp('/*==================================================================================================*/')
disp('/*  Simple Genetic Algorithm Laboratory Toolbox (SGALAB) 1.0.0.3 for Matlab 7.x */ ')
disp('');
disp('    15-Oct-2009 Chen Yi update 1003     leo.chen.yi@gmail.com  Glasgow ')
disp('/*==================================================================================================*/')
disp('>>>>')
disp(' Begin to evaluate...Waiting please ...')


min_confines = fscanf( fid1 , '%g' ); min_confines = min_confines' ;

max_confines = fscanf( fid2 , '%g' ); max_confines = max_confines';

probability_crossover = fscanf( fid3 , '%g' ); probability_mutation = fscanf(fid4,'%g');

population = fscanf( fid5 , '%g' );

decimal_step = fscanf( fid6 , '%g' );

max_generation = fscanf( fid7 , '%g' );

convergence_method = fscanf( fid8 , '%g' );

max_no_change_probability_crossover_generation = fscanf( fid9 , '%g' );

deta_fitness_max = fscanf( fid10 , '%g' );

max_probability_crossover = fscanf( fid11,'%g' );

probability_crossover_step = fscanf(fid12,'%g');

max_no_change_fitness_generation = fscanf(fid13,'%g');

mendel_number_percent = fscanf(fid14,'%g'); % [0,1], percent of mendel number

if ( mendel_number_percent > 1 || mendel_number_percent < 0 )
    
    error(' SGALAB_demo_SO_mendel(), mendel_number_percent is in the range of [0,1]');
end

decimal_step = decimal_step' ;

now_probability_crossover = probability_crossover;

% import basic math function database
%   basic_math_func_list_str = fscanf(fid15,'%s');
%
% active tournament selection, 2009-Sep-16
tournament_size = fscanf(fid22,'%g');


disp('End Evaluating, List of results :')

% Step into SGALAB()
options = { 'Binary',
    'tournament',
%                'Roulettewheel', %Roulettewheel, Stochastic, tournament, truncation
    '1' % 1 points crossover, uniformly distributed
    '1',% 1 points mutation , uniformly distributed
    '0',
    'NON_MO'};
% Output

% [ fitness_data ,...
%   now_generation , ...
%   now_probability_crossover,...
%   best_decimal_space ,...
%   best_coding_space ,...
%   error_status ]= SGA_entry_SO_mendel...
% ( options,...
%   min_confines ,...
%   max_confines ,...
%   probability_crossover ,...
%   probability_mutation ,...
%   population ,...
%   decimal_step , ...
%   max_generation ,...
%   convergence_method ,...
%   max_no_change_probability_crossover_generation ,...
%   deta_fitness_max ,...
%   max_probability_crossover ,...
%   max_no_change_fitness_generation ,...
%   probability_crossover_step,...
%   mendel_number_percent );

[ fitness_data ,...
    now_generation , ...
    now_probability_crossover,...
    best_decimal_space ,...
    best_coding_space ,...
    error_status ]= SGA__entry_SO_mendel...
    ( options,...
    min_confines ,...
    max_confines ,...
    probability_crossover ,...
    probability_mutation ,...
    population ,...
    decimal_step , ...
    max_generation ,...
    convergence_method ,...
    max_no_change_probability_crossover_generation ,...
    deta_fitness_max ,...
    max_probability_crossover ,...
    max_no_change_fitness_generation ,...
    probability_crossover_step,...
    mendel_number_percent,...
    tournament_size );

if ( error_status ~= 0 )  return ;  end

%  [ maxfitness , minfitness , meanfitness , best_decimal_space , now_generation , now_probability_crossover , best_binary_space ] = SGALAB...
%  ( min_confines , max_confines , probability_crossover , probability_mutation , population , decimal_step , max_generation , convergence_method , max_no_change_probability_crossover_generation , deta_fitness_max , deta_fitness_max_min , max_probability_crossover , max_no_change_fitness_generation , probability_crossover_step );


%  maxfitness = max( fitness_value )
%  best_decimal_space = decimal_space( max_fitness_temp_position( population ) )

%write data to output files

%   OUTPUT_bestfitness.txt
fprintf( fid104 , '%f\n', fitness_data(1));

%   OUTPUT_maxfitness.txt
fprintf( fid105 , '%f\n', fitness_data(2));

%   OUTPUT_minfitness.txt
fprintf( fid106,  '%f\n', fitness_data(3));

%   OUTPUT_meanfitness.txt
fprintf(  fid107,  '%f\n', fitness_data(4));

%   OUTPUT_best_result_space.txt
fprintf(  fid108,'%f\n', best_decimal_space );

%   OUTPUT_best_coding_space
fprintf(  fid109 , '%f\n' , best_coding_space );

%   OUTPUT_now_generation.txt
fprintf(  fid200, '%f\n' , now_generation );

%   OUTPUT_now_probability_crossover.txt
fprintf(  fid201, '%f\n' , now_probability_crossover );

%close files
status = fclose( 'all' );


disp(' More detail result in text files with " Output_*.txt " ' )
disp('----------------------------------------------------------------------------------------')
result_files = list_current_dir_files ('OUTPUT_*.txt')

disp('----------------------------------------------------------------------------------------')

% timer end
toc

%  SGA_remove_work_paths

% SGALAB_demo_SO_mendel End