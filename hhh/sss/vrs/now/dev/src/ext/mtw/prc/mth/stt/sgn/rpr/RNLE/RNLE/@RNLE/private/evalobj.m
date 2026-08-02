function [fun,grad,weight]=evalobj(state,in,out,weight,...
    initfun,transfun,obsfun,param,type)

% Store size.
[nstate,npoint]=size(state);
[nout,~]=size(out);

% Allocate space for return arguments.
fun=zeros();
grad=zeros(nstate,npoint);

% Allocate space for auxiliary variables.
obsfact=zeros(nout,nout);
dobsfact=zeros(nout,nout,nstate);
obsres=zeros(nout,1);
obsrate=zeros(nout,1);

% Evaluate objective function and gradient.
for i=1:npoint
    if i>1
        
        % Evaluate transition function and derivatives.
        [transmean,transvar,dtransmean,dtransvar]=...
            feval(transfun,state(:,i-1),in(:,i));
        
        % Factorize variance-covariance matrix and its derivatives.
        [transfact,dtransfact]=choldiff(transvar,dtransvar);
        
        % Compute normalized residuals.
        transres=transfact\(state(:,i)-transmean(:));
        
        % Store squared error.
        transerr=sum(transres.^2);
        
        % Check type of outliers.
        if isinf(param)||~strcmpi(type,'state')
            
            % Update weight.
            if isnan(weight(i))&&strcmpi(type,'state')
                weight(i)=1;
            end
            
            % Increment function.
            fun=fun+(nstate/2)*log(2*pi())+sum(log(diag(transfact)))+transerr/2;
            
            % Store weight.
            w=1;
            
        else
            
            % Update weight.
            if isnan(weight(i))
                weight(i)=(param+nstate)/(param+transerr);
            end
            
            % Increment function.
            aux=param+nstate;
            fun=fun+(nstate/2)*log(2*pi())+sum(log(diag(transfact)))+...
                (weight(i)/2)*transerr+gammaln(param/2)-gammaln(aux/2)-...
                (param/2)*log(param/2)+(aux/2)*log(aux/2)+...
                (param/2)*weight(i)-(aux/2)*log(weight(i))-aux/2;
            
            % Store weight.
            w=weight(i);
            
        end
        
        % Increment gradient.
        transrate=transfact'\transres;
        for j=1:nstate
            dtransmean(:,j)=dtransmean(:,j)+dtransfact(:,:,j)*transres;
            transbias=sum(diag(transfact\dtransfact(:,:,j)));
            grad(j,i-1)=grad(j,i-1)-w*(dtransmean(:,j)'*transrate)+transbias;
        end
        grad(:,i)=grad(:,i)+w*transrate;
        
    else
        
        % Evaluate initialization function.
        [initmean,initvar]=feval(initfun,in(:,i));
        
        % Factorize variance-covariance matrix.
        initfact=chol(initvar,'lower');
        
        % Compute normalized residuals.
        initres=initfact\(state(:,i)-initmean(:));
        
        % Store squared error.
        initerr=sum(initres.^2);
        
        % Check type of outliers.
        if isinf(param)||~strcmpi(type,'state')
            
            % Update weight.
            if isnan(weight(i))&&strcmpi(type,'state')
                weight(i)=1;
            end
            
            % Increment function.
            fun=fun+(nstate/2)*log(2*pi())+sum(log(diag(initfact)))+initerr/2;
            
            % Store weight.
            w=1;
            
        else
            
            % Update weight.
            if isnan(weight(i))
                weight(i)=(param+nstate)/(param+initerr);
            end
            
            % Increment function.
            aux=param+nstate;
            fun=fun+(nstate/2)*log(2*pi())+sum(log(diag(initfact)))+...
                (weight(i)/2)*initerr+gammaln(param/2)-gammaln(aux/2)-...
                (param/2)*log(param/2)+(aux/2)*log(aux/2)+...
                (param/2)*weight(i)-(aux/2)*log(weight(i))-aux/2;
            
            % Store weight.
            w=weight(i);
            
        end
        
        % Increment gradient.
        initrate=initfact'\initres;
        grad(:,i)=grad(:,i)+w*initrate;
        
    end
    obs=~isnan(out(:,i));
    if any(obs)
        
        % Evaluate observation function and derivatives.
        [obsmean,obsvar,dobsmean,dobsvar]=feval(obsfun,state(:,i),in(:,i));
        
        % Factorize variance-covariance matrix and its derivatives.
        [obsfact(obs,obs),dobsfact(obs,obs,:)]=...
            choldiff(obsvar(obs,obs),dobsvar(obs,obs,:));
        
        % Compute normalized residuals.
        obsres(obs)=obsfact(obs,obs)\(out(obs,i)-obsmean(obs));
        
        % Store squared error and number of observations.
        obserr=sum(obsres(obs).^2);
        nobs=sum(obs);
        
        % Check type of outliers.
        if isinf(param)||~strcmpi(type,'output')
            
            % Update weight.
            if isnan(weight(i))&&strcmpi(type,'output')
                weight(i)=1;
            end
            
            % Increment function.
            fun=fun+(nobs/2)*log(2*pi())+...
                sum(log(diag(obsfact(obs,obs))))+obserr/2;
            
            % Store weight.
            w=1;
            
        else
            
            % Update weight.
            if isnan(weight(i))
                weight(i)=(param+nobs)/(param+obserr);
            end
            
            % Increment function.
            aux=param+nobs;
            fun=fun+(nobs/2)*log(2*pi())+sum(log(diag(obsfact(obs,obs))))+...
                (weight(i)/2)*obserr+gammaln(param/2)-gammaln(aux/2)-...
                (param/2)*log(param/2)+(aux/2)*log(aux/2)+...
                (param/2)*weight(i)-(aux/2)*log(weight(i))-aux/2;
            
            % Store weight.
            w=weight(i);
            
        end
        
        % Increment gradient.
        obsrate(obs)=obsfact(obs,obs)'\obsres(obs);
        for j=1:nstate
            dobsmean(obs,j)=dobsmean(obs,j)+dobsfact(obs,obs,j)*obsres(obs);
            obsbias=sum(diag(obsfact(obs,obs)\dobsfact(obs,obs,j)));
            grad(j,i)=grad(j,i)-w*(dobsmean(obs,j)'*obsrate(obs))+obsbias;
        end
        
    end
end

end