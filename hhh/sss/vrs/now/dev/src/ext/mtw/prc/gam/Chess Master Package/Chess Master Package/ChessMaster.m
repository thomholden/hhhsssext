classdef ChessMaster < handle
%--------------------------------------------------------------------------
% Syntax:       ChessMaster();
%               ChessMaster(figSize);
%               ChessMaster('last');
%               CM = ChessMaster();
%               CM = ChessMaster(figSize);
%               CM = ChessMaster('last');
%               
% Inputs:       [OPTIONAL] figSize in [0 1] is the desired size of the GUI
%               relative to the smallest screen dimension. The default
%               value is figSize = 0.75
%               
%               [OPTIONAL] 'last' loads the ChessMaster figures as they
%               were (i.e., same size/position) when the GUI last closed
%               
% Outputs:      CM is a ChessMaster object with public methods:
%               
%               SANstr  = CM.MakeMove(LANstr);   % Make specified move
%               SANstr  = CM.RandomMove();       % Make random legal move
%                         CM.UndoMove();         % Undo last halfmove
%                         CM.UndoMoves(n);       % Undo last n halfmoves
%                         CM.UndoAll();          % Undo all halfmoves
%                         CM.RedoMove();         % Redo last halfmove
%                         CM.RedoMoves(n);       % Redo last n halfmoves
%                         CM.RedoAll();          % Redo all halfmoves
%                         CM.GoToMove(n);        % Go to given halfmove
%               FENstr  = CM.GetFENstr();        % Get current FEN string
%               LANstrs = CM.GetLANstrs();       % Get all LAN move strings
%               SANstrs = CM.GetSANstrs();       % Get all SAN move strings
%                         CM.FlipBoard();        % Flip board orientation
%                         CM.BlockGUI(bool);     % Set GUI-block state
%                         CM.ResetBoard();       % Start new game
%                         CM.Close();            % Close GUI
%               
% Note:         All of the necessary public properties/methods are exposed
%               for you to write your own external auto-move engine.
%               Alternatively, you can download any chess engine that
%               supports the Universal Chess Interface (UCI) communication
%               protocol and connect it to the ChessEngine objects spawned
%               by a ChessMaster GUI. See README.txt for more information
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         July 22, 2014
%--------------------------------------------------------------------------

    %
    % Private constants
    %
    properties (GetAccess = private, Constant = true)
        % Constants
        DEFAULT_FIG_SIZE = 0.75;    % Default relative figure size
        AUTOPLAY_APS = 10;          % Engine autoplay attempts/sec
    end
    
    %
    % Public properties
    %
    properties (Access = public)
        % Options (default values overwritten by ChessOptions)
        whiteName;                  % Name of white player
        blackName;                  % Name of black player
        defTimeControl;             % Default time control string
    end
    
    %
    % Public GetAccess properties
    %
    properties (SetAccess = private, GetAccess = public)
        %   1 ==> white
        %   2 ==> black
        turnColor;                  % Turn color
        
        %   0 ==> draw
        %   1 ==> white
        %   2 ==> black
        % NaN ==> in progess
        winner;                     % Winning side value
        
        % Logicals
        alock = false;              % Engine autoplay lock
        block = false;              % GUI block lock
        elock = false;              % Execution lock
        glock = false;              % Graphics lock
        mlock = false;              % Mouse lock
        isGameOver;                 % Game over flag
        
        % Miscellaneous info
        FM;                         % FigureManager object
        tag = 'ChessMaster';        % Chess GUI tag
        dir;                        % Base directory path
        version;                    % Version structure
    end
    
    %
    % Public GetAccess properties (dependent)
    %
    properties (GetAccess = public, SetAccess = private, Dependent = true)
        % Nonnegative integer
        currentMove;                % Current halfmove count
        
        % false ==> white on bottom
        %  true ==> black on bottom
        boardFlipped;               % Board flipped flag
    end
    
    %
    % Private properties
    %
    properties (Access = private)
        % Game/board state
        BS;                         % BoardState object
        CPD;                        % Chess piece data structure
        CO;                         % ChessOptions object
        CC;                         % ChessClock object
        ML;                         % MoveList object
        GA;                         % GameAnalyzer object
        themes;                     % Theme structure
        bsize;                      % Board size structure
        activePiece = nan;          % Active piece object
        ptimer;                     % Piece movement timer
        
        % Options (default values overwritten by ChessOptions)
        checkText = true;           % Check text visibility flag
        showLastMoveMenu = true;    % Last move menu visibility
        showTurnMarker = true;      % Turn marker visibility flag
        animateMoves;               % Move animation flag
        allowDB;                    % Undo/Redo dialog box flag
        movesThresh;                % Undo/Redo dialog box move threshold
        enableML;                   % MoveList enable flag 
        enableGA;                   % GameAnalyzer enable flag
        enableCC;                   % ChessClock enable flag
        
        % Square highlights
        CHD;                        % ChessHighlight data structure
        CHf;                        % "From" ChessHighlight object
        CHt;                        % "To" ChessHighlight object
        CHc;                        % "Current" ChessHighlight object
        
        % Engines
        engines;                    % Engines data structure
        CElist;                     % ChessEngine object array
        nwauto = 0;                 % Number of engines on white autoplay
        nbauto = 0;                 % Number of engines on black autoplay
        atimer;                     % Autoplay timer
        
        % GUI variables
        squareSize;                 % Board square size
        file;                       % File coordinates
        rank;                       % Rank coordinates
        filec;                      % File center coordinates
        rankc;                      % Rank center coordinates
        file_textc;                 % File text center coordinates
        rank_textc;                 % Rank text center coordinates
        tcpos_white;                % Location of white turn square
        tcpos_black;                % Location of black turn square
        
        % GUI handles
        fig;                        % Figure handle
        ax;                         % Axis handles
        bh;                         % Board handle
        tch;                        % Time control menu handle
        mlh;                        % Move list menu handle
        gah;                        % Game analyzer menu handle
        undoh;                      % Undo move menu handle
        undoallh;                   % Undo all moves menu handle
        redoh;                      % Redo move menu handle
        redoallh;                   % Redo all moves menu handle
        drawh1;                     % Offer draw menu handle
        drawh2;                     % Fifty-move rule menu handle
        drawh3;                     % Threefold repetition menu handle
        resignh;                    % Resign menu handle
        movewh;                     % Last white move menu handle
        movebh;                     % Last black move menu handle
        filetexth;                  % File text handles
        ranktexth;                  % Rank text handles
        checkh;                     % Check text handle
        markerh;                    % Turn marker handle
    end
    
    %
    % Getter/Setter methods
    %
    methods % Dependent methods only
        %
        % currentMove getter
        %
        function n = get.currentMove(this)
            % Get move number from underlying board state 
            n = this.BS.currentMove;
        end
        
        %
        % boardFlipped getter
        %
        function bool = get.boardFlipped(this)
            % Get orientation from underlying board state 
            bool = this.BS.flipped;
        end
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = ChessMaster(arg1)
        % Type "help ChessMaster" for more information
        
            % Save base directory
            this.dir = this.GetBaseDir();
            
            % Load data
            data = load([this.dir '/data.mat']);
            this.engines = data.engines;
            this.themes = data.themes;
            this.version = data.version;
            
            % Parse input args
            if (nargin == 0)
                % Default pieces
                xyc = ChessMaster.GetScreenCenter();
                pieces = ChessMaster.GetPieces(data.pieces);
                loadChildren = false;
            elseif isnumeric(arg1)
                % User-specifed pieces
                xyc = ChessMaster.GetScreenCenter();
                pieces = ChessMaster.GetPieces(data.pieces,arg1);
                loadChildren = false;
            elseif (ischar(arg1) && strcmpi(arg1,'last'))
                % Last-used pieces
                xyc = data.windows.xyc;
                idx = ([data.pieces.size] == data.windows.sqSz);
                pieces = data.pieces(idx);
                loadChildren = true;
            else
                % Display error message
                msgid = 'CM:SYNTAX:ERROR';
                errmsg = ['Invalid syntax. Type ''help ChessMaster'' ' ...
                          'for more information'];
                error(msgid,errmsg);
            end
            
            % Save chess piece data
            this.CPD.Black = pieces.Black;
            this.CPD.White = pieces.White;
            this.CPD.size = pieces.size;
            this.squareSize = pieces.size;
            
            % Initialize autoplay timer
            this.atimer = timer('Name','AutoPlayTimer', ...
                                'ExecutionMode','FixedRate', ...
                                'StartDelay',0, ...
                                'Period',1 / ChessMaster.AUTOPLAY_APS, ...
                                'TasksToExecute',Inf, ...
                                'TimerFcn',@(s,e)AutoPlay(this));
            
            % Initialize piece movement timer
            this.ptimer = timer('Name','PieceMoveTimer', ...
                                'ExecutionMode','FixedRate', ...
                                'TasksToExecute',Inf, ...
                                'TimerFcn',@(s,e)MouseMove(this));
            
            % Create board state container
            this.BS = BoardState();
            
            % Initialize chess engine array
            this.CElist = ChessEngine.empty(1,0);
            
            % Spawn figure manager
            this.FM = FigureManager();
            
            % Initialize GUI
            this.InitializeGUI(xyc);
            
            % Spawn options manager
            this.CO = ChessOptions(this,data.options);
            
            % Restore last children windows, if necessary
            if (loadChildren == true)
                this.RestoreChildrenWindows(data.windows.children);
            end
        end
        
        %
        % Make move (if it is legal)
        %
        function SANstr = MakeMove(this,LANstr)
        %------------------------------------------------------------------
        % Syntax:       SANstr = CM.MakeMove(LANstr);
        %               SANstr = MakeMove(CM,LANstr);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        %               LANstr is a string in long algebraic notation (LAN)
        %               
        % Outputs:      SANstr is a string in standard algebraic notation
        %               (SAN) describing the move just performed. If the
        %               move was illegal, SANstr = '' is returned
        %               
        % LAN Standard:                Syntax
        %               '<file><rank><file><rank>[promotion]'
        %               
        %                             Examples                             
        %               'e2e4'
        %               'e7e5'
        %               'e1g1'  - White kingside castling
        %               'e7e8q' - Promotion to queen
        %               
        % Description:  This function performs the move described by the
        %               given LAN string
        %               
        % Note:         In combination with GetFENstr() or GetLANstrs(),
        %               one can easily control a ChessMaster GUI with an
        %               external MATLAB AI engine (although designing such
        %               an engine is quite nontrivial ;-)
        %------------------------------------------------------------------
        
            % Set execution lock
            this.elock = true;
            
            % Initialize SAN string
            SANstr = '';
            
            % (Try to) parse LAN string
            try
                [fromi fromj toi toj promID] = Move.ParseLAN(LANstr);
            catch %#ok
                % Quick return
                this.elock = false;
                return;
            end
            
            % Get active piece
            piece = this.BS.PieceAt(fromi,fromj);
            
            % Check for valid move
            if (~isnan(piece) && (piece.color == this.turnColor) && ...
                (this.isGameOver == false) && piece.IsValidMove(toi,toj))
                % Perform the move
                [move isprom] = piece.MovePiece(toi,toj);
                
                % Update checks
                this.BS.UpdateChecks();
                
                % See if move was legal (didn't leave own king in check)
                if (this.BS.InCheck(this.turnColor) == true)
                    % A check was ignored, so undo the move
                    ChessPiece.UndoMovePiece(move,this.BS);
                    
                    % Update checks
                    this.BS.UpdateChecks();
                else
                    % Check for promotions
                    if (isprom == true)
                        if ~isempty(promID)
                            % Apply specified promotion
                            prom = PromotePawn(this,piece,promID);
                        else
                            % Ask user for promotion choice
                            prom = this.GetPromotion(piece);
                        end
                        
                        % Save promotion data in move
                        if ~isnan(prom)
                            move.AddPromotion(piece,prom);
                        end
                        
                        % Update checks
                        this.BS.UpdateChecks();
                    end
                    
                    % Toggle turn color
                    this.ToggleTurnColor();
                    
                    % Get mate status
                    mate = this.BS.MateStatus(this.turnColor);
                    if (mate == BoardState.CHECKMATE)
                        % Add checkmate to the move
                        move.AddCheckmate();
                    end
                    
                    % Save the move
                    this.SaveMove(move,piece.color);
                    SANstr = move.SANstr;
                    
                    % Stop any active analysis engines
                    this.StopAnalysisEngines();
                    
                    % Handle game over scenarios
                    switch mate
                        case BoardState.CHECKMATE
                           % Checkmate!
                           this.winner = ChessPiece.Toggle(this.turnColor);
                           this.GameOver('Checkmate!');
                        case BoardState.STALEMATE
                           % Stalemate...
                           this.winner = ChessPiece.DRAW;
                           this.GameOver('Stalemate...');                            
                    end
                end
            end
            
            % Release execution lock
            this.elock = false;
        end
        
        %
        % Make a random move for the current color
        %
        function SANstr = RandomMove(this)
        %------------------------------------------------------------------
        % Syntax:       SANstr = CM.RandomMove();
        %               SANstr = RandomMove(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Outputs:      SANstr is a string in standard algebraic notation
        %               (SAN) describing the move just performed
        %               
        % Description:  This function performs a randomly selected move for
        %               the current color to-move 
        %------------------------------------------------------------------
        
            % Query board state for a random move
            LANstr = this.BS.GetRandomMove(this.turnColor);
            
            % Make the move
            SANstr = this.MakeMove(LANstr);
        end
        
        %
        % Undo the last halfmove
        %
        function UndoMove(this,drawflag)
        %------------------------------------------------------------------
        % Syntax:       CM.UndoMove();
        %               UndoMove(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  This function undoes the last halfmove
        %------------------------------------------------------------------
            
            % Set execution lock
            this.elock = true;
            
            % Get graphics flag
            drawflag = ~((nargin > 1) && (drawflag == false));
            
            % Never have game over here since we're undoing a move
            if (this.isGameOver == true)
                this.winner = ChessPiece.NULL;
                this.isGameOver = false;
                this.UpdateDrawResignMenus();
                this.UpdateTurnMarkerVisibility();
            end
            
            % Undo the current move
            cmove = this.BS.moveList(this.BS.currentMove);
            this.BS.currentMove = this.BS.currentMove - 1;
            ChessPiece.UndoMovePiece(cmove,this.BS);
            
            % Toggle the turn color variable
            this.ToggleTurnColor();
            
            % Update check status
            this.BS.UpdateChecks();
            
            % Update GUI, if necessary
            if (drawflag == true)
                this.UpdateGUI();
            end
            
            % Update engines, if necessary
            if (drawflag == true)
                % Update engine states
                this.UpdateEngineStates();
                
                % Turn off engine autoplay for current color
                this.TurnOffEngineAutoPlay(this.turnColor);
            end
            
            % Release execution lock
            this.elock = false;
            
            % Handle engine autoplay, if necessary
            if (drawflag == true)
                this.EngineAutoPlay();
            end
        end
        
        %
        % Undo the specified number of halfmoves
        %
        function UndoMoves(this,n,varargin)
        %------------------------------------------------------------------
        % Syntax:       CM.UndoMoves(n);
        %               UndoMoves(CM,n);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        %               n is the number of halfmoves to undo
        %               
        % Description:  This function undoes the given number of halfmoves
        %------------------------------------------------------------------
        
            % Get dialog box flag
            showDB = (((nargin == 2) || (varargin{1} == true)) && ...
                      (this.allowDB == true) && (n >= this.movesThresh));
            
            % Create undoing dialog box, if necessary
            if (showDB == true)
                udh = this.DialogBox('Undoing...');
            end
            
            % Undo all but one move without flushing events
            for i = 1:(n - 1)
                this.UndoMove(false);
            end
            
            % Close undoing dialog box, if necessary
            if (showDB == true)
                this.CloseDialogBox(udh);
            end
            
            % Redo the last move *with* events flush
            if (n > 0)
                this.UndoMove(true);
            end
        end
        
        %
        % Undo all halfmoves
        %
        function UndoAll(this,varargin)
        %------------------------------------------------------------------
        % Syntax:       CM.UndoAll();
        %               UndoAll(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  This function undoes all halfmoves, returning the
        %               game to the starting position
        %------------------------------------------------------------------
        
            % Undo all moves
            n = this.BS.currentMove;
            this.UndoMoves(n,varargin{:});
        end
        
        %
        % Redo the next halfmove
        %
        function RedoMove(this,drawflag)
        %------------------------------------------------------------------
        % Syntax:       CM.RedoMove();
        %               RedoMove(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  This function redoes the next halfmove
        %------------------------------------------------------------------
        
            % Set execution lock
            this.elock = true;
            
            % Get graphics flag
            drawflag = ~((nargin > 1) && (drawflag == false));
            
            % Get the next move
            this.BS.currentMove = this.BS.currentMove + 1;
            move = this.BS.moveList(this.BS.currentMove);
            
            % Get handle to piece that moved
            piece = this.BS.PieceAt(move.fromi,move.fromj);
            
            % Move the piece
            piece.MovePiece(move.toi,move.toj);
            
            % Check for promotions
            if ~isnan(move.pawn)
                % Make the pawn disappear
                move.pawn.CapturePiece();
                
                % Reinstate the promoted piece
                move.promotion.UncapturePiece();
            end
            
            % Toggle the turn color variable
            this.ToggleTurnColor();
            
            % Update check status
            this.BS.UpdateChecks();
            
            % Update GUI, if necessary
            if (drawflag == true)
                this.UpdateGUI();
            end
            
            % Handle mates, if necessary
            if (this.BS.currentMove == length(this.BS.moveList))
                switch this.BS.MateStatus(this.turnColor)
                    case BoardState.CHECKMATE
                        % Checkmate!
                        this.winner = ChessPiece.Toggle(this.turnColor);
                        this.GameOver('Checkmate!');
                        return;
                    case BoardState.STALEMATE
                        % Stalemate...
                        this.winner = ChessPiece.DRAW;
                        this.GameOver('Stalemate...');
                        return;
                end
            end
            
            % Update engines, if necessary
            if (drawflag == true)
                % Update engine states
                this.UpdateEngineStates();
                
                % Turn off engine autoplay for current color
                this.TurnOffEngineAutoPlay(this.turnColor);
            end
            
            % Release execution lock
            this.elock = false;
            
            % Handle engine autoplay, if necessary
            if (drawflag == true)
                this.EngineAutoPlay();
            end
        end
        
        %
        % Redo the specified number of halfmoves
        %
        function RedoMoves(this,n,varargin)
        %------------------------------------------------------------------
        % Syntax:       CM.RedoMoves(n);
        %               RedoMoves(CM,n);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        %               n is the number of halfmoves to redo
        %               
        % Description:  This function redoes the given number of halfmoves
        %------------------------------------------------------------------
        
            % Get dialog box flag
            showDB = (((nargin == 2) || (varargin{1} == true)) && ...
                      (this.allowDB == true) && (n >= this.movesThresh));
            
            % Create redoing dialog box, if necessary
            if (showDB == true)
                rdh = this.DialogBox('Redoing...');
            end
            
            % Redo all but one move without flushing events
            for i = 1:(n - 1)
                this.RedoMove(false);
            end
            
            % Close redoing dialog box, if necessary
            if (showDB == true)
                this.CloseDialogBox(rdh);
            end
            
            % Redo the last move *with* events flush
            if (n > 0)
                this.RedoMove(true);
            end
        end
        
        %
        % Redo all halfmoves
        %
        function RedoAll(this,varargin)
        %------------------------------------------------------------------
        % Syntax:       CM.RedoAll();
        %               RedoAll(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  This function redoes all halfmoves, progressing
        %               the game to its furthest position
        %------------------------------------------------------------------
        
            % Redo all moves
            num = length(this.BS.moveList) - this.BS.currentMove;
            this.RedoMoves(num,varargin{:});
        end
        
        %
        % Go to the given halfmove number
        %
        function GoToMove(this,n)
        %------------------------------------------------------------------
        % Syntax:       CM.GoToMove(n);
        %               GoToMove(CM,n);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Outputs:      n is the desired halfmove (nonnegative integer)
        %               
        % Description:  This function reverts/progresses the game state to
        %               the given halfmove number, where n = 0 returns to
        %               the starting position
        %------------------------------------------------------------------
        
            % Clip target idx to valid range
            n = min(max(n,0),length(this.BS.moveList));

            % Go to target move
            dm = n - this.BS.currentMove;
            absdm = abs(dm);
            switch sign(dm)
                case -1
                    % Undo the requisite number of moves
                    this.UndoMoves(absdm);
                case 1
                    % Redo the requisite number of moves
                    this.RedoMoves(absdm);
            end
        end
        
        %
        % Get the FEN string for the *current* board position
        %
        function FENstr = GetFENstr(this)
        %------------------------------------------------------------------
        % Syntax:       FENstr = CM.GetFENstr();
        %               FENstr = GetFENstr(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Outputs:      FENstr is the Forsyth–Edwards Notation (FEN) string
        %               describing the *current* board position
        %               
        % Description:  This function returns the FEN string that encodes
        %               the *current* board position
        %               
        % Note:         In combination with MakeMove(), one can easily
        %               control a ChessMaster GUI with an external MATLAB
        %               AI engine (although designing such an engine is
        %               quite nontrivial ;-)
        %------------------------------------------------------------------
            
            % Query board state for FEN string
            FENstr = this.BS.GenerateFEN(this.turnColor);
        end
        
        %
        % Get list of all LAN strings *up until* the current position 
        %
        function LANstrs = GetLANstrs(this)
        %------------------------------------------------------------------
        % Syntax:       LANstrs = CM.GetLANstrs();
        %               LANstrs = GetLANstrs(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Outputs:      LANstrs is a cell array containing the long
        %               algebraic notation (LAN) strings describing each
        %               move *up until* the current position
        %               
        % Description:  This function returns the LAN strings for each move
        %               *up until* the current position
        %               
        % Note:         In combination with MakeMove(), one can easily
        %               control a ChessMaster GUI with an external MATLAB
        %               AI engine (although designing such an engine is
        %               quite nontrivial ;-)
        %------------------------------------------------------------------
        
            % Get LAN strings from move list
            LANstrs = {this.BS.moveList(1:this.BS.currentMove).LANstr};
        end
        
        %
        % Get list of all SAN strings *up until* the current position 
        %
        function SANstrs = GetSANstrs(this)
        %------------------------------------------------------------------
        % Syntax:       SANstrs = CM.GetSANstrs();
        %               SANstrs = GetSANstrs(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Outputs:      SANstrs is a cell array containing the standard
        %               algebraic notation (SAN) strings describing each
        %               move *up until* the current position
        %               
        % Description:  This function returns the SAN strings for each move
        %               *up until* the current position
        %------------------------------------------------------------------
        
            % Get SAN strings from move list
            SANstrs = {this.BS.moveList(1:this.BS.currentMove).SANstr};
        end
        
        %
        % Flip board orientation
        %
        function FlipBoard(this)
        %------------------------------------------------------------------
        % Syntax:       CM.FlipBoard();
        %               FlipBoard(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  Flips the board orientation (i.e., toggles between
        %               white-on-bottom and black-on-bottom)
        %------------------------------------------------------------------
        
            % Toggle board orientation
            this.BS.flipped = ~this.BS.flipped;
            
            % Refresh board
            this.RefreshBoard();
        end
        
        %
        % Set the GUI-block state
        %
        function BlockGUI(this,bool)
        %------------------------------------------------------------------
        % Syntax:       CM.BlockGUI(bool);
        %               BlockGUI(CM,bool);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        %               bool = {true,false} is the desired GUI-block state
        %               
        % Description:  When bool = true, all ChessMaster GUI mouse clicks
        %               are ignored. This is useful, for instance, to
        %               prevent the user from trying to make a move while
        %               an engine is thinking
        %------------------------------------------------------------------
        
            % Update GUI-block state
            this.block = bool;
        end
        
        %
        % Reset the GUI
        %
        function ResetBoard(this)
        %------------------------------------------------------------------
        % Syntax:       CM.ResetBoard();
        %               ResetBoard(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  This function resets the GUI and initializes a new
        %               game
        %------------------------------------------------------------------
        
            % Clear the board
            this.BS.Clear();
            this.activePiece = nan;
            
            % Release locks
            this.alock = false;
            this.block = false;
            this.elock = false;
            this.glock = false;
            this.mlock = false;
            
            % Reset game state
            this.isGameOver = false;
            this.winner = ChessPiece.NULL;
            this.UpdateDrawResignMenus();
            this.UpdateTurnMarkerVisibility();
            this.CHc.Off();
            
            % Stop piece movement timer, if necessary
            if strcmpi(this.ptimer.Running,'on')
                stop(this.ptimer);
            end
            
            % Reset turn color/marker
            if (this.turnColor ~= ChessPiece.WHITE)
                this.ToggleTurnColor();
            end
            
            % Initialize pieces
            this.InitializePieces();
            
            % Update GUI
            this.UpdateGUI();
            
            % Reset chess clock
            %this.CloseChessClock();
            this.ResetChessClock();
            
            % Reset engines
            %this.CloseEngines();
            this.ResetEngines();
            
            % Reset move list
            %this.CloseMoveList();
            this.ResetMoveList();
            
            % Reset game analyzer
            %this.CloseGameAnalyzer();
            this.ResetGameAnalyzer();
        end
        
        %
        % Close the GUI
        %
        function Close(this)
        %------------------------------------------------------------------
        % Syntax:       CM.Close();
        %               Close(CM);
        %               
        % Inputs:       CM is a ChessMaster object
        %               
        % Description:  This function gracefully closes the ChessMaster GUI
        %               and deletes the ChessMaster object
        %------------------------------------------------------------------
        
            try
                % Stop autoplay timer, if necessary
                if strcmpi(this.atimer.Running,'on')
                    % Stop timer
                    stop(this.atimer);
                end
                
                % Delete autoplay timer
                delete(this.atimer);
            catch %#ok
                % Graceful exit
            end
            
            try
                % Stop piece movement timer, if necessary
                if strcmpi(this.ptimer.Running,'on')
                    % Stop timer
                    stop(this.ptimer);
                end
                
                % Delete piece movement timer
                delete(this.ptimer);
            catch %#ok
                % Graceful exit
            end
            
            try
                % Save current window positions
                windows.children = this.FM.GetChildWindowInfo(this.tag);
                windows.xyc = this.GetCenterCoordinates();
                windows.sqSz = this.squareSize; %#ok
                
                % Close all figures except the main GUI
                this.FM.CloseAllExcept(this.tag);
            catch %#ok
                % Graceful exit
            end
            
            try
                % Save updated info
                engines = this.engines; %#ok
                options = this.CO.Close(); %#ok
                themes = this.themes; %#ok
                save([this.dir '/data.mat'],'-append', ...
                                            'engines','options', ...
                                            'themes','windows');
            catch %#ok
                % Graceful exit
            end
            
            try
                % Force close the main GUI
                delete(this.fig);
            catch %#ok
                % Something strange happened, so delete the current figure
                delete(gcf);
            end
            
            try
                % Delete this object
                delete(this);
            catch %#ok
                % Graceful exit
            end
        end
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Get mouse location in axis units
        %
        function [x y] = GetMouseLocation(this)
            % Get absolute pointer location (w.r.t. screen)
            mpos = get(0,'PointerLocation');
            
            % Compute pointer location in axis units
            fpos = get(this.fig,'Position');
            xy = mpos - fpos(1:2);
            if (this.BS.flipped == true)
                % Flip coordinates to account for board orientation
                xy = this.bsize.dim + 1 - xy;
            end
            x = xy(1);
            y = xy(2);
        end
        
        %
        % Get (rank,file) coordinates of (x,y) axis location
        %
        function [i j] = LocateClick(this,x,y)
            % Get file
            i = find(x < this.file,1,'first') - 1;
            if isempty(i)
                i = 0; % off board
            end
            
            % Get rank
            j = find(y < this.rank,1,'first') - 1;
            if isempty(j)
                j = 0; % off board
            end
        end
        
        %
        % Parse user's mouse click
        %
        function MouseDown(this)
            % If this is a second click
            if ~isnan(this.activePiece)
                % Set mouse lock
                this.mlock = true;
            elseif ((this.block == false) && (this.mlock == false) && ...
                    (this.isGameOver == false))
                % Get (rank,file) mouse coordinates
                xy = get(this.ax(3),'CurrentPoint');
                [i j] = this.LocateClick(xy(1,1),xy(1,2));
                %[x y] = this.GetMouseLocation()
                %[i j] = this.LocateClick(x,y);
                
                % If a valid square was selected
                if ((i >= 1) && (i <= 8) && (j >= 1) && (j <= 8) && ...
                    this.BS.ColorAt(i,j) == this.turnColor)
                    % Get active piece
                    this.activePiece = this.BS.PieceAt(i,j);
                    this.activePiece.MakeActive();
                    
                    % Set current square highlight
                    this.CHc.SetLocation(i,j);
                    
                    % If move animation is on
                    if (this.animateMoves == true)
                        % Set mouse lock
                        this.mlock = true;
                        
                        % Start piece movement timers
                        start(this.ptimer);
                    end
                end
            end
        end
        
        %
        % Handle mouse move
        %
        function MouseMove(this)            
            % If we're ready to update graphics
            if ((this.mlock == true) && (this.glock == false))                
                % Set graphics lock
                this.glock = true;
                
                % Get (x,y) mouse coordinates in axis units
                [x y] = this.GetMouseLocation();
                
                % Update active piece location
                ssq = this.bsize.square - 1; % Piece height/width
                this.activePiece.DrawPieceAt(x,y,ssq);
                
                % Release graphics lock
                this.glock = false;
            end
        end
        
        %
        % Handle mouse release
        %
        function MouseUp(this)
            % If mouse lock is set
            if (this.mlock == true)
                % Stop piece movement timer, if necessary
                if strcmpi(this.ptimer.Running,'on')
                    stop(this.ptimer);
                end
                
                % If GUI isn't blocked and game isn't over
                if ((this.block == false) && (this.isGameOver == false))
                    % Get (rank,file) mouse coordinates
                    xy = get(this.ax(3),'CurrentPoint');
                    [i j] = this.LocateClick(xy(1,1),xy(1,2));
                    %[x y] = this.GetMouseLocation();
                    %[i j] = this.LocateClick(x,y);
                    
                    % Make the move (if it is legal)
                    fromi = this.activePiece.i;
                    fromj = this.activePiece.j;
                    LANstr = Move.GenerateLAN(fromi,fromj,i,j);                    
                    if isempty(this.MakeMove(LANstr))
                        % Return piece to its home location
                        this.activePiece.DrawPiece();
                    end
                else
                    % Return piece to its home location
                    this.activePiece.DrawPiece();
                end
                
                % Turn off current square highlight
                this.CHc.Off();
                
                % Clear active piece
                this.activePiece = nan;
                
                % Release mouse lock
                this.mlock = false;
                
                % Flush graphics
                this.FlushGraphics();
                
                % Check for engine auto-plays
                this.EngineAutoPlay();
            end
        end
        
        %
        % Save the move within the board state
        %
        function SaveMove(this,move,color,drawflag)
            % Get graphics flag
            drawflag = ~((nargin > 3) && (drawflag == false));
            
            % Update the reversible moves count
            if (move.reversible == true)
                % This move was reversible, so increment the counter
                move.IncRevMoves();
            end
            
            % Add check to move if necessary
            if (this.BS.InCheck(ChessPiece.Toggle(color)) == true)
                % Add check to the move
                move.AddCheck();
            end
            
            % Save encoded board state
            move.EncodeBoardState();
            
            % Record the move
            this.BS.currentMove = this.BS.currentMove + 1;
            if (length(this.BS.moveList) > this.BS.currentMove)
                % Remove (now invalid) future moves
                this.BS.moveList((this.BS.currentMove + 1):end) = [];
            end
            this.BS.moveList(this.BS.currentMove) = move;
            
            % Add to GameAnalyzer, if necessary
            if ~isempty(this.GA)
                idx = this.BS.currentMove - 1;
                this.GA.AppendMoves({move.LANstr},{move.SANstr},idx);
            end
            
            % Add to MoveList, if necessary
            if ~isempty(this.ML)
                idx = this.BS.currentMove - 1;
                this.ML.AppendMoves({move.SANstr},idx);
            end
            
            % Toggle chess clock, if necessary
            if ~isempty(this.CC)
                this.CC.ToggleClock();
            end
            
            % Update GUI, if necessary
            if (drawflag == true)
                this.UpdateGUI();
            end
        end
        
        %
        % Offer draw
        %
        function OfferDraw(this)
            % Get color of team to accept the draw
            switch this.turnColor
                case ChessPiece.WHITE
                    % White is offering the draw
                    color = 'White';
                case ChessPiece.BLACK
                    % Black is offering the draw
                    color = 'Black';
            end
            
            % Offer a draw to opponent
            selection = questdlg([color ' offers a draw. Accept?'], ...
                                 this.version.name,'Yes','No','Yes');
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Handle request
            if strcmp(selection,'Yes')
                % Game ends in draw
                this.winner = ChessPiece.DRAW;
                this.GameOver('Draw...');
            end
        end
        
        %
        % Draw based on Fifty-move rule
        %
        function FiftyMovesDraw(this)
            % Game ends in draw
            this.winner = ChessPiece.DRAW;
            this.GameOver('Fity-move rule draw...');
        end
        
        %
        % Draw based on threefold repetition
        %
        function Rep3FoldDraw(this)
            % Game ends in draw
            this.winner = ChessPiece.DRAW;
            this.GameOver('Threefold repetition draw...');
        end
        
        %
        % Resign from the game
        %
        function Resign(this)
            % Resign from the game
            switch this.turnColor
                case ChessPiece.WHITE
                    % White resigns
                    color = 'White';
                    this.winner = ChessPiece.BLACK;
                case ChessPiece.BLACK
                    % Black resigns
                    color = 'Black';
                    this.winner = ChessPiece.WHITE;
            end
            this.GameOver([color ' resigns...']);
        end
        
        %
        % Get a promotion from the user
        %
        function prom = GetPromotion(this,pawn)
            % Flush graphics
            this.FlushGraphics();
            
            % Ask the user what to promote to
            %
            % NOTE: strings *must* match class names 
            %
            liststr = {'Pawn';'Knight';'Bishop';'Rook';'Queen'};
            idx = listdlg('PromptString','Select a piece:', ...
                          'SelectionMode','single', ...
                          'InitialValue',5, ...
                          'Name','Pawn promotion', ...
                          'ListSize',[200 100], ...
                          'ListString',liststr);
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Make sure the user didn't press cancel or choose pawn
            if (~isempty(idx) && (idx > 1))
                % Promote pawn
                ID = eval([liststr{idx} '.ID']); % hack
                prom = this.PromotePawn(pawn,ID);
            else
                % No promotion selected
                prom = nan;
            end
        end
        
        %
        % Promote pawn to the piece with given ID
        %
        function prom = PromotePawn(this,pawn,ID)
            % "Capture old pawn to make it disappear
            pawn.CapturePiece();
            
            % Create the promoted piece
            switch ID
                case Knight.ID
                    % Create a knight
                    prom = Knight(this.ax(2),this.BS, ...
                                  this.CPD,pawn.color, ...
                                  pawn.i,pawn.j);
                case Bishop.ID
                    % Create a bishop
                    prom = Bishop(this.ax(2),this.BS, ...
                                  this.CPD,pawn.color, ...
                                  pawn.i,pawn.j);
                case Rook.ID
                    % Create a rook
                    prom = Rook(this.ax(2),this.BS, ...
                                this.CPD,pawn.color, ...
                                pawn.i,pawn.j);
                case Queen.ID
                    %Create a queen
                    prom = Queen(this.ax(2),this.BS, ...
                                 this.CPD,pawn.color, ...
                                 pawn.i,pawn.j);
            end
        end
        
        %
        % Open game from file
        %
        function OpenGame(this)
            % Flush graphics
            this.FlushGraphics();
            
            % Ask the user what file to load
            path = inputdlg({['Enter a path (plus extension) to an ' ...
                              'existing PGN file:']}, ...
                              'Load game from file',1, ...
                             {'./game.pgn'},'on');
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Make sure the user didn't press cancel
            if ~isempty(path)
                % Ask user where to begin play
                selection = questdlg('Where should we resume play?', ...
                                this.version.name,'Beginning','End','End'); 
                drawnow; % hack to avoid MATLAB freeze + crash
                
                % Make sure the user didn't press cancel
                if ~isempty(selection)
                    % Close game analyzer (if applicable) and save position
                    GApos = this.FM.GetPosition('GameAnalyzer');
                    this.CloseGameAnalyzer();
                    
                    % Close move list (if applicable) and save position
                    MLpos = this.FM.GetPosition('MoveList');
                    this.CloseMoveList();
                    
                    % Close chess clock (if applicable) and save position
                    TCpos = this.FM.GetPosition('ChessClock');
                    this.CloseChessClock();
                    
                    % Create loading dialog box
                    ldh = this.DialogBox('Loading...');
                    
                    % Reset board
                    this.ResetBoard();
                    
                    % Parse PGN file
                    [moves outcome tcStr] = ChessMaster.ParsePGN(path{1});
                    SANstrs = {moves.SAN};
                    
                    % Perform the moves
                    mate = BoardState.NOMATE;
                    for i = 1:length(SANstrs)
                        % Make sure the move isn't empty
                        if ~isempty(SANstrs{i})
                            % Parse move
                            [fromi fromj toi toj promID] = ...
                          Move.ParseSAN(SANstrs{i},this.BS,this.turnColor);
                            
                            % Move piece
                            piece = this.BS.PieceAt(fromi,fromj);
                            move = piece.MovePiece(toi,toj);
                            
                            % Check for promotion
                            if ~isempty(promID)
                                % piece is a pawn
                                prom = this.PromotePawn(piece,promID);
                                move.AddPromotion(piece,prom);
                            end
                            
                            % Update check status
                            this.BS.UpdateChecks();
                            
                            % Toggle the turn color variable
                            this.ToggleTurnColor();
                            
                            % Check mate status on last move only
                            if (i == length(SANstrs))
                                mate = this.BS.MateStatus(this.turnColor);
                                if (mate == BoardState.CHECKMATE)
                                    % Checkmate!
                                    move.AddCheckmate();
                                end
                            end
                            
                            % Save the move
                            this.SaveMove(move,piece.color,false);
                        end
                    end
                    
                    % Parse time control
                    isTimeControl = false;
                    try
                        % Parse time control string
                        per = ChessClock.ParseTimeControl(tcStr);
                        
                        % If time control exists
                        if ~isempty(per)
                            % Set time control flag
                            isTimeControl = true;
                        end
                    catch ME
                        % Warn user that time control wasn't supported
                        warning(ME.identifier,ME.message);
                    end
                    
                    % Update GUI
                    this.UpdateGUI(false);
                    
                    % Go to user's desired state
                    switch selection
                        case 'Beginning'
                            % Undo all moves
                            this.UndoAll(false);
                            
                            % Close loading dialog box
                            this.CloseDialogBox(ldh);
                        case 'End'
                            % Close loading dialog box
                            this.CloseDialogBox(ldh);
                            
                            % Check end game status
                            if (mate == BoardState.CHECKMATE)
                                % Checkmate!
                                color = this.turnColor;
                                this.winner = ChessPiece.Toggle(color);
                                this.GameOver('Checkmate!');
                            elseif (mate == BoardState.STALEMATE)
                                % Stalemate...
                                this.winner = ChessPiece.DRAW;
                                this.GameOver('Stalemate...');
                            elseif strcmp(outcome,'1/2-1/2')
                                % Game ended in a draw
                                this.winner = ChessPiece.DRAW;
                                this.GameOver('Draw...');
                            elseif strcmp(outcome,'1-0')
                                % Black resigned
                                this.winner = ChessPiece.WHITE;
                                this.GameOver('Black resigns...');
                            elseif strcmp(outcome,'0-1')
                                % White resigned
                                this.winner = ChessPiece.BLACK;
                                this.GameOver('White resigns...');
                            end
                        otherwise
                            % Close loading dialog box
                            this.CloseDialogBox(ldh);
                    end
                    
                    try
                        % Spawn game analyzer
                        this.SpawnGameAnalyzer('pos',GApos);
                    catch %#ok
                        % Graceful exit
                    end
                    
                    try
                        % Spawn move list
                        this.SpawnMoveList('pos',MLpos);
                    catch %#ok
                        % Graceful exit
                    end
                    
                    % If time control exists
                    if (isTimeControl == true)
                        % Spawn chess clock
                        times = [moves.time]; % Clock times
                        this.SpawnChessClock(tcStr,times,'pos',TCpos);
                    end
                end
            end
        end
        
        %
        % Save current game to file
        %
        function SaveGame(this)
            % Flush graphics
            this.FlushGraphics();
            
            % Ask the user what file to save to
            path = inputdlg({['Enter a path (plus extension) for the ' ...
                              'output pgn file:']}, ...
                              'Save game to file',1, ...
                             {'./game.pgn'},'on');
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Make sure the user didn't press cancel
            if ~isempty(path)
                % Parse winner
                switch this.winner
                    case ChessPiece.WHITE
                        % White won
                        outcome = '1-0';
                    case ChessPiece.BLACK
                        % Black won
                        outcome = '0-1';
                    case ChessPiece.DRAW
                        % Game was drawn
                        outcome = '1/2-1/2';
                    otherwise
                        % Game is still in progress
                        outcome = '*';
                end
                
                % Get game data
                Nmoves = this.BS.currentMove;
                moves = {this.BS.moveList(1:Nmoves).SANstr};
                [tcStr times] = this.GetClockData();
                Ntimes = length(times);
                
                %----------------------------------------------------------
                % Write .pgn file
                %----------------------------------------------------------
                % Open file
                fid = fopen(path{1},'w');
                
                % Construct preamble
                fprintf(fid,['[Event "?"]\n' ...
                             '[Site "%s v%s"]\n' ...
                             '[Date "%s"]\n' ...
                             '[Round "-"]\n', ...
                             '[White "%s"]\n', ...
                             '[Black "%s"]\n', ...
                             '[Result "%s"]\n', ...
                             '[TimeControl "%s"]\n', ...
                             '[PlyCount "%i"]\n\n'], ...
                             this.version.name, ...
                             this.version.release, ...
                             datestr(date(),'yyyy.mm.dd'), ...
                             this.whiteName, ...
                             this.blackName, ...
                             outcome, ...
                             tcStr, ...
                             this.BS.currentMove);
                
                % Record moves/times
                lineLength = 65; % Approx. # characters per line
                line = '';
                for i = 1:2:Nmoves
                    % Append turn number
                    appendBite(sprintf('%i.',0.5 * (i + 1)));
                    
                    % Append white move
                    appendBite(moves{i});
                    
                    % Append white time, if available
                    if ((Ntimes >= i) && (times(i) >= 0))
                        appendBite(sec2clk(times(i)));
                    end
                    
                    % If we haven't reached the end of the game
                    if (i < Nmoves)
                        % Append black move
                        appendBite(moves{i + 1}); 
                        
                        % Append black time, if available
                        if ((Ntimes >= (i + 1)) && (times(i + 1) >= 0))
                            appendBite(sec2clk(times(i + 1)));
                        end
                    end
                end
                
                % Append game outcome
                if ~strcmp(outcome,'*')
                    line = sprintf('%s%s',line,outcome);
                end
                
                % Print last line to file
                if ~isempty(line)
                    fprintf(fid,'%s',line);
                end
                
                % Close the file
                fclose(fid);
                %----------------------------------------------------------
            end
            
            %--------------------------------------------------------------
            % Nested functions
            %--------------------------------------------------------------
            function appendBite(bite)
            % Append bite to line
            
                % Append bite string
                line = sprintf('%s%s ',line,bite);
                
                % If line is long enough
                if (length(line) >= lineLength)
                    % Append line to file
                    fprintf(fid,'%s\n',line);
                    line = '';
                end
            end
            
            function clk = sec2clk(time)
            % Construct clock time comment for given time
            
                % Convert to pretty time string
                timeStr = ChessClock.PrettyTime(time);
                
                % Generate comment
                clk = sprintf('{[%%clk %s]}',timeStr);
            end
            %--------------------------------------------------------------
        end
        
        %
        % Create a dialog box with the given string
        %
        function ldh = DialogBox(this,str)
            % Dialog box dimensions
            dim = [220 30];
            
            % Create centered dialog box
            xyc = this.GetCenterCoordinates();
            ldh = dialog('WindowStyle','Modal', ...
                         'Name',this.version.name, ...
                         'Position',[(xyc - 0.5 * dim) dim]);
            
            % Add loading text
            uicontrol(ldh,'Style','text', ...
                          'String',str, ...
                          'Units','Normalized', ...
                          'Position',[0.1 0 0.8 0.8]);
            
            % Flush graphics
            this.FlushGraphics();
        end
        
        %
        % Close dialog box
        %
        function CloseDialogBox(this,dh) %#ok
            try
                % Delete the figure
                delete(dh);
            catch %#ok
                % Graceful exit
            end
        end
        
        %
        % Toggle turn color
        %
        function ToggleTurnColor(this)
            % Toggle turn color
            switch this.turnColor
                case ChessPiece.WHITE
                    % Now black's turn
                    this.turnColor = ChessPiece.BLACK;
                case ChessPiece.BLACK
                    % Now white's turn
                    this.turnColor = ChessPiece.WHITE;
            end
            
            % Draw turn marker
            this.UpdateTurnMarker();
        end
        
        %
        % Draw the turn marker at its current location
        %
        function UpdateTurnMarker(this)
            % Update marker coordinates
            b = this.BS.flipped; % board orientation flag
            switch this.turnColor
                case ChessPiece.WHITE
                    % White's turn
                    pos = this.tcpos_white(b + 1,:);
                case ChessPiece.BLACK
                    % Black's turn
                    pos = this.tcpos_black(b + 1,:);
            end
            set(this.markerh,'Position',pos);
        end
        
        %
        % Update turn marker visibility
        %
        function UpdateTurnMarkerVisibility(this)
            % Check if we should show turn marker
            if ((this.isGameOver == true) || (this.showTurnMarker == false))
                % Turn off marker
                set(this.markerh,'Visible','off');
            else
                % Turn on marker
                set(this.markerh,'Visible','on');
            end
        end
        
        %
        % Handle game over
        %
        function GameOver(this,str1)
            % Set game over
            this.isGameOver = true;
            this.UpdateTurnMarkerVisibility();
            this.UpdateDrawResignMenus();
            
            % Stop chess timer, if necessary
            if ~isempty(this.CC)
                this.CC.StopTimer();
            end
            
            % Turn off square highlights
            this.CHf.Off();
            this.CHt.Off();
            this.CHc.Off();
            
            % Update engine states
            this.UpdateEngineStates();
            
            % Update game analyzer state
            this.UpdateGameAnalyzerState();
            
            % Parse winner
            switch this.winner
                case ChessPiece.WHITE
                    % White won
                    str2 = ' White wins!';
                case ChessPiece.BLACK
                    % Black won
                    str2 = ' Black wins!';
                otherwise
                    % No winner
                    str2 = '';
            end
            
            % Flush graphics
            this.FlushGraphics();
            
            % Ask user what to do
            selection = questdlg([str1 str2 ' Play again?'], ...
                                 this.version.name,'Yes','No','Yes');
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Handle user selection
            switch selection
                case 'Yes'
                    % Reset board
                    this.ResetBoard();
                case 'No'
                    try
                        % Spawn a game analyzer
                        this.SpawnGameAnalyzer();
                    catch %#ok
                        % Graceful exit
                    end
                    
                    try
                        % Spawn a move list
                        this.SpawnMoveList();
                    catch %#ok
                        % Graceful exit
                    end
            end
        end
        
        %
        % Create a new chess engine
        %
        function NewEngine(this,xyc)            
            % Spawn a new ChessEngine object
            etag = 'ChessEngine';
            if (nargin < 2)
                xyc = this.GetCenterCoordinates();
            end
            CE = ChessEngine(this,this.engines,etag,xyc);
            
            % Save to engine list
            this.CElist(end + 1) = CE;
            
            % Add figure to figure manager
            this.FM.AddFigure(CE.fig);
        end
        
        %
        % Manage engine list
        %
        function ManageEngines(this)            
            % Spawn an engine manager
            elements = {this.engines.list.name};
            initVal = double(~isempty(elements));
            name = 'Engine Manager';
            xyc = this.GetCenterCoordinates();
            [names idx] = MutableList.Instance(elements,initVal,name,xyc);
            
            % If selection wasn't cancelled
            if ~isempty(idx)
                % Update engine list
                [~,inds] = ismember(names,elements);
                this.engines.list = this.engines.list(inds);
                
                % Update current engine index
                this.engines.idx = sum(find(inds == this.engines.idx));
            end
        end
        
        %
        % Add an external engine to the engine list
        %
        function AddEngine(this)
            % Get engine name/path from user
            strs = {'UCI Engine (Windows)', ...
                    './engines/UCIengine.exe'};
            response = inputdlg({'Name','Path'},'Add UCI Engine', ...
                                [1 50],strs);
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Process user responses
            if ~isempty(response)
                name = response{1};
                path = response{2};
                try
                    % Attempt a connection with the specified engine
                    delete(EngineInterface([],path,'',1,false));
                    
                    % The connection succeeded, so save the engine
                    idx = find(ismember({this.engines.list.name},name));
                    if isempty(idx)
                        % Append engine to list
                        idx = length(this.engines.list) + 1;
                    end
                    this.engines.list(idx).name = name;
                    this.engines.list(idx).path = path;
                catch ME
                    % Show the orginal error as a warning
                    warning(ME.identifier,ME.message);
                    
                    % Warn the user know that engine addition failed
                    msgid = 'CM:ADDENGINE:FAIL';
                    msg = '\n\n*** Unable to connect to engine "%s" ***\n';
                    warning(msgid,msg,path);
                end
            end
        end
        
        %
        % Update engine states
        %
        function UpdateEngineStates(this)
            % Loop over active engines
            for i = 1:length(this.CElist)
                % Update engine state
                this.CElist(i).UpdateEngineState();
            end
        end
        
        %
        % Tell analysis engines to stop thinking
        %
        function StopAnalysisEngines(this)
            % Loop over active engines
            for i = 1:length(this.CElist)
                % Stop analysis engine (if applicable)
                this.CElist(i).StopAnalysisEngine();
            end
        end
        
        %
        % Turn off engine autoplay for current color
        %
        function TurnOffEngineAutoPlay(this,color)
            % Loop over active engines
            for i = 1:length(this.CElist)
                % Turn-off autoplay for given color
                this.CElist(i).TurnOffAutoPlay(color);
            end
        end
        
        %
        % Get time control string
        %
        function [tcStr times] = GetClockData(this)
            % If a chess clock exists
            if ~isempty(this.CC)
                % Get clock data
                [tcStr times] = this.CC.GetClockData();
            else
                % Unknown time control
                tcStr = '?';
                times = [];
            end
        end
        
        %
        % Reset chess clock
        %
        function ResetChessClock(this)
            % If a chess clock exists
            if ~isempty(this.CC)
                % Reset the clock
                this.CC.Reset();
            end
        end
        
        %
        % Close chess clock
        %
        function CloseChessClock(this)
            % If a chess clock exists
            if ~isempty(this.CC)
                % Close the clock
                this.CC.Close();
            end
        end
        
        %
        % Reset all engines
        %
        function ResetEngines(this)
            % Loop over engines
            for i = length(this.CElist):-1:1
                % Reset engine
                this.CElist(i).Reset();
            end
        end
        
        %
        % Close all engines
        %
        function CloseEngines(this)
            % Loop over engines
            for i = length(this.CElist):-1:1
                % Close engine
                this.CElist(i).Close();
            end
        end
        
        %
        % Reset move list
        %
        function ResetMoveList(this)
            % If a move list exists
            if ~isempty(this.ML)
                % Clear the list
                this.ML.Clear();
            end
        end
        
        %
        % Close move list
        %
        function CloseMoveList(this)
            % If a move list exists
            if ~isempty(this.ML)
                % Close the list
                this.ML.Close();
            end
        end
        
        %
        % Tell GameAnalyzer about the current game state
        %
        function UpdateGameAnalyzerState(this)
            % If a GameAnalyzer exists
            if ~isempty(this.GA)
                % Prompt GameAnalyzer to update based on game state
                this.GA.HandleGameState();
            end
        end
        
        %
        % Reset game analyzer
        %
        function ResetGameAnalyzer(this)
            % If a game analyzer exists
            if ~isempty(this.GA)
                % Reset the analyzer
                this.GA.Reset();
            end
        end
        
        %
        % Close game analyzer
        %
        function CloseGameAnalyzer(this)
            % If a game analyzer exists
            if ~isempty(this.GA)
                % Close the analyzer
                this.GA.Close();
            end
        end
        
        %
        % Initialize pieces
        %
        function InitializePieces(this)
            %--------------------------------------------------------------
            % White pieces
            %--------------------------------------------------------------
            for i = 1:8
                Pawn(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,i,2);
            end
            Rook(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,1,1);
            Knight(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,2,1);
            Bishop(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,3,1);
            Queen(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,4,1);
            King(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,5,1);
            Bishop(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,6,1);
            Knight(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,7,1);
            Rook(this.ax(2),this.BS,this.CPD,ChessPiece.WHITE,8,1);
            %--------------------------------------------------------------
            
            %--------------------------------------------------------------
            % Black pieces
            %--------------------------------------------------------------
            for i = 1:8
                Pawn(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,i,7);
            end
            Rook(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,1,8);
            Knight(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,2,8);
            Bishop(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,3,8);
            Queen(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,4,8);
            King(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,5,8);
            Bishop(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,6,8);
            Knight(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,7,8);
            Rook(this.ax(2),this.BS,this.CPD,ChessPiece.BLACK,8,8);
            %--------------------------------------------------------------
        end
        
        %
        % Initialize GUI
        %
        function InitializeGUI(this,xyc)
            % Set board sizes
            this.SetBoardSize(this.squareSize,this.themes.size);
            
            % Create a nice figure
            dim = this.bsize.dim;
            this.fig = figure('MenuBar','None', ...
                           'NumberTitle','off', ...
                           'DockControl','off', ...
                           'name',this.version.name, ...
                           'tag',this.tag, ...
                           'Position',[(xyc - 0.5 * dim) dim dim], ...
                           'PaperPositionMode','auto', ...
                           'RendererMode','manual', ...
                           'Renderer','opengl', ...
                           'Resize','off', ...
                           'WindowButtonDownFcn',@(s,e)MouseDown(this), ...
                           'WindowButtonUpFcn',@(s,e)MouseUp(this), ...
                           'CloseRequestFcn',@(s,e)Close(this), ...
                           'Interruptible','off', ...
                           'Visible','off');
            
            %--------------------------------------------------------------
            % Menus
            %--------------------------------------------------------------
            gamem = uimenu(this.fig,'Label','Game');
            uimenu(gamem,'Label','Preferences', ...
                              'Callback',@(s,e)SpawnChessOptions(this), ...
                              'Accelerator','P');
            uimenu(gamem,'Label','New Game', ...
                              'Callback',@(s,e)ResetBoard(this), ...
                              'Separator','on', ...
                              'Accelerator','N');
            uimenu(gamem,'Label','Open Game', ...
                              'Callback',@(s,e)OpenGame(this), ...
                              'Accelerator','O');
            uimenu(gamem,'Label','Save Game', ...
                              'Callback',@(s,e)SaveGame(this), ...
                              'Accelerator','S');
            this.mlh = uimenu(gamem,'Label','Move List', ...
                              'Callback',@(s,e)SpawnMoveList(this), ...
                              'Separator','on', ...
                              'Accelerator','L');
            this.tch = uimenu(gamem,'Label','Time Control', ...
                          'Callback',@(s,e)SpawnChessClock(this,'',[]), ...
                              'Accelerator','T');
            uimenu(gamem,'Label','Close', ...
                              'Callback',@(s,e)Close(this), ...
                              'Separator','on', ...
                              'Accelerator','W');
            boardm = uimenu(this.fig,'Label','Board');
            uimenu(boardm,'Label','Flip Board', ...
                              'Callback',@(s,e)FlipBoard(this), ...
                              'Accelerator','F');
            uimenu(boardm,'Label','Change Theme...', ...
                              'Callback',@(s,e)ChangeTheme(this), ...
                              'Separator','on');
            uimenu(boardm,'Label','Edit Theme...', ...
                              'Callback',@(s,e)EditTheme(this));
            uimenu(boardm,'Label','Screenshot...', ...
                              'Callback',@(s,e)TakeScreenshot(this), ...
                              'Separator','on');
            enginem = uimenu(this.fig,'Label','Engine');   
            uimenu(enginem,'Label','New Engine', ...
                              'Callback',@(s,e)NewEngine(this), ...
                              'Accelerator','E');
            this.gah = uimenu(enginem,'Label','Analyze Game', ...
                              'Callback',@(s,e)SpawnGameAnalyzer(this), ...
                              'Accelerator','A');
            uimenu(enginem,'Label','Manage Engines...', ...
                              'Callback',@(s,e)ManageEngines(this), ...
                              'Separator','on');
            uimenu(enginem,'Label','Add Engine...', ...
                              'Callback',@(s,e)AddEngine(this));
            undom = uimenu(this.fig,'Label','Undo'); 
            this.undoh = uimenu(undom,'Label','Undo Move', ...
                              'Callback',@(s,e)UndoMove(this), ...
                              'Accelerator','Z');
            this.undoallh = uimenu(undom,'Label','Undo All', ...
                              'Callback',@(s,e)UndoAll(this), ...
                              'Accelerator','X');
            redom = uimenu(this.fig,'Label','Redo');
            this.redoh = uimenu(redom,'Label','Redo Move', ...
                              'Callback',@(s,e)RedoMove(this), ...
                              'Accelerator','Y');
            this.redoallh = uimenu(redom,'Label','Redo All', ...
                              'Callback',@(s,e)RedoAll(this), ...
                              'Accelerator','V');
            drawm = uimenu(this.fig,'Label','Draw');     
            this.drawh1 = uimenu(drawm,'Label','Offer Draw', ...
                              'Callback',@(s,e)OfferDraw(this), ...
                              'Accelerator','D');
            this.drawh2 = uimenu(drawm,'Label','Fifty-Move Rule', ...
                              'Callback',@(s,e)FiftyMovesDraw(this), ...
                              'Separator','on');
            this.drawh3 = uimenu(drawm,'Label','Threefold Repetition', ...
                              'Callback',@(s,e)Rep3FoldDraw(this));
            resignm = uimenu(this.fig,'Label','Resign');
            this.resignh = uimenu(resignm,'Label','Resign', ...
                              'Callback',@(s,e)Resign(this), ...
                              'Accelerator','R');
            helpm = uimenu(this.fig,'Label','Help');
            uimenu(helpm,'Label','Help...', ...
                              'Callback',@(s,e)Help(this));
            uimenu(helpm,'Label','About', ...
                              'Separator','on', ...
                              'Callback',@(s,e)About(this));
            this.movewh = uimenu(this.fig,'Label','W:      ', ...
                                          'Enable','off');
            this.movebh = uimenu(this.fig,'Label','B:      ', ...
                                          'Enable','off');
            %--------------------------------------------------------------
            
            % Add board axis
            this.ax(1) = axes('Position',[0 0 1 1]);
            set(this.ax(1),'DrawMode','fast');
            axis(this.ax(1),'off');
            hold(this.ax(1),'on');
            this.bh = image([1 dim],[1 dim],0,'Parent',this.ax(1));
            axis(this.ax(1),0.5 + [0 dim 0 dim]);
            
            % Add piece axis
            this.ax(2) = axes('Position',[0 0 1 1]);
            set(this.ax(2),'DrawMode','fast', ...
                           'XDir','Normal', ...
                           'YDir','Normal', ...
                           'XLim',get(this.ax(1),'XLim'), ...
                           'YLim',get(this.ax(1),'YLim'));
            axis(this.ax(2),'off');
            hold(this.ax(2),'on');
            
            % Add check axis
            this.ax(3) = axes('Position',[0 0 1 1]);
            set(this.ax(3),'DrawMode','fast', ...
                           'XDir','Normal', ...
                           'YDir','Normal', ...
                           'XLim',get(this.ax(1),'XLim'), ...
                           'YLim',get(this.ax(1),'YLim'));
            axis(this.ax(3),'off');
            hold(this.ax(3),'on');
            
            % Order axes
            uistack(this.ax(2),'bottom');
            uistack(this.ax(1),'bottom');
            
            %--------------------------------------------------------------
            % Add rank/file labels
            %--------------------------------------------------------------
            fpos = @(i,j) [this.filec(i) this.rank_textc(j)];
            rpos = @(i,j) [this.file_textc(j) this.rankc(i)];
            for i = 1:8
                % File labels
                this.filetexth(i,1) = text('Parent',this.ax(1), ...
                                        'Position',fpos(i,1), ...
                                        'FontUnits','pixels', ...
                                        'FontSize',this.bsize.bfont, ...
                                        'FontWeight','normal', ...
                                        'HorizontalAlignment','center', ...
                                        'VerticalAlignment','middle', ...
                                        'Visible','off');
                this.filetexth(i,2) = text('Parent',this.ax(1), ...
                                        'Position',fpos(i,2), ...
                                        'FontUnits','pixels', ...
                                        'FontSize',this.bsize.bfont, ...
                                        'FontWeight','normal', ...
                                        'HorizontalAlignment','center', ...
                                        'VerticalAlignment','middle', ...
                                        'Visible','off');
                
                % Rank labels
                this.ranktexth(i,1) = text('Parent',this.ax(1), ...
                                        'Position',rpos(i,1), ...
                                        'FontUnits','pixels', ...
                                        'FontSize',this.bsize.bfont, ...
                                        'FontWeight','normal', ...
                                        'HorizontalAlignment','center', ...
                                        'VerticalAlignment','middle', ...
                                        'Visible','off');
                this.ranktexth(i,2) = text('Parent',this.ax(1), ...
                                        'Position',rpos(i,2), ...
                                        'FontUnits','pixels', ...
                                        'FontSize',this.bsize.bfont, ...
                                        'FontWeight','normal', ...
                                        'HorizontalAlignment','center', ...
                                        'VerticalAlignment','middle', ...
                                        'Visible','off');
            end
            
            % Create check text box
            this.checkh = text(1,1,'CHECK', ...
                                   'FontUnits','pixels', ...
                                   'FontSize',this.bsize.cfont, ...
                                   'FontWeight','bold', ...
                                   'HorizontalAlignment','center', ...
                                   'VerticalAlignment','middle', ...
                                   'Parent',this.ax(3), ...
                                   'Visible','off');
            %--------------------------------------------------------------
            
            % Create square highlights
            this.CHf = ChessHighlight(this.CHD,this.BS,this.ax(1));
            this.CHt = ChessHighlight(this.CHD,this.BS,this.ax(1));
            this.CHc = ChessHighlight(this.CHD,this.BS,this.ax(1));
            
            % Create turn marker
            this.turnColor = ChessPiece.WHITE;
            b = this.BS.flipped; % Board orientation flag
            pos = this.tcpos_white(1 + b,:);
            this.markerh = rectangle('Position',pos, ...
                                     'Curvature',[0.4 0.4], ...
                                     'Parent',this.ax(1), ...
                                     'Visible','off');
            
            % Apply last used theme
            this.LoadLastTheme();
            
            % Initialize board
            this.ResetBoard();
            
            % Finally, make the completed GUI visible
            set(this.fig,'Visible','on');
            
            % Save handle to figure manager
            this.FM.AddFigure(this.fig);
        end
        
        %
        % Spawn chess options GUI
        %
        function SpawnChessOptions(this)
            % Open engine options GUI
            xyc = this.GetCenterCoordinates();
            figh = this.CO.OpenGUI(xyc);
            
            % Save figure to figure manager, if necessary
            if ~isempty(figh)
                this.FM.AddFigure(figh);
            end
        end
        
        %
        % Spawn chess clock
        %
        function SpawnChessClock(this,tcStr,times,varargin)
            % If ChessClocks are enabled
            if (this.enableCC == true)
                % Get handle to existing ChessClock
                ctag = 'ChessClock';
                figh = this.FM.GetFigHandle(ctag);
                
                % If no ChessClock exists
                if isempty(figh)
                    % Spawn a chess clock
                    if (isempty(varargin) || isempty(varargin{2}))
                        % Spawn GUI centered on ChessMaster figure
                        args = {'xyc',this.GetCenterCoordinates()};
                    else
                        % Use supplied arguments
                        args = varargin;
                    end
                    if isempty(tcStr)
                        % Use default time control
                        tcStr = this.defTimeControl;
                    end
                    this.CC = ChessClock(this,tcStr,times,ctag,args{:});
                    
                    % Add figure to figure manager
                    this.FM.AddFigure(this.CC.fig);
                else
                    % Give focus to the existing ChessClock
                    figure(figh(1));
                end
            end
        end
        
        %
        % Spawn a move list
        %
        function SpawnMoveList(this,varargin)
            % If MoveLists are enabled
            if (this.enableML == true)
                % Get handle to existing MoveList
                mtag = 'MoveList';
                figh = this.FM.GetFigHandle(mtag);
                
                % If no MoveList exists
                if isempty(figh)                
                    % Spawn a move list
                    if (isempty(varargin) || isempty(varargin{2}))
                        % Spawn GUI centered on ChessMaster figure
                        args = {'xyc',this.GetCenterCoordinates()};
                    else
                        % Use supplied arguments
                        args = varargin;
                    end
                    this.ML = MoveList(this,mtag,args{:});
                    
                    % Load current moves
                    this.ML.AppendMoves({this.BS.moveList.SANstr},0);
                    this.ML.SetPosition(this.BS.currentMove);
                    
                    % Add figure to figure manager
                    this.FM.AddFigure(this.ML.fig);
                else
                    % Give focus to the existing MoveList
                    figure(figh(1));
                end
            end
        end
        
        %
        % Spawn a game analyzer GUI
        %
        function SpawnGameAnalyzer(this,varargin)
            % If GameAnalzyers are enabled
            if (this.enableGA == true)
                % Get handle to existing GameAnalyzer
                gtag = 'GameAnalyzer';
                figh = this.FM.GetFigHandle(gtag);
                
                % If no GameAnalyzer exists
                if isempty(figh)                
                    % Spawn a GameAnalyzer GUI
                    if (isempty(varargin) || isempty(varargin{2}))
                        % Spawn GUI centered on ChessMaster figure
                        args = {'xyc',this.GetCenterCoordinates()};
                    else
                        % Use supplied arguments
                        args = varargin;
                    end
                    engns = this.engines;
                    this.GA = GameAnalyzer(this,engns,gtag,args{:});
                    
                    % Append current moves
                    LANstrs = {this.BS.moveList.LANstr};
                    SANstrs = {this.BS.moveList.SANstr};
                    this.GA.AppendMoves(LANstrs,SANstrs,0);
                    
                    % Add figure to figure manager
                    this.FM.AddFigure(this.GA.fig);
                else
                    % Give focus to the existing GameAnalyzer
                    figure(figh(1));
                end
            end
        end
        
        %
        % Let user edit the current board theme
        %
        function EditTheme(this,varargin)
            % Get handle to existing ThemeEditor
            ttag = 'ThemeEditor';
            figh = this.FM.GetFigHandle(ttag);
            
            % If no ThemeEditor exists
            if isempty(figh)                
                % Spawn a ThemeEditor GUI based on the current theme
                color = this.themes.color(this.themes.ID);
                if (isempty(varargin) || isempty(varargin{2}))
                    % Spawn GUI centered on ChessMaster figure
                    args = {'xyc',this.GetCenterCoordinates()};
                else
                    % Use supplied arguments
                    args = varargin;
                end
                TE = ThemeEditor(this,color,ttag,args{:});
                
                % Add figure to figure manager
                this.FM.AddFigure(TE.fig);
            else
                % Give focus to the existing ThemeEditor
                figure(figh(1));
            end
        end
        
        %
        % Let user pick new board theme
        %
        function ChangeTheme(this)
            % Delete any existing ThemeEditor
            this.FM.CloseFigs('ThemeEditor');
            
            % Spawn a theme manager
            elements = {this.themes.color.name};
            initVal = this.themes.ID;
            name = 'Theme Manager';
            xyc = this.GetCenterCoordinates();
            [names idx] = MutableList.Instance(elements,initVal,name,xyc);
            
            % If cancel wasn't selected
            if ~isempty(idx)
                if isempty(names)
                    % Retain current theme
                    this.themes.color = this.themes.color(this.themes.ID);
                    this.themes.ID = 1;
                else
                    % Apply user changes
                    [~,inds] = ismember(names,elements);
                    this.themes.color = this.themes.color(inds);
                    
                    % Set board theme
                    this.SetBoardTheme(idx);
                end
            end
        end
        
        %
        % Set the board theme
        %
        function SetBoardTheme(this,idx)
            % Set the theme ID
            this.themes.ID = idx;
            
            % Apply the desired theme
            color = this.themes.color(this.themes.ID);
            this.ApplyTheme(color);
        end
        
        %
        % Set board sizes to match the desired square size
        %
        function SetBoardSize(this,sqSz,size)
            % Scale up theme size dimensions to desired square size
            ssq = round(sqSz * size.square);
            sbdr = round(sqSz * size.border);
            sbdy = round(sqSz * size.boundary);
            stm = round(sqSz * size.turnMarker);
            sbfont = round(sqSz * size.bfont);
            scfont = round(sqSz * size.cfont);
            shighlight = round(sqSz * size.highlight);
            btot = sbdy + sbdr;
            dim = 2 * btot + 8 * ssq;
            
            % Create a board size structure
            this.bsize = struct('square',ssq, ...
                                'border',sbdr, ...
                                'boundary',sbdy, ...
                                'turnMarker',stm, ...
                                'bfont',sbfont, ...
                                'cfont',scfont, ...
                                'highlight',shighlight, ...
                                'btotal',btot, ...
                                'dim',dim);
            
            % Compute file/rank coordinates
            this.file = btot + 1 + ssq * (0:8);
            this.rank = this.file;
            
            % Store file/rank coordinate matrices in piece structure
            this.CPD.filem = [this.file(1:8)' (this.file(2:9) - 1)'];
            this.CPD.rankm = [this.rank(1:8)' (this.rank(2:9) - 1)'];
            
            % Store graphics info for square highlighters
            this.CHD.file = this.file;
            this.CHD.rank = this.rank;
            this.CHD.size = shighlight;
            
            % Store file/rank center coordinates
            this.filec = 0.5 * (this.file(1:8) + this.file(2:9) - 1);
            this.rankc = 0.5 * (this.rank(1:8) + this.rank(2:9) - 1);
            
            % Store text alignment coordinates
            db = 0.5 * (sbdr - 1);
            this.file_textc = [(1 + db) (dim - db)];
            this.rank_textc = [(1 + db) (dim - db)];
            
            % Store turn marker coordinates
            pos = stm * [-0.5 -0.5 1 1];
            this.tcpos_white = [([(dim - db)  (1 + db)  0 0] + pos);
                                ([ (1 + db)   (1 + db)  0 0] + pos)];
            this.tcpos_black = [([(dim - db) (dim - db) 0 0] + pos);
                                ([ (1 + db)  (dim - db) 0 0] + pos)];
        end
        
        %
        % Save a screenshot of the current board
        %
        function TakeScreenshot(this)
            % Construct unique default filename
            ext = '.png';
            str = ['./board_' regexprep(date(),'-','')];
            len = length(str);
            str = [str ext];
            num = 1;
            while (exist(str,'file') == 2)
                num = num + 1;
                str = [str(1:len) '_' num2str(num) ext];
            end
            
            % Ask the user for a filename
            path = inputdlg({['Enter a path (plus extension) for the ' ...
                              'screenshot:']}, ...
                              'Take a screenshot',1, ...
                              {str},'on');
            drawnow; % hack to avoid MATLAB freeze + crash
            
            % Make sure the user didn't press cancel
            if ~isempty(path)
                % Take the screenshot
                saveas(this.fig,path{1});
            end
        end
        
        %
        % Refresh board
        %
        function RefreshBoard(this)
            % Update axis orientation
            if (this.BS.flipped == true)
                % Black on bottom
                set(this.ax,'XDir','Reverse','YDir','Reverse');
            else
                % White on bottom
                set(this.ax,'XDir','Normal','YDir','Normal');
            end
            
            % Refresh pieces
            this.BS.RefreshPieces();
            
            % Update turn marker
            this.UpdateTurnMarker();
            
            % Update check text
            this.UpdateCheckText();
            
            % Update chess clock orientation, if necessary
            if ~isempty(this.CC)
                this.CC.UpdateClockOrientation();
            end
        end
        
        %
        % Update GUI state based on the current board position
        %
        function UpdateGUI(this,drawflag)
            % Get some info
            drawflag = ~((nargin > 1) && (drawflag == false));
            currMove = this.BS.currentMove;
            
            % Update check text
            this.UpdateCheckText();
            
            % Update square highlights
            if (currMove == 0)
                % Reached beginning of game, so turn off highlights
                this.CHf.Off();
                this.CHt.Off();
            else
                % Highlight last move locations
                move = this.BS.moveList(currMove);
                this.CHf.SetLocation(move.fromi,move.fromj);
                this.CHt.SetLocation(move.toi,move.toj);
            end
            
            % Update undo menu
            if (currMove == 0)
                % No undos allowed
                this.UpdateUndoMenu('off');
            else
                % Undos are allowed
                this.UpdateUndoMenu('on');
            end
            
            % Update redo menu
            if (currMove == length(this.BS.moveList))
                % No redos allowed
                this.UpdateRedoMenu('off');
            else
                % Redos allowed
                this.UpdateRedoMenu('on');
            end
            
            % Update fifty move rule menu
            this.UpdateFiftyMoveRuleMenu();
            
            % Update threefold repetition rule menu
            this.Update3FoldRepMenu();
            
            % Update last move menu
            this.UpdateLastMoveMenu();
            
            % Set chess clock state, if necessary
            if ~isempty(this.CC)
                this.CC.SetClockState(currMove);
            end
            
            % Set analyzer move label position, if necessary
            if ~isempty(this.GA)
                this.GA.SetMoveLabelPosition(currMove);
            end
            
            % Flush graphics, if necessary
            if (drawflag == true)
                this.FlushGraphics();
            end
            
            % Update move list, if necessary
            if ~isempty(this.ML)
                this.ML.SetPosition(currMove);
            end
        end
        
        %
        % Update last move menu items
        %
        function UpdateLastMoveMenu(this)
            % Process based on turn color
            switch this.turnColor
                case ChessPiece.WHITE
                    % Currently white's turn
                    widx = this.BS.currentMove - 1;
                    bidx = this.BS.currentMove;
                case ChessPiece.BLACK
                    % Currently black's turn
                    widx = this.BS.currentMove;
                    bidx = this.BS.currentMove - 1;
            end
            
            % Update last white move
            if (widx > 0)
                % Get last move's SAN
                wSANstr = this.BS.moveList(widx).SANstr;
            else
                % Empty string
                wSANstr = '     ';
            end
            set(this.movewh,'Label',['W: ' wSANstr]);
            
            % Update last black move
            if (bidx > 0)
                % Get last move's SAN
                bSANstr = this.BS.moveList(bidx).SANstr;
            else
                % Empty string
                bSANstr = '     ';
            end
            set(this.movebh,'Label',['B: ' bSANstr]);
            
            % Update menu visibility
            if (this.showLastMoveMenu == true)
                set(this.movewh,'Visible','on');
                set(this.movebh,'Visible','on');
            else
                set(this.movewh,'Visible','off');
                set(this.movebh,'Visible','off');
            end
        end
        
        %
        % Update draw/resign menus
        %
        function UpdateDrawResignMenus(this)
            % Check game status
            if (this.isGameOver == true)
                % Game is over, so don't allow draw offers, resignations
                set(this.drawh1,'Enable','off');
                set(this.drawh2,'Enable','off');
                set(this.drawh3,'Enable','off');
                set(this.resignh,'Enable','off');
            else
                % Game is not over, so allow draws/resignations
                set(this.drawh1,'Enable','on');
                set(this.resignh,'Enable','on');
            end
        end
        
        %
        % Update fifty-move rule menu
        %
        function UpdateFiftyMoveRuleMenu(this)
            % If >= 50 turns since last pawn movement or capture
            if (this.BS.GetReversibleMoves() >= 100)
                % Can now claim fifty-move rule
                set(this.drawh2,'Enable','on');
            else
                % Cannot claim fifty-move rule
                set(this.drawh2,'Enable','off');
            end
        end
        
        %
        % Update threefold repetition rule menu
        %
        function Update3FoldRepMenu(this)
            % If current state has been repeated 3x without progress
            if (this.BS.Is3FoldRep() == true)
                % Threefold repetition has just occured
                set(this.drawh3,'Enable','on');
            else
                % Cannot claim threefold repetition draw
                set(this.drawh3,'Enable','off');
            end
        end
        
        %
        % Update undo menu
        %
        function UpdateUndoMenu(this,str)
            % Update enable states
            set(this.undoh,'Enable',str);
            set(this.undoallh,'Enable',str);
        end
        
        %
        % Update redo menu
        %
        function UpdateRedoMenu(this,str)
            % Update enable states
            set(this.redoh,'Enable',str);
            set(this.redoallh,'Enable',str);
        end
        
        %
        % Help window
        %
        function Help(this,xyc)
            % Get handle to existing leaderboard
            htag = 'ChessMasterHelp';
            figh = this.FM.GetFigHandle(htag);
            
            % If no leaderboard exists
            if isempty(figh)                
                % Spawn help window
                help = this.version.help;
                if (nargin < 2)
                    xyc = this.GetCenterCoordinates();
                end
                name = [this.version.name ' Help'];
                HW = HelpWindow(help,name,htag,xyc);
                
                % Add figure to figure manager
                this.FM.AddFigure(HW.fig);
            else
                % Give focus to existing help window
                figure(figh(1));
            end
        end
        
        %
        % About window
        %
        function About(this,xyc)
            % Get handle to existing leaderboard
            atag = 'ChessMasterAbout';
            figh = this.FM.GetFigHandle(atag);
            
            % If no leaderboard exists
            if isempty(figh)                
                % Load version info
                name = this.version.name;
                release = this.version.release;
                date = this.version.date;
                author = this.version.author;
                contact = this.version.contact;
                
                % Spawn "about" window
                help.name = 'About';
                help.text = {[name ' v' release],'', ...
                              date,'', ...
                              author, ...
                              contact};
                if (nargin < 2)
                    xyc = this.GetCenterCoordinates();
                end
                name = 'About';
                HW = HelpWindow(help,name,atag,xyc);
                
                % Add figure to figure manager
                this.FM.AddFigure(HW.fig);
            else
                % Give focus to existing about window
                figure(figh(1));
            end
        end
        
        %
        % Restore last-used children windows
        %
        function RestoreChildrenWindows(this,cwindows)
            % Iterate through children list
            for i = 1:length(cwindows)
                % Process based on window tag
                switch cwindows(i).tag
                    case 'ChessEngine'
                        % Spawn a ChessEngine object
                        this.NewEngine(cwindows(i).xyc);
                    case 'GameAnalyzer'
                        % Spawn a GameAnalyzer object
                        this.SpawnGameAnalyzer('pos',cwindows(i).pos);
                    case 'ChessClock'
                        % Spawn a ChessClock object
                        this.SpawnChessClock('',[],'pos',cwindows(i).pos);
                    case 'MoveList'
                        % Spawn a MoveList object
                        this.SpawnMoveList('pos',cwindows(i).pos);
                    case 'ThemeEditor'
                        % Spawn a ThemeEditor object
                        this.EditTheme('pos',cwindows(i).pos);
                    case 'ChessMasterHelp'
                        % Spawn a "help" window
                        this.Help(cwindows(i).xyc);
                    case 'ChessMasterAbout'
                        % Spawn an "about" window
                        this.About(cwindows(i).xyc);
                end
            end
        end
        
        %
        % Get center coordinates of GUI
        %
        function xyc = GetCenterCoordinates(this)
            % Infer center coordinates from GUI position
            pos = get(this.fig,'Position');
            xyc = pos(1:2) + 0.5 * pos(3:4);
        end
        
        %
        % Flush graphics
        %
        function FlushGraphics(this,varargin) %#ok
            if ((nargin < 2) || (varargin{1} == true))
                % Flush graphics
                drawnow;
            end
        end
    end
    
    %
    % Private static methods
    %
    methods (Access = private, Static = true)
        %
        % Parse .pgn file at the specified location
        %
        function [moves outcome timeControl] = ParsePGN(path)
            % Read the pgn file
            fid = fopen(path,'r');
            pgn = '';
            while true
                % Get line
                line = fgetl(fid);
                if ~ischar(line)
                    break;
                end
                
                % Remove "rest of line" comments
                line = regexprep(line,';.+','');
                
                % Append line to PGN string
                pgn = [pgn ' ' line]; %#ok
            end
            fclose(fid);
            
            % Extract tags
            tagpat = '\[[^%\[\]]+\]';
            tags = regexp(pgn,tagpat,'match');
            pgn = regexprep(pgn,tagpat,'');
            
            % Process TimeControl tag
            timeControl = extractTagInfo(tags,'TimeControl');
            
            % Split body into bites
            pgn = regexprep(pgn,'e.p.',''); % Remove tricy en passant
            bites = regexp(pgn,'[^\s{}\.]+|{[^{}]*}','match');
            
            % Delete turn numbers
            bites(cellfun(@(str)~isnan(str2double(str)),bites)) = [];
            
            % Extract outcome
            if ismember(bites{end},{'1-0','0-1','1/2-1/2'})
                outcome = bites{end};
                bites(end) = [];
            else
                outcome = '';
            end
            
            % Process move/time info
            moves = repmat(struct('SAN',[],'time',[]),[1 0]);
            timepat = '{\s*\[%\s*clk\s+(?<time>[^\s\]]+)\s*\][^{}]*}';
            for i = 1:length(bites)
                % If bite is a comment
                if (bites{i}(1) == '{')
                    % Check comment for time info
                    move = regexp(bites{i},timepat,'names');
                    if ~isempty(move)
                        % Record clock time, in seconds
                        moves(end).time = str2sec(move.time);
                    else
                        % No time info given
                        moves(end).time = -1;
                    end
                else
                    % Record base SAN string (w/ "P"s prepended)
                    SAN = regexprep(bites{i},{'[+#x!?]','e.p.'},'');
                    if ~isempty(SAN)
                        if isstrprop(SAN(1),'lower')
                            SAN = ['P' SAN]; %#ok
                        end
                        moves(end + 1).SAN = SAN; %#ok
                    end
                end
            end
            
            %--------------------------------------------------------------
            % NESTED FUNCTIONS
            %--------------------------------------------------------------
            function info = extractTagInfo(tags,name)
            % Extract info string from tag with given name
            
                % Parse tags
                pat = ['\[\s*' name '\s*"(?<info>[^"]*)"\s*]'];
                infos = regexp(tags,pat,'names');
                
                % Check for desired tag name
                idx = find(cellfun(@(info)~isempty(info),infos),1,'last');
                if ~isempty(idx)
                    % Found desired info
                    info = infos{idx}.info;
                else
                    % No info
                    info = '';
                end
            end
            
            function sec = str2sec(str)
            % Convert HH:MM:SS.T to seconds
            
                % Split at colons
                strs = regexp(str,':','split');
                
                % Convert to seconds
                times = [zeros(1,3 - length(strs)) str2double(strs)];
                sec = [3600 60 1] * times';
            end
            %--------------------------------------------------------------
        end
        
        %
        % Get base directory of this class
        %
        function dir = GetBaseDir()
            % Extract base directory from location of current .m file
            [dir name ext] = fileparts(mfilename('fullpath')); %#ok
            
            % Convert to forward slashes for platform independence
            dir = regexprep(dir,'\','/');
        end
        
        %
        % Get coordinates of screen center
        %
        function xyc = GetScreenCenter()
            % Get center coordinates of screen
            scrsz = get(0,'ScreenSize');
            xyc = 0.5 * scrsz(3:4);
        end
        
        %
        % Extract best-sized pieces
        %
        function pieces = GetPieces(pieces,figSize)
            % Parse input args
            if (nargin < 2)
                % Default target figure size
                figSize = ChessMaster.DEFAULT_FIG_SIZE;
            end
            
            % Compute closest available piece size
            scrsz = get(0,'screensize');
            sqSz = figSize * min(scrsz(3:4)) / 9; % Target size
            [temp idx] = min(abs([pieces.size] - sqSz)); %#ok
            pieces = pieces(idx); % Closest available size
        end
        
        %
        % Generate board image from given bsize/color
        %
        function img = GenerateBoardImage(bsize,color)
            % Get board dimensions
            sbdr = bsize.border;
            ssq = bsize.square;
            btot = bsize.btotal;
            dim = bsize.dim;
            
            % Install border
            cbdr = permute(color.border,[1 3 2]);
            img = repmat(cbdr,[dim dim]);
            
            % Install boundary
            cbdy = permute(color.boundary,[1 3 2]);
            bdry = repmat(cbdy,[dim dim] - 2 * sbdr);
            img((sbdr + 1):(dim - sbdr),(sbdr + 1):(dim - sbdr),:) = bdry;
            
            % Create a (constant) light square
            sql = ChessMaster.ConstantSquare(ssq,color.light);
            
            % Create a (diagonal gradient) dark square
            sqd = ChessMaster.GradientSquare(ssq,color.dark1,color.dark2);
            
            % Install squares
            light_sq = false;
            idx = btot + 1 + ssq * (0:8);
            for i = 1:8
                % Toggle square color
                light_sq = ~light_sq;
                
                for j = 1:8
                    % Toggle square color
                    light_sq = ~light_sq;
                    
                    % Install squares
                    idxx = idx(i):(idx(i + 1) - 1);
                    idxy = idx(j):(idx(j + 1) - 1);
                    if (light_sq == true)
                        % Install a light square
                        img(idxx,idxy,:) = sql;
                    else
                        % Install a dark square
                        img(idxx,idxy,:) = sqd;
                    end
                end
            end
            
            % Convert to uint8 image
            img = uint8(round(img));
        end
        
        %
        % Generate a constant square of the given size/color
        %
        function square = ConstantSquare(sz,c)
            % Create constant square
            c = permute(c,[1 3 2]);
            square = repmat(c,[sz sz]);
        end
        
        %
        % Generate a gradient square of the given size/colors
        %
        function square = GradientSquare(sz,c1,c2)            
            % Interpolate colors
            c1 = permute(c1,[1 3 2]);
            c2 = permute(c2,[1 3 2]);
            inds = bsxfun(@plus,(1:sz)',(0:(sz - 1)));
            Nc = 2 * sz - 1;
            colors = repmat(c1,[1 Nc]) + ...
                            bsxfun(@times,0:(Nc - 1),(c2 - c1) / (Nc - 1));
            
            % Create gradient square
            square = zeros(sz,sz,3);
            for ii = 1:sz
                for jj = 1:sz
                    square(ii,jj,:) = colors(1,inds(ii,jj),:);
                end
            end
        end
    end
    
    %
    % Hidden public methods ***** NOT for human use *****
    %
    methods (Hidden = true, Access = public)
        %
        % Handle time-based win
        %
        function WinOnTime(this,winner)
            % Check mating material
            if (this.BS.SufficientMatingMaterial(winner) == false)
                % Insufficient mating material
                winner = ChessPiece.DRAW;
            end
            
            % Handle winner
            this.winner = winner;
            switch winner
                case ChessPiece.WHITE
                    % Black forfeited
                    str = 'Black forfeits on time.';
                case ChessPiece.BLACK
                    % White forfeited
                    str = 'White forfeits on time.';
                case ChessPiece.DRAW
                    % Insufficient mating material
                    str = 'Draw... (insufficient mating material).';
            end
            
            % Process game over
            this.GameOver(str);
        end
        
        %
        % Perform engine autoplay(s)
        %
        function EngineAutoPlay(this)
            % If engine autoplay is needed
            if ((this.nwauto > 0) && (this.nbauto > 0) && ...
                strcmpi(this.atimer.Running,'off'))
                % Start autoplay timer
                start(this.atimer);
            else
                % Kick-off a single autoplay session
                this.AutoPlay();
            end
        end
        
        %
        % Autoplay all (valid) engines
        %
        function AutoPlay(this)
            % If autoplay isn't already in progress
            if (this.alock == false)
                % Set autoplay lock
                this.alock = true;
                
                % Loop over engines
                idx = 1;
                while (idx <= length(this.CElist))
                    % If auto-play is valid
                    if ((this.elock == false) && isvalid(this.CElist(idx)))
                        % Auto-play engine
                        this.CElist(idx).AutoPlay(this.turnColor);
                    end
                    idx = idx + 1;
                end
                
                % Stop autoplay timer, if necessary
                if (((this.nwauto < 1) || (this.nbauto < 1)) && ...
                    strcmpi(this.atimer.Running,'on'))
                    % Stop autoplay timer
                    stop(this.atimer);
                end
                
                % Release autoplay lock
                this.alock = false;
                
                % Flush graphics
                this.FlushGraphics();
            end
        end
        
        %
        % Update number of engines of given color on autoplay
        %
        function IncNauto(this,color,inc)
            % Increment count for given color
            switch color
                case ChessPiece.WHITE
                    % White pieces
                    this.nwauto = this.nwauto + inc;
                case ChessPiece.BLACK
                    % Black pieces
                    this.nbauto = this.nbauto + inc;
                case ChessPiece.BOTH
                    % Both colors
                    this.nwauto = this.nwauto + inc;
                    this.nbauto = this.nbauto + inc;
            end
        end
        
        %
        % Get number of engines of given color on autoplay
        %
        function nauto = GetNauto(this,color)
            % Get count for given color
            switch color
                case ChessPiece.WHITE
                    % White pieces
                    nauto = this.nwauto;
                case ChessPiece.BLACK
                    % Black pieces
                    nauto = this.nbauto;
                case ChessPiece.BOTH
                    % Both colors
                    nauto = this.nwauto + this.nbauto;
            end
        end
        
        %
        % Delete given engine from engine list
        %
        function DeleteEngine(this,engine)
            % Loop over engines
            for i = length(this.CElist):-1:1
                if (this.CElist(i) == engine)
                    % Save persistent engine variables
                    this.engines.book = this.CElist(i).engineBook;
                    this.engines.idx = this.CElist(i).engineIdx;
                    
                    % Delete the specified engine
                    this.CElist(i) = [];
                end
            end
        end
        
        %
        % Delete chess clock
        %
        function DeleteChessClock(this)            
            % Clear the ChessClock pointer
            this.CC = [];
        end
        
        %
        % Delete move list
        %
        function DeleteMoveList(this)
            % Clear the MoveList pointer
            this.ML = [];
        end
        
        %
        % Delete game analyzer
        %
        function DeleteGameAnalyzer(this)
            % Save current engine state
            this.engines.idx = this.GA.engineIdx;
            
            % Clear the GameAnalyzer pointer
            this.GA = [];
        end
        
        %
        % Update move animation
        %
        function UpdateMoveAnimation(this,bool)
            % Set move animation flag
            this.animateMoves = bool;
        end
        
        %
        % Update move animation FPS
        %
        function SetAnimationFPS(this,val)
            % Update timer start delay and period (to msec precision) 
            period = round(1000 / val) / 1000;
            set(this.ptimer,'StartDelay',period,'Period',period);
        end
        
        %
        % Update last move highlight states
        %
        function UpdateLastMoveHighlights(this,bool)
            % Set "on" state of last move highlights
            this.CHf.SetOnState(bool);
            this.CHt.SetOnState(bool);
        end
        
        %
        % Update current move highlight states
        %
        function UpdateCurrentMoveHighlights(this,bool)
            % Set "on" state of current move highlights
            this.CHc.SetOnState(bool);
        end
        
        %
        % Update last move menu state
        %
        function UpdateLastMoveMenuState(this,bool)
            % Set move menu visibility flag
            this.showLastMoveMenu = bool;
            
            % Update last move menus
            this.UpdateLastMoveMenu();
        end
        
        %
        % Update turn marker state
        %
        function UpdateTurnMarkerState(this,bool)
            % Set turn marker visibility flag
            this.showTurnMarker = bool;
            
            % Update turn marker graphic
            this.UpdateTurnMarkerVisibility();
        end
        
        %
        % Update check text
        %
        function UpdateCheckText(this,bool)
            % Parse input args
            if (nargin >= 2);
                % Set check text flag
                this.checkText = bool;
            end
            
            % Get check status
            if (this.BS.InCheck(ChessPiece.WHITE) == true)
                % White king is in check
                king = this.BS.whiteKing;
                
                % Set check flag
                isCheck = true;
            elseif (this.BS.InCheck(ChessPiece.BLACK) == true)
                % Black king is in check
                king = this.BS.blackKing;
                
                % Set check flag
                isCheck = true;
            else
                % Release check flag
                isCheck = false;
            end
            
            % If a king is in check
            if ((isCheck == true) && (this.checkText == true))
                % Get GUI info
                dy = this.squareSize / 6; % 1/6th of square size
                sgn = 2 * this.BS.flipped - 1; % Orientation-based sign
                
                % Update check text position
                x = this.filec(king.i);
                y = this.rankc(king.j) + sgn * dy;
                set(this.checkh,'Position',[x y],'Visible','on');
            else
                % Turn off check text
                set(this.checkh,'Visible','off');
            end
        end
        
        %
        % Update undo/redo dialog state
        %
        function UpdateUndoRedoDialogState(this,bool)
            % Set undo/redo dialog flag
            this.allowDB = bool;
        end
        
        %
        % Update dialog moves threshold
        %
        function UpdateMoveThreshold(this,val)
            % Set moves threshold
            this.movesThresh = val;
        end
        
        %
        % Update file/rank text
        %
        function UpdateFileRankLabels(this,str)
            % Process based on option string
            switch str
                case 'Lowercase'
                    % Turn on text
                    letters = 'abcdefgh';
                    numbers = '12345678';
                    visible = 'on';
                case 'Uppercase'
                    % Turn on text
                    letters = 'ABCDEFGH';
                    numbers = '12345678';
                    visible = 'on';
                case 'None'
                    % Turn off text
                    visible = 'off';
            end
            
            % Update text, if necessary
            if strcmpi(visible,'on')
                for i = 1:8
                    % Update file text
                    set(this.filetexth(i,:),'String',letters(i));
                    
                    % Update rank text
                    set(this.ranktexth(i,:),'String',numbers(i));
                end
            end
            
            % Update file/rank text visibility
            set([this.filetexth; this.ranktexth],'Visible',visible);
        end
        
        %
        % Update GameAnalyzer enable state
        %
        function UpdateGameAnalyzerEnableState(this,bool)
            % Set GameAnalyzer enable state
            this.enableGA = bool;
            if (this.enableGA == true)
                % Enable game analyzer menu option
                set(this.gah,'Enable','on');
            else
                % Disable game analyzer menu option
                set(this.gah,'Enable','off');
                
                % Close existing game analyzer, if any
                this.CloseGameAnalyzer();
            end            
        end
        
        %
        % Update MoveList enable state
        %
        function UpdateMoveListEnableState(this,bool)
            % Set MoveList enable state
            this.enableML = bool;
            if (this.enableML == true)
                % Enable move list menu option
                set(this.mlh,'Enable','on');
            else
                % Disable move list menu option
                set(this.mlh,'Enable','off');
                
                % Close existing move list, if any
                this.CloseMoveList();
            end
        end
        
        %
        % Update ChessClock enable state
        %
        function UpdateChessClockEnableState(this,bool)
            % Set ChessClock enable state
            this.enableCC = bool;
            if (this.enableCC == true)
                % Enable chess clock menu option
                set(this.tch,'Enable','on');
            else
                % Disable chess clock menu option
                set(this.tch,'Enable','off');
                
                % Close existing chess clock, if any
                this.CloseChessClock();
            end
        end
        
        %
        % Apply the given color theme to the board
        %
        function ApplyTheme(this,color)
            % Update board image
            img = ChessMaster.GenerateBoardImage(this.bsize,color);
            XData = get(this.bh,'XData');
            YData = get(this.bh,'YData');
            set(this.bh,'CData',img, ...
                        'XData',XData, ...
                        'YData',YData);
            
            % Update file/rank text
            for i = 1:8
                set(this.filetexth(i,1),'Color',color.text / 255);
                set(this.filetexth(i,2),'Color',color.text / 255);
                set(this.ranktexth(i,1),'Color',color.text / 255);
                set(this.ranktexth(i,2),'Color',color.text / 255);
            end
            
            % Update check text
            set(this.checkh,'Color',color.text / 255, ...
                            'EdgeColor',color.boundary / 255, ...
                            'BackgroundColor',color.border / 255);
            
            % Update last-square highlights
            lastCHD = this.CHD;
            lastCHD.color = color.lastMove;
            this.CHf.SetStyle(lastCHD);
            this.CHt.SetStyle(lastCHD);
            
            % Update current-square highlight
            currentCHD = this.CHD;
            currentCHD.color = color.currentMove;
            this.CHc.SetStyle(currentCHD);
            
            % Update turn marker
            set(this.markerh,'FaceColor',color.turnMarker / 255);
        end
        
        %
        % Save the given color theme
        %
        function SaveTheme(this,color)
            % Determine theme index
            idx = find(ismember({this.themes.color.name},color.name));
            if isempty(idx)
                % Add new theme to list
                idx = length(this.themes.color) + 1;
            end
            
            % Save theme
            this.themes.color(idx) = color;
            this.themes.ID = idx; % Update current theme ID
        end
        
        %
        % Revert the board to the last used theme
        %
        function LoadLastTheme(this)
            % Apply last used theme            
            this.SetBoardTheme(this.themes.ID);
        end
        
        % Custom (empty) display method
        function display(varargin)
            % Empty
        end
        
        % Hide handle's addlistener() method
        function out = addlistener(varargin)
            out = addlistener@handle(varargin{:});
        end
        
        % Hide handle's eq() method
        function out = eq(varargin)
            out = eq@handle(varargin{:});
        end
        
        % Hide handle's findobj() method
        function out = findobj(varargin)
            out = findobj@handle(varargin{:});
        end
        
        % Hide handle's findprop() method
        function out = findprop(varargin)
            out = findprop@handle(varargin{:});
        end
        
        % Hide handle's ge() method
        function out = ge(varargin)
            out = ge@handle(varargin{:});
        end
        
        % Hide handle's gt() method
        function out = gt(varargin)
            out = gt@handle(varargin{:});
        end
        
        % Hide handle's le() method
        function out = le(varargin)
            out = le@handle(varargin{:});
        end
        
        % Hide handle's lt() method
        function out = lt(varargin)
            out = lt@handle(varargin{:});
        end
        
        % Hide handle's ne() method
        function out = ne(varargin)
            out = ne@handle(varargin{:});
        end
        
        % Hide handle's notify() method
        function notify(varargin)
            notify@handle(varargin{:});
        end
    end
end
