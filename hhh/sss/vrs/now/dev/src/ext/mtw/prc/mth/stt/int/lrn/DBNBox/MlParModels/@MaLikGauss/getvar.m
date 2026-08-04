function val = getvar(obj)
%  obj=getvar(obj_name)
%
% GET Get expected variance of gaussian observation model


val=obj.Wish_B/obj.Wish_alpha;
