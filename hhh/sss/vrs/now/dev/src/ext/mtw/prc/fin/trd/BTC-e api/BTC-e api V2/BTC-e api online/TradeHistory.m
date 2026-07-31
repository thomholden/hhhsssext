function response = TradeHistory(varargin)
    % Get the trade history
    % Properties:    
    % from 	No 	the number of the transaction to start displaying with 	numerical 	0
    % count 	No 	the number of transactions for displaying 	numerical 	1000
    % from_id 	No 	the ID of the transaction to start displaying with 	numerical 	0
    % end_id 	No 	the ID of the transaction to finish displaying with 	numerical 	?
    % order 	No 	sorting 	ASC or DESC 	DESC
    % since 	No 	when to start the displaying 	UNIX time 	0
    % end 	No 	when to finish the displaying 	UNIX time 	?
    % pair 	No 	the pair to show the transactions 	btc_usd (example) 	all pairs
    
    in.from = '';
    in.count = '';
    in.from_id = '';
    in.end_id = '';
    in.order = '';
    in.since = '';
    in.end = '';
    in.pair = '';
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

    method = 'TradeHistory';
    response = btce_call(method,params);
end