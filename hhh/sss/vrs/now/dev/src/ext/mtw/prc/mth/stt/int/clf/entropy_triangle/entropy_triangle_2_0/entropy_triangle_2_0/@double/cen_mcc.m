function [cen,mcc]=cen_mcc(Am)
%function [cen,mcc]=cen_mcc(Am)
%
% Returns values for the Confusion Entropy (CEN) and Matthews Correlation 
% Coefficient (MCC) of an n x n matrix (not defined for non square
% matrices)
% 
% (from Jurman, G., Riccadona, S., Furlanello, C., "A comparison of MCC and
% CEN Error Measures in Multiclass Prediction, PLOS One, vol. 7, issue 8,
% 2012)
%
% Inputs a count matrix (Am) and outputs CEN and MCC. 
%
% Authors: CPM


error(nargchk(1,1,nargin));

%if (iscell(Am))
    [M P K] = size(Am);%Dimensions of experiment
    N=sum(sum(Am));
    if M~=P
        disp('Not defined for non-square matrices');
        return
    end
    if (K==1)%single matrix
        A=Am./N;%Normalize into a joint distribution
    else
        A = zeros([M P K]);
        for k = 1:K
            A(:,:,k) =Am(:,:,k)./N(:,:,k);
        end
    end
    
    %Compute ln(2*(N-1)) to change the base of the log
    lbase=log(2*(M-1));
    for k=1:K
        Amk=Am(:,:,k);
        Nk=N(k);
        %First: CEN
        missPxy=zeros(M,M);
        %The overall CEN is the weighted sum of CENj
        for j=1:M
            %Missclassification probability
            missPx(:,j) =Amk(:,j) /sum(Amk(j,:)+Amk(:,j)');
            missPx(j,j)=0;
            missPy(j,:) =Amk(j,:) /sum(Am(j,:)+Amk(:,j)');
            missPy(j,j)=0;
            %Confusion probability of class j
            Pr(j)=(sum(Amk(j,:)+Amk(:,j)'))/(2*N);
            %Covariance for MCC
            
%             covxy_mat=cov(Amk(j,:),Amk(:,j)',1);
%             covxy(j)=(1/M)*(covxy_mat(1,2));
%             covxx(j)=(1/M)*(covxy_mat(1,1));
%             covyy(j)=(1/M)*(covxy_mat(2,2));
        end
        missPx(find(missPx==0))=1; %So that log can be 0 (avoid NaN)
        missPy(find(missPy==0))=1; %So that log can be 0 (avoid NaN)
        for j=1:M
            %Confusion entropy of class j
            %cenj(j)=-(sum(missPxy(j,:).*log(missPxy(j,:))/lbase)+sum(missPxy(:,j).*log(missPxy(:,j))/lbase));
            cenj(j)=-(sum(missPy(j,:).*log(missPy(j,:))/lbase)+sum(missPx(:,j).*log(missPx(:,j))/lbase));
            
        end
        cen=sum(Pr.*cenj);
        %mcc=sum(covxy)/sqrt(sum(covxx)*sum(covyy));
        
        
        %Now MCC
        covxy=0;
        for kk=1:M
            for l=1:M
                for m=1:M
                    covxy=covxy+(Amk(kk,kk)*Amk(m,l)-Amk(l,kk)*Amk(kk,m));
                end
            end
        end
        covxx=0;
        covyy=0;
        for kk=1:M
            covxx=covxx+(sum(Amk(:,kk))*(Nk-sum(Amk(:,kk))));
            covyy=covyy+(sum(Amk(kk,:))*(Nk-sum(Amk(kk,:))));
        end
        mcc=covxy/sqrt(covxx*covyy);
        if isnan(mcc) mcc=0.0; end
    end
    
return
