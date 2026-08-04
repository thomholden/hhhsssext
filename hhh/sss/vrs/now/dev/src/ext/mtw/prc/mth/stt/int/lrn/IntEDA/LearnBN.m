
function[bnet] =  LearnBN(NumbVar,Card,SelPop,TypeLearning,MaxParent,epsilon,mwst,star,SCORE,cachesize)
% Learns the Bayesian network from the selected population

% INPUTS
% NumbVar: Number of variables
% SelPop: Selected population (data set for learning the BN
% Card: Vector with the dimension of all the variables. 
% TypeLearning: Type of method used for learning the Bayesian network
%--- TypeLearning = {'pc','ic','pc_cheng','tree','k2t','greedyt'};
% MaxParent: Maximum number of parents for the Bayesian Networks or maximum size of the conditioning set for PC
%---MaxParent = 5;
% epsilon: Epsilon value for the probabilistic independence tests 
%--- epsilon=0.05
% mwst: Parameters for the improved PC algorithm (see BNT structure learning package)
%--- mswt = 1;
% star: Parameters for the improved PC algorithm (see BNT structure learning package)
%--- star = 1;
% SCORE: Type of score used by K2 and greedy BN structure learning algorithms.
%--- SCORE = 'bic', SCORE = 'bayesian', SCORE = 'mutual_info'
% cachesize: Size of the cache for optimizing BN learning 



% OUTPUTS
% bnet: Bayesian network learned from the selected population 

% All nodes are set to be discrete
for i=1:NumbVar 
 nodetype{1,i} = 'tabular';
end

 
switch lower(TypeLearning)
  case {'pc'}
    % PC algorithm
    pdag = learn_struct_pdag_pc('cond_indep_chisquare',NumbVar,MaxParent,SelPop);
    dag = cpdag_to_dag(pdag);
  case {'ic'}
     %IC* latent structure algorithm
    pdag = learn_struct_pdag_ic_star('cond_indep_chisquare',NumbVar,MaxParent,SelPop);
    dag = cpdag_to_dag(pdag);
  case {'pc_cheng'} 
    % PC algorithm as improved by Cheng
    dag = learn_struct_bnpc(SelPop,Card,epsilon,mwst,star);
  case {'tree'}
    % MWST based tree algorithm
    root = fix(rand*NumbVar);
    dag = full(learn_struct_mwst(SelPop,ones(NumbVar,1),Card,nodetype,'mutual_info',root))
  case {'k2t'} 
   %K2 algorithm initialized from a tree dag
    %root = fix(rand*NumbVar);
    %dag = full(learn_struct_mwst(SelPop,ones(NumbVar,1),Card,nodetype,SCORE,root));
    %order = topological_sort(dag);
    order = randperm(NumbVar);
    %dag =  learn_struct_K2(SelPop,Card,order,'max_fan_in',MaxParent,'scoring_fn',SCORE);   
    dag = learn_struct_K2(SelPop,Card,order,'max_fan_in',MaxParent);
  case {'greedyt'} 
    %Greedy based search initialized from a tree dag
    %root = fix(rand*NumbVar)
    %seeddag = full(learn_struct_mwst(SelPop,ones(NumbVar,1),Card,nodetype,SCORE,root))
    cache = score_init_cache(NumbVar,cachesize);
    %dag = learn_struct_gs2(SelPop,'scoring_fn',SCORE,'cache',cache);   
    dag = learn_struct_gs2(SelPop,Card);   
  otherwise
    % MWST based tree algorithm
    root = fix(rand*NumbVar);
    dag = full(learn_struct_mwst(SelPop,ones(NumbVar,1),Card,nodetype,'mutual_info',root));
end,

dag
init_bnet = mk_bnet(dag,Card);
% All nodes are set to be discrete
for i=1:NumbVar 
 init_bnet.CPD{i} = tabular_CPD(init_bnet,i);
end,
bnet = learn_params(init_bnet,SelPop);


 
% Last version 9/27/2005. Roberto Santana (rsantana@si.ehu.es) 