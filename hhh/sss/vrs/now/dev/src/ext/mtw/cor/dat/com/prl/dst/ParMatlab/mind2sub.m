function sub=mind2sub(siz,ind)
%function sub=mind2sub(siz,ind)
%
%same as ind2sub() but sub is a vector 
%instead of separate subindexes
%
%by Lucio Andrade
%April 2001

switch length(siz)
case 1, sub(1)=ind2sub(siz,ind);
case 2, [sub(1),sub(2)]=ind2sub(siz,ind);
case 3, [sub(1),sub(2),sub(3)]=ind2sub(siz,ind);
case 4, [sub(1),sub(2),sub(3),sub(4)]=ind2sub(siz,ind);
case 5, [sub(1),sub(2),sub(3),sub(4),sub(5)]=ind2sub(siz,ind);
otherwise error('Dimension too high');
end;