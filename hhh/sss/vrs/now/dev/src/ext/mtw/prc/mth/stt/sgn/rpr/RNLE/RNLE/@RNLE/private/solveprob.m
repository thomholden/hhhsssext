function [mean,var,covar]=solveprob(state,in,out,weight,...
    initfun,transfun,obsfun,type)

% Store size.
[nstate,npoint]=size(state);
[nout,~]=size(out);

% Allocate space for return arguments.
mean=zeros(nstate,npoint);
var=zeros(nstate,nstate,npoint);
covar=zeros(nstate,nstate,npoint-1);

% Allocate space for auxiliary variable.
transbias=zeros(nstate,1);

% Allocate space for auxiliary variables.
obsfact=zeros(nout,nout);
dobsfact=zeros(nout,nout,nstate);
obsres=zeros(nout,1);
obsbias=zeros(nstate,1);

% Allocate space for gain matrix.
kalman=zeros(nstate,nout);

% Execute forward-backward recursions on linearized model.
for i=1:npoint
    
    % Perform prediction step.
    if i>1
        
        % Propagate solution through linearized transition model.
        mean(:,i)=dtransmean*mean(:,i-1)+transmean(:)-state(:,i);
        var(:,:,i)=dtransmean*var(:,:,i-1)*dtransmean'+transvar;
        
    else
        
        % Evaluate initialization function.
        [initmean,initvar]=feval(initfun,in(:,i));
        
        % Compute equivalent initialization parameters.
        if strcmpi(type,'state')
            initvar=initvar/weight(i);
        end
        
        % Initialize solution.
        mean(:,i)=initmean(:)-state(:,i);
        var(:,:,i)=initvar;
        
    end
    if i<npoint
        
        % Evaluate transition function and derivatives.
        [transmean,transvar,dtransmean,dtransvar]=...
            feval(transfun,state(:,i),in(:,i+1));
        
        % Factorize variance-covariance matrix and its derivatives.
        [transfact,dtransfact]=choldiff(transvar,dtransvar);
        
        % Compute normalized residuals.
        transres=transfact\(state(:,i+1)-transmean(:));
        
        % Compute equivalent transition parameters.
        for j=1:nstate
            dtransmean(:,j)=dtransmean(:,j)+dtransfact(:,:,j)*transres;
            transbias(j)=sum(diag(transfact\dtransfact(:,:,j)));
        end
        if strcmpi(type,'state')
            transvar=transvar/weight(i+1);
        end
        
    end
    
    % Perform correction step.
    obs=~isnan(out(:,i));
    if any(obs)
        
        % Evaluate observation function and derivatives.
        [obsmean,obsvar,dobsmean,dobsvar]=feval(obsfun,state(:,i),in(:,i));
        
        % Factorize variance-covariance matrix and its derivatives.
        [obsfact(obs,obs),dobsfact(obs,obs,:)]=...
            choldiff(obsvar(obs,obs),dobsvar(obs,obs,:));
        
        % Compute normalized residuals.
        obsres(obs)=obsfact(obs,obs)\(out(obs,i)-obsmean(obs));
        
        % Compute equivalent observation parameters.
        for j=1:nstate
            dobsmean(obs,j)=dobsmean(obs,j)+dobsfact(obs,obs,j)*obsres(obs);
            obsbias(j)=sum(diag(obsfact(obs,obs)\dobsfact(obs,obs,j)));
        end
        if strcmpi(type,'output')
            obsvar(obs,obs)=obsvar(obs,obs)/weight(i);
        end
        
        % Compute Kalman gain matrix.
        kalman(:,obs)=var(:,:,i)*dobsmean(obs,:)';
        kalman(:,obs)=kalman(:,obs)/(dobsmean(obs,:)*kalman(:,obs)+...
            obsvar(obs,obs));
        
        % Compute Joseph complement.
        joseph=eye(nstate)-kalman(:,obs)*dobsmean(obs,:);
        
        % Condition solution according to linearized observation model.
        mean(:,i)=joseph*mean(:,i)+kalman(:,obs)*(out(obs,i)-obsmean(obs));
        var(:,:,i)=joseph*var(:,:,i)*joseph'+...
            kalman(:,obs)*obsvar(obs,obs)*kalman(:,obs)';
        
    end
    
    % Adjust solution to account for fictitious zero-valued observations.
    if i<npoint
        mean(:,i)=mean(:,i)-var(:,:,i)*(transbias+obsbias);
    else
        mean(:,i)=mean(:,i)-var(:,:,i)*obsbias;
    end
    
end
for i=npoint-1:-1:1
    
    % Evaluate transition function.
    [transmean,transvar,dtransmean,dtransvar]=...
        feval(transfun,state(:,i),in(:,i+1));
    
    % Factorize variance-covariance matrix and its derivatives.
    [transfact,dtransfact]=choldiff(transvar,dtransvar);
    
    % Compute normalized residuals.
    transres=transfact\(state(:,i+1)-transmean(:));
    
    % Compute equivalent transition parameters.
    for j=1:nstate
        dtransmean(:,j)=dtransmean(:,j)+dtransfact(:,:,j)*transres;
    end
    if strcmpi(type,'state')
        transvar=transvar/weight(i+1);
    end
    
    % Compute Kalman gain matrix.
    kalman=var(:,:,i)*dtransmean';
    kalman=kalman/(dtransmean*kalman+transvar);
    
    % Compute Joseph complement.
    joseph=eye(nstate)-kalman*dtransmean;
    
    % Backtrack solution according to linearized transition model.
    mean(:,i)=joseph*mean(:,i)+kalman*(mean(:,i+1)-transmean(:)+state(:,i+1));
    var(:,:,i)=joseph*var(:,:,i)*joseph'+kalman*(var(:,:,i+1)+transvar)*kalman';
    covar(:,:,i)=kalman*var(:,:,i+1);
    
end

end