classdef ChessHighlight < handle
%
% Class implementing a square highlight for the ChessMaster GUI
%
% NOTE: This class is used internally by the ChessMaster GUI and is not
%       intended for public invocation
%
% Brian Moore
% brimoor@umich.edu
%

    %
    % Public GetAccess properties
    %
    properties (GetAccess = public, SetAccess = private)
        visible = false;        % Visibility flag
        on = true;              % On flag
        i;                      % File
        j;                      % Rank
    end
    
    %
    % Private properties
    %
    properties (Access = private)
        % Board state
        BS;                     % Board state handle
        
        % GUI variables
        ax;                     % Axis handle
        ph;                     % Image handle
        
        % Cursor data
        file;                   % File coordinates
        rank;                   % Rank coordinates
    end
    
    %
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = ChessHighlight(CHD,BS,ax)
            % Save board state handle
            this.BS = BS;
            
            % Save file/rank info
            this.file = CHD.file;
            this.rank = CHD.rank;
            
            % Create highlight graphics object
            this.ax = ax;
            this.ph = image(0,'Parent',this.ax, ...
                              'Visible','off');
        end
        
        %
        % Set the size/color of the highlight
        %
        function SetStyle(this,CHD)
            % Get size/color information
            size = CHD.size;
            color = CHD.color;
            
            % Highlight parameters
            x0 = 0.5 * (size + 1);
            y0 = 0.5 * (size + 1);
            sigma = 1.25 * x0;
            
            % Create highlight graphics object
            c = permute(color,[1 3 2]);
            I = uint8(round(repmat(c,[size size])));
            [X Y] = meshgrid(1:size,1:size);
            Z = abs(X - x0).^2.5 + abs(Y - y0).^2.5;
            alpha = uint8(round(230 * exp((-1 / (2 * sigma^2)) * Z)));
            
            % Update highlight grahpics
            XData = get(this.ph,'XData');
            YData = get(this.ph,'YData');
            set(this.ph,'CData',I, ...
                        'AlphaData',alpha, ...
                        'XData',XData, ...
                        'YData',YData);
        end
        
        %
        % Set the highlight location
        %
        function SetLocation(this,i,j)
            % Update coordinates
            this.i = i;
            this.j = j;
            
            % Draw highlight at new location
            this.DrawHighlight();
        end
        
        %
        % Set highlight "on" state
        %
        function SetOnState(this,bool)
            % Set on state
            this.on = bool;
            
            % Update highlights
            if ((this.visible == true) && (this.on == true))
                % Turn on highlight
                set(this.ph,'Visible','on');
            elseif (this.on == false)
                % Turn off highlight
                set(this.ph,'Visible','off');
            end
        end
        
        %
        % Turn the highlight on
        %
        function On(this)
            % Set visibility flag
            this.visible = true;
            
            % Turn on highlight, if necessary
            if (this.on == true)
                set(this.ph,'Visible','on');
            end
        end
        
        %
        % Turn the highlight off
        %
        function Off(this)
            % Release visibility flag
            this.visible = false;
            
            % Turn off highlight
            set(this.ph,'Visible','off');
        end
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Draw the highlight at its current coordinates
        %
        function DrawHighlight(this)
            % Draw highlight at its location
            b = this.BS.flipped; % Board orientation flag
            xlim = this.file(this.i + [b ~b]) - [b ~b];
            ylim = this.rank(this.j + [b ~b]) - [b ~b];            
            set(this.ph,'XData',xlim,'YData',ylim);
            
            % Turn on highlight
            this.On();
        end
    end
end
