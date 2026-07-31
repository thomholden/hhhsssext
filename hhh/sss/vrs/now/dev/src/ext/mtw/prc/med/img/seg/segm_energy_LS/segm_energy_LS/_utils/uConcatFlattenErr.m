function err_all = uConcatFlattenErr(err_all, err)
% err_all = uConcatFlattenErr(err_all, err)
%
% concatenates errors obtained in succesive iterative runs
% also flattens structure for lower footprint, higher speed
%
% 08.06.2009    - new, from older uConcatErr(script ver v.066c, 11.08.2008)

if ~isempty(err_all)
    kk = fieldnames(err);
    for i = 1:size(kk,1)
        err_all.(kk{i}) = [err_all.(kk{i}) err.(kk{i}) ];
    end

else % at first run :
    err_all = err;
end;