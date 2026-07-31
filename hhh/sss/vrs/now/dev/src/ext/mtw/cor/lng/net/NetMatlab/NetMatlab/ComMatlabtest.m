% This script shows the usage of c# (.Net) Functions in Matlab
%
% See info.txt on how to Create and Register the ComMatlab ActiveX control
%
% Author: D.Kroon, University of Twente

net = actxserver('ComMatlab.ComMatlabClass'); % Load the ActiveX ComMatlab

methods(net) % The functions of ComMatlab Class

disp('- Test C# functions - ')
val = net.SumDoubles(1.2,1.3);
disp(['Sum Double: 1.2 + 1.3 = ' num2str(val)]);

val = net.SumInts(1,2);
disp(['Sum Int: 1 + 2 = ' num2str(val)]);

val = net.SumStrings('Comb','ined');
disp(['Combine String = ' val]);

val = net.ReturnIntArray();
disp(['Return Int Array = ' num2str(val)]);

val = net.SumDoubleArray([1.1 2 3.1 4]);
disp(['Sum Double Array 1.1 + 2 + 3.1 + 4 = ' num2str(val)]);

val = net.SumIntMatrix(int32([1 2;3 4])); % Notice int32
disp(['Sum Int Matrix 1 + 2 + 3 + 4 = ' num2str(val)]);

