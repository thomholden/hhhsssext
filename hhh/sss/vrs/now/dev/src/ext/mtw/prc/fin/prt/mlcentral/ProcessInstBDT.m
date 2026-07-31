
%------------------------
% Process the bond data:
InstSetBDT = instadd('Bond', BondRateBDT(1), BondSettleBDT(1), BondMaturityBDT(1), BondPeriodBDT(1));
for i=2:length(BondNameBDT)
	InstSetBDT = instadd(InstSetBDT, 'Bond', BondRateBDT(i), BondSettleBDT(i), BondMaturityBDT(i), BondPeriodBDT(i));
end

%------------------------
% Process option

% First find option index
BondIndexBDT = strmatch(OptUndBondBDT, BondNameBDT);

% If found, add to portfolio
if ~isempty(BondIndexBDT)
	InstSetBDT = instadd(InstSetBDT, 'OptBond', BondIndexBDT, OptTypeBDT, OptionStrikeBDT, OptExDatesBDT, OptionAmEuBDT);
end

InstSetBDT = instsetfield(InstSetBDT, 'Index',1:4, 'FieldName', {'Name'}, ...
                    'Data',  {'4% Bond'; '5% Bond'; '6% Bond';'Option' });

clear i               