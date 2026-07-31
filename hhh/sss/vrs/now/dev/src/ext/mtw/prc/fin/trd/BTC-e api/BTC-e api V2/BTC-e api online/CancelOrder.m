function response = CancelOrder(varargin)
    % Make a trade
    % Properties:
    % parameter 	oblig? 	description 	it takes up the values 	standard value
    % order_id 	Yes 	Order id 	numerical 	-
    
    in.order_id = '';
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

    method = 'CancelOrder';
    response = btce_call(method,params);
end