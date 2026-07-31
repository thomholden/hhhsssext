function [label,index]=segment_parallel(im)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function segment_parallel segments the input black & white image to %
%segmented image. The segments are numbered as and when new segments comes%
% up.                                                                     %
%                                                                         %
%Example                                                                  %
%im=[1 1 1 0 0 0 0 0 1 1;1 1 0 0 1 0 0 1 1 1;1 1 0 0 1 1 0 1 0 0;0 0 0 1 0% 
%    1 1 1 1 1;0 0 0 1 1 1 0 0 0 0;0 0 0 1 1 0 0 0 0 0];                  %
%[Label, Index]=segment_parallel(im);                                     %                                                       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[ht,wt]=size(im);
label=zeros(ht,wt);
index=1;
pint=0;
for row=1:ht
    for col=1:wt
        if im(row,col)==1
            
            if row==1 && col==1
                label(row,col)=index;
                index=index+1;
            end
            
            label=process1(im,label,row,col,label(row,col));
            
            if row-1>0 && col-1>0 && row+1<ht && col+1<wt  
                if label(row-1,col-1)+label(row-1,col)+label(row-1,col+1)+label(row,col-1)+label(row,col+1)+label(row+1,col-1)+label(row+1,col)+label(row+1,col+1)==0
                    label(row,col)=index;
                    index=index+1;
                end
                label=process1(im,label,row,col,label(row,col));
            end
            
        end
    end
end

end



function label=process1(im,label,row,col,index)

[ht,wt]=size(im);
if im(row,col)==1
    if (row-1)>0
        if col-1 >0
            if im(row-1,col-1)==1
                label(row-1,col-1)=index;
            end
        end
        if im(row-1,col)==1
            label(row-1,col)=index;
        end
        if col+1<wt
            if im(row-1,col+1)==1
                label(row-1,col+1)=index;
            end
        end
    end
    if (col-1)>0
        if im(row,col-1)==1
            label(row,col-1)=index;
        end
    end
    if col+1<wt
        if im(row,col+1)==1
            label(row,col+1)=index;
        end
    end
    if row+1 <ht
        if col-1>0
            if im(row+1,col-1)==1
                label(row+1,col-1)=index;
            end
        end
        if im(row+1,col)==1
            label(row+1,col)=index;
        end
        if col+1<wt
            if im(row+1,col+1)==1
                label(row+1,col+1)=index;
            end
        end
    end 
end

end
