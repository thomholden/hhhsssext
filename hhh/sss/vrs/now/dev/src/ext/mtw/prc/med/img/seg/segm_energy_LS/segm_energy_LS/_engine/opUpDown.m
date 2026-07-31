function [g_o, offset] = opUpDown(g, UpNotDown, offset, method)
% [IMG_OUT, OFFSET] = opUpDown(IMG_IN, UpNotDown, OFFSET, method)
%
% prolongation/restriction of IMG_IN to PREDICTION
% by a factor of 2 (i.e. doubling/halving the size)
%
% UpNotDown     - UP when 1, DOWN when 0 :-)
% OFFSET        - 2-by-1 boolean (for images, later ndims(IMG_IN)-long)
%                 in Prolongation it forces the output size to  
%                 2k-1 on the respective dimension (k size of input)
%                 set as output in Restriction (ignored as an input)
%
% Restrict.| set O      in O | Prolong. 
% ---------+------      -----+----------
% 2k-1 > k |   1          1  | k > 2k-1 
% 2k   > k |   0          0  | k > 2k 
%
% METHOD    - 'cell-full' bilinear interp, full weighting,  
%           - 'vertex-full' (default)
%
% 12.01.2011    - new, unify older opUp and opDown
%                 still to do: plug it in!!!

if nargin < 4, method = 'cell-full'; end
if nargin < 3, offset = []; end
if nargin < 2, UpNotDown = false; end
if isempty(offset), offset = [0 0]; end

[nR, nC] = size(g);
%% figure out input type, match output (logical, for masks)
SetLogicalOutput = false;
if islogical(g) % will force output to logical
    g = single(g);
    SetLogicalOutput = true;
end

