function v = scale(v, sf) % added 2014-02-10
%  SCALE(IN, SF) performs a dynamic scaling operation by the scaling
%  factor SF on the input variable IN. 
% 
%   *****Undocumented function.*****
% 
%   See also UNITS.

% TODO: document.

a = 0*v.exponents;
a(1:3) = [1 3 1/2];

v.value = v.value * sf^sum(v.exponents.*a);

