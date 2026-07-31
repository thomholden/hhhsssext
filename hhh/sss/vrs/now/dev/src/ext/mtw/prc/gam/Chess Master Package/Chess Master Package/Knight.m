classdef Knight < ChessPiece
%
% Class representing the Knight piece
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
        ID = 2;                     % Piece ID number
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = Knight(ax,BS,CPD,color,i,j)
            % Call ChessPiece constructor
            this = this@ChessPiece(ax,BS,CPD,color,Knight.ID,i,j);
        end
        
        %
        % Check if a move is valid (i.e., pseudo-legal)
        %
        function bool = IsValidMove(this,i,j)
            % Assume invalid by default
            bool = false;
            
            % Get movement
            dfile = abs(i - this.i);
            drank = abs(j - this.j);

            % Check for valid shape
            if (((dfile == 1) && (drank == 2)) || ...
               ((dfile == 2) && (drank == 1)))
                % Check for vacancy
                if ((this.BS.IsEmpty(i,j) == true) || ...
                   (this.color ~= this.BS.ColorAt(i,j)))
                    bool = true;
                end
            end
        end
        
        %
        % Return coordinates of all valid (i.e., pseudo-legal) moves
        %
        function [ii jj] = ValidMoves(this)
            % Try all possible moves
            ii = this.i + [-2 -2 -1 -1  1  1  2  2];
            jj = this.j + [-1  1 -2  2 -2  2 -1  1];
            kk = (ii >= 1) .* (ii <= 8) .* (jj >= 1) .* (jj <= 8);
            for k = 1:8
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
