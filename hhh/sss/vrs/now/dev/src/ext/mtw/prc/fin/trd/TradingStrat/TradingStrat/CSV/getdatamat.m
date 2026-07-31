

[TheData TheName] = readdata('UOB1minA.csv');
EditedData = cand2(TheData,300);
Output2 = EditedData(:,[3:6]);
mainwindow(Output2,1,1,1,1);