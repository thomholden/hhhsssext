function ind=msub2ind(siz,sub)
%function ind=msub2ind(siz,sub)
%
%same as sub2ind() but sub is a vector 
%instead of separate subindexes
%
%by Lucio Andrade
%April 2001

switch length(siz)
case 1, ind=sub2ind(siz,sub);
case 2, ind=sub2ind(siz,sub(2),sub(1));
case 3, ind=sub2ind(siz,sub(3),sub(2),sub(1));
case 4, ind=sub2ind(siz,sub(4),sub(3),sub(2),sub(1));
case 5, ind=sub2ind(siz,sub(5),sub(4),sub(3),sub(2),sub(1));
otherwise error('Dimension too high');
end;