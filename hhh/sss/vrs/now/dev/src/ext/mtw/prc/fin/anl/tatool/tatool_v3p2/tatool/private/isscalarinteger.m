function flag = isscalarinteger(in)
% tatool helper function to determine whether the input is a scalar integer
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if ~isa(in,'double') ||...
        numel(in)~=1 ||...
        mod(in,1)~=0
    flag = 0;
else
    flag =1 ;
end
