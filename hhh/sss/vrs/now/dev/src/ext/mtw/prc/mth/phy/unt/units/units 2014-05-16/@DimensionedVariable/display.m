function display(v)
NDimensions = length(v.names);
numString = '';
denString = '';
for nd = 1:NDimensions
    currentExp = v.exponents(nd);
    [n,d] = rat(currentExp);
    if currentExp > 0 % Numerator
        if(d==1)
            if currentExp == 1
                numString = sprintf('%s[%s]',numString,v.names{nd});
            else
                numString = sprintf('%s[%s^%g]',...
                    numString,v.names{nd},currentExp);
            end
        else
            numString = sprintf('%s[%s^(%g/%g)]',...
                numString,v.names{nd},n,d);
        end
    elseif currentExp < 0 %Denominator
        if(d==1)
            if currentExp == -1
                denString = sprintf('%s[%s]',denString,v.names{nd});
            else
                denString = sprintf('%s[%s^%g]',...
                    denString,v.names{nd},-currentExp);
            end
        else
            denString = sprintf('%s[%s^(%g/%g)]',...
                denString,v.names{nd},-n,d);
        end
    end
end

% Trim brakets for lonely terms (alts 1 and 2)
if 1 == nnz(sign(v.exponents) == 1)
    numString = numString(2:end-1);
end
if 1 == nnz(sign(v.exponents) == -1)
    denString = denString(2:end-1);
end
if isempty(numString)
    numString = '1'; %2013-07-19/Sartorius: added this if block.
end


% Alternative 1 (my favorite):
fprintf('\n%s =\n\n',inputname(1))
disp(v.value)
if isempty(denString)
    fprintf('\t\t %s\n', numString);
else
    numLength = length(numString);
    denLength = length(denString);
    barLength = max(numLength,denLength);
    hbar = repmat('-',1,barLength);
    
    numBuffer = repmat(' ',1,max(0,floor((denLength-numLength)/2)));
    numString = [numBuffer numString];
    
    denBuffer = repmat(' ',1,max(0,floor((-denLength+numLength)/2)));
    denString = [denBuffer denString];

    fprintf('\t\t%s\n\t\t%s\n\t\t%s\n\n',numString,hbar,denString);

end


% %% Alternative 2:
% if isempty(denString)
%     fprintf('\n%s = %s × \n\n',inputname(1),numString)
% else
%     numLength = length(numString);
%     denLength = length(denString);
%     barLength = max(numLength,denLength);
%     hbar = [repmat('-',1,barLength) ' ×'];
%     
%     numBuffer = repmat(' ',1,max(0,floor((denLength-numLength)/2)));
%     numString = [numBuffer numString];
%     
%     denBuffer = repmat(' ',1,max(0,floor((-denLength+numLength)/2)));
%     denString = [denBuffer denString];
%     
%     buffer = repmat(' ',1,length(inputname(1))+3);
%     
%     fprintf('\n%s%s\n%s = %s\n%s%s\n\n',...
%         buffer,numString,inputname(1),hbar,buffer,denString);
% %     fprintf('\n%s = %s\n%s%s\n%s%s\n\n',...
% %         inputname(1),numString,buffer,hbar,buffer,denString);
% end
% disp(v.value)

% %% Alternative 3:
% fprintf('\n%s =\n\n',inputname(1))
% disp(v.value)
% pretty(sym([numString '/' denString]))

% 2013-07-15/Sartorius: modified whole display function
% 2013-09-19/Sartorius: took care of problem displaying units with no
%   denominator, e.g. Hz
