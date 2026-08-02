
% Test classifiers on two class gaussian data

n=100;
class0=randn(n/2,2);
class1=randn(n/2,2)+1;
plot(class0(:,1),class0(:,2),'o');
hold on
plot(class1(:,1),class1(:,2),'x');
hold off

[tp,tn,fp,fn]=l1out(class0,class1,'clindisc');
r=(tp+tn)/(tp+tn+fp+fn);
[csq,pcsq]=chisq(tp,fp,fn,tn);
disp(sprintf('Correct classification rate,r =%1.3f',r));
disp(sprintf('Significance,p                =%1.3f',pcsq));

[tp,tn,fp,fn]=l1out(class0,class1,'nn',0.5,0.5);
r=(tp+tn)/(tp+tn+fp+fn);
[csq,pcsq]=chisq(tp,fp,fn,tn);
disp(sprintf('Correct classification rate,r =%1.3f',r));
disp(sprintf('Significance,p                =%1.3f',pcsq));

[tp,tn,fp,fn]=l1out(class0,class1,'knn');
r=(tp+tn)/(tp+tn+fp+fn);
[csq,pcsq]=chisq(tp,fp,fn,tn);
disp(sprintf('Correct classification rate,r =%1.3f',r));
disp(sprintf('Significance,p                =%1.3f',pcsq));