%% change resolution
if UpNotDown
    % k>2k, k+1>2k+1
    % double the size, then if offsets remove at end
    nR_o = 2*nR; nC_o = 2*nC; 
    % init the right size g_o matrix
    g_o = zeros(nR_o, nC_o, class(g)); % normally single :-)
    switch method
        case 'cell-full' % std, 9/3/1
            w = [9 3 1];
            % normalize it, for faster calculations!
            norm = (w(1)+2*w(2)+w(3));            
            comp_corners = norm/w(1);
            comp_edges = norm/(w(1)+w(2));
            w = w/norm;
            % ixs
            ixOddRow = 1:2:2*nR-1;
            ixEvenRow = ixOddRow+1;
            ixOddCol = 1:2:2*nC-1;
            ixEvenCol = ixOddCol+1;
            if w(1) > 0
                % multiply the whole matrix by 9 := w(1);
                g_w = g*w(1);
                % distribute it properly, LRUD
                g_o(ixOddRow, ixOddCol) = g_w;
                g_o(ixOddRow, ixEvenCol) = g_w;
                g_o(ixEvenRow, ixOddCol) = g_w;
                g_o(ixEvenRow, ixEvenCol) = g_w;
            end
            if w(2) >0
                % --- H/V neighbour contribution, w(2) ---
                % multiply once the whole matrix by 3 :=1 w(2)
                g_w = g*w(2);
                % add DOWN to rows 3:end, ALL cols
                g_o(ixOddRow(2:end), ixOddCol) = ...
                    g_o(ixOddRow(2:end), ixOddCol) + g_w(1:end-1,:);
                g_o(ixOddRow(2:end), ixEvenCol) = ...
                    g_o(ixOddRow(2:end), ixEvenCol) + g_w(1:end-1,:);
                % add UP to rows 1:end-2, ALL cols
                g_o(ixEvenRow(1:end-1), ixOddCol) = ...
                    g_o(ixEvenRow(1:end-1), ixOddCol) + g_w(2:end,:);
                g_o(ixEvenRow(1:end-1), ixEvenCol) = ...
                    g_o(ixEvenRow(1:end-1), ixEvenCol) + g_w(2:end,:);

                % add RIGHT to cols 3:end, ALL rows
                g_o(ixEvenRow, ixOddCol(2:end)) = ...
                    g_o(ixEvenRow, ixOddCol(2:end)) + g_w(:,1:end-1);
                g_o(ixOddRow, ixOddCol(2:end)) = ...
                    g_o(ixOddRow, ixOddCol(2:end)) + g_w(:,1:end-1);
                % add LEFT to cols 1:end-2, ALL rows
                g_o(ixEvenRow, ixEvenCol(1:end-1)) = ...
                    g_o(ixEvenRow, ixEvenCol(1:end-1)) + g_w(:,2:end);
                g_o(ixOddRow, ixEvenCol(1:end-1)) = ...
                    g_o(ixOddRow, ixEvenCol(1:end-1)) + g_w(:,2:end);
            end
            if w(3) >0
                %gg = zeros(nR_o, nC_o);
                % --- diagonal neighbour contribution, w(3) ---
                g_w = g*w(3); % normally one :-)
                % DOWN, RIGHT (odd ROWs, odd COLs)
                ixRd = ixOddRow(2:end); ixCd = ixOddCol(2:end);
                ixRs = 1:nR-1; ixCs = 1:nC-1;
                g_o(ixRd, ixCd) = g_o(ixRd, ixCd) + g_w(ixRs, ixCs);
                %gg(ixRd, ixCd) = 1;
                % DOWN LEFT, odd ROWs, even COLs
                ixRd = ixOddRow(2:end); ixCd = ixEvenCol(1:end-1); 
                ixRs = 1:nR-1; ixCs = 2:nC;
                g_o(ixRd, ixCd) = g_o(ixRd, ixCd) + g_w(ixRs, ixCs);
                %gg(ixRd, ixCd) = 0.01;
                % UP, RIGHT, even ROWS1, oddCols2, src 2,1
                ixRd = ixEvenRow(1:end-1); ixCd = ixOddCol(2:end);
                ixRs = 2:nR; ixCs = 1:nC-1;
                g_o(ixRd, ixCd) = g_o(ixRd, ixCd) + g_w(ixRs, ixCs);
                %gg(ixRd, ixCd) = 3;
                % UP, LEFT == even1, even1, src 1,1
                ixRd = ixEvenRow(1:end-1); ixCd = ixEvenCol(1:end-1); 
                ixRs = 2:nR; ixCs = 2:nC;
                g_o(ixRd, ixCd) = g_o(ixRd, ixCd) + g_w(ixRs, ixCs);
                %gg(ixRd, ixCd) = 2;
            end
            % normalize...
            %g_o = g_o/(w(1)+2*w(2)+w(3));
            % compensate edges
            g_o(2:nR_o-1,1) = g_o(2:nR_o-1,1)*comp_edges;
            g_o(2:nR_o-1,end) = g_o(2:nR_o-1,nC_o)*comp_edges;
            g_o(1, 2:nC_o-1) = g_o(1, 2:nC_o-1)*comp_edges;
            g_o(nR_o, 2:nC_o-1) = g_o(nR_o, 2:nC_o-1)*comp_edges;
            % compensate corners
            g_o(1,1) = g_o(1,1) * comp_corners;
            g_o(nR_o,1) = g_o(nR_o,1) * comp_corners;
            g_o(1,nC_o) = g_o(1,nC_o) * comp_corners;
            g_o(nR_o,nC_o) = g_o(nR_o,nC_o) * comp_corners;
            
        case 'vertex-full' % [1 2 1; 2 4 2; 1 2 1]/4
            nRC = size(g);
            ForceEven = ~offset;
            nRCo = 2*nRC;
            % natural: k->2k-1, if ForceEven then ADD a row/col at end
              % init the right size g_o matrix
            g_o = zeros(nRCo);
            w = [1/2 1/4]; % H/V and Diagonal
                        
            ixEvenRow = 2:2:nRCo(1);
            ixOddRow = ixEvenRow-1;
            ixEvenCol = 2:2:nRCo(2);
            ixOddCol = ixEvenCol-1;
                       
            % ODD-ODD will be injected
            % init with g in Odd-Odd
            g_o(ixOddRow, ixOddCol) = g;
            % --- V/H contributions
            g_w = g*w(1);
            % distribute it properly, LRUD

            % --- DOWN --- init EVEN dest ROWS with ALL g_w Rows 
            % ... only even cols :-) cheaper
            g_o(ixEvenRow(1:nR-1),ixOddCol) = g_w(1:nR-1,:);
            if ForceEven(1) % i.e. nRo even = 2*nR
                g_o(2*nR,ixOddCol) = 2*g_w(nR,:); % or g(nR,:);
            end
            % --- UP --- add ALL g_w Rows to ODD dest rows            
            g_o(ixEvenRow(1:nR-1),ixOddCol) = ...
                g_o(ixEvenRow(1:nR-1),ixOddCol) + g_w(2:nR,:);
            
            % reset moving matrix for columns :-)
            g_w = g_o(:,ixOddCol)*w(1); % only works for 1/4 = 1/2*1/2...
            
            % --- LEFT --- + src COLs 2:end to EVEN dest COLs 1:end-1            
            g_o(:,ixEvenCol(1:nC-1)) = g_o(:,ixEvenCol(1:nC-1))+...
                g_w(:,2:nC);            
            % --- RIGHT --- + src COLs 1:end-1 to EVEN dest COLs 2:end
            g_o(:,ixEvenCol(1:nC-1)) = g_o(:,ixEvenCol(1:nC-1))+...
                g_w(:,1:nC-1);
            if ForceEven(2) % i.e. nCo even = 2*nC
                g_o(:,2*nC) = 2*g_w(:,nC);
            end
           
        case 'vertex-half-std' % [0 1 0; 1 4 1; 0 1 0]/8
            for i = 2:nR-1 % cruude and sloow, test
                for j = 2:nC-1
                    g_o(2*i,2*j) = g(i,j);
                    g_o(2*i+1,2*j) = 1/2 *(g(i,j)+g(i+1,j));
                    g_o(2*i,2*j+1) = 1/2 *(g(i,j)+g(i,j+1));
                    g_o(2*i+1,2*j+1) = 1/4*(...
                        g(i,j) +g(i+1,j) +g(i,j+1) +g(i+1,j+1) );
                end
            end
    end
    % REMOVE row/col at end when signalled by offset
    if offset(1), g_o = g_o(1:nR_o-1,:); end;
    if offset(2), g_o = g_o(:, 1:nC_o-1); end;
    
