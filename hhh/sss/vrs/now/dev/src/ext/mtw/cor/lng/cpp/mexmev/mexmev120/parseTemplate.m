function [str] = parseTemplate(str,varargin)
    for ii = 1:(nargin-1)/2
        arg = varargin{ii*2-1};
        val = varargin{ii*2};
        if isnumeric(val)
            val = num2str(val);
        end
        str = strrep(str,['^' arg '^'],val);
    end
end