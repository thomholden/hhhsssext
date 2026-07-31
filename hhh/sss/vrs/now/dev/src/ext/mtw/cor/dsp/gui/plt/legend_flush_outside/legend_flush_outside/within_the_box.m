function boolean = within_the_box(point, box)
% Is the given 2D point inside the given 2D box?
%
% boolean = within_the_box(point, box)
%
% Inputs:
%   point       [x; y]
%   box         [x_left, y_bot, width, height]
%
% Output:
%   boolean     true or false?

% Kevin J. Delaney
% July 6, 2009

    boolean = [];

    if ~exist('point', 'var')
        help(mfilename);
        return
    end

    if isempty(point) || ~isnumeric(point)
        errordlg('Input "point" is empty or non-numeric.', mfilename);
        return
    end

    if length(point) ~= 2
        errordlg(['Input "point" is supposed to have length 2, not ', ...
            num2str(length(point))], mfilename);
        return
    end

    if ~exist('box', 'var') || ...
       isempty(box) || ...
       ~isnumeric(box)
        errordlg('Input "box" is missing, empty or non-numeric.', mfilename);
        return
    end

    if length(box) ~= 4
        errordlg(['Input "box" is supposed to have length 4, not ', ...
            num2str(length(box))], mfilename);
        return
    end

    boolean = (isbetween(point(1), box(1), box(1) + box(3))) && ...
              (isbetween(point(2), box(2), box(2) + box(4)));
end