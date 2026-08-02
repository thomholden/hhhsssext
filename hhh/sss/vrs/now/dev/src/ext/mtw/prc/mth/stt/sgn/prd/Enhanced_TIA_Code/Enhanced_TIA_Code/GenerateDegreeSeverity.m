function[out]=GenerateDegreeSeverity(e,y,ProbOccMx)

u=rand(1);
d=0;

if u<=ProbOccMx(e,y,1)

    d=1;

end

if u<=(ProbOccMx(e,y,2)+ProbOccMx(e,y,1)) & u>ProbOccMx(e,y,1)

    d=2;
    
end

if u<=(ProbOccMx(e,y,3)+ProbOccMx(e,y,2)+ProbOccMx(e,y,1)) & u>(ProbOccMx(e,y,2)+ProbOccMx(e,y,1))

    d=3;
    
end

out=d;