else % restrict!
    nRC = size(g);
    offset = mod(nRC,2);
    
    switch method

        case 'cell-full'    % no filtering, new offset (2k+1 => k+1, 2k => k)
            % equal weight of the 4-neighbour set            
            % add ODD ROWS DOWN
            EvenRows = 2:2:nR;
            g(EvenRows,:) = g(EvenRows,:) + g(EvenRows-1,:);
            if offset(1) % i.e. nR odd,
                % change parity, add next to last (even), update ixToKeep
                g(nR,:) = g(nR,:) + g(nR-1,:);
                EvenRows = [EvenRows nR];
            end
            % discard OddRows
            g = g(EvenRows,:);
            % add EVEN COLS RIGHT
            EvenCols = 2:2:nC;
            g(:,EvenCols) = g(:,EvenCols) + g(:,EvenCols-1);
            if offset(2) % i.e. nC odd,
                % change parity, add next to last (even), update ixToKeep
                g(:,nC) = g(:,nC) + g(:,nC-1);
                EvenCols = [EvenCols nC];
            end
            % discard Odd COLs
            g = g(:,EvenCols);
            % normalize!
            g_o = g/4;

        case 'vertex-full' % [1 2 1; 2 4 2; 1 2 1]/16
            nRC_even = floor(nRC/2);
            nRC_odd = nRC_even + offset;
            w = [4 2 1]/16;

            ixER = 2:2:nRC(1); % always of size floor(nR/2)
            ixEC = 2:2:nRC(2);
            ixOR = 1:2:nRC(1); % of size floor(nR/2) + offset_R
            ixOC = 1:2:nRC(2);

            % --- weigh ALL g! ---
            g_w = zeros(nRC);
            % 1 -> keep ODD-ODD
            g_w(ixOR,ixOC) = w(1)*g(ixOR,ixOC);
            % 2 -> ,[EVEN,ODD], [ODD,EVEN]
            g_w(ixER,ixOC) = w(2)*g(ixER,ixOC);
            g_w(ixOR,ixEC) = w(2)*g(ixOR,ixEC);
            % 3 -> diagonal el-s, [EVEN,EVEN]
            g_w(ixER,ixEC) = w(3)*g(ixER,ixEC);
            
            % +(even)ROWS, UD
            % ---------------
            % DOWN, weigh double the 2nd
            g_w(1,:) = g_w(1,:) + 2*g_w(2,:); % 2 to 1
            % 2k to 2k-1
            ixThis = ixER(2:nRC_even(1))-1;
            g_w(ixThis,:) = g_w(ixThis,:) + g_w(ixThis+1,:);
            % UP, weigh double next to last row if nR is odd
            ixThis = ixOR(2:nRC_odd(1)-1);
            g_w(ixThis,:) = g_w(ixThis,:) + g_w(ixThis-1,:);
            % next to last row
            ixThis = ixOR(nRC_odd(1));
            g_w(ixThis,:) = g_w(ixThis,:) + (1+offset(1))*g_w(nRC(1),:);

            % discard Even Rows
            g_w = g_w(ixOR,:);
            
            % +(odd)COLS, LR
            % ---------------
            % DOWN, weigh double the 2nd COL
            g_w(:,1) = g_w(:,1) + 2*g_w(:,2); % 2 to 1
            % 2k to 2k-1
            ixThis = ixEC(2:nRC_even(2))-1;
            g_w(:,ixThis) = g_w(:,ixThis) + g_w(:,ixThis+1);
            % UP, weigh double next to last col if nC is odd
            ixThis = ixOC(2:nRC_odd(2)-1);
            g_w(:,ixThis) = g_w(:,ixThis) + g_w(:,ixThis-1);
            % next to last COL
            ixThis = ixOC(nRC_odd(2));
            g_w(:,ixThis) = g_w(:,ixThis) + (1+offset(2))*g_w(:,nRC(2));
            
            % discard Even Cols
            g_o = g_w(:,ixOC);
            
        case 'vertex-half-std' % [0 1 0; 1 4 1; 0 1 0]/8
            nRC_o = ceil(nRC/2);
            g_o = zeros(nRC_o, 'single');
            for i = 2:nRC_o(1)-1 % cruude and sloow, test
                for j = 2:nRC_o(2)-1
                    g_o(i,j) = g(2*i,2*j)/2 + ...
                        g(2*i+1,2*j)/8 + g(2*i,2*j+1)/8 + ...
                        g(2*i-1,2*j)/8 + g(2*i,2*j-1)/8;
                end
            end

            
        case 'vertex-injection'
            g_o = g(1:2:nR,1:2:nC);
    end

end

if SetLogicalOutput
    g_o = g_o >= 0.5;
end