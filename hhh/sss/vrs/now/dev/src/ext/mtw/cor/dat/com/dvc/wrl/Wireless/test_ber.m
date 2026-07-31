%% BER Range Test
% Example of doing a traditional BER simulation where the BER is calculated
% for a range of SNR.
%
% Copyright 2008-2009 The MathWorks, Inc

%% Set up
EsNo_values=-2:1:9;
BER_results=zeros(length(EsNo_values),1);
disp('Starting...');

%% For each SNR
figure
title('BER Simulation Results');
ylabel('BER');
xlabel('EsNo');
    
for i=1:length(EsNo_values)
    EsNo=EsNo_values(i);
    fprintf('\nTesting EsNo = %d dB...\n', EsNo);
    BER_results(i)= btint('-EbNo',num2str(EsNo),'-d','BT','-i','802.11','-c','2');
    semilogy(EsNo_values(1:i),BER_results(1:i),'-*')
    grid;
    drawnow;
end
disp('Finished')