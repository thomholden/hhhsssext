classdef ChessPiece < handle
%
% Superclass for all chess piece classes
%
% NOTE: This class is used internally by the ChessMaster GUI and is not
%       intended for public invocation
%
% Brian Moore
% brimoor@umich.edu
%

    %
    % Public constants
    %
    properties (GetAccess = public, Constant = true)
        NULL = -1;                  % Null enum
        DRAW = 0;                   % Draw enum
        WHITE = 1;                  % White piece enum
        BLACK = 2;                  % Black piece enum
        BOTH = 3;                   % Both colors enum
    end
    
    %
    % Public GetAccess properties
    %
    properties (SetAccess = private, GetAccess = public)
        BS;                         % Board state handle
        color;                      % Color
        i;                          % File
        j;                          % Rank
    end
    
    %
    % Private properties
    %
    properties (Access = private)
        % Piece drawing information
        filem;                      % File coordinate matrix
        rankm;                      % Rank coordinate matrix
        
        % Graphics handles
        ax;                         % Axis handle
        ph;                         % pcolor handle
    end
    
    %
    % Abstract public constants
    %
    properties (Abstract = true, GetAccess = public, Constant = true)
        ID;                         % Piece ID number
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = ChessPiece(ax,BS,CPD,color,ID,i,j)
            % Save piece information
            this.ax = ax;
            this.BS = BS;
            this.filem = CPD.filem;
            this.rankm = CPD.rankm;
            this.color = color;
            this.i = i;
            this.j = j;
            
            % Create image object
            if (color == ChessPiece.WHITE)
                % White piece
                piece = CPD.White(ID);
            else
                % Black piece
                piece = CPD.Black(ID);
            end
            img = flipdim(piece.I,1);
            alph = flipdim(piece.alpha,1);
            this.ph = image(img,'AlphaData',alph, ...
                                'Parent',this.ax, ...
                                'Visible','off');
            
            % Add piece to board
            this.BS.AddPiece(this);
            
            % Draw piece at desired location
            this.DrawPiece();
        end
        
        %
        % Move piece, capturing if necessary
        %
        function [move isprom] = MovePiece(this,i,j,drawflag)
            % Parse drawflag
            if (nargin < 4)
                drawflag = true;
            end
            
            % Create move object
            move = Move(this,i,j);
            
            % Check for capture
            if ((this.ID == Pawn.ID) && ...
                (((this.color == ChessPiece.WHITE) && ...
                ((j - this.j) == 1) && ...
                ((i - this.i) ~= 0)) || ...
                (((this.color == ChessPiece.BLACK) && ...
                ((j - this.j) == -1) && ...
                ((i - this.i) ~= 0)))) && ...
                (this.BS.IsEmpty(i,j) == true))
                % En-passant capture
                pawn = this.BS.PieceAt(i,this.j);
                pawn.CapturePiece(drawflag);
                move.AddCapture(pawn);
            elseif (this.BS.IsEmpty(i,j) == false)
                % Standard capture
                piece = this.BS.PieceAt(i,j);
                piece.CapturePiece(drawflag);
                move.AddCapture(piece);
            end
            
            % Check for castle
            if ((this.ID == King.ID) && ((i - this.i) == 2))                
                % King-side castle
                rook = this.BS.PieceAt(8,this.j);
                rook.FastMovePiece(6,this.j,drawflag);
            elseif ((this.ID == King.ID) && ((i - this.i) == -2))
                % Queen-side castle
                rook = this.BS.PieceAt(1,this.j);
                rook.FastMovePiece(4,this.j,drawflag);
            end
            
            % Check for promotion
            if ((this.ID == Pawn.ID) && ...
               (((j == 1) && (this.color == ChessPiece.BLACK)) || ...
               ((j == 8) && (this.color == ChessPiece.WHITE))))
                % Need to perfom promotion
                isprom = true;
            else
                % No promotion required
                isprom = false;
            end
            
            % Move piece on board
            this.BS.MovePiece(this,i,j);
            
            % Update coordinates
            this.i = i;
            this.j = j;
            
            % Draw piece at new location
            if (drawflag == true)
                this.DrawPiece();
            end
        end
        
        %
        % Fast move piece (don't check promotions, captures, or castles)
        %
        function FastMovePiece(this,i,j,drawflag)
            % Parse drawflag
            if (nargin < 4)
                drawflag = true;
            end
            
            % Move piece on board
            this.BS.MovePiece(this,i,j);
            
            % Update coordinates
            this.i = i;
            this.j = j;
            
            % Draw piece at new location
            if (drawflag == true)
                this.DrawPiece();
            end
        end
        
        %
        % See if proposed move results in a check for this piece's color
        %
        function bool = IsCheckingMove(this,i,j)
            % Perform the move (without drawing)
            move = this.MovePiece(i,j,false);
            
            % See if the move was legal
            if (this.color == ChessPiece.WHITE)
                % Legality == Check status of white pieces
                bool = this.BS.IsWhiteInCheck();
            else
                % Legality == Check status of black pieces
                bool = this.BS.IsBlackInCheck();
            end
            
            % Undo the move (without drawing)
            ChessPiece.UndoMovePiece(move,this.BS,false);
        end
        
        %
        % Capture this piece
        %
        function CapturePiece(this,drawflag)
            % Parse drawflag
            if (nargin < 2)
                drawflag = true;
            end
            
            % Remove piece from board
            this.BS.RemovePiece(this);
            
            % Turn off piece
            if (drawflag == true)
                this.TurnOff();
            end
        end
        
        %
        % Uncapture piece (for undoing moves)
        %
        function UncapturePiece(this,drawflag)
            % Parse drawflag
            if (nargin < 2)
                drawflag = true;
            end
            
            % Add piece back onto board
            this.BS.AddPiece(this);
            
            % Redraw piece on board
            if (drawflag == true)
                this.DrawPiece();
            end
        end
        
        %
        % Check if piece is under attack by the opposition
        %
        function bool = IsUnderAttack(this)
            % Call BoardState routine for doing this
            switch this.color
                case ChessPiece.WHITE
                    % Opponents are black
                    bool = this.BS.IsUnderAttack(this.i,this.j, ...
                                                         ChessPiece.BLACK);
                case ChessPiece.BLACK
                    % Opponents are white
                    bool = this.BS.IsUnderAttack(this.i,this.j, ...
                                                         ChessPiece.WHITE);
            end
        end
        
        %
        % Draw piece at its coordinates
        %
        function DrawPiece(this)
            % Get piece limits
            xlim = this.filem(this.i,:);
            ylim = this.rankm(this.j,:);
            
            % Handle board orientation
            if (this.BS.flipped == true)
                % Flip coordinates
                xlim = fliplr(xlim);
                ylim = fliplr(ylim);
            end
            
            % Draw piece at its location
            set(this.ph,'XData',xlim,'YData',ylim);
            
            % Make sure piece is on
            this.TurnOn();
        end
        
        %
        % Draw piece at the (arbitrary) axis coordinates
        %
        function DrawPieceAt(this,x,y,ssq)
            % Compute piece limits
            xlim = x + ssq * [-0.5 0.5];
            ylim = y + ssq * [-0.5 0.5];
            
            % Handle board orientation
            if (this.BS.flipped == true)
                % Flip coordinates
                xlim = fliplr(xlim);
                ylim = fliplr(ylim);
            end
            
            % Draw piece at new location
            set(this.ph,'XData',xlim,'YData',ylim);
        end
        
        %
        % Make piece active
        %
        function MakeActive(this)
            % Send piece to top of graphics stack
            uistack(this.ph,'top');
        end
        
        %
        % Chess pieces are never nans!
        %
        function bool = isnan(this) %#ok
            bool = false;
        end
        
        %
        % Permanently delete piece
        %
        function Delete(this)
            % Delete pcolor handle
            delete(this.ph);
            
            % Delete object itself
            delete(this);
        end
    end
    
    %
    % Public static methods
    %
    methods (Access = public, Static = true)
        %
        % Undo an entire move
        %
        function UndoMovePiece(move,BS,drawflag)
            % Parse drawflag
            if (nargin < 3)
                drawflag = true;
            end
            
            % Get handle to piece that moved
            if ~isnan(move.pawn)
                % A pawn was promoted during last move
                piece = move.pawn;
            else
                % Normal piece movement
                piece = BS.PieceAt(move.toi,move.toj);
            end
            
            % Check for castle
            if ((piece.ID == King.ID) && ((move.fromi - piece.i) == 2))                
                % Undoing queen-side castle
                rook = BS.PieceAt(4,piece.j);
                rook.FastMovePiece(1,piece.j,drawflag);
            elseif ((piece.ID == King.ID) && ...
                    ((move.fromi - piece.i) == -2))
                % Undoing king-side castle
                rook = BS.PieceAt(6,piece.j);
                rook.FastMovePiece(8,piece.j,drawflag);
            end
            
            % Move piece back to its original home
            piece.FastMovePiece(move.fromi,move.fromj,drawflag);
            
            % Check for pawn promotions
            if ~isnan(move.promotion)
                % Delete the promoted piece
                move.promotion.CapturePiece(drawflag);
                
                % Uncapture the pawn
                piece.UncapturePiece(drawflag);
            end
            
            % Check for captures
            if ~isnan(move.capture)
                % Undo the capture
                move.capture.UncapturePiece(drawflag);
            end
        end
        
        %
        % Return the other color
        %
        function ocolor = Toggle(color)
            switch color
                case ChessPiece.WHITE
                    % Return black
                    ocolor = ChessPiece.BLACK;
                case ChessPiece.BLACK
                    % Return white
                    ocolor = ChessPiece.WHITE;
            end
        end
    end
    
    %
    % Abstract public methods
    %
    methods (Access = public, Abstract = true)
        %
        % Check if move is valid (i.e., pseudo-legal)
        %
        bool = IsValidMove(this,i,j);
        
        %
        % Return coordinates of all valid (i.e., pseudo-legal) moves
        %
        [ii jj] = ValidMoves(this);
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Turn on piece
        %
        function TurnOn(this)
            % Set pcolor to visible
            set(this.ph,'Visible','on');  
        end
        
        %
        % Turn off piece
        %
        function TurnOff(this)
            % Set pcolor to invisible
            set(this.ph,'Visible','off');   
        end
    end
end
