function boolean = box_1_inside_box_2(varargin)
% Is box_1 completely inside box_2?
%
% boolean = box_1_inside_box_2(y_limits_1, long_limits_1, y_limits_2, long_limits_2)
%
% Inputs:
%   lat_limits_1            [bottom_latitude, top_latitude]
%   long_limits_1           [left_longitude,  right_longitude]
%   lat_limits_2            [bottom_latitude, top_latitude]
%   long_limits_2           [left_longitude,  right_longitude]
%
%                      -- OR --
%
% boolean = box_1_inside_box_2(box_1, box_2)
%
% Inputs:
%   box_1                   [x, y, xwidth, ywidth]
%   box_2                   [x, y, xwidth, ywidth]
%
% Output:
%   boolean     true or false?

% Kevin J. Delaney
% July 3, 2011
% May 01, 2013          Add two-input version.

    boolean = [];

    switch length(varargin)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 0
            help(mfilename);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 2
            box_1 = varargin{1};
            box_2 = varargin{2};
                       
            if isempty(box_1) || ~isnumeric(box_1)
                errordlg('Input "box_1" is empty or non-numeric.', mfilename);
                return
            end

            if length(box_1) ~= 4
                errordlg(['Input "box_1" is supposed to have length 4, not ', ...
                    num2str(length(box_1))], mfilename);
                return
            end
            
            x_limits_1 = box_1(1) + [0, box_1(3)];
            y_limits_1 = box_1(2) + [0, box_1(4)];

            if isempty(box_2) || ~isnumeric(box_2)
                errordlg('Input "box_2" is empty or non-numeric.', mfilename);
                return
            end

            if length(box_2) ~= 4
                errordlg(['Input "box_2" is supposed to have length 4, not ', ...
                    num2str(length(box_2))], mfilename);
                return
            end

            x_limits_2 = box_2(1) + [0, box_2(3)];
            y_limits_2 = box_2(2) + [0, box_2(4)];

            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 4
            y_limits_1 = varargin{1};
            y_limits_2 = varargin{2};
            x_limits_1 = varargin{3};
            x_limits_2 = varargin{4};
            
            if isempty(y_limits_1) || ~isnumeric(y_limits_1)
                errordlg('Input "y_limits_1" is empty or non-numeric.', mfilename);
                return
            end

            if length(y_limits_1) ~= 2
                errordlg(['Input "y_limits_1" is supposed to have length 2, not ', ...
                    num2str(length(y_limits_1))], mfilename);
                return
            end

            if isempty(x_limits_1) || ...
               ~isnumeric(x_limits_1)
                errordlg('Input "x_limits_1" is empty or non-numeric.', mfilename);
                return
            end

            if length(x_limits_1) ~= 2
                errordlg(['Input "x_limits_1" is supposed to have length 2, not ', ...
                    num2str(length(x_limits_1))], mfilename);
                return
            end

            if ~exist('y_limits_2', 'var') || ...
               isempty(y_limits_2) || ...
               ~isnumeric(y_limits_2)
                errordlg('Input "y_limits_2" is missing, empty or non-numeric.', mfilename);
                return
            end

            if length(y_limits_2) ~= 2
                errordlg(['Input "y_limits_2" is supposed to have length 2, not ', ...
                    num2str(length(y_limits_2))], mfilename);
                return
            end

            if isempty(x_limits_2) || ...
               ~isnumeric(x_limits_2)
                errordlg('Input "x_limits_2" is empty or non-numeric.', mfilename);
                return
            end

            if length(x_limits_2) ~= 2
                errordlg(['Input "x_limits_2" is supposed to have length 2, not ', ...
                    num2str(length(x_limits_2))], mfilename);
                return
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        otherwise
            errordlg('Unexpected number of inputs.', mfilename);
    end
    
    boolean = isbetween(y_limits_1(1), y_limits_2) && ...
              isbetween(y_limits_1(2), y_limits_2) && ...
              isbetween(x_limits_1(1), x_limits_2) && ...
              isbetween(x_limits_1(2), x_limits_2);
end