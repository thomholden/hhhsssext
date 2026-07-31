function response = Trade(varargin)
    % Make a trade
    % Properties: 
    % parameter 	oblig? 	description 	it takes up the values 	standard value
    % pair          Yes 	pair                    btc_usd (example) 	-
    % type          Yes 	The transaction type 	buy or sell         -
    % rate          Yes 	The rate to buy/sell 	numerical           -
    % amount        Yes 	The amount which is necessary to buy/sell 	numerical 	-    
    
    in.pair = '';
    in.type = '';
    in.rate = '';
    in.amount = '';
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

    method = 'Trade';
    response = btce_call(method,params);
end