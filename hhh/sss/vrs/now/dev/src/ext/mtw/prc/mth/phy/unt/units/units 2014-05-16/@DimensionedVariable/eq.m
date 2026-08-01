function result = eq(v1,v2)

if compatible(v1,v2)
    result = v1.value == v2.value;
end

% if isa(v1,'DimensionedVariable') && isa(v2,'DimensionedVariable') && ...
%         (max(abs(v1.exponents - v2.exponents))<=v1.exponentsZeroTolerance)
%     
%     result = v1.value == v2.value;
%     
% else
%     error('Unit inconsistency in relational operator.');
% end

% 2014-05-14/Sartorius: new.