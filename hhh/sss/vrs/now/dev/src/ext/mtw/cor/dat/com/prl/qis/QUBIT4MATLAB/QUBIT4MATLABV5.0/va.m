% va  Variance of an operator
%    va(op,rho) is the variance of the operator op
%    for the density matrix rho. If rho is not normalized,
%    it is automatically normalized to have trace 1.
%    If instead of rho a state vector is given then it is 
%    automatically converted to a normalized density matrix. 

function v=va(op,rho)
   if min(size(rho))==1,
       % Input is a state vector
       v=bra(rho)*op^2*ket(rho)-(bra(rho)*op*ket(rho))^2;
   else
       % Input is a density matrix
       v=trace(rho*op^2)/trace(rho)-trace(rho*op)^2/trace(rho)^2;
   end %if