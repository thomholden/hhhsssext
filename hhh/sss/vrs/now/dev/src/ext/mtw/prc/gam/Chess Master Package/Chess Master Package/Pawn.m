classdef Pawn < ChessPiece
%
% Class representing the Pawn piece
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
        ID = 1;                     % Piece ID number
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = Pawn(ax,BS,CPD,color,i,j)
            % Call ChessPiece constructor
            this = this@ChessPiece(ax,BS,CPD,color,Pawn.ID,i,j);
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

            % Parse based on pawn color
            if (this.color == ChessPiece.WHITE)
                % White pawn
                if ((this.j == 2) && (drank == 2) && (dfile == 0) && ...
                    this.BS.IsEmpty(i,j) && this.BS.IsEmpty(i,j - 1))
                    % Initial two-step move
                    bool = true;
                elseif (drank == 1) && (abs(dfile) <= 1)
                    if (dfile == 0)
                        % Trying to step forward one square
                        if this.BS.IsEmpty(i,j)
                            bool = true;
                        end
                    else
                        % Trying to capture @(i,j)
                        if this.BS.IsBlack(i,j)
                            bool = true;
                        end

                        % Trying an en-passant capture
                        if ((this.j == 5) && (this.BS.IsBlack(i,5)))
                            if this.BS.IsValidEnPassant(i,5)
                                bool = true;
                            end
                        end
                    end
                end
            else
                % Black pawn
                if ((this.j == 7) && (drank == -2) && (dfile == 0) && ...
                    this.BS.IsEmpty(i,j) && this.BS.IsEmpty(i,j + 1))
                    % Initial two-step move
                    bool = true;
                elseif (drank == -1) && (abs(dfile) <= 1)
                    if (dfile == 0)
                        % Trying to step forward one square
                        if this.BS.IsEmpty(i,j)
                            bool = true;
                        end
                    else
                        % Trying to capture @(i,j)
                        if this.BS.IsWhite(i,j)
                            bool = true;
                        end

                        % Trying an en-passant capture
                        if ((this.j == 4) && (this.BS.IsWhite(i,4)))
                            if this.BS.IsValidEnPassant(i,4)
                                bool = true;
                            end
                        end
                    end
                end
            end
        end
        
        %
        % Return coordinates of all valid (i.e., pseudo-legal) moves
        %
        function [ii jj] = ValidMoves(this)
            % Process based on pawn color
            switch this.color
                case ChessPiece.WHITE
                    % White pawn
                    sgnj = 1;
                case ChessPiece.BLACK
                    % Black pawn
                    sgnj = -1;
            end
            
            % Try all possible moves
            ii = this.i + [0  0 -1  1];
            jj = this.j + sgnj * [2  1  1  1];
            kk = (ii >= 1) .* (ii <= 8) .* (jj >= 1) .* (jj <= 8);
            for k = 1:4
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
