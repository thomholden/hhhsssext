classdef King < ChessPiece
%
% Class representing the King piece
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
        ID = 6;                     % Piece ID number
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = King(ax,BS,CPD,color,i,j)
            % Call ChessPiece constructor
            this = this@ChessPiece(ax,BS,CPD,color,King.ID,i,j);
        end
        
        %
        % Check if a move is valid (i.e., pseudo-legal)
        %
        function bool = IsValidMove(this,i,j)
            % Assume invalid by default
            bool = false;
            
            % Get movement
            dfile = i - this.i;
            drank = j - this.j;

            % Check move validity
            if ((abs(dfile) <= 1) && (abs(drank) <= 1))
                % Check for vacancy
                if ((this.BS.IsEmpty(i,j) == true) || ...
                   (this.color ~= this.BS.ColorAt(i,j)))
                    bool = true;
                end
            elseif ((this.color == ChessPiece.WHITE) && ...
                    (this.j == 1) && ...
                    (dfile == 2) && ...
                    (drank == 0))
                % White is attempting a king's side castle
                if this.BS.IsValidWhiteCastle(8)
                    bool = true;
                end
            elseif ((this.color == ChessPiece.WHITE) && ...
                    (this.j == 1) && ...
                    (dfile == -2) && ...
                    (drank == 0))
                % White is attempting a queen's side castle
                if this.BS.IsValidWhiteCastle(1)
                    bool = true;
                end
            elseif ((this.color == ChessPiece.BLACK) && ...
                    (this.j == 8) && ...
                    (dfile == 2) && ...
                    (drank == 0))
                % Black is attempting a king's side castle
                if this.BS.IsValidBlackCastle(8)
                    bool = true;
                end
            elseif ((this.color == ChessPiece.BLACK) && ...
                    (this.j == 8) && ...
                    (dfile == -2) && ...
                    (drank == 0))
                % Black is attempting a queen's side castle
                if this.BS.IsValidBlackCastle(1)
                    bool = true;
                end
            end
        end
        
        %
        % Return coordinates of all valid (i.e., pseudo-legal) moves
        %
        function [ii jj] = ValidMoves(this)
            % Try all possible moves
            ii = this.i + [-1  0  1 -1  1  -1  0  1  2 -2];
            jj = this.j + [-1 -1 -1  0  0   1  1  1  0  0];
            kk = (ii >= 1) .* (ii <= 8) .* (jj >= 1) .* (jj <= 8);
            for k = 1:10
                if ((kk(k) == true) && ~this.IsValidMove(ii(k),jj(k)))
                    kk(k) = 0;
                end
            end
            
            % Return valid moves
            ii = ii(logical(kk));
            jj = jj(logical(kk));
        end
    end
end
