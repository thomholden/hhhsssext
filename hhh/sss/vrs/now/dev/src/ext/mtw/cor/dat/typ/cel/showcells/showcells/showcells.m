function str = showcells (C)
%%SHOWCELLS  Display an ASCII representation of a cell array
%
%  This was inspired by the Dyalog APL display of boxed variables. It is
%  intended to provide a clear visual display of the contents of a cell
%  array. It uses the built-in NUM2STR to convert elements to strings.
%
%  SHOWCELLS(C); simply prints the visual representation to the console.
%  The semicolon suppresses the return of an integer representation of the
%  string to the console.
%
%  STR=SHOWCELLS(C); saves the generated 2D char array to STR and
%  suppresses printing to the console.
%
%  Written by David Smith <david.smith@gmail.com>
%
if ~iscell(C)
  error('Cell inputs required.');
elseif isempty(C)
  C = {' '};
end
[rows,cols] = size(C);
C = cellfun(@cell2string, C, 'UniformOutput', false);
col_widths = zeros(cols,1);
for kc = 1:cols
  col_widths(kc) =  max(cellfun(@(x) size(x,2)+3, C(:,kc)));
end
row_heights = zeros(rows,1);
for kr = 1:rows
  row_heights(kr) =  max(cellfun(@(x) size(x,1)+2, C(kr,:)));
end
str = ' '*ones(sum(row_heights) + 1, sum(col_widths) + 1);
str(1,2:end-1) = '_';
str(2:end-1,[1 end]) = '|';
cur_row = 1;
for kr = 1:rows
  cur_col = 1;
  for kc = 1:cols
    [dr,dc] = size(C{kr,kc});
    str(cur_row,cur_col+1:cur_col+col_widths(kc)-1) = '_';
    str(cur_row+1:cur_row+row_heights(kr),cur_col) = '|';
    r = cur_row + ceil((row_heights(kr)-dr)/2) + 1;
    c = cur_col + floor((col_widths(kc)-dc)/2) + 1;
    str(r:r+dr-1,c:c+dc-1) = C{kr,kc};
    cur_col = cur_col + col_widths(kc);
  end
  cur_row = cur_row + row_heights(kr);
end
str(end,:) = '_';
str(end,cumsum([0; col_widths])+1) = '|';
if ~nargout
  for k = 1:size(str,1)
    fprintf('%s\n', str(k,:));
  end
end


function S = cell2string(C)
%%CELL2STRING Convert individual element to strings.
if iscell(C)
  S = showcells(C);
else
  S = num2str(C,'%-0.3g ');
end