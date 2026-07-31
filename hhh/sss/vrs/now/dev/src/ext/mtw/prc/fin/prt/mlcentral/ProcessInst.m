
%------------------------
% Process the bond data:
InstSet = instadd('Bond', BondRate(1), BondSettle(1), BondMaturity(1), BondPeriod(1));
for i=2:length(BondName)
	InstSet = instadd(InstSet, 'Bond', BondRate(i), BondSettle(i), BondMaturity(i), BondPeriod(i));
end

%------------------------
% Process option

% First find option index
BondIndex = strmatch(OptUndBond, BondName);

% If found, add to portfolio
if ~isempty(BondIndex)
	InstSet = instadd(InstSet, 'OptBond', BondIndex, OptType, OptionStrike, OptionExDates, OptionAmEu);
end

InstSet = instsetfield(InstSet, 'Index',1:4, 'FieldName', {'Name'}, ...
                    'Data',  {'4% Bond'; '5% Bond'; '6% Bond';'Option' });

clear i               