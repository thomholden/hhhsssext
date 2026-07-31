% Input a CSV file, make it continuous, and then output another CSV file.

function contCSV(filename)

tic;
[TheData TheName] = readdata(filename);
DatatoPlot = cand2(TheData,160);
toc;
writetofile(DatatoPlot,TheName,'TestingSpeed.csv');

end