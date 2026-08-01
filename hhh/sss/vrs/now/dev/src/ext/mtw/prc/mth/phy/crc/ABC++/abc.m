%Type abc(0) to start the piece-wise linear version of the program, and
%type abc(1) to start the cubic version of the program

function abc(op);

switch op
    case 0
        abc_pp;
    case 1
        abc_cc;
end


        