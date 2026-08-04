function[decep]=Deceptive3(vector)

% Deceptive3  Deceptive function introduced by Goldberg  
% f(x) = f_d(x_1,x_2,x_3) + f_d(x_4,x_5,x_6) + ...+  f_d(x_{3m-2},x_{3m-1},x_{3m})

% INPUTS
% vector: set of variables

% OUTPUTS
% decep: Evaluation of the deceptive function

  s=sum(vector);
  if s==3
    decep=1; 
  elseif s==1
    decep=0.8; 
  elseif s==2
    decep=0; 
  else
    decep=0.9;
  end
 return


% Last version 10/10/2005. Roberto Santana (rsantana@si.ehu.es) 
