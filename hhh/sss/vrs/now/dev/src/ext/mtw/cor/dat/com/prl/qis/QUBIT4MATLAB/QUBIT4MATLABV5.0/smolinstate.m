% smolinstate   Gives the four-qubit bound entangled state 
%               defined by Smolin in 
%               http://www.arxiv.org/abs/quant-ph/0001001

function s=smolinstate

f1=kron([1 0 0 1],[1 0 0 1]);
f2=kron([1 0 0 -1],[1 0 0 -1]);
f3=kron([0 1 1 0],[0 1 1 0]);
f4=kron([0 1 -1 0],[0 1 -1 0]);

s=(f1'*f1+f2'*f2+f3'*f3+f4'*f4)/16;