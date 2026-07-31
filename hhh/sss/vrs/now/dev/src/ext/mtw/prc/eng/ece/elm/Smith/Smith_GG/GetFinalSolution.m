function GetFinalSolution()
global Gr
global Gi
global soln_ind
global CircleSolutions

Gr = CircleSolutions{soln_ind+1}(1);
Gi = CircleSolutions{soln_ind+1}(2);