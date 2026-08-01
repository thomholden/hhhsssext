% VectorGA is a vectorized implementation of a Genetic Algorithm in Matlab
% version 1.01
% Copyright (C) 2007  Keki Burjorjee
% 
% Created and tested under Matlab 7 (R14). 
%

% If a parameter is passed to the vectorGA function, it is used to set the
% seed of the random number generator. Otherwise, the seed is made to be
% dependent upon the system clock. 
% Sample usage: vectorGA(), vectorGA(27463)
% In the current configuration the fitness function is onemax

function vectorGA(varargin)
len=64                  % The length of bitstrings
popSize=600             % The size of the population
maxGens=300             % The maximum number of maxGens allowed for a run
probCrossover=1         % The probability of crossing over. 
                        % (Note: 1-probCrossover is the probability of
                        % reproduction without crossover)
probMutation=.5/len     % The mutation probability (per bit)
sigmaScalingFlag=1      % Sigma Scaling is described on pg 168 of M. Mitchell's
                        % GA book. It often improves GA performance.
sigmaScalingCoeff=2     % Higher values => less fitness pressure 
linkageCoeff=1-1/len    % This is the probability that some bit will have
                        % the same value as the preceeding bit in a 
                        % crossover mask. linkageCoeff should be a
                        % value between 1/2 and 1-1/len. A value of 1/2
                        % indicates
                        % uniform crossover. Higher values generate fewer
                        % crossover points. A value of 1-1/len
                        % generates crossover masks such that the expected 
                        % number of crossover points is 1. A value of
                        % 1-2/len generates crossover masks such that the
                        % expected number of crossover points is 2, and so
                        % on
                

% If a parameter was passed to the vectorGA function, it is used to set the
% seed of the random number generator. Otherwise, the seed is made to be
% dependent upon the system clock
if size(nargin==1)
    rand('state',varargin{:});
else
    rand('state',sum(100*clock));
end
    
% the population is a popSize by len matrix of randomly generated boolean
% values
pop=rand(popSize,len)<.5;
logLinkageCoeff=log(linkageCoeff);
for gen=0:maxGens
    
    for i=1:popSize
        fitnessVals(i)=oneMax(pop(i,:));
    end
    
    %obtain the fitness value and index of the fittest individual 
    [maxFitness, maxIndex]=max(fitnessVals);
    
    %%%%%%%%%%%%%%% display population information
    % create a string of the bestIndividual
    bestIndiv=[];
    for i=1:len
        bestIndiv=[bestIndiv num2Str(pop(maxIndex,i))];
    end
    
    % display the generation number, the average Fitness of the population,
    % the maximum fitness of an individual in the population, and an 
    % individual with the maximum fitness
    display(['gen=' num2str(gen,'%.3d') '   avgFitness=' ...
        num2str(mean(fitnessVals),'%3.3f') '   maxFitness=' ...
        num2str(maxFitness,'%.3d') '  bestIndiv=' bestIndiv]);
    
    % if sigma scaling is on then perform it
    if(sigmaScalingFlag)
        sigma=std(fitnessVals);
        if sigma~=0;
            fitnessVals=1+(fitnessVals-mean(fitnessVals))/...
            (sigmaScalingCoeff*sigma);
            fitnessVals(fitnessVals<=0)=realmin;
        else
            fitnessVals=1;
        end
    end        
    
    % Normalize the fitness values and then create an array with the 
    % cumulative normalized fitness values (the last value in this array
    % will be 1)
    cumNormFitnessVals=cumsum(fitnessVals/sum(fitnessVals));
    
    % Preallocate an array for the post-selection population 
    newPop=zeros(popSize,len);
    % Perform fitness proportional selection using Stochastic Universal
    % Sampling
    SUSMarkers=rand(1,1)+[1:popSize]/popSize;
    gt1=SUSMarkers>1;
    SUSMarkers(gt1)=SUSMarkers(gt1)-1;
    [temp newPopIndices]=histc(SUSMarkers,[0 cumNormFitnessVals]);
    pop=pop(newPopIndices,:);

    %%%%%%%%%%%%%%% Perform uniform recombination and reproduction    
    % generate pairs of mating indices
    matingIndices=ceil(rand(popSize,2)*popSize);
    % create a new population using the first mate from each mating pair
    newPop=pop(matingIndices(:,1),:);
    % create a new population using the second mate from each mating pair
    secondMate(:,:)=pop(matingIndices(:,2),:);
    % create crossover masks for the entire population
    logRandNums=log(rand(1,popSize*len));
    bitValue=0;
    randNumCtr=1;
    tempMasks=zeros(1,popSize*len);
    ctr=1;
    while ctr<=popSize*len
      tempMasks(1,ctr:ctr+ceil(logRandNums(randNumCtr)/logLinkageCoeff)-1)=...
        bitValue;
      ctr=ctr+ceil(logRandNums(randNumCtr)/logLinkageCoeff);
      randNumCtr=randNumCtr+1;
      bitValue=rem(bitValue+1,2);
    end
    masks=reshape(tempMasks(1,1:popSize*len),len,popSize)';
    % generate an array of booleans indicating which first mates to leave 
    % untouched
    reprodIndices=rand(popSize,1)<1-probCrossover;
    masks(reprodIndices,:)=false;
    % implement uniform recombination with reproduction
    newPop(logical(masks))=secondMate(logical(masks));
    % implement mutation
    masks=rand(popSize,len)<probMutation;
    pop=xor(newPop,masks);    
end


% onemax
function fitness=oneMax(chromosome)
    fitness=sum(chromosome);

% The royal roads function. The chromosome length (i.e. len) 
% should be a multiple of 8
function fitness=royalRoads(chromosome)
chr=reshape(chromosome,8,length(chromosome)/8);
temp=sum(chr);
temp2=double(temp==8);
fitness=sum(temp2);

    





