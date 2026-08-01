
% usage:  >ds(method,fnc,mydata,popsize,dim,low,up,maxcycle)

% method
% 1: Bijective DSA
% 2: Surjective DSA
% 3: Elitist DSA (strategy 1)
% 4: Elitist DSA (strategy 2)
% methods:   Hybrid-DSA --> H-DSA;  method=[1 2] for B-DSA and S-DSA hybridization.

RECOMMENDED METHODS ARE 1,2, and [1 2].

%----------------------------------------------------------
% constrained optimization
low =[ 2.6 0.7 17 7.3 7.8 2.9 5   ];
up = [ 3.6 0.8 28 8.3 8.3 3.9 5.5 ];
dim = 7;
ds(1,'speedreducer',[],30,dim,low,up,1000)
% or
ds([1 2 3],'speedreducer',[],30,dim,low,up,1000);  % H-DSA
%----------------------------------------------------------
% examples of bounded-problems. 
% example 2:  rosenbrock 
ds(2,'rosenbrock',[],30,30,-30,30,100e3)
%----------------------------------------------------------
% example 3: step2  
ds(1,'step2',[],30,30,-100,100,100e3)
%----------------------------------------------------------
% example 4: weierstrass
ds(1,'weierstrass',[],30,30,-10,10,100e3)
or
ds([1 2],'weierstrass',[],30,30,-10,10,100e3);   % H-DSA
%----------------------------------------------------------






