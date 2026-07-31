function response = TransHistory(varargin)
    % Get the transfer history
    % Properties:
    % fromparameter 	oblig? 	description 	it takes on the values 	standard value
    % from              No      The ID of the transaction to start displaying with 	numerical 	0
    % count             No  	The number of transactions for displaying 	numerical 	1,000
    % from_id           No      The ID of the transaction to start displaying with 	numerical 	0
    % end_id            No      The ID of the transaction to finish displaying with 	numerical 	?
    % order             No      sorting 	ASC or DESC 	DESC
    % since             No      When to start displaying? 	UNIX time 	0
    % end               No      When to finish displaying? 	UNIX time 	?
    %
    % Example:
    % response = TransHistory('count',2)

    in.from = '';
    in.count = '';
    in.from_id = '';
    in.end_id = '';
    in.order = '';
    in.since = '';
    in.end = '';
    params = '';

    if ~isempty(varargin)
        for i = 1:2:numel(varargin)
            prop  = lower(varargin{i});
            value = varargin{i+1};
            if isfield(in,prop)
                params = [params '&' prop '=' num2str(value)];
            else
                error('Unrecognized input to function: %s',prop)
            end
        end
    end

    method = 'TransHistory';
    response = btce_call(method,params);
end