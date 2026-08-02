function r = conta(aux,f)
% PURPOSE: determine number of non-f elements in polynomial
% ------------------------------------------------------------
% SYNTAX: r = conta(aux,f);
% ------------------------------------------------------------
% OUTPUT: r: 1x1 number of non-f elements in aux
% ------------------------------------------------------------
% INPUT: aux: polynomial of unknown length
%        f: selected value for comparison
% ------------------------------------------------------------

% written by:
% Enrique M. Quilis
%  D.G. del Tesoro
%  Paseo del Prado, 6. Office 4.1-3.
%  28014 - Madrid (SPAIN)
%  <equilis@tesoro.meh.es>

% Version 1.1 [August 2006]

r=0;
u=length(aux);
for i=1:u
   if (aux(i) ~= f);
      r=r+1;
   end
end

      