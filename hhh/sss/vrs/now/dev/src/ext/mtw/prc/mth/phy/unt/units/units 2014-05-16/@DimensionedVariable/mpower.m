function v = mpower(v,y)
% 

if isa(y,'DimensionedVariable')
    error('Exponent may not be a DimensionedVariable.');
else
    v.value = v.value^y; % ^ will catch if y isn't scalar.
    v.exponents = y*v.exponents;
    
    v = clearcanceledunits(v);
end

% 2014-05-16/Sartorius: reworked.