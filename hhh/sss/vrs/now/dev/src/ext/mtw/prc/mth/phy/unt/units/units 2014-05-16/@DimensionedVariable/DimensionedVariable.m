classdef DimensionedVariable
    % See also UNITS, U2NUM, UNITSOF, DimensionedVariable.unitslist, 
    %   DimensionedVariable.strconv.
    properties (Access = protected)
        names
        exponents
        exponentsZeroTolerance = 1e-6;
        value = 1;
    end
    
    methods
        function v = DimensionedVariable(dimensionNames,dimensionToCreate)
            % See also UNITS.
            v.names = dimensionNames;
            v.exponents = zeros(size(v.names));
            dimensionIndex = strcmp(v.names,dimensionToCreate);
            v.exponents(dimensionIndex) = 1;
        end
    end
    methods (Static)
        [listString,list] = unitslist(varargin)
        [cTo,cInverse] = strconv(sFrom,sTo,u) % added 2013-10-29/Sartorius
    end
end

%{
% Original version below. New classdef on 2013-07-15/Sartorius

function v = DimensionedVariable(dimensionNames,dimensionToCreate)
% See also UNITS.

v.names = dimensionNames;
v.exponents = zeros(size(v.names));
dimensionIndex = strcmp(v.names,dimensionToCreate);
v.exponents(dimensionIndex) = 1;
v.exponentsZeroTolerance = 1e-6;
v.value = 1;
v = class(v,'DimensionedVariable');
%}