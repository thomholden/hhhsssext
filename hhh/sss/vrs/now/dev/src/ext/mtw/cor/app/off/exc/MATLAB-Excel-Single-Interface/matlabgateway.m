function results = matlabgateway( command, in, out )
%MATLABGATEWAY Single point of entry to MATLAB from Excel/VBA subroutines
%
% The aim of this function is to work in conjuction with serve as a common
% gateway into MATLAB for function calls from Excel/VBA, enabling MATLAB to
% be called in the same way with .NET/COM Builder as with Excel Link. The
% VBA code looks something like this:
%
% RunInMATLAB( functionName, inArgs, outArgs )
%
% where functionName is a string specifying the MATLAB command to run,
% inArgs (optional) is an array of strings corresponding to named ranges
% holding the input data and outArgs (optional) is another array of named
% ranges, this time pointing to the upper-left cell of the location into
% which the corresponding output matrix is inserted.
%
% Under the hood, this function is called in two different ways. From Excel
% Link, "in" is a cell array of range names, or just {} of there are no input
% arguments and "out" is a cell array of range names (each pointing to the
% upper-left cell of the block to be written) or {} if no outputs. The
% results of the function call are assigned in the base workspace. The
% inputs are pushed across to MATLAB in VBA then the function is called and
% the outputs are retrieved from the base workspace.
%
% When deployed, this function is called slightly differently. The inputs
% argument "in" is now a cell array of the actual input values which is
% passed to the command directly and "out" is now the number of output
% arguments. The cell array "results" is returned directly and appears as a
% Variant array in VBA.

%   Copyright 2006 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2006/08/17 09:11:48 $

try
    % decide how to run command
    if isdeployed
        % running deployed via COM/.NET Builder. First set up results cell
        results = cell( out, 1 );
        % might have to convert to matrices if numeric
        in = iConvertToNumeric( in );
        % remove empty strings - for the zero input arguments case
        in = iRemoveEmptyStrings( in );
        % then call the function
        [results{:}] = feval( command, in{:} );
        % dress strings in cells
        results = iDressStrings( results );
    else
        % running under Excel link
        if strcmpi( command, 'clearBaseWorkspace' )
            iClearBaseWorkspace( in );
            results = [];
        else
            % grab variables from base workspace
            invals = iAssignFromBase( in );
            % allocate temporary cell to ensure we call the function with the
            % right number of output arguments
            results = cell( 1, length( out ) );
            % call the function
            [results{:}] = feval( command, invals{:} );
            % assign the results in the base workspace
            iAssignInBase( out, results );
        end
    end
catch
    L = lasterror;
    str = [ 'Error in ' L.stack(1).name ', line ' num2str( L.stack(1).line ) ': ' ];
    errordlg( [ str lasterr ] );
end

end % function

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function iClearBaseWorkspace( names )

% remove empty names
togo = [];
for n = 1:length( names )
    if isempty( names{n} )
        togo = [ togo, n ];
    end
end
if ~isempty( togo )
    names(togo) = [];
end

clearStr = 'clear ';
varList = '';
for n = 1:length( names )
    varList = [ varList names{n} ' '];
end

if ~isempty( varList )
    evalin( 'base', [ clearStr varList ] );
end

end % subfunction

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function invals = iAssignFromBase( in )

invals = cell( 1, length( in ) );
for n = 1:length( in )
    invals{n} = evalin( 'base', in{n} );
end

end % subfunction

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function iAssignInBase( out, results )

for n = 1:length( out )
    assignin( 'base', out{n}, results{n} );
end

end % subfunction

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function in = iConvertToNumeric( in )

for n = 1:length( in )
    isCell = iscell( in{n} );
    if all( isCell(:) )
        isNumeric = cellfun( @isnumeric, in{n} );
        if all( isNumeric(:) )
            in{n} = cell2mat( in{n} );
        end
    end
end

end % subfunction

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function in = iRemoveEmptyStrings( in )

in(cellfun( @isempty, in )) = [];

end % subfunction

% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
function results = iDressStrings( results )

for n = 1:length( results )
    if ischar( results{n} )
        results{n} = { results{n} };
    end
end

end % subfunction