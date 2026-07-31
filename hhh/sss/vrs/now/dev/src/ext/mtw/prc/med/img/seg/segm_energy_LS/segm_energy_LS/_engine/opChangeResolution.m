function [prjData, ReportOut] = opChangeResolution(prjData, UpNotDown)
% [prjData, ReportOut] = opChangeResolution(prjData, UpNotDown)
% change the scale of Fn by one step
% Up=>finer, Down=>coarser
% also updates sphi, sphi_prev, fn_prev
% 
% 01.02.2011    - revisited, synchronized with the change of
%                 Method (now vertex-full & cell-full), 1bit U/D
%               - it basically became a wrapper for opUpDown :-)
% 17.02.2011    - interpolate Residue and Dirac !
% 10.03.2011    - add gTile, to phase in
% 15.03.2011    - correct gate offsets: match Fn_stepped size to gTile

if nargin < 2 % should never be used
    UpNotDown = false;
    disp('opChangeResolution > warning, default Down')
end

% short notations
k = prjData.res.kLevel;
[nRo, nCo] = size(prjData.fn); 
% detect when k hits the boundaries, (0, kMax), spare the updates
DoOperation = (UpNotDown && (k>0)) || (~UpNotDown && (k < prjData.res.kMax));
if ~DoOperation
    % do nothing :-)   
    if nargout > 1
        ReportOut = ['k = ' num2str(k) ', resolution ' ...
            num2str(nRo) ' x ' num2str(nCo) ' hit lim.'];
    end
    return
end

% increment/decrement K (increase/decrease resolution level)
delta_k = ~UpNotDown*2 - 1;
k_next = k + delta_k;

thisMethod = prjData.opt.DwnMethod;

% --- actual resolution change ---
% --------------------------------
% Full, 0-protect in Down (ignored), only used in Up
thisOffset = prjData.gOffset(max(k,1),:);
fn_pr = opUpDown(prjData.fn, UpNotDown, thisOffset, thisMethod);
prjData.fn_prev = opUpDown(prjData.fn_prev, UpNotDown, thisOffset, thisMethod);
[nR, nC] = size(fn_pr);
prjData.gTile = prjData.g{k_next+1}; % chk only...


% preserve gradient values...
prjData.fn = fn_pr * 2^(-delta_k); % 2 when Up, 1/2 when Down

% figure out which reset function to apply... phased out (wrapped inside opReset);

[thisErr, prjData.evol.Residue, prjData.evol.Dirac, ...
    prjData.evol.Hvi, prjData.evol.gradHviMag] = opReset_Wrap(...
    prjData.fn, prjData.gTile, prjData.par, prjData.opt.RegStyle);

prjData.res.kLevel = k_next;
prjData.res.kGridSize = [nR nC];

prjData.sphi_prev = prjData.fn_prev > 0;
prjData.sphi = prjData.fn > 0;

% membrane detection removed (now done in ShowData)
prjData.Show.Updated = false;

if nargout > 1
    ReportOut = ['k = ' num2str(prjData.res.kLevel) ...
        ', resolution ' num2str(nR) ' x ' num2str(nC) ];
end
end

% function [RC_io_s, RC_io_d] = uGrid(RC_raw, RC_Offset)
% % insert a tile of size RC_raw_s in a smaller/larger tile
% % nominal outputs, when offsets are 0 0
% RC_io_s = [1 RC_raw(1)];
% %C_io_s = [1 RC_raw(2)];
% 
% RC_out = RC_raw + RC_Offset;
% RC_io_d = [ 1 RC_out];
% %R_io_d(2) = [ 1 RC_out(2)];
% 
% % rows:    
% if RC_Offset > 0 % out tile is larger    
%     RC_io_d(1) = floor(RC_Offset/2)+1;
%     RC_io_d(2) = RC_out - ceil(RC_Offset/2);
% else % smaller, cut the source tile
%     % use abs(offset)
%     RC_io_s(1) = floor(-RC_Offset/2)+1;
%     RC_io_s(2) = RC_raw - ceil(-RC_Offset/2);
% end
% % % cols:
% % if RC_Offset(2) > 0 % out tile is larger
% %     RC_io_d(2) = RC_out - ceil(RC_Offset/2);
% % else % out tile smaller, cut the source tile
% %     RC_io_s(2) = RC_raw(2) - ceil(RC_Offset(2)/2);
% % end
% 
% end
