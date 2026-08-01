function [cTo,cInverse] = strconv(sFrom,sTo,u) %#ok<INUSD>
% [cTo,cInverse] = STRCONV(sFrom,sTo,u) finds conversion factor, cTo, that
% converts from the unit indicated by the string sFrom to the unit
% indicated by the string sTo. cInverse is the inverse. Optional input u is
% the units structure.
% 
%   Examples:
%       u = units;
%       DimensionedVariable.STRCONV('MPa/min','(lbf/cm^2)/hr',u)
%       DimensionedVariable.STRCONV('deg/min','1/hr',u)
% 
%   See also UNITS.



if isempty(sFrom) || isempty(sTo)
    if isempty(sFrom) && isempty(sTo)
        cTo = 1;
        cInverse = 1;
        return
    else
        error('If one string is empty, the other must be.')
    end
end

if nargin < 3
    u  = units; %#ok<*NASGU>
    warning(...
        'Provide STRCONV with the units struct to improve performance.')
end

sTo = uer(sTo);
sFrom = uer(sFrom);

cTo = eval(['(' sFrom ')/(' sTo ');']);

if isa(cTo, 'DimensionedVariable')
    error('Incompatible units.')
end

cInverse = 1/cTo;


end


function str = uer(str)
% Prepends 'u.' to valid strings (a letter followed by zero or more
% alphanumeric or underscore.

str = regexprep(str,'([A-Za-z]+\w*)','u.$0');

end