function [tp,tn,fp,fn] = l1out (class0,class1,CLASS,P1,P2,P3,P4,P5,P6,P7,P8)

% function [tp,tn,fp,fn] = l1out (class0,class1,CLASS,P1,P2,P3,P4,P5,P6,P7,P8)
% Leave one out cross-validation
% using classifier type 'CLASS' with parameters P1..P10

show=0;

evalstr = [CLASS];
evalstr = [evalstr, '(set0,set1,pattern'];
for i=1:nargin-3
	evalstr = [evalstr, ',P',int2str(i)];
end
evalstr = [evalstr, ')'];
%disp(evalstr);

tn=0;tp=0;
n=size(class0,1);
set1=class1;
for i=1:n,
	if show==1,
		disp(sprintf('Fold=%d',i));
	end
	pattern=class0(i,:);
	set0=class0;
	if i>1
		set0(i,:)=class0(i-1,:);
	else
		set0(i,:)=class0(i+1,:);
	end
	%class=nn(set0,set1,pattern,p0,p1);
	%class=clindisc(set0,set1,pattern);
	class=eval(evalstr);
	if class==0
		tn=tn+1;
	end
end

p=size(class1,1);
set0=class0;
for i=1:p,
	if show==1,
		disp(sprintf('Fold=%d',i+n));
	end
	pattern=class1(i,:);
	set1=class1;
	if i>1
		set1(i,:)=class1(i-1,:);
	else
		set1(i,:)=class1(i+1,:);
	end
	%class=nn(set0,set1,p0,p1,pattern);
	%class=clindisc(set0,set1,pattern);
	class=eval(evalstr);
	if class==1
		tp=tp+1;
	end
end

fn=n-tn;
fp=p-tp;

