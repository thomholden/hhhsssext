function mask_shifted = bShift2DMask(mask, dim, dir)
% mask_shifted = bShift2DMask(mask, DIM, SENSE)
%
% shifts the binary MASK by 1 pixel on dimension DIM
% reduction to 2D of bShift2DMask, v. of 21.01.2011
%
% DIM = 1/2 == Y/X
% SENSE -1/1 == Down/Up

[nR, nC] = size(mask);
mask_shifted = false(nR, nC);
% dim 1:2, dir 0/1, or -1/1

switch dim % Y/X
    case {'Y', '1', 1}
        ZeroPlane = false(1, nC); % X, row
        if dir > 0 % 1, + :-)
            mask_shifted(1,:) = ZeroPlane;
            mask_shifted(2:end,:) = mask(1:end-1,:);
        else % -1, 0, down, M
            mask_shifted(end,:) = ZeroPlane;
            mask_shifted(1:end-1,:) = mask(2:end,:);
        end
    case {'X', '2', 2}
        ZeroPlane = false(nR, 1); % Y, col
        if dir > 0 % 1, + :-)
            mask_shifted(:,1) = ZeroPlane;
            mask_shifted(:,2:end) = mask(:,1:end-1);
        else % -1, 0, down, M
            mask_shifted(:,end) = ZeroPlane;
            mask_shifted(:,1:end-1) = mask(:,2:end);
        end
    
    otherwise
        disp('uShift2DMask: unrecognized dir')

end

end