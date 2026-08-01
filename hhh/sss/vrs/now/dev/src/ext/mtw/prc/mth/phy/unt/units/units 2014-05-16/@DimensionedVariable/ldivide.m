function vOut = ldivide(v1,v2)


if ~isa(v2,'DimensionedVariable') % v1 is the DimensionedVariable.
    vOut = v1;
    vOut.value = v1.value.\v2;
    vOut.exponents = - v1.exponents;
    
elseif ~isa(v1,'DimensionedVariable') % v2 is the DimensionedVariable.
    vOut = v2;
    vOut.value = v1.\v2.value;


else % BOTH v1 and v2 are DimensionedVariables.
    vOut = v1;
    vOut.value = v1.value.\v2.value;
    vOut.exponents = v2.exponents - v1.exponents;

    vOut = clearcanceledunits(vOut);
end

% 2014-05-14/Sartorius: Modestly simplified.