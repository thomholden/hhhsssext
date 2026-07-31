function response = ActiveOrders(varargin)
    % Get the active orders
    % Properties: 
    % parameter 	oblig? 	description 	it takes up values 	standard value
    % pair 	No 	the pair to display the orders 	btc_usd (example) 	all pairs
    
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

    method = 'ActiveOrders';
    response = btce_call(method,params);
end