function legend_flush_outside(legend_handle, varargin)
% Pushes legend outside on top beneath the title.
%
% legend_flush_outside(legend_handle, 'Location', location_string)
%
% Input:
%   legend_handle
%
% Option:
%   location            'Top' (default)
%                       'TopLeft'
%                       'TopRight'

% Kevin J. Delaney
% March 29, 2013
% May 01, 2013          Move the title up above the legend.
% May 06, 2013          Don't complain if no title.

    %   Default
    location_string = 'Top';
    
    if ~exist('legend_handle', 'var')
        legend_handle = gca;
    end

    if any(isempty(legend_handle))
        return
    end

    if any(~ishandle(legend_handle))
        errordlg('Input "legend_handle" contains an invalid handle.', mfilename);
        return
    end
    
    if num_dims(legend_handle) > 1
        errordlg(['Can only work with one dimension, not ', num2str(num_dims(legend_handle))], ...
            mfilename);
        return
    end
    
    for option_index = 1 : 2 : (length(varargin) - 1)
        option_name = varargin{option_index};
        
        if isempty(option_name) || ~ischar(option_name)
            errordlg('Option name is empty or non-char.', mfilename);
            return
        end
        
        option_value = varargin{option_index + 1};
        
        if isempty(option_value)
            continue
        end
        
        switch lower(option_name)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'location'
                
                if ischar(option_value)
                    location_string = option_value;
                else
                    errordlg('Value accompanying "location" option is non-char.', ...
                             mfilename);
                    return
                end
                

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            otherwise
                errordlg(['Unknown option "', option_name, '".'], mfilename);
                return
        end
    end
    
    for index = 1:length(legend_handle)
        
        %   Get size of this legend.
        legend_position_vector = get(legend_handle(index), 'Position');
        
        %   Find associated axes.
        axes_handles = find_legend_peer(legend_handle(index));

        if isempty(axes_handles) || ~ishandle(axes_handles)
            errordlg('Unable to find peer to this legend.', mfilename);
            return
        end
        
        axes_position_vector = get(axes_handles(1), 'Position');
    
        %   Are there overlaid axes?
        overlaid_axes_handle = find_overlaid_axes(axes_handles);
        
        if ~isempty(overlaid_axes_handle)
            axes_handles(2) = overlaid_axes_handle;
        end
        
        %   Store away for later use.
        arrayfun(@(ah) setappdata(ah, 'OriginalPosition', axes_position_vector), axes_handles);
        
        legend_already_outside = ~box_1_inside_box_2(legend_position_vector, axes_position_vector) && ...
                                 ~boxes_overlap(legend_position_vector, axes_position_vector);

        switch lower(location_string)
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'top'
                %   Shrink axes vertically by legend height.
                if ~legend_already_outside
                    axes_position_vector(4) = axes_position_vector(4) - legend_position_vector(4);
                    set(axes_handles, 'Position', axes_position_vector);
                end

                %   Move the legend so that its bottom edge almost touches the axes' top edge.
                axes_top_limit = axes_position_vector(2) + axes_position_vector(4);
                legend_position_vector(2) = axes_top_limit + 0.01;
            
                %   Center legend.
                legend_position_vector(1) = axes_position_vector(1) + (axes_position_vector(3)/2) + ...
                                            - legend_position_vector(3)/2;
                                        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'topleft'
                %   Shrink axes vertically by legend height.
                if ~legend_already_outside
                    axes_position_vector(4) = axes_position_vector(4) - legend_position_vector(4);
                    set(axes_handles, 'Position', axes_position_vector);
                end

                %   Move the legend so that its bottom edge almost touches the axes' top edge.
                axes_top_limit = axes_position_vector(2) + axes_position_vector(4);
                legend_position_vector(2) = axes_top_limit + 0.01;

                %   Flush with left-hand edge.
                axes_lh_limit = axes_position_vector(1);
                legend_position_vector(1) = axes_lh_limit;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'topright'
                %   Shrink axes vertically by legend height.
                if ~legend_already_outside
                    axes_position_vector(4) = axes_position_vector(4) - legend_position_vector(4);
                    set(axes_handles, 'Position', axes_position_vector);
                end

                %   Move the legend so that its bottom edge almost touches the axes' top edge.
                axes_top_limit = axes_position_vector(2) + axes_position_vector(4);
                legend_position_vector(2) = axes_top_limit + 0.01;

                %   Flush with right-hand edge.
                axes_rh_limit = axes_position_vector(1) + axes_position_vector(3);
                legend_position_vector(1) = axes_rh_limit - legend_position_vector(3);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            otherwise
                errordlg(['Unknown legend position "', location_string, '".'], ...
                         mfilename);
                return
        end
        
        set(legend_handle(index), 'Position', legend_position_vector);        
        
        %   Move the title up above the legend.
        title_handles = arrayfun(@(h) get(h, 'Title'), axes_handles);
        title_empty_syndrome = arrayfun(@(h) isempty(get(h, 'String')), title_handles);
        title_handle = title_handles(~title_empty_syndrome);
    
        if ~isempty(title_handle) && ishandle(title_handle)
            %   The legend is actually its own axes object, whose position is recorded in normalized figure units.
            top_of_legend_figure_units = legend_position_vector(2) + legend_position_vector(4);

            %   But the title object belongs to the axes, and its position is specified in axes units.
            set(title_handle, 'Units', 'normalized');
            title_position_vector = get(title_handle, 'Position');

            %   Store away for later use.
            setappdata(title_handle, 'OriginalPosition', title_position_vector);

            %   Push the axes back to where it should be with a top legend.
            top_of_legend_axes_units = (top_of_legend_figure_units - axes_position_vector(2)) / axes_position_vector(4);
            set(title_handle, 'Position', [title_position_vector(1), top_of_legend_axes_units + 0.01, 0]);
        end
    end
end