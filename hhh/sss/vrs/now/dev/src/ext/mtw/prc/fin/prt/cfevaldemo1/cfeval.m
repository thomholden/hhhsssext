function[cfval,varargout] = cfeval(pofun,cpfun,psfun,ppfun,varargin)
% CFEVAL    Evaluate portfolio cash flows given their symbolic definitions
% INPUTS  : N*T cell arrays of strings, where cell (i,t) contains definition
%           of .. on security i in period t:
%             pofun - principal outstanding
%             cpfun - coupon payment
%             psfun - scheduled principal repayment
%             ppfun - unscheduled principal repayment
%           par   - parameter structure, available  to calculations  defined 
%                   in pofun, cpfun, psfun, ppfun 
% OUTPUTS : N*T arrays, where element (i,t) contains value of .. on security
%           i in period t:
%             cfval - total cash flow (sum of cfval, psval and ppval)
%             poval - principal outstanding
%             cpval - coupon payment
%             psval - scheduled principal repayment
%             ppval - unscheduled principal repayment
% NOTES   : Cells of input arrays are evaluated sequentially, iterating over 
%           * periods: t = 1,..,T 
%           * securities: i = 1,..,N
%           * input arrays: pofun, cpfun, psfun, ppfun
%           Computing xval(i,t) - note that xfun arrays definitions must use
%           indexes i and t - one can reference already-evaluated quantities 
% EXAMPLE : See CFEVALDEMO
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 9/25/07

in  = {'pofun','cpfun','psfun','ppfun'};
out = {'poval','cpval','psval','ppval'};
for i = 1:4
    n = in{i};
    x = eval(n);
    if ~iscellstr(x)
       error(['Input argument "' n '" must be a cell array of strings'])
    else
       if i == 1
          s = size(x);
       else
          if any(size(x) ~= s)
             error('Input cell arrays must have the same size')
          end  
       end  
    end
end

if nargin > 4
   par = varargin{1};
   if ~isstruct(par)
      error('Input argument "par" must be a structure')
   end
end

[cfval,poval,cpval,psval,ppval] = deal(nan(s)); 
for t = 1:s(2)
    for i = 1:s(1)
        poval(i,t) = eval(pofun{i,t});
        cpval(i,t) = eval(cpfun{i,t});
        psval(i,t) = eval(psfun{i,t});
        ppval(i,t) = eval(ppfun{i,t});
        cfval(i,t) = cpval(i,t) + psval(i,t) + ppval(i,t);
    end
end
for i = 1:4
    if nargout > i
       varargout{i} = eval(out{i});                        %#ok
    end
end  