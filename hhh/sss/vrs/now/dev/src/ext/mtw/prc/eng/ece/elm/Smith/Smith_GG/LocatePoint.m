function LocatePoint(ind,val)

global GMod
global r_norm
global x_norm
global FixLoci_G
global FixLoci_r
global FixLoci_x
global IsWaitEnabled
global CircleSolutions
global PathNextRemoveFlag
global Gr
global Gi
switch ind
    case 'G'
        C1 = [0,0,val];
    case 'r'
        C1 = [val/(val+1), 0, 1/(val+1)];
    case 'x'
        C1 = [1, 1/val, 1/abs(val)];
end
if FixLoci_G
    C2 = [0,0,GMod];
elseif FixLoci_r
    C2 = [r_norm/(r_norm+1), 0, 1/(r_norm+1)];
elseif FixLoci_x
    C2 = [1, 1/x_norm, 1/abs(x_norm)];
end

[nsoln, S1, S2] = SolveCircle(C1, C2);
             
CircleSolutions = [S1;S2];
switch nsoln
    case 0
%         no solution
        ErrWarnings('g004');
    case 1
        
        GetFinalSolution();
    case 2
            ErrWarnings('g001');
            SubFcnCheckExistingOverlap(CircleSolutions);
        GetFinalSolution();
        IsWaitEnabled = 1;
end


    function SubFcnCheckExistingOverlap(CS)

        PathNextRemoveFlag = 0;
        epsilon = 10^-7;

        for i=1:2
            if (CS{i}(1) - Gr)^2 + (CS{i}(2) - Gi)^2 ...
                    < epsilon ^2
                PathNextRemoveFlag = 1;
            end
        end
    end
end