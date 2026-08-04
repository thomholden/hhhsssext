function [p] = ppartialf (f,n,k)

% function [p] = ppartialf (f,n,k)
% Calculate significance of partial f statistic 
% see p.128 Kleinbaum and p.229 Press
% f		partial f statistic
% n		number of data points
% k		number of variables in old model
%
% p		p value
  
if (f < 0.0)
      % Negative f will create x>1.0 thus causing 
      % an error in the betai routine 
	p=1;
else 
        v1=1;
        v2=n-k-2;
        x=v2/(v2+f*v1);
        if (x<0.0 | x>1.0)
              disp('Error in ppartialf: x must be between 0 and 1');
	end      
        p=betainc(x,v2/2,v1/2);
end


