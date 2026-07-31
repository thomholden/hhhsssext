function boolean = boxes_overlap(box_1, box_2)
% Does box_1 overlap box_2?
%
% boolean = boxes_overlap(box_1, box_2)
%
% Inputs:
%   box_1       [x_left, y_bot, width, height]
%   box_2       [x_left, y_bot, width, height]
%
% Output:
%   boolean     true or false?

% Kevin J. Delaney
% July 6, 2009

    boolean = [];

    if ~exist('box_1', 'var')
        help(mfilename);
        return
    end

    if isempty(box_1) || ~isnumeric(box_1)
        errordlg('Input "box_1" is empty or non-numeric.', mfilename);
        return
    end

    if length(box_1) ~= 4
        errordlg(['Input "box_1" is supposed to have length 4, not ', ...
            num2str(length(box_1))], mfilename);
        return
    end

    if ~exist('box_2', 'var') || ...
       isempty(box_2) || ...
       ~isnumeric(box_2)
        errordlg('Input "box_2" is missing, empty or non-numeric.', mfilename);
        return
    end

    if length(box_2) ~= 4
        errordlg(['Input "box_2" is supposed to have length 4, not ', ...
            num2str(length(box_2))], mfilename);
        return
    end

    %   CCW from SouthWest corner.
    box_1_corners = [box_1(1),            box_1(2); ...
                     box_1(1) + box_1(3), box_1(2); ....
                     box_1(1) + box_1(3), box_1(2) + box_1(4); ....
                     box_1(1)           , box_1(2) + box_1(4)];

    %   Check the four corners of box_1.
    for corner_index = 1:4
        this_point = box_1_corners(corner_index, :);
        boolean = within_the_box(this_point, box_2);

        if boolean
            return
        end
    end

    boolean = false;
end