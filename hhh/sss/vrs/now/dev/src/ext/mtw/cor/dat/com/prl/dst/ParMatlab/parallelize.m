function [o1,o2,o3,o4,o5]=parallelize(sendsoc,receivesoc,errhan,verbose,func,nargout,i1,c1,i2,c2,i3,c3,i4,c4,i5,c5)

%function [o1,o2,...]=parallelize(sendsoc,receivesoc,errhan,verbose,func,nargout,i1,c1,i2,c2,...)
% 
% This function is used to automatically create parallel instances and mannage them
% with any quantity of workers available when the data is regularly ordered. The same
% function is applied to sub-hyperblocks of data (i1 ... i5) which are selected with the 
% control indexes (c1 ... c5). ix and cx when x>1 are optional depending on the number
% of input arguments for the function to parallelize
%
% sendsoc = tcpip socket for sending tasks (use initmajordomo)
% receivesoc =tcpip socket for receiving tasks (use initmajordomo)
% errhan = used to decide what action to take when there is an error in a remote worker
%          0 ignore and continue both (default) 
%          1 stop remote machine to debug workspace
%          2 pause majordomo and ask
% verbose = flag to see communication info between this function and workers
% func = string with the function to parallelize
% nargout = number of output arg to expect from 'func', results will 
%           be ordered according with subindexes of i1/c1
% i# = variables (usually matrixes) but can be up to 5 dimensions with
%      the data to parallelize
% c# = each row controls the indexing along every dimension, the first
%      row controls the subindex that changes faster and so on, can control
%      several dimensions at the same time, but the total number of parallel
%      elements must be the same for every input variable, it is possible
%      to pass constant values just by seting incrments for every dimenssion
%      equal to zero, constant input variable will be automatically detected
%      by the tool and will not be sent if they are already in the remote
%      machine workspace
%      The format of the control indexes behaives as follows (see demos to 
%      better understand them):
%         [dimension #elem startat increment blocksize ;
%          dimension #elem startat increment blocksize ;
%                              ...                      ]
%
%by Lucio Andrade
%April 2001

hosts=[];workstat=[];element=[];

if (rem(nargin,2)|(nargin<8)) error('Incorrect number of input arguments'); end

nvarin=nargin/2-3;
outnum=ones(5,1);
outnum(1:length(c1(:,2)))=c1(:,2); %dimesion of outputs are determined by first arg

if rem(size(c1,2),5) error('Bad indexing control');  end; 
if (nvarin>=2) & rem(size(c2,2),5) error('Bad indexing control'); end; 
if (nvarin>=3) & rem(size(c3,2),5) error('Bad indexing control'); end; 
if (nvarin>=4) & rem(size(c4,2),5) error('Bad indexing control'); end; 
if (nvarin>=5) & rem(size(c5,2),5) error('Bad indexing control'); end; 

parelements=prod(c1(:,2));
if (nvarin>=2) & (parelements~=prod(c2(:,2))) error('Not same num of elements'); end;
if (nvarin>=3) & (parelements~=prod(c3(:,2))) error('Not same num of elements'); end;
if (nvarin>=4) & (parelements~=prod(c4(:,2))) error('Not same num of elements'); end;
if (nvarin>=5) & (parelements~=prod(c5(:,2))) error('Not same num of elements'); end;

c=zeros(5,5,5);c(:,:,[2 3])=1;
c(1,1:size(c1,1),1:size(c1,2))=c1;
if (nvarin>=2) c(2,1:size(c2,1),1:size(c2,2))=c2; end;
if (nvarin>=3) c(3,1:size(c3,1),1:size(c3,2))=c3; end;
if (nvarin>=4) c(4,1:size(c4,1),1:size(c4,2))=c4; end;
if (nvarin>=5) c(5,1:size(c5,1),1:size(c5,2))=c5; end;


taskstosend=parelements;
taskstoreceive=0;
i=1;

