function[Max,k,BestSolutions]=GassUMDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,InitValues,Complex,ConstraintCheck) 
% Gaussian EDA. Use the univariate and multivariate models to approximate continuous distributions      

% INPUTS
% PopSize: Population size
% NumbVar: Number of variables
% T: Truncation parameter (when T=0, proportional selection is used)
% F: Name of the function that has as an argument a vector or NumbVar variables
% CantGen: Maximum number of generations 
% MaximumFunction:  Maximum of the function that can be used as stop condition when it is known 
% InitValues: (2 X NumbVar) matrix with minimum and maximum values for each variable (this is for initialization) % 
% Complex: Determines whether interactions are considered (Complex=1) or not (Complex = 0, univariate case)
% ConstraintCheck (=1) Checks whether the constraints defined by InitValues are fulfilled
% setting to the maximum value those variables over MAX, and to MIN those that do not reach the minimum
% ConstraintCheck (=0) allows to violate these bounds 

% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation

% EXAMPLE
%[Max,k,BestSolutions]=GassUMDA(300,10,0.5,'sum',20,100,[zeros(1,10);5*ones(1,10)],0,1)
% In this example the maximum of the function sum is search for in the 
% interval [0,5]. There are 10 variables.


k=1;

% Initial random population in the interval of values 
  NewPop = repmat(InitValues(1,:),PopSize,1)+(rand(PopSize,NumbVar).*repmat(InitValues(2,:)-InitValues(1,:),PopSize,1));

 
while( (k==1) | (k<=CantGen & Max(k-1)<MaximumFunction) ) 
      
       Pop=NewPop;
       
       % Population is evaluated using function F 
       for i=1:PopSize
        FunVal(i) = feval(F,Pop(i,:));
       end
       
       % Solutions are sorted according to the function value 
       [Val,Ind]= sort(FunVal);
  
       Max(k) = Val(PopSize);   %Maximum value of the population
       BestSolutions(k,:) = Pop(Ind(PopSize),:); % Best solution 

       
    if T==0   
       %Proportional selection is applied
       [Index]=PropSelection(PopSize,FunVal);
       SelPop=Pop(Index,:);       
    else 
       % Truncation selection is applied
       SelPop=Pop(Ind(PopSize:-1:PopSize-floor(T*PopSize)+1),:);
    end   
    
    % The probabilistic model is calculated 
       vars_mean = mean(SelPop);   % mean vector
       vars_cov = cov(SelPop);    %  covariance matrix 
    
    % The new population is calculated sampling from the model according to its complexity   
    if Complex==0
       vars_sigmas = sqrt(diag(vars_cov))';
       NewPop =  normrnd(repmat(vars_mean,PopSize,1),repmat(vars_sigmas,PopSize,1));	 
    else
       NewPop = mvnrnd(vars_mean,vars_cov,PopSize); 
    end
    
    % Fix the  maximum and  minimum values
    if (ConstraintCheck==1)
       for i=1:NumbVar,
          under_val = find(NewPop(:,i)<InitValues(1,i));
          NewPop(under_val,i) = InitValues(1,i);
          over_val = find(NewPop(:,i)>InitValues(2,i));
          NewPop(over_val,i) = InitValues(2,i);
       end   
    end
    
    k=k+1;       
end


return 
    
% Last version 9/22/2005. Roberto Santana (rsantana@si.ehu.es) 