% This function performs classification with either CART or SVM
%
% SVM uses libsvm. http://www.csie.ntu.edu.tw/~cjlin/libsvm/
% The BITE source code package includes libsvm.
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for support vector 
% machines. ACM Transactions on Intelligent Systems and Technology, 
% 2:27:1--27:27, 2011. 
%
% Software available at http://www.csie.ntu.edu.tw/~cjlin/libsvm
%
% With existing models and data scaling factors, this function classify the
% features extracted from trajectory into a disturbance type map, a
% slow-onset disturbance map and a rapid-onset disturbance map with years
% of onset.
% 
% INPUT
% 
% inputdir: folder for trajectory Excel files.
%     
% outputdir: folder to store the output disturbance maps. 
% 
% modeldir: folder for model files. For NDMI to do classfication using SVM,
% one must have “NDMIminX.mat”, “NDMImaxX.mat” and “NDMISVM.mat”. To use
% CART, only “NDMItree.mat” is required.
% 
% lcfile: the complete filename for the forest mask.
% 
% combinelist: the array to store the list of spectral indices to process
% in sequence.
% 
% numparts: the same number as being used in Module_Disturb.m.
% 
% algorithm: 1 – CART, 2 – SVM.
% 
% OUTPUT
% 
% The output include a type map, a slow-onset disturbance map and a
% rapid-onset disturbance map generated in outputdir. For the type map,
% pixel values are defined as the following: 0 - unclassified, 1 –
% persistent, 2 - slow-onset, 3 - rapid-onset.
% 
% EXAMPLE
% inputdir = 'F:\Data\TrOutput\';
% modeldir = 'F:\Data\Models\';
% outputdir = 'F:\Data\DistMap\';
% lcfile = 'F:\Data\forestmask';
% combinelist = [10 11 15];
% numparts = 4;
% algorithm = 2; % 1 - CART 2 - SVM
% Module_Classification(inputdir, outputdir, modeldir, lcfile, ...
%     combinelist, numparts, algorithm);
function Module_Classification(inputdir, outputdir, modeldir, lcfile, ...
    combinelist, numparts, algorithm)


dnames = {'Persistent', 'Slow-onset', 'Rapid-onset'};
bands = {'B1', 'B2', 'B3', 'B4', 'B5', 'B7', 'NDVI', 'NDSI', 'NDWI', 'NDMI'...
    , 'NBR', 'EVI', 'Brightness', 'Greenness', 'Wetness'};

% trsamples = {'Persistant.shp','Disturbed.shp', 'Clearecut.shp'};
% testsamples = {'val_1.shp','val_3.shp','val_5.shp'};
% yrstring = {'2005','2009','2011'};
numc = numel(dnames);
[lcmask,p,t,xystart,mapinfo,coodsys,index] = ...
            readenvi(lcfile, true);

m = size(lcmask, 1);
partsint = fix([1:m/numparts:m m+1]);
% 1 - CART 2 - SVM
algonames = {'CART', 'SVM'};

    algon = char(algonames(algorithm));
    for listidx = 1:numel(combinelist)
        idx = combinelist(listidx);
        vegx = char(bands(idx));
        dataout = zeros(m, 2);
        tic;
        for parts = 1:numparts
            partn = partsint(parts+1)-partsint(parts);
            nodpoints = xlsread([inputdir vegx 'nodx' num2str(parts) '.xlsx']);
            nodvalues = xlsread([inputdir vegx 'nody' num2str(parts) '.xlsx']);
            
            % Feature extraction
            % Min Slope, Max Slope, Min Range Change,
            % Max Range Change, Min, Max
            nums = 6;
            nump = size(nodpoints,1);
            X = NaN(nump,nums);
            ydis = zeros(nump,1);
            for i = 1:nump
                ypoints = [nodpoints(i,:); nodvalues(i,:)]';
                ypoints = ypoints(~isnan(ypoints(:,1)),:);
                X(i,:) = trendstats(ypoints);
                ydis(i) = trendlabel(ypoints,idx);
            end
            % Classify

            if algorithm == 1
                load([modeldir vegx 'tree.mat'],'CARTtree');
                dtype = eval(CARTtree,X);
                dtype = str2num(cell2mat(dtype));
            elseif algorithm == 2
                load([modeldir vegx 'SVM.mat'],'SVMmodel');
                load([modeldir vegx 'minX.mat'],'minX');
                load([modeldir vegx 'maxX.mat'],'maxX');
                XX = (X-minX) ./ (maxX-minX);
                y = zeros(size(XX,1),1);
                dtype = svmpredict(y, XX, SVMmodel);
            end
            for i = 1:nump
                if (dtype(i)~=1)
                    if ydis(i) == 0
                        dtype(i) = 1;
                    end
                else
                    ydis(i) = 0;
                end
            end
            if size(dtype,1)==1
                dtype = dtype';
            end
            dataout(partsint(parts):partsint(parts+1)-1,:) = [dtype ydis];
        end
        toc
        p(3) = 1;
        bandnames = '{type}';
        writeenvi([uint8(dataout(:,1))],p,[outputdir algon vegx 'typemap'],xystart,mapinfo,coodsys,bandnames,index);
        bandnames = '{year of slow-onset disturbance}';
        ycd = dataout(:,2);
        ycd(dataout(:,1)~=2,:) = 0;
        writeenvi([int16(ycd)],p,[outputdir algon vegx 'slowmap'],xystart,mapinfo,coodsys,bandnames,index);
        bandnames = '{year of rapid-onset disturbance}';
        yad = dataout(:,2);
        yad(dataout(:,1)~=3,:) = 0;
        writeenvi([int16(yad)],p,[outputdir algon vegx 'rapidmap'],xystart,mapinfo,coodsys,bandnames,index);
    end

        