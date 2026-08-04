function contplot(hmm,data,plotoptions)
%  contplot(hmm,data,plotoptions)
%
%   continous plotting of HMM results
%

Gamma=gethsbeliefs(hmm);
[nXgrid,nYgrid,Xgrid,Ygrid,Ncols,colstr,dpf,cpf,phtime,figh]=deal(plotoptions{:});
[N,ndim]=size(data);
figure(figh);clf;                                      % focus of created figure and clear

if (dpf | cpf),
  [y,classndx]=max(Gamma,[],2);
  for k=1:hmm.K,
    if ndim>1
      plot(data(find(classndx==k),1),data(find(classndx==k),2), ...
	   colstr{rem(k,Ncols)+1}),hold on;
      centre=getmean(hmm.obsmodel{k});
      Cov=getvar(hmm.obsmodel{k});
      text(centre(1),centre(2),sprintf('X-%s%d',blanks(k),k));
      if cpf
	for xg=1:nXgrid, 
	  for yg=1:nYgrid,
	    pdf(xg,yg)=gaussmd([Xgrid(xg,yg) Ygrid(xg,yg)],centre,Cov);
	  end;
	end;
	pdf=pdf./(max(max(pdf))-min(min(pdf)));
	contour(Xgrid(1,:),Ygrid(:,1),pdf,[.67 .67],'b:');
      end;
    else
      plot(find(classndx==k),data(find(classndx==k),1),...
	   colstr{rem(k,Ncols)+1}),hold on;
      centre=getmean(hmm.obsmodel{k});
      Cov=getvar(hmm.obsmodel{k});
      plot(1:N,ones(1,N)*centre(1),colstr{rem(k,Ncols)+1});
      text(k,centre(1),sprintf('X-%s%d',blanks(k),k));
      if cpf
	for xg=1:nXgrid, 
	  for yg=1:nYgrid,
	    pdf(xg,yg)=gaussmd([Ygrid(xg,yg)],centre,Cov);
	  end;
	end;
	pdf=pdf./(max(max(pdf))-min(min(pdf)));
	contour(Xgrid(1,:),Ygrid(:,1),pdf,[.67 .67],'b:');
      end;
    end
  end;
  drawnow, hold off;
else
  T=length(Gamma);
  plot(Gamma);
  axis([0 T 0 1.1]);
  drawnow;
end;
pause(phtime);

