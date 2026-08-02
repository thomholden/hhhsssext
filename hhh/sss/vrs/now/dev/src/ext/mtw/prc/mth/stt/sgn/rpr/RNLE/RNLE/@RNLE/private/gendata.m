function [state,out]=gendata(in,nstate,nout,initfun,transfun,obsfun,param,type)

% Store number of points.
[~,npoint]=size(in);

% Allocate space for data.
state=zeros(nstate,npoint);
out=zeros(nout,npoint);

% Generate data by simulating model.
for i=1:npoint
    
    % Generate state.
    if i>1
        
        % Evaluate transition function.
        [state(:,i),transvar]=feval(transfun,state(:,i-1),in(:,i));
        
        % Factorize variance-covariance matrix.
        transfact=chol(transvar,'lower');
        
        % Generate weight.
        if isinf(param)||~strcmpi(type,'state')
            w=1;
        else
            w=max(randg(param/2)/(param/2),eps());
        end
        
        % Generate state.
        state(:,i)=state(:,i)+transfact*randn(nstate,1)/sqrt(w);
        
    else
        
        % Evaluate initialization function.
        [state(:,i),initvar]=feval(initfun,in(:,i));
        
        % Factorize variance-covariance matrix.
        initfact=chol(initvar,'lower');
        
        % Generate weight.
        if isinf(param)||~strcmpi(type,'state')
            w=1;
        else
            w=max(randg(param/2)/(param/2),eps());
        end
        
        % Generate state.
        state(:,i)=state(:,i)+initfact*randn(nstate,1)/sqrt(w);
        
    end
    
    % Evaluate observation function.
    [out(:,i),obsvar]=feval(obsfun,state(:,i),in(:,i));
    
    % Factorize variance-covariance matrix.
    obsfact=chol(obsvar,'lower');
    
    % Generate weight.
    if isinf(param)||~strcmpi(type,'output')
        w=1;
    else
        w=max(randg(param/2)/(param/2),eps());
    end
    
    % Generate output.
    out(:,i)=out(:,i)+obsfact*randn(nout,1)/sqrt(w);
    
end

end