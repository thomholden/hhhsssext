classdef minesweeper < handle
    
    properties
        fh
        ncols
        nrows
        nmines
        sprite_tc
        minefield
        neighbors
        clickfield
        flagfield
        cellon
        blockon
        smileyon
        timeelapsed
        borders
        smileys
        neighbor_nums
        button_images
        numbers
    end
    
    properties (Constant)
        difficulties = [9  9 10; 16 16 40; 16 30 99]
    end
    
    methods
        
        function obj = minesweeper( nrows, ncols, nmines )
            
            % If the user forgot some inputs
            if nargin < 3, nmines = 40; end
            if nargin < 2, ncols = 16; end
            if nargin < 1, nrows = 16; end
            
            % Default run
            if nargin == 0
                if exist( 'minesweeper.mat', 'file' ) && ...
                        ismember( 'state', who('-file','minesweeper.mat') )
                    load( 'minesweeper.mat', 'state' );
                    nrows = state(1); %#ok<NODEF>
                    ncols = state(2);
                    nmines = state(3);
                end
            end
            
            obj.nmines = nmines;
            obj.ncols = ncols;
            obj.nrows = nrows;
            
            % Enforce minimum colsize
            obj.ncols = max( obj.ncols, 8 );
            
            % Save the state to a file
            state = [ obj.nrows, obj.ncols, obj.nmines ]; %#ok<NASGU>
            if exist( 'minesweeper.mat', 'file' )
                save( 'minesweeper.mat', 'state', '-append' );
            else
                save( 'minesweeper.mat', 'state' );
            end
            
            % Start a new game
            obj.generate_minefield;
            obj.neighbors = obj.generate_neighbors( obj.minefield );
            obj.clickfield = false( obj.nrows, obj.ncols );
            obj.flagfield = false( obj.nrows, obj.ncols );
            obj.cellon = false;
            obj.blockon = false;
            obj.smileyon = false;
            obj.timeelapsed = 0;
            
            % Disassemble the sprite
            sprite = imread( 'minesweeper.gif' );
            sprite_info = imfinfo( 'minesweeper.gif' );
            obj.sprite_tc = reshape( sprite_info.ColorTable( sprite+1, : ), [ size( sprite ), 3 ] );
            
            % Numbers for Counters
            obj.numbers = cell( 1, 11 );
            for n = 0:10
                obj.numbers(n+1) = {obj.sprite_tc(1:23,n*13+(1:13),:)};
            end
            
            % NeighborNums (for cells)
            obj.neighbor_nums = cell( 1, 9 );
            for n = 0:8
                obj.neighbor_nums(n+1) = {obj.sprite_tc(24:39,n*16+(1:16),:)};
            end
            
            % ButtonImages (for cells)
            obj.button_images = cell( 1, 7 );
            for n = 0:6
                obj.button_images(n+1) = {obj.sprite_tc(40:55,n*16+(1:16),:)};
            end
            
            % Smileys for the Reset Button
            obj.smileys = cell( 1, 5 );
            for n = 0:4
                obj.smileys(n+1) = {obj.sprite_tc(56:81,n*26+(1:26),:)};
            end
            
            % Borders
            obj.borders = cell( 1, 4 );
            obj.borders(1) = {obj.sprite_tc(82:91,1:10,:)};
            obj.borders(2) = {obj.sprite_tc(82:91,11:20,:)};
            obj.borders(3) = {obj.sprite_tc(82:91,21:30,:)};
            obj.borders(4) = {obj.sprite_tc(82:91,31:40,:)};
            obj.borders(5) = {obj.sprite_tc(82:91,41:56,:)};
            obj.borders(6) = {obj.sprite_tc(82:91,57:66,:)};
            obj.borders(7) = {obj.sprite_tc(82:91,67:76,:)};
            obj.borders(8) = {obj.sprite_tc(40:55,135:144,:)};
            obj.borders(9) = {obj.sprite_tc(40:71,135:144,:)};
            
            obj.fh = obj.build_gui_image;
            
        end
        
        %% Subfunctions
        
        % Build the GUI
        function fh = build_gui_image( obj )
            
            % Create the figure and the axis
            fh = figure( 'Color', obj.sprite_tc(30,9,:), ...
                'Position', [ 0 0 obj.ncols*16+19 obj.nrows*16+30+32 ], ...
                'MenuBar', 'figure', ...
                'ToolBar', 'none', ...
                'CreateFcn', 'movegui center', ...
                'Name', 'Minesweeper', ...
                'NumberTitle', 'off', ...
                'WindowButtonUpFcn', @obj.buttonup, ...
                'WindowButtonMotionFcn', @obj.buttonmotion, ...
                'Resize', 'off', ...
                'DockControls', 'off', ...
                'DeleteFcn', @obj.deletefcn );
            ax = axes( 'Parent', fh, ...
                'XLim', [-9 obj.ncols*16+10-1], ...
                'YLim', [1-10-32-10 obj.nrows*16+10-1], ...
                'Units', 'Normalized', ...
                'Position', [0 0 1 1] );
            axis ij; axis image; axis off; hold( ax, 'on' );
            
            % Change the icon
            warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
            jframe=get(fh,'javaframe');
            jIcon=javax.swing.ImageIcon('minesweeper_icon.jpg');
            jframe.setFigureIcon(jIcon);
            
            % Determine the difficulty from the inputs
            difficulty = find( all( bsxfun( @eq, obj.difficulties, [ obj.nrows obj.ncols obj.nmines ] ), 2 ) );
            checked = { 'off' 'off' 'off' 'off' };
            if ~isempty( difficulty )
                checked( difficulty ) = {'on'};
            else
                checked( 4 ) = {'on'};
            end
            
            % Generate the menubar
            set( fh, 'MenuBar', 'none' );
            mb.game = uimenu( 'Parent', fh, 'Label', 'Game' );
            mb.new  = uimenu( mb.game, 'Label', 'New', ...
                'Accelerator', 'N', ...
                'Callback', @obj.changedifficulty );
            mb.beg  = uimenu( mb.game, 'Label', 'Beginner', ...
                'Separator', 'on', ...
                'Checked', checked{1}, ...
                'Callback', @obj.changedifficulty );
            mb.int  = uimenu( mb.game, 'Label', 'Intermediate', ...
                'Checked', checked{2}, ...
                'Callback', @obj.changedifficulty );
            mb.exp  = uimenu( mb.game, 'Label', 'Expert', ...
                'Checked', checked{3}, ...
                'Callback', @obj.changedifficulty );
            mb.cus  = uimenu( mb.game, 'Label', 'Custom...', ...
                'Checked', checked{4}, ...
                'Callback', {@obj.changedifficulty} );
            uimenu( mb.game, 'Label', 'Best Times...', ...
                'Separator', 'on', ...
                'Callback', @obj.leaderboard_show );
            uimenu( mb.game, 'Label', 'Exit', ...
                'Separator', 'on', ...
                'Callback', sprintf('close %d', fh) );
            mb.help = uimenu( 'Parent', fh, 'Label', 'Help' );
            uimenu( mb.help, 'Label', 'About', ...
                'Callback', sprintf('helpdlg(sprintf(''Created by Microsoft\\n(microsoft.com)\\nCoded by @bmtran\\n(bmtran.com)\\nImages by Emmett Nicholas\\n(minesweeperonline.com)''),''About'')'));
            
            % Append the borders
            image( -9:obj.ncols*16+10, -51:-42, ...
                [obj.borders{1} repmat( obj.borders{5}, 1, obj.ncols ) obj.borders{2}] );
            image( -9:0, -41:-10, ...
                obj.borders{9} );
            image( obj.ncols*16+(1:10), -41:-10, ...
                obj.borders{9} );
            image( -9:obj.ncols*16+10, -9:0, ...
                [obj.borders{6} repmat( obj.borders{5}, 1, obj.ncols ) obj.borders{7}] );
            image( -9:obj.ncols*16+10, obj.nrows*16+(1:10), ...
                [obj.borders{3} repmat( obj.borders{5}, 1, obj.ncols ) obj.borders{4}]);
            image( -9:0, 1:obj.nrows*16, ...
                repmat( obj.borders{8}, obj.nrows, 1 ) );
            image( obj.ncols*16+(1:10), 1:obj.nrows*16, ...
                repmat( obj.borders{8}, obj.nrows, 1 ) );
            
            % Image the Smiley
            sm = image( obj.ncols*8 + (-12:13), -38:-13, ...
                obj.smileys{1} );
            set( sm, 'UserData', 1, ...
                'ButtonDownFcn', @obj.smileydown );
            
            % Add the bomb count and timer
            bc = image( 7:45, -37:-15, ...
                [obj.numbers{str2double(num2cell(sprintf('%03.0f', obj.nmines)))+1}] );
            tc = image( obj.ncols*16 + (-45:-7), -37:-15, ...
                [obj.numbers{[1 1 1]}] );
            tm = timer( 'Period', 1, ...
                'StartDelay', 1, ...
                'ExecutionMode', 'FixedRate', ...
                'UserData', fh, ...
                'TimerFcn', @obj.timerfcn );
            
            % Add the minefield
            im = zeros( obj.nrows, obj.ncols );
            for jrow = 1:obj.nrows
                for jcol = 1:obj.ncols
                    im(jrow,jcol) = image( (1:16)+(jcol-1)*16, ...
                        (1:16)+(jrow-1)*16, ...
                        obj.button_images{1}, ...
                        'Parent', ax );
                    set( im(jrow,jcol), 'ButtonDownFcn', @obj.buttondown_minefield, ...
                        'UserData', [ jrow, jcol ], ...
                        'Tag', 'Buttons' );
                end
            end
            
            % Save the necessary items in guidata
            data.im = im;
            data.fh = fh;
            data.ax = ax;
            data.sm = sm;
            data.bc = bc;
            data.tc = tc;
            data.tm = tm;
            data.mb = mb;
            guidata( fh, data );
        end
        
        % Randomly Generate minefield
        function generate_minefield( obj )
            obj.minefield = false( obj.nrows, obj.ncols );
            while sum( obj.minefield(:) ) < obj.nmines
                mine_row = randi( obj.nrows );
                mine_col = randi( obj.ncols );
                obj.minefield( mine_row, mine_col ) = true;
            end
        end
        
        % Calculate the neighbors numbers
        function neighbors = generate_neighbors( obj, minefield )
            neighbors = conv2( double( minefield ), ones( 3 ), 'same' );
        end
        
        % Change the difficulty level
        function changedifficulty( obj, hObject, ~ )
            data = guidata( hObject );
            position = get( data.fh, 'Position' );
            topleft = [ position(1) sum( position([2 4]) ) 0 0 ];
            label = get( hObject, 'Label' );
            switch label
                case 'Beginner'
                    obj.nrows  = obj.difficulties(1,1);
                    obj.ncols  = obj.difficulties(1,2);
                    obj.nmines = obj.difficulties(1,3);
                case 'Intermediate'
                    obj.nrows  = obj.difficulties(2,1);
                    obj.ncols  = obj.difficulties(2,2);
                    obj.nmines = obj.difficulties(2,3);
                case 'Expert'
                    obj.nrows  = obj.difficulties(3,1);
                    obj.ncols  = obj.difficulties(3,2);
                    obj.nmines = obj.difficulties(3,3);
                case 'Custom...'
                    obj.custominput;
            end
            if obj.nrows + obj.ncols + obj.nmines ~= 0
                new_obj = minesweeper( obj.nrows, obj.ncols, obj.nmines );
                new_position = get( new_obj.fh, 'Position' );
                new_topleft = [ new_position(1) sum( new_position([2 4]) ) 0 0 ];
                set( new_obj.fh, 'Position', new_position - new_topleft + topleft );
                set( findobj( new_obj.fh, 'Type', 'uimenu' ), 'Checked', 'off' );
                set( findobj( new_obj.fh, 'Label', label ), 'Checked', 'on' );
                close( data.fh );
            end
        end
        
        % Custom difficulty input
        function custominput( obj )
            prompt = {'Height:', 'Width:', 'Mines:'};
            dlg_title = 'Custom Field';
            num_lines = 1;
            def = { num2str( obj.nrows ) num2str( obj.ncols ) num2str( obj.nmines ) };
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            if numel( answer ) == 3
                try
                    obj.nrows = str2double( answer{1} );
                    obj.ncols = str2double( answer{2} );
                    obj.nmines = str2double( answer{3} );
                catch %#ok<CTCH>
                    obj.custominput;
                end
            else
                obj.nrows = 0;
                obj.ncols = 0;
                obj.nmines = 0;
            end
        end
        
        % Add your name to the Leaderboard!
        function leaderboard_add( obj, hObject, ~ )
            % Load leaderboard from file
            if exist( 'minesweeper.mat', 'file' ) && ...
                    ismember( 'leaderboard', who('-file','minesweeper.mat') )
                load( 'minesweeper.mat', 'leaderboard' );
            else
                leaderboard = { ...
                    'Anonymous' 999
                    'Anonymous' 999
                    'Anonymous' 999 };
                save( 'minesweeper.mat', 'leaderboard' );
            end
            
            % Prompt user for info if in leaderboard
            data = guidata( hObject );
            if strcmpi( get( data.mb.beg, 'Checked' ), 'on' )
                level = 1; levelstring = 'beginner';
            elseif strcmpi( get( data.mb.int, 'Checked' ), 'on' )
                level = 2; levelstring = 'intermediate';
            elseif strcmpi( get( data.mb.exp, 'Checked' ), 'on' )
                level = 3; levelstring = 'expert';
            else
                level = 0;
            end
            if level ~= 0 && obj.timeelapsed < leaderboard{ level, 2 }
                leaderboard( level, 1 ) = ...
                    inputdlg( sprintf( ['You have the fastest time\n' ...
                    'for %s level.\n' ...
                    'Please enter your name.'], ...
                    levelstring ), ...
                    'CONGRATS!', 1, leaderboard( level, 1 ) );
                leaderboard{ level, 2 } = obj.timeelapsed; %#ok<NASGU>
                
                % Save leaderboard to file
                save( 'minesweeper.mat', 'leaderboard', '-append' );
                obj.leaderboard_show( hObject );
            end
        end
        
        function leaderboard_show( varargin )
            % Load leaderboard from file
            if exist( 'minesweeper.mat', 'file' )
                load( 'minesweeper.mat', 'leaderboard' );
            else
                leaderboard = { 'Anonymous' 999
                    'Anonymous' 999
                    'Anonymous' 999 };
            end
            button = 'do';
            while ~strcmp( button, 'OK' ) && ~isempty( button )
                button = questdlg( { sprintf( 'Beginner: %d by %s', ...
                    leaderboard{1,2}, leaderboard{1,1} )
                    sprintf( 'Intermediate: %d by %s', ...
                    leaderboard{2,2}, leaderboard{2,1} )
                    sprintf( 'Expert: %d by %s', ...
                    leaderboard{3,2}, leaderboard{3,1} )}, ...
                    'Fastest Mine Sweepers', 'Reset Scores', 'OK', 'OK' );
                if strcmp( button, 'Reset Scores' )
                    leaderboard = { 'Anonymous' 999
                        'Anonymous' 999
                        'Anonymous' 999 };
                    save( 'minesweeper.mat', 'leaderboard', '-append' );
                end
            end
        end
        
        % Buttondown function for image sprite buttons
        function buttondown_minefield( obj, hObject, eventdata )
            
            % Do this every time
            data = guidata( hObject );
            row_col = get( hObject, 'UserData' );
            row = row_col(1); col = row_col(2);
            if strcmp( eventdata, 'force' ) || strcmp( eventdata, 'op' )
                SelectionType = eventdata;
            else
                SelectionType = get( data.fh, 'SelectionType' );
            end
            
            switch SelectionType
                case 'force' % Left Click Release
                    if strcmp( get( data.tm, 'Running' ), 'off' )
                        start( data.tm );
                        if obj.minefield(row,col)
                            firstavailable = find( ~obj.minefield', 1, 'first' );
                            obj.minefield(row,col) = false;
                            obj.minefield( firstavailable ) = true;
                            obj.neighbors = obj.generate_neighbors( obj.minefield );
                        end
                    end
                    
                    if ~obj.clickfield(row,col)
                        obj.clickfield(row,col) = true;
                        if obj.minefield( row, col )
                            set( hObject, 'cdata', obj.button_images{3} );
                            set( data.im( obj.minefield & ~obj.clickfield ), 'CData', obj.button_images{5} );
                            set( data.im( obj.flagfield & ~obj.minefield ), 'CData', obj.button_images{4} );
                            set( data.sm, 'CData', obj.smileys{4}, 'UserData', 4 );
                            stop( data.tm );
                            obj.clickfield(:) = true;
                            return;
                        else
                            set( hObject, 'cdata', obj.neighbor_nums{ obj.neighbors(row,col)+1 } );
                            if obj.neighbors(row,col) == 0
                                nb_coords = obj.generate_nb_coords( row, col );
                                for ii = 1:size( nb_coords, 1 )
                                    if ~obj.clickfield(nb_coords(ii,1),nb_coords(ii,2))
                                        obj.buttondown_minefield( data.im(nb_coords(ii,1),nb_coords(ii,2)), eventdata );
                                    end
                                end
                            end
                        end
                    end
                case 'normal' % Left Click Down
                    if ~obj.clickfield(row,col)
                        obj.cellon = true;
                        set( hObject, 'CData', obj.neighbor_nums{1} );
                        set( data.sm, 'CData', obj.smileys{3}, ...
                            'UserData', 3 );
                    end
                case 'alt' % Right Click
                    if obj.clickfield(row,col) == obj.flagfield(row,col)
                        if obj.flagfield(row,col)
                            set( hObject, 'cdata', obj.button_images{1} );
                        else
                            set( hObject, 'cdata', obj.button_images{2} );
                        end
                        obj.clickfield(row,col) = ~obj.clickfield(row,col);
                        obj.flagfield(row,col) = ~obj.flagfield(row,col);
                    end
                case {'extend' 'open'} % Middle Click or Double Click Down
                    nb_coords = [ obj.generate_nb_coords( row, col ); row col ];
                    for ii = 1:size( nb_coords, 1 )
                        if ~obj.clickfield(nb_coords(ii,1),nb_coords(ii,2))
                            set( data.im(nb_coords(ii,1),nb_coords(ii,2)), 'CData', obj.neighbor_nums{1} );
                        end
                    end
                    obj.blockon = true;
                case 'op' % Middle Click or Double Click Release
                    flag_neighbors = obj.generate_neighbors( obj.flagfield );
                    if obj.clickfield(row,col) && ...
                            flag_neighbors(row,col) == obj.neighbors(row,col)
                        nb_coords = obj.generate_nb_coords( row, col );
                        for ii = 1:size( nb_coords, 1 )
                            if ~obj.clickfield(nb_coords(ii,1),nb_coords(ii,2))
                                obj.buttondown_minefield( data.im(nb_coords(ii,1),nb_coords(ii,2)), 'force' );
                            end
                        end
                    end
                otherwise
                    disp( SelectionType );
            end
            
            % Check for success!
            if strcmpi( get( data.tm, 'Running' ), 'on' )
                if all( obj.flagfield(:) == obj.minefield(:) ) && all( obj.clickfield(:) )
                    set( data.sm, 'CData', obj.smileys{5}, ...
                        'UserData', 5 );
                    stop( data.tm );
                    obj.leaderboard_add( hObject );
                elseif all( obj.minefield(obj.flagfield) ) && ...
                        sum( obj.flagfield(:) ) + sum( ~obj.clickfield(:) ) == obj.nmines
                    obj.flagfield(~obj.clickfield) = true;
                    set( data.sm, 'CData', obj.smileys{5}, ...
                        'UserData', 5 );
                    set( data.im(~obj.clickfield), 'CData', obj.button_images{2} );
                    obj.clickfield(:) = true;
                    stop( data.tm );
                    obj.leaderboard_add( hObject );
                end
            end
        end
        
        % Generates the coordinates of the neighboring cells
        function nb_coords = generate_nb_coords( obj, row, col )
            nb_coords = [ row - 1 col - 1
                row - 1 col
                row - 1 col + 1
                row col - 1
                row col + 1
                row + 1 col - 1
                row + 1 col
                row + 1 col + 1 ];
            nb_coords( any( nb_coords <= 0, 2 ) | nb_coords(:,1) > obj.nrows | nb_coords(:,2) > obj.ncols, : ) = [];
        end
        
        % Smiley ButtonDown Function
        function smileydown( obj, hObject, ~ )
            data = guidata( hObject );
            obj.smileyon = true;
            set( data.sm, 'CData', obj.smileys{2} );
        end
        
        % ButtonMotion function
        function buttonmotion( obj, hObject, ~ )
            data = guidata( hObject );
            if obj.cellon
                col_row = ceil( get( data.ax, 'CurrentPoint' ) / 16 );
                col = col_row(1,1); row = col_row(1,2);
                set( data.im( ~obj.clickfield ), 'CData', obj.button_images{1} );
                if ~( row < 1 || col < 1 || row > obj.nrows || col > obj.ncols || obj.clickfield(row, col) )
                    set( data.im(row,col), 'CData', obj.neighbor_nums{1} );
                end
            elseif obj.blockon
                col_row = ceil( get( data.ax, 'CurrentPoint' ) / 16 );
                col = col_row(1,1); row = col_row(1,2);
                nb_coords = [ obj.generate_nb_coords( row, col ); row col ];
                nb_coords( any( nb_coords <= 0, 2 ) | nb_coords(:,1) > obj.nrows | nb_coords(:,2) > obj.ncols, : ) = [];
                set( data.im( ~obj.clickfield ), 'CData', obj.button_images{1} );
                for ii = 1:size( nb_coords, 1 )
                    if ~obj.clickfield(nb_coords(ii,1),nb_coords(ii,2))
                        set( data.im(nb_coords(ii,1),nb_coords(ii,2)), 'CData', obj.neighbor_nums{1} );
                    end
                end
            elseif obj.smileyon
                xy = get( data.ax, 'CurrentPoint' );
                x = xy(1,1); y = xy(1,2);
                xdata = get( data.sm, 'XData' );
                ydata = get( data.sm, 'YData' );
                if inpolygon( x, y, xdata([1 end end 1 1]), ydata([1 1 end end 1]) )
                    set( data.sm, 'CData', obj.smileys{2} );
                else
                    set( data.sm, 'CData', obj.smileys{ get( data.sm, 'UserData' ) } );
                end
            end
        end
        
        % ButtonUp function for image-type figure
        function buttonup( obj, hObject, ~ )
            data = guidata( hObject );
            col_row = ceil( get( data.ax, 'CurrentPoint' ) / 16 );
            col = col_row(1,1); row = col_row(1,2);
            
            % Dragging a block
            if obj.blockon
                obj.buttondown_minefield( data.im(row,col), 'op' );
            end
            
            % Dragging a single point
            if obj.cellon && ~( any( [row col] <= 0, 2 ) || row > obj.nrows || col > obj.ncols )
                set( data.sm, ...
                    'CData', obj.smileys{1}, ...
                    'UserData', 1 );
                obj.buttondown_minefield( data.im(row,col), 'force' );
            end
            
            % Clicking on the smiley (Resetting the Game)
            if obj.smileyon
                xy = get( data.ax, 'CurrentPoint' );
                x = xy(1,1); y = xy(1,2);
                xdata = get( data.sm, 'XData' );
                ydata = get( data.sm, 'YData' );
                set( data.sm, 'CData', obj.smileys{get(data.sm, 'UserData')} );
                if inpolygon( x, y, xdata([1 end end 1 1]), ydata([1 1 end end 1]) )
                    set( data.sm, 'UserData', 1 );
                    obj.generate_minefield;
                    obj.neighbors = obj.generate_neighbors( obj.minefield );
                    obj.clickfield = false( obj.nrows, obj.ncols );
                    obj.flagfield = false( obj.nrows, obj.ncols );
                    obj.timeelapsed = 0;
                    stop( data.tm );
                end
            end
            
            % Refresh the gameboard
            set( data.sm, 'CData', obj.smileys{get( data.sm, 'UserData' )} );
            set( data.bc, 'CData', [obj.numbers{str2double(num2cell(sprintf('%03.0f',obj.nmines-sum(obj.flagfield(:)))))+1}] );
            set( data.tc, 'CData', [obj.numbers{str2double(num2cell(sprintf('%03.0f',obj.timeelapsed)))+1}] );
            set( data.im( ~obj.clickfield ), 'CData', obj.button_images{1} );
            obj.blockon = false; obj.cellon = false; obj.smileyon = false;
        end
        
        % Timer Function
        function timerfcn( obj, sender, ~ )
            data = guidata( get( sender, 'UserData' ) );
            obj.timeelapsed = obj.timeelapsed + 1;
            if obj.timeelapsed >= 999
                obj.timeelapsed = 999;
                stop( sender );
            end
            set( data.tc, 'CData', [obj.numbers{str2double(num2cell(sprintf('%03.0f', obj.timeelapsed)))+1}] );
        end
        
        % Figure Delete Function
        function deletefcn( ~, hObject, ~ )
            data = guidata( hObject );
            stop( data.tm );
            delete( data.tm );
        end
        
    end
    
end