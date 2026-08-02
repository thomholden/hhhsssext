function NewImage=vsymshift(im,x);

% Shifts an image in the vertical direction by x pixels,
% after symmetrically extending the image;
% with n being the size of the image in this direction x must 
% fulfill  -n <= x <= n

n=size(im,1);

if x>0
  NewImage(1:x,:)=im(x:-1:1,:);
  NewImage(1+x:n,:)=im(1:n-x,:);
  
  else
    if x<0
      NewImage(1:n+x,:)=im(1-x:n,:);
      NewImage(n+x+1:n,:)=im(n:-1:n+x+1,:); 
    else 
      if x==0
        NewImage=im;
      end
    end
  end
 