while (taskstosend+taskstoreceive)

 if taskstosend
    
    con=tcpip_listen(sendsoc);
    if con>-1  %if there is a worker available 
       hostname=getvar(con); %get its name (ip address)
       %Preparing indexes of the input variables
       %in v## I'll have the subindexes of data to send
       subs=(mind2sub(c(1,:,2),i)-1).*c(1,:,4)+c(1,:,3);
       v11=[1 1];v12=[1 1];v13=[1 1];v14=[1 1];v15=[1 1];
       h=find(c(1,:,1)==1); if ~isempty(h) v11 = [ 1 c(1,h,5) ] + subs(h)-1;end;
       h=find(c(1,:,1)==2); if ~isempty(h) v12 = [ 1 c(1,h,5) ] + subs(h)-1;end;
       h=find(c(1,:,1)==3); if ~isempty(h) v13 = [ 1 c(1,h,5) ] + subs(h)-1;end;
       h=find(c(1,:,1)==4); if ~isempty(h) v14 = [ 1 c(1,h,5) ] + subs(h)-1;end;   
       h=find(c(1,:,1)==5); if ~isempty(h) v15 = [ 1 c(1,h,5) ] + subs(h)-1;end;
       if (nvarin>=2)   
         subs=(mind2sub(c(2,:,2),i)-1).*c(2,:,4)+c(2,:,3);
         v21=[1 1];v22=[1 1];v23=[1 1];v24=[1 1];v25=[1 1];
         h=find(c(2,:,1)==1); if ~isempty(h) v21 = [ 1 c(2,h,5) ] + subs(h)-1;end;
         h=find(c(2,:,1)==2); if ~isempty(h) v22 = [ 1 c(2,h,5) ] + subs(h)-1;end;
         h=find(c(2,:,1)==3); if ~isempty(h) v23 = [ 1 c(2,h,5) ] + subs(h)-1;end;
         h=find(c(2,:,1)==4); if ~isempty(h) v24 = [ 1 c(2,h,5) ] + subs(h)-1;end;   
         h=find(c(2,:,1)==5); if ~isempty(h) v25 = [ 1 c(2,h,5) ] + subs(h)-1;end;
       end;
       if (nvarin>=3) 
         subs=(mind2sub(c(3,:,2),i)-1).*c(3,:,4)+c(3,:,3);
         v31=[1 1];v32=[1 1];v33=[1 1];v34=[1 1];v35=[1 1];
         h=find(c(3,:,1)==1); if ~isempty(h) v31 = [ 1 c(3,h,5) ] + subs(h)-1;end;
         h=find(c(3,:,1)==2); if ~isempty(h) v32 = [ 1 c(3,h,5) ] + subs(h)-1;end;
         h=find(c(3,:,1)==3); if ~isempty(h) v33 = [ 1 c(3,h,5) ] + subs(h)-1;end;
         h=find(c(3,:,1)==4); if ~isempty(h) v34 = [ 1 c(3,h,5) ] + subs(h)-1;end;   
         h=find(c(3,:,1)==5); if ~isempty(h) v35 = [ 1 c(3,h,5) ] + subs(h)-1;end;
       end;
       if (nvarin>=4) 
         subs=(mind2sub(c(4,:,2),i)-1).*c(4,:,4)+c(4,:,3);
         v41=[1 1];v42=[1 1];v43=[1 1];v44=[1 1];v45=[1 1];
         h=find(c(4,:,1)==1); if ~isempty(h) v41 = [ 1 c(4,h,5) ] + subs(h)-1;end;
         h=find(c(4,:,1)==2); if ~isempty(h) v42 = [ 1 c(4,h,5) ] + subs(h)-1;end;
         h=find(c(4,:,1)==3); if ~isempty(h) v43 = [ 1 c(4,h,5) ] + subs(h)-1;end;
         h=find(c(4,:,1)==4); if ~isempty(h) v44 = [ 1 c(4,h,5) ] + subs(h)-1;end;   
         h=find(c(4,:,1)==5); if ~isempty(h) v45 = [ 1 c(4,h,5) ] + subs(h)-1;end;
       end;
       if (nvarin>=5) 
         subs=(mind2sub(c(5,:,2),i)-1).*c(5,:,4)+c(5,:,3);
         v51=[1 1];v52=[1 1];v53=[1 1];v54=[1 1];v55=[1 1];
         h=find(c(5,:,1)==1); if ~isempty(h) v51 = [ 1 c(5,h,5) ] + subs(h)-1;end;
         h=find(c(5,:,1)==2); if ~isempty(h) v52 = [ 1 c(5,h,5) ] + subs(h)-1;end;
         h=find(c(5,:,1)==3); if ~isempty(h) v53 = [ 1 c(5,h,5) ] + subs(h)-1;end;
         h=find(c(5,:,1)==4); if ~isempty(h) v54 = [ 1 c(5,h,5) ] + subs(h)-1;end;   
         h=find(c(5,:,1)==5); if ~isempty(h) v55 = [ 1 c(5,h,5) ] + subs(h)-1;end;
       end;
       
       %initalize to do not preserve any variable
       preserve1=0;preserve2=0;preserve3=0;preserve4=0;preserve5=0;
       
       %Now check if the machine is already in table
       h=strmatch(hostname,hosts); %h is empty if is the first time the machine is used
       if isempty(h) 
          hosts=strvcat(hosts,hostname);    %add machine to table
          h=size(hosts,1);                  %and set the pointer to it
       else %if machine has been used compare variable to be sent with variables in workspace
          if prod(squeeze(vartable(h,1,:))==[v11 v12 v13 v14 v15]') preserve1=1; end
          if (nvarin>=2) if prod(squeeze(vartable(h,2,:))==[v21 v22 v23 v24 v25]') preserve2=1; end; end;
          if (nvarin>=3) if prod(squeeze(vartable(h,3,:))==[v31 v32 v33 v34 v35]') preserve3=1; end; end;
          if (nvarin>=4) if prod(squeeze(vartable(h,4,:))==[v41 v42 v43 v44 v45]') preserve4=1; end; end;
          if (nvarin>=5) if prod(squeeze(vartable(h,5,:))==[v51 v52 v53 v54 v55]') preserve5=1; end; end;
       end; %isempty(h)
       
       %actualize vartable, shows what variables are in the remote machine workspace
       vartable(h,1,:)=[v11 v12 v13 v14 v15]; 
       if (nvarin>=2) vartable(h,2,:)=[v21 v22 v23 v24 v25]; end; 
       if (nvarin>=3) vartable(h,3,:)=[v31 v32 v33 v34 v35]; end; 
       if (nvarin>=4) vartable(h,4,:)=[v41 v42 v43 v44 v45]; end; 
       if (nvarin>=5) vartable(h,5,:)=[v51 v52 v53 v54 v55]; end; 
       
       workstat(h)=1;   %set the machine status to --communication phase--
       %send comand and variables, empty variables to preserve
       sendvar(con,func)
       sendvar(con,nvarin)
       sendvar(con,nargout)
       for j=1:nvarin
         sj=num2str(j);
         eval(['testpre=preserve' sj ';']);
         if testpre sendvar(con,[]);
         else eval(['sendvar(con,i' sj '(v' sj '1(1):v' sj '1(2),'...
                                        'v' sj '2(1):v' sj '2(2),'...
                                        'v' sj '3(1):v' sj '3(2),'...
                                        'v' sj '4(1):v' sj '4(2),'...
                                        'v' sj '5(1):v' sj '5(2)))' ]);
         end %testpre
       end % for j=1:nvarin
                    
       tcpip_close(con); %finish sending task, close socket
       
       workstat(h)=2;   %set the machine status to --processing phase--
       element(h)=i;    %remember what is the parallel element this machine processed
       
       %actualize counters
       taskstosend=taskstosend-1; 
       taskstoreceive=taskstoreceive+1; 
       i=i+1; 
       
       if verbose
          disp(['Task id:' num2str(element(h)) ' sent to ' hostname(1:end) ])
          disp(['To send: ' int2str(taskstosend) '  Pending:' int2str(taskstoreceive)])
       end; %if verbose
    end; %con>-1
 end; %taskstosend

 if taskstoreceive
   %build string with command
   coma=['[con,hostname'];
   for j=1:nargout coma=[coma ',p' num2str(j) ]; end;
   coma=[coma ']=receivetask(receivesoc,nargout,errhan);']; 
   eval(coma)
   if con>-1 
     h=strmatch(hostname,hosts);
     workstat(h)=0; 
     taskstoreceive=taskstoreceive-1; 
     where=element(h);
     
     if ~isempty(p1)   %if its empty there was an error, dont do anything
       sp=[size(p1,1),size(p1,2),size(p1,3),size(p1,4),size(p1,5)];
       startat=sp.*(mind2sub(outnum',where)-1)+1;
       stopat=sp.*(mind2sub(outnum',where));
       v1=startat(1):stopat(1);v2=startat(2):stopat(2);v3=startat(3):stopat(3);
       v4=startat(4):stopat(4);v5=startat(5):stopat(5);
       o1(v1,v2,v3,v4,v5)=p1;
     end
     
     if (nargout>=2)
     if ~isempty(p2)   %if its empty there was an error, dont do anything
       sp=[size(p2,1),size(p2,2),size(p2,3),size(p2,4),size(p2,5)];
       startat=sp.*(mind2sub(outnum',where)-1)+1;
       stopat=sp.*(mind2sub(outnum',where));
       v1=startat(1):stopat(1);v2=startat(2):stopat(2);v3=startat(3):stopat(3);
       v4=startat(4):stopat(4);v5=startat(5):stopat(5);
       o2(v1,v2,v3,v4,v5)=p2;
     end;
     end;
     
     if (nargout>=3)
     if ~isempty(p3)   %if its empty there was an error, dont do anything
       sp=[size(p3,1),size(p3,2),size(p3,3),size(p3,4),size(p3,5)];
       startat=sp.*(mind2sub(outnum',where)-1)+1;
       stopat=sp.*(mind2sub(outnum',where));
       v1=startat(1):stopat(1);v2=startat(2):stopat(2);v3=startat(3):stopat(3);
       v4=startat(4):stopat(4);v5=startat(5):stopat(5);
       o3(v1,v2,v3,v4,v5)=p3;
     end;
     end;
     
     if (nargout>=4)
     if ~isempty(p4)   %if its empty there was an error, dont do anything
       sp=[size(p4,1),size(p4,2),size(p4,3),size(p4,4),size(p4,5)];
       startat=sp.*(mind2sub(outnum',where)-1)+1;
       stopat=sp.*(mind2sub(outnum',where));
       v1=startat(1):stopat(1);v2=startat(2):stopat(2);v3=startat(3):stopat(3);
       v4=startat(4):stopat(4);v5=startat(5):stopat(5);
       o4(v1,v2,v3,v4,v5)=p4;
     end;
     end;
  
     if (nargout>=5)
     if ~isempty(p5)   %if its empty there was an error, dont do anything
       sp=[size(p5,1),size(p5,2),size(p5,3),size(p5,4),size(p5,5)];
       startat=sp.*(mind2sub(outnum',where)-1)+1;
       stopat=sp.*(mind2sub(outnum',where));
       v1=startat(1):stopat(1);v2=startat(2):stopat(2);v3=startat(3):stopat(3);
       v4=startat(4):stopat(4);v5=startat(5):stopat(5);
       o5(v1,v2,v3,v4,v5)=p5;
     end;
     end;
     
     if verbose
       disp(['Task id:' num2str(element(h)) ' received from ' hostname(1:end) ])
       disp(['To send: ' int2str(taskstosend) '  Pending:' int2str(taskstoreceive)])
     end; %if verbose
     
  end; %con>-1
 end %taskstoreceive

end  % while (taskstosend+taskstoreceive)



