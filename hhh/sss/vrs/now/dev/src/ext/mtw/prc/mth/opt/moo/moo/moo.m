%% Simple EMOO problem
% The objective is to find the pareto front of the MOO problem defined as follows:
% Maximize:
% f1(X) = 2*x1 + 3*x2
% f2(X) = 2/x1 + 1/x2
%   such that:
%     10 > x1 > 20
%     20 > x2 > 30
%
% Author: Wesam Elshamy
%
% PhD candidate, Kansas State University
%
% welshamy@ksu.edu
%
% http://cis.ksu.edu/~welshamy
%%

clear;
clc;

% Define parameters
iterations = 500;
population_size = 500;
mutation_rate = 0.02;
crossover_rate = 0.3;
population = zeros(population_size,3);

% Initialize population within constraints
for i = 1 : population_size
    x1 = (rand*10 + 10); % x1 value for individual i within range
    x2 = (rand*10 + 20); % x2 value for individual i within range
    population(i,1) = x1;
    population(i,2) = x2;
    population(i,3) = 2*x1 + 3*x2; % f1 value for individual i
    population(i,4) = 2/x1 + 1/x2; % f2 value for individual i
end

% Iterations
for iter = 1 : iterations
    pool = population;
    for i = 1 : population_size
        % -------------- crossover ----------------
        if (rand < crossover_rate)
            parent1 = pool(randi(size(pool,1)),:); % randomly select parent1
            parent2 = pool(randi(size(pool,1)),:); % randomly select parent2
            child1 = [parent1(1) parent2(2) zeros(1,2)];
            child2 = [parent1(2) parent2(1) zeros(1,2)];
            pool = [pool; child1; child2];
        end
        
        % -------------- mutation ------------------
        if (rand < mutation_rate)
            individual = pool(randi(size(pool,1)),:); % randomly select individual from pool
            bit = randi(2); % select gene to mutate
            if (bit == 1)
                individual(1) = rand*10 + 10; % value of mutation respects x1 constraints
            else
                individual(2) = rand*10 + 20; % value of mutation respects x2 constraints
            end
            individual(3:4) = zeros(1,2); % assign temporary fitness of zeros
            pool = [pool; individual]; % add individual to pool
        end
    end
    
    % fitness evaluation of the new individuals
    for i = population_size+1 : size(pool,1)
        pool(i,3) = 2*x1 + 3*x2;
        pool(i,4) = 2/x1 + 1/x2;
    end
    
    temp_pop = [];
    % select non dominated individuals to start next iteration with
    for i = 1 : size(pool,1)
        dominated = false;
        for j = 1 : size(pool,1)
            if (pool(i,3)<pool(j,3) && pool(i,4)<pool(j,4)) % if individual i is dominated by individual j
                dominated = true;
                break; % break and go to next individual
            end
        end
        if (~dominated) % if individual not dominated
            temp_pop = [temp_pop; pool(i,:)]; % add it to the pool
            if (size(temp_pop,1) == population_size) % Have enough individuals to fill populatino array?
                break;
            end
        end
    end
    population = temp_pop;
end

% visualization of the results
disp('x1 and x2 values for non-dominated solutions:')
disp(population(:,[1,2]))
f = population(:,[3,4]); % store f1 and f2 values for the population in f
plot(f(:,1), f(:,2), 'x'); % plot the Pareto front
title({'Pareto front of: Max:', 'f_1(X) = 2x_1 + 3x_2', 'f_2(X) = 2/x_1 + 1/x_2'});
xlabel('f_1(X)');
ylabel('f_2(X)');








