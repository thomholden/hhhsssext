function[val]=evalfuncdec3(vector)

% evalfuncdec3  Deceptive function introduced by Goldberg  
% f(x) = f_d(x_1,x_2,x_3) + f_d(x_4,x_5,x_6) + ...+  f_d(x_{3m-2},x_{3m-1},x_{3m})

% INPUTS
% vector: set of variables

% OUTPUTS
% val: Evaluation of the deceptive function


NumbVar = size(vector,2);

val = 0;

for i=1:3:NumbVar
   val = val+Deceptive3(vector(i:i+2));
end


% Last version 10/10/2005. Roberto Santana (rsantana@si.ehu.es) 

   