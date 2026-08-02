% Store and retrieve variables
function xBook=fLibrary(sVarName,xVarValue)

persistent stcLibrary

xBook=[];

% If no outputs and two inputs, set variable value
if nargout==0&&nargin==2
    stcLibrary.(sVarName)=xVarValue;
% If one output and one output, get variable name
elseif nargout==1&&nargin==1
    if isfield(stcLibrary,sVarName)
        xBook=stcLibrary.(sVarName);
    else
        fprintf('WARNING:  Variable not found in fLibrary (''%s'')\n\n',...
            sVarName);
    end
% If one output and two outputs, act accordingly (added 130322)
elseif nargout==1&&nargin==2
    switch xVarValue
        case 'no_warning'
            if isfield(stcLibrary,sVarName)
                xBook=stcLibrary.(sVarName);
            end
        otherwise
            fprintf('WARNING:  Unrecognized command sent to fLibrary (''%s'')\n\n',...
                xVarValue);
    end

% If one input and no outputs, remove variable from libary
elseif nargout==0&&nargin==1
    if isfield(stcLibrary,sVarName)
        stcLibrary=rmfield(stcLibrary,sVarName);
    else
        %fprintf('NOTE:  Variable not found in fLibrary (''%s'')\n\n',...
        %    sVarName);  % suppress this warning (V2.3.0)
    end    
else
    fprintf('ERROR:  Unexpected input to fLibrary function (''%s'')\n\n',...
            sVarName);
end