classdef BoardState < handle
%
% Class for sharing board state information between ChessPiece objects
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
        % Mate "enum"
        NOMATE = 0;                 % No mate
        CHECKMATE = 1;              % Checkmate
        STALEMATE = 2;              % Stalemate
    end
    
    %
    % Public properties
    %
    properties (Access = public)
        % Move info
        moveList = Move.empty();    % List of moves in current game
        currentMove = 0;            % Current halfmove in the game
        flipped = false;            % Board orientation flag
    end
    
    %
    % Public GetAccess properties
    %
    properties (GetAccess = public, SetAccess = private)
        % King objects
        whiteKing;                  % White king
        blackKing;                  % Black king
    end
    
    %
    % Private properties
    %
    properties (Access = private)
        board = num2cell(nan(8,8)); % Cell array of ChessPiece objects
        whitePieces = {};           % Cell array of white piece handles
        blackPieces = {};           % Cell array of black piece handles
        whiteInCheck = false;       % White check status
        blackInCheck = false;       % Black check status
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = BoardState()
            % Empty
        end
        
        %
        % Add piece @(i,j)
        %
        function AddPiece(this,obj)
            % Add piece to board
            this.board{obj.i,obj.j} = obj;
            
            % Add piece to color collection
            switch obj.color
                case ChessPiece.WHITE
                    % White piece
                    this.whitePieces{end + 1} = obj;
                    
                    % Store dedicated copy of king pointer
                    if (obj.ID == King.ID)
                        this.whiteKing = obj;
                    end
                case ChessPiece.BLACK
                    % Black piece
                    this.blackPieces{end + 1} = obj;
                    
                    % Store dedicated copy of king pointer
                    if (obj.ID == King.ID)
                        this.blackKing = obj;
                    end
            end
        end
        
        %
        % Remove piece
        %
        function RemovePiece(this,obj)
            % Remove piece from board
            this.board{obj.i,obj.j} = nan;
            
            % Remove piece from color collection
            iseq = @(p) (p == obj);
            switch obj.color
                case ChessPiece.WHITE
                    % White piece
                    this.whitePieces(cellfun(iseq,this.whitePieces)) = [];
                case ChessPiece.BLACK
                    % Black piece
                    this.blackPieces(cellfun(iseq,this.blackPieces)) = [];
            end
        end
        
        %
        % Move given piece to (i,j)
        %
        function MovePiece(this,obj,i,j)
            % Remove piece from old location
            this.board{obj.i,obj.j} = nan;
            
            % Add piece to new location
            this.board{i,j} = obj;
        end
        
        %
        % Return handle to piece @(i,j)
        %
        function obj = PieceAt(this,i,j)
            obj = this.board{i,j};
        end
        
        %
        % Return color of piece at (i,j)
        %
        function color = ColorAt(this,i,j)
            if (this.IsEmpty(i,j) == true)
                color = nan;
            else
                color = this.PieceAt(i,j).color;
            end
        end
        
        %
        % Check if (i,j) empty
        %
        function bool = IsEmpty(this,i,j)
            bool = isnan(this.board{i,j});
        end
        
        %
        % Check if (i,j) is occupied by a white piece
        %
        function bool = IsWhite(this,i,j)
            bool = false;
            if (~this.IsEmpty(i,j) && ...
                (this.board{i,j}.color == ChessPiece.WHITE))
                bool = true;
            end
        end
        
        %
        % Check if (i,j) is occupied by a black piece
        %
        function bool = IsBlack(this,i,j)
            bool = false;
            if (~this.IsEmpty(i,j) && ...
                (this.board{i,j}.color == ChessPiece.BLACK))
                bool = true;
            end
        end
        
        %
        % Return handles to the pieces of the given color and ID that can
        % attack square (i,j)
        %
        function pieces = Attackers(this,i,j,color,ID)
            % Get locations of all opposing pieces
            switch color
                case ChessPiece.WHITE
                    % Opponents are white
                    pieces = this.whitePieces;
                case ChessPiece.BLACK
                    % Opponents are black
                    pieces = this.blackPieces;
            end
            
            % Only return attacking pieces
            isattacking = @(p) ((p.ID ~= ID) || ~p.IsValidMove(i,j));
            pieces(cellfun(isattacking,pieces)) = [];
        end
        
        %
        % Determine whether square (i,j) is under attack by the given color
        %
        function bool = IsUnderAttack(this,i,j,color)
            % Get locations of all opposing pieces
            switch color
                case ChessPiece.WHITE
                    % Opponents are white
                    pieces = this.whitePieces;
                case ChessPiece.BLACK
                    % Opponents are black
                    pieces = this.blackPieces;
            end
            
            % Loop over opposing pieces
            bool = false;
            for k = 1:length(pieces)
                % Check if opponent can capture
                if pieces{k}.IsValidMove(i,j)
                    % Found an attacker
                    bool = true;
                    return;
                end
            end
        end
        
        %
        % Return the check status of the given color
        %
        % NOTE: This function doesn't recompute the check statuses, it
        % merely returns the last computed values
        %
        function bool = InCheck(this,color)
            switch color
                case ChessPiece.WHITE
                    % White king check status
                    bool = this.whiteInCheck;
                case ChessPiece.BLACK
                    % Black king check status
                    bool = this.blackInCheck;
            end
        end
        
        %
        % Update check statuses
        % 
        function UpdateChecks(this)
            % Update check status of white king
            this.whiteInCheck = this.IsWhiteInCheck();
            
            % Update check status of black king
            this.blackInCheck = this.IsBlackInCheck();
        end
        
        %
        % Check if the white king is in check
        %
        function bool = IsWhiteInCheck(this)
            % Look to see if the king has any attackers
            i = this.whiteKing.i;
            j = this.whiteKing.j;
            bool = this.IsUnderAttack(i,j,ChessPiece.BLACK);
        end
        
        %
        % Check if the black king is in check
        %
        function bool = IsBlackInCheck(this)
            % Look to see if the king has any attackers
            i = this.blackKing.i;
            j = this.blackKing.j;
            bool = this.IsUnderAttack(i,j,ChessPiece.WHITE);
        end
        
        %
        % Return the checkmate/stalemate status of the given color
        %
        function mate = MateStatus(this,color)            
            % Get pieces of specified color
            switch color
                case ChessPiece.WHITE
                    % Get white pieces
                    pieces = this.whitePieces;
                case ChessPiece.BLACK
                    % Get white pieces
                    pieces = this.blackPieces;
            end
            
            % Look for checkmates
            for k = 1:length(pieces)
                % Get all valid moves for this piece
                [ii jj] = pieces{k}.ValidMoves();
                
                % Loop over valid moves
                for kk = 1:length(ii)
                    % Check for legal move
                    if ~pieces{k}.IsCheckingMove(ii(kk),jj(kk))
                        % Found a legal move
                        mate = BoardState.NOMATE;
                        return;
                    end
                end
            end
            
            % Decide between checkmate and stalemate
            if (this.InCheck(color) == true)
                % Checkmate!
                mate = BoardState.CHECKMATE;
            else
                % Stalemate...
                mate = BoardState.STALEMATE;
            end
        end
        
        %
        % Check if the given color has sufficient mating material
        %
        function bool = SufficientMatingMaterial(this,color)
            % Process based on color
            switch color
                case ChessPiece.WHITE
                    if (length(this.whitePieces) > 1)
                        % Sufficient mating material
                        bool = true;
                    else
                        % Insufficient mating material
                        bool = false;
                    end
                case ChessPiece.BLACK
                    if (length(this.blackPieces) > 1)
                        % Sufficient mating material
                        bool = true;
                    else
                        % Insufficient mating material
                        bool = false;
                    end
            end                
        end
        
        %
        % Check if the White King or the White rook in the given file have
        % moved during this game, and check if any of the spaces involved
        % in the castle have attackers
        %
        % file = 1 <==> queenside castle
        % file = 8 <==> kingside castle
        %
        function bool = IsValidWhiteCastle(this,file)
            % Look for open spaces/checks
            bool = true;
            if (file == 1)
                % Queenside castle
                
                % Make sure squares are open 
                if (~this.IsEmpty(2,1) || ...
                    ~this.IsEmpty(3,1) || ...
                    ~this.IsEmpty(4,1))
                    % One of the requisite squares is not empty
                    bool = false;
                    return;
                end
                
                % Make sure no relevant squares are under attack
                if (this.IsUnderAttack(3,1,ChessPiece.BLACK) || ...
                    this.IsUnderAttack(4,1,ChessPiece.BLACK) || ...
                    this.IsUnderAttack(5,1,ChessPiece.BLACK))
                    % One of the squares is under attack
                    bool = false;
                    return;
                end
            else
                % Kingside castle
                
                % Make sure squares are open 
                if (~this.IsEmpty(6,1) || ~this.IsEmpty(7,1))
                    % One of the requisite squares is not empty
                    bool = false;
                    return;
                end
                
                % Make sure no relevant squares are under attack
                if (this.IsUnderAttack(5,1,ChessPiece.BLACK) || ...
                    this.IsUnderAttack(6,1,ChessPiece.BLACK) || ...
                    this.IsUnderAttack(7,1,ChessPiece.BLACK))
                    % One of the squares is under attack
                    bool = false;
                    return;
                end
            end
            
            % Check if the king or rook has been moved
            for i = 1:2:this.currentMove
                % Only white moves
                move = this.moveList(i);
                if ((move.ID == King.ID) || ...
                    ((move.ID == Rook.ID) && (move.fromi == file)))
                    % King or rook was moved
                    bool = false;
                    return;
                end
            end
        end
        
        % 
        % Check if the Black King or the Black rook in the given file have
        % moved during this game, and check if any of the spaces involved
        % in the castle have attackers
        % 
        % file = 1 <==> queenside castle
        % file = 8 <==> kingside castle
        % 
        function bool = IsValidBlackCastle(this,file)
            % Look for open spaces/checks
            bool = true;
            if (file == 1)
                % Queenside castle
                
                % Make sure squares are open 
                if (~this.IsEmpty(2,8) || ...
                    ~this.IsEmpty(3,8) || ...
                    ~this.IsEmpty(4,8))
                    % One of the requisite squares is not empty
                    bool = false;
                    return;
                end
                
                % Make sure no relevant squares are under attack
                if (this.IsUnderAttack(3,8,ChessPiece.WHITE) || ...
                    this.IsUnderAttack(4,8,ChessPiece.WHITE) || ...
                    this.IsUnderAttack(5,8,ChessPiece.WHITE))
                    % One of the squares is under attack
                    bool = false;
                    return;
                end
            else
                % Kingside castle
                
                % Make sure squares are open 
                if (~this.IsEmpty(6,8) || ~this.IsEmpty(7,8))
                    % One of the requisite squares is not empty
                    bool = false;
                    return;
                end
                
                % Make sure no relevant squares are under attack
                if (this.IsUnderAttack(5,8,ChessPiece.WHITE) || ...
                    this.IsUnderAttack(6,8,ChessPiece.WHITE) || ...
                    this.IsUnderAttack(7,8,ChessPiece.WHITE))
                    % One of the squares is under attack
                    bool = false;
                    return;
                end
            end
            
            % Check if the king or rook has been moved
            for i = 2:2:this.currentMove
                % Only black moves
                move = this.moveList(i);
                if ((move.ID == King.ID) || ...
                    ((move.ID == Rook.ID) && (move.fromi == file)))
                    % King or rook was moved
                    bool = false;
                    return;
                end
            end
        end
        
        %
        % Check if the piece at the specified location is a pawn that just
        % two-stepped (for en-passant capture)
        %
        function bool = IsValidEnPassant(this,i,j)
            bool = false;
            piece = this.PieceAt(i,j);
            if (piece.ID == Pawn.ID)
                % The piece is a pawn (assumed of correct color)
                move = this.moveList(this.currentMove);
                color = piece.color;
                switch color
                    case ChessPiece.WHITE
                        % Make sure white pawn just two-stepped
                        if ((move.toi == i) && ...
                            (move.toj == j) && ...
                            (move.fromj == 2))
                            % Valid en-passant
                            bool = true;
                        end
                    case ChessPiece.BLACK
                        % Make sure black pawn just two-stepped
                        if ((move.toi == i) && ...
                            (move.toj == j) && ...
                            (move.fromj == 7))
                            % Valid en-passant
                            bool = true;
                        end
                end
            end
        end
        
        %
        % Get a random move for the given color
        %
        function LANstr = GetRandomMove(this,color)
            % Get pieces of specified color
            switch color
                case ChessPiece.WHITE
                    % Get white pieces
                    promRank = 8;
                    pieces = this.whitePieces;
                case ChessPiece.BLACK
                    % Get black pieces
                    promRank = 1;
                    pieces = this.blackPieces;
            end
            
            % Search for a random (legal) move
            np = length(pieces);
            idx = 1;
            ids = randperm(np); % Loop through pieces in random order
            bool = false;
            while ((bool == false) && (idx <= np))
                % Get all valid moves for this piece
                piece = pieces{ids(idx)};
                [ii jj] = piece.ValidMoves();
                
                % Loop over valid moves
                nv = length(ii);
                ids2 = randperm(nv); % Loop through moves in random order
                ii = ii(ids2);
                jj = jj(ids2);
                for kk = 1:nv
                    % Check for legal move
                    if (piece.IsCheckingMove(ii(kk),jj(kk)) == false)
                        % Found a legal move
                        fmi = piece.i;
                        fmj = piece.j;
                        toi = ii(kk);
                        toj = jj(kk);
                        
                        % Add a promotion, if necessary
                        if ((piece.ID == Pawn.ID) && (toj == promRank))
                            % Random promotion
                            promID = randi([2 5]);
                        else
                            promID = [];
                        end
                        
                        % Return LAN string
                        LANstr = Move.GenerateLAN(fmi,fmj,toi,toj,promID);
                        return;
                    end
                end
                
                % Increment counter
                idx = idx + 1;
            end
            
            % No legal moves found... (this should never happen)
            msgid = 'BS:NOLEGALMOVES';
            errmsg = 'No legal moves found';
            error(msgid,errmsg);
        end
        
        %
        % Get number of halfmoves since last capture or pawn movement
        %
        function count = GetReversibleMoves(this)
            if (this.currentMove > 0)
                % Get npm from last saved move
                count = this.moveList(this.currentMove).reversibleMoves;
            else
                % No moves yet, so return zero
                count = 0;
            end
        end
        
        %
        % Determine if threefold repetition has just occured
        %
        function bool = Is3FoldRep(this)
            bool = false;
            if (this.currentMove > 0)
                % Only need to search last consecutive reversible moves
                Nrev = this.GetReversibleMoves();
                
                % Current state
                cstate = this.GetCurrentEncoding();
                
                % Iterate backwards through previous moves
                count = 1;
                for i = 1:(Nrev - 1)
                    % Check for equality with current state
                    pstate = this.moveList(this.currentMove - i).state;
                    if all(cstate(:) == pstate(:))
                        % Found a repetition
                        count = count + 1;
                        if (count >= 3)
                            % Found threefold repetition
                            bool = true;
                            return;
                        end
                    end
                end
            end
        end
        
        %
        % Get current (i.e., most recently performed) board encoding
        %
        function state = GetCurrentEncoding(this)
            % See if any moves have been performed
            if (this.currentMove > 0)
                % Get current encoding from move list
                state = this.moveList(this.currentMove).state;
            else
                % No moves yet, so get default encoding
                state = this.BaseEncoding();
            end
        end
        
        %
        % Encode board state
        %
        % NOTE: The following uint8 encoding strategy is used,
        %       where Bit 1 = LSB and Bit 8 = MSB
        %
        %  Bit | Description
        % -----+-------------
        %  1-3 | ID
        %  4-5 | Not used
        %   6  | En passant (assigned in Move.EncodeBoardState())
        %   7  | Castling (partially assigned in Move.EncodeBoardState())
        %   8  | Color
        %
        function state = BaseEncoding(this)
            % Empty state
            state = zeros(8,8,'uint8');
            
            % Encode white pieces
            for k = 1:length(this.whitePieces)
                piece = this.whitePieces{k};
                i = piece.i;
                j = piece.j;
                state(i,j) = piece.ID;
                if (((piece.ID == Rook.ID) || (piece.ID == King.ID)) && ...
                    (this.currentMove > 0))
                    % Record castling rights
                    if bitget(this.moveList(this.currentMove).state(i,j),7)
                        % King/rook has already moved
                        state(i,j) = bitset(state(i,j),7);
                    end
                end
            end
            
            % Encode black pieces
            for k = 1:length(this.blackPieces)
                piece = this.blackPieces{k};
                i = piece.i;
                j = piece.j;
                state(i,j) = 128 + piece.ID;
                if (((piece.ID == Rook.ID) || (piece.ID == King.ID)) && ...
                   (this.currentMove > 0))
                    % Record castling rights
                    if bitget(this.moveList(this.currentMove).state(i,j),7)
                        % King/rook has already moved
                        state(i,j) = bitset(state(i,j),7);
                    end
                end
            end
        end
        
        %
        % Generate FEN string describing the current board position with
        % the given color to move
        %
        function FENstr = GenerateFEN(this,color)
            % Get encoded board state
            state = this.GetCurrentEncoding();
            
            % Get # halfmoves
            halfMoves = this.GetReversibleMoves();
            
            % Get # full moves
            fullMoves = floor(this.currentMove / 2) + 1;
            
            % Generate piece location strings
            pcolor = bitget(state,8); % 0 = White, 1 = Black
            pSyms = [Move.SYMBOLS '1'];
            pieces =     bitget(state,1) + ...
                     2 * bitget(state,2) + ...
                     4 * bitget(state,3);
            pieces(pieces == 0) = length(pSyms);
            plStrs = pSyms(pieces);
            plStrs(pcolor == 0) = upper(plStrs(pcolor == 0));
            plStrs(pcolor == 1) = lower(plStrs(pcolor == 1));
            plStrs = cellstr(flipud(plStrs'));
            fcn = @(str)regexprep(str,'1+','${num2str(length($&))}');
            plStrs = cellfun(fcn,plStrs,'UniformOutput',false);
            
            % Generate turn color string
            switch color
                case ChessPiece.WHITE
                    % White to move
                    tcStr = 'w';
                case ChessPiece.BLACK
                    % Black to move
                    tcStr = 'b';
            end
            
            % Generate castling string
            cStr = '';
            if ((pieces(5,1) == King.ID) && ...
                (pcolor(5,1) == 0) && ...
                (bitget(state(5,1),7) == 0))
                % White king hasn't moved
                if ((pieces(8,1) == Rook.ID) && ...
                    (pcolor(8,1) == 0) && ...
                    (bitget(state(8,1),7) == 0))
                    % White kingside castle is legal
                    cStr = [cStr 'K'];
                end
                if ((pieces(1,1) == Rook.ID) && ...
                    (pcolor(1,1) == 0) && ...
                    (bitget(state(1,1),7) == 0))
                    % White queenside castle is legal
                    cStr = [cStr 'Q'];
                end
            end
            if ((pieces(5,8) == King.ID) && ...
                (pcolor(5,8) == 1) && ...
                (bitget(state(5,8),7) == 0))
                % Black king hasn't moved
                if ((pieces(8,8) == Rook.ID) && ...
                    (pcolor(8,8) == 1) && ...
                    (bitget(state(8,8),7) == 0))
                    % Black kingside castle is legal
                    cStr = [cStr 'k'];
                end
                if ((pieces(1,8) == Rook.ID) && ...
                    (pcolor(1,8) == 1) && ...
                    (bitget(state(1,8),7) == 0))
                    % White queenside castle is legal
                    cStr = [cStr 'q'];
                end
            end
            if isempty(cStr)
                % No valid castles
                cStr = '-';
            end
            
            % Generate en-passant string
            [i j] = find(bitget(state,6));
            if ~isempty(i)
                % Record en-passant target square
                epStr = [Move.FILES(i) Move.RANKS(j)];
            else
                % No en-passant targets
                epStr = '-';
            end
            
            % Generate FEN string
            FENstr = sprintf('%s/%s/%s/%s/%s/%s/%s/%s %s %s %s %i %i', ...
                           plStrs{:},tcStr,cStr,epStr,halfMoves,fullMoves);
        end
        
        %
        % Refresh pieces on board
        %
        function RefreshPieces(this)
            % Refresh white pieces
            for i = 1:length(this.whitePieces)
                this.whitePieces{i}.DrawPiece();
            end
            
            % Refresh black pieces
            for i = 1:length(this.blackPieces)
                this.blackPieces{i}.DrawPiece();
            end
        end
        
        %
        % Clear the entire board state
        %
        function Clear(this)
            % Delete white pieces
            for i = 1:length(this.whitePieces)
                this.whitePieces{i}.Delete();
            end
            this.whitePieces = {};
            this.whiteKing = nan;
            this.whiteInCheck = false;
            
            % Delete black pieces
            for i = 1:length(this.blackPieces)
                this.blackPieces{i}.Delete();
            end
            this.blackPieces = {};
            this.blackKing = nan;
            this.blackInCheck = false;
            
            % Clear board
            this.board = num2cell(nan(8,8));
            
            % Clear the move list
            this.moveList = Move.empty(0,1);
            this.currentMove = 0;
        end
    end
end
