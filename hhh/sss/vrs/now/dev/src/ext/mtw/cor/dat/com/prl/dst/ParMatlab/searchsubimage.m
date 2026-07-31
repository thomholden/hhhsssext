function [ii,jj,vv]=searchsubimage(A,S)

  ii=0;jj=0;vv=inf;
  
  S=(S-min(min(S)))./(max(max(S))-min(min(S)));
  
  for i=1:(size(A,1)-size(S,1))
    for j=1:(size(A,2)-size(S,2))
      tem=A(i:i+size(S,1)-1,j:j+size(S,2)-1);
      tem=(tem-min(min(tem)))./(max(max(tem))-min(min(tem)));
      v=sum(sum(abs((tem-S))));
      if v<vv vv=v;ii=i;jj=j;end
    end
  end
    