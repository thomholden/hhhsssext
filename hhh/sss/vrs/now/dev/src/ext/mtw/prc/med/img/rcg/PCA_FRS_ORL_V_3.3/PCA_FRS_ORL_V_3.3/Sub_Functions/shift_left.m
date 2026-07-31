function x=shift_left(x)
%% Shift Left function
fv=x(1);
x(1:end-1)=x(2:end);
x(end)=fv;
