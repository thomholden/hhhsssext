% /*M-FILE SCRIPT SGALAB_DEMO_TSP_13cities MMM SGALAB */ %
% /*==================================================================================================
%  Simple Genetic Algorithm Laboratory Toolbox for Matlab 7.x
%
%  Copyright 2010 The SxLAB Family - Yi Chen - leo.chen.yi@gmail.com
% ====================================================================================================
%File description:
%  main function for TSP 13 cities case.
%
%Appendix comments:
%
%Usage:
%
% We can run SGALAB by key-in "SGALAB_demo_TSP_13cities" in Matlab command window
%
%===================================================================================================
%  See Also:         SGALAB_demo_SO_std
%                    SGALAB_demo_MO_MOGA
%                    SGALAB_demo_MO_NPGA
%                    SGALAB_demo_MO_NSGA
%                    SGALAB_demo_MO_NSGAII
%                    SGALAB_demo_MO_VEGA
%                    SGALAB_demo_TSP_13cities
%
%===================================================================================================
%
%
%===================================================================================================
%Revision -
%Date        Name    Description of Change email                  Location
%27-Jun-2003 Chen Yi Initial version       leo.chen.yi@gmail.com  Chongqing
%14-Jan-2005 Chen Yi update 1003           leo.chen.yi@gmail.com  Shanghai
%02-Dec-2009 Chen Yi update SGA__array_to_matrix
%HISTORY$
%==================================================================================================*/

% SGALAB_demo_TSP_13cities Begin

%% set screen


% fresh
clear all
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
fid1  = fopen('INPUT_TSP_city_number.txt' , 'r' );
fid2  = fopen('INPUT_TSP_start_city_number.txt' , 'r' );
fid3  = fopen('INPUT_probability_crossover.txt' , 'r' );
fid4  = fopen('INPUT_probability_mutation.txt' , 'r' );
fid5  = fopen('INPUT_population.txt' , 'r' );
fid6  = fopen('INPUT_TSP_cost_matrix.txt' , 'r' );
fid7  = fopen('INPUT_max_generation.txt' , 'r' );
fid8  = fopen('INPUT_convergence_method.txt' , 'r' );
fid9  = fopen('INPUT_max_no_change_probability_crossover_generation.txt','r');
fid10 = fopen('INPUT_deta_fitness_max.txt','r');
fid11 = fopen('INPUT_max_probability_crossover.txt','r');
fid12 = fopen('INPUT_probability_crossover_step.txt','r');
fid13 = fopen('INPUT_max_no_change_fitness_generation.txt','r');


%output data files
fid14 = fopen('OUTPUT_min_TSP_cost.txt','w+');
fid15 = fopen('OUTPUT_max_TSP_cost.txt','w+');
fid16 = fopen('OUTPUT_mean_TSP_cost.txt','w+');
fid17 = fopen('OUTPUT_best_TSP_path.txt','w+');
fid18 = fopen('OUTPUT_best_coding_space.txt','w+');
fid19 = fopen('OUTPUT_now_generation.txt','w+');
fid20 = fopen('OUTPUT_now_probability_crossover.txt','w+');

% begin to load data from file

SGALAB_version

SGALAB_status_info

%% read data from these files

% when TSP:
% min_confines -- city_number , e.g. 13 cities
% max_confines -- start_city_number, e.g. we want to start from city 4
% decimal_step -- no need


min_confines = fscanf( fid1 , '%g' ); min_confines = min_confines' ;
%
max_confines = fscanf( fid2 , '%g' ); max_confines = max_confines';


probability_crossover = fscanf( fid3 , '%g' );

probability_mutation = fscanf(fid4,'%g');

population = fscanf( fid5 , '%g' );

TSP_cost_matrix = fscanf( fid6 , '%g' );

[ TSP_cost_matrix ] = SGA__array_to_matrix(TSP_cost_matrix, min_confines);

max_generation = fscanf( fid7 , '%g' );

convergence_method = fscanf( fid8 , '%g' );

max_no_change_probability_crossover_generation = fscanf( fid9 , '%g' );

deta_fitness_max = fscanf( fid10 , '%g' );

max_probability_crossover = fscanf( fid11,'%g' );

probability_crossover_step = fscanf(fid12,'%g');

max_no_change_fitness_generation = fscanf(fid13,'%g');

%       decimal_step = decimal_step' ;

now_probability_crossover = probability_crossover;
%

disp(' >>>>')
disp('End Evaluating, List of results :')

% Step into SGA_entry_TSP_13cities()
options = { 'Literal',
    'tsp_rw',
    'CX',
    'Insertion',
    '0' };

% Output

[ maxfitness ,...
    minfitness ,...
    meanfitness ,...
    now_generation , ...
    now_probability_crossover,...
    best_decimal_space ,...
    best_coding_space ,...
    error_status ]= SGA__entry_TSP...
    ( options,...
    min_confines ,...
    max_confines ,...
    probability_crossover ,...
    probability_mutation ,...
    population ,...
    TSP_cost_matrix , ...
    max_generation ,...
    convergence_method ,...
    max_no_change_probability_crossover_generation ,...
    deta_fitness_max ,...
    max_probability_crossover ,...
    max_no_change_fitness_generation ,...
    probability_crossover_step  );

if ( error_status ~= 0 )  return ;  end

%  [ maxfitness , minfitness , meanfitness , best_decimal_space , now_generation , now_probability_crossover , best_binary_space ] = SGALAB...
%  ( min_confines , max_confines , probability_crossover , probability_mutation , population , TSP_cost_matrix , max_generation , convergence_method , max_no_change_probability_crossover_generation , deta_fitness_max , deta_fitness_max_min , max_probability_crossover , max_no_change_fitness_generation , probability_crossover_step );


%  maxfitness = max( fitness_value )
%  best_decimal_space = decimal_space( max_fitness_temp_position( population ) )

%write data to output files
% fprintf( fid8 , '\n the max value of fitness function:\n' );
fprintf( fid14 , '%f\n' , 1/maxfitness);

%fprintf( fid9, '\n the min value of fitness function:\n');
fprintf( fid15 , '%f\n' ,1/minfitness);

%fprintf(fid10,'\n the mean value of fitness function:\n');
fprintf(fid16,'%f\n',1/meanfitness);

%fprintf( fid11,'\nthe best decimal space(x1 x2 x3...):\n');
fprintf( fid17,'%f\n',best_decimal_space );

fprintf( fid18 , '%f\n' , best_coding_space );

%fprintf( fid12, '\nthe generation number when end GAs:\n' );

fprintf( fid19, '%f\n' , now_generation );

fprintf( fid20, '%f\n' , now_probability_crossover );

%close files
status = fclose( 'all' );

SGALAB_output_info

% timer end
toc

clear all
%  SGA_remove_work_paths

% SGALAB_demo_TSP_13cities End