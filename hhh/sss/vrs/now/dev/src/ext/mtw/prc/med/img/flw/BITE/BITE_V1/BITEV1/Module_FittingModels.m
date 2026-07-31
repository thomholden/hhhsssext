% This function extracts values from training samples in shp format and
% trains SVM model or CART model.
%
% The BITE source code package includes libsvm.
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for support vector 
% machines. ACM Transactions on Intelligent Systems and Technology, 
% 2:27:1--27:27, 2011. 
% Software available at http://www.csie.ntu.edu.tw/~cjlin/libsvm
%
% Prepare three shape files for persistent forest, slow-onset disturbances
% and rapid-onset disturbances respectively as training data samples. The
% samples are in point format. They must be named as 'persistent.shp',
% 'slowonset.shp' and 'rapidonset.shp'.
% 
% INPUT
% 
% imagedir is the directory for time-series image.
% 
% shapedir is the folder to store 'persistent.shp', 'slowonset.shp' and
% 'rapidonset.shp' as the training data samples. The shape files are in
% point format and each point is a sample location. They should have the
% completely same coordinate system as the images.
% 
% modeldir is where the output models are saved.
% 
% yfile: the Excel file in which the first colomn stores the times of
% acquisition, for instance 2001179, 2002158, 2003207, etc..
% 
% maxsample is the largest number of training samples in a single training
% class. For instance, if the training samples for the three classes have
% 60, 70 and 65. The maxsample can be set to be greater than 70.
% 
% combinelist: time-series images of the spectral indices in the list will
% be processed.
% 
% SVMgsOption: if SVMgsOption = [1,2,11,-7,1,5], it means to search C from
% 2^1 to 2^13 with step = 2 and to search Gamma from 2^-7 to 2^5 with step
% = 1.
% 
% OUTPUT
% 
% Models and corresponding scaling factors will be saved to modeldir. For
% instance, the files for index NBR are “NBRmaxX.mat”, “NBRminX.mat”,
% “NBRSVM.mat” and “NBRtree.mat”. The first two files store scaling
% factors, while the remaining two store the SVM model and CART model
% respectively.

%
% EXAMPLE
% imagedir = 'F:\Data\TimeSeries\';
% shapedir = 'F:\Data\ReferencePoints\';
% modeldir = 'F:\Data\Models\';
% yfile = 'F:\Data\stats.xlsx';
% maxsample = 200;
% combinelist = [10 11 15];
% SVMgsOption = [1,1,13,-7,1,5]; 
%      % Search C from 2^1 to 2^13 with step = 1
%      % Gamma from 2^-7 to 2^5 with step = 1
% Module_FittingModels(imagedir, shapedir, modeldir, yfile, combinelist,
% maxsample, SVMgsOption);

function Module_FittingModels(imagedir, shapedir, modeldir, yfile, ...
    combinelist, maxsample, SVMgsOption)

samples = {'Persistent.shp','Slowonset.shp', 'Rapidonset.shp'}; 

dnames = {'Persistent', 'Slow-onset', 'Rapid-onset'};

bands = {'B1', 'B2', 'B3', 'B4', 'B5', 'B7', 'NDVI', 'NDSI', 'NDWI', 'NDMI'...
    , 'NBR', 'EVI', 'Brightness', 'Greenness', 'Wetness'};

for listidx = 1:numel(combinelist)
    idx = combinelist(listidx);
    vegx = char(bands(idx));
    
    imgfile = strcat(imagedir, vegx,'_TS');
    [image,p,t,xystart,mapinfo,coodsys,index] = ...
            readenvi(imgfile, false);
    image=reshape(image,[p(1),p(2),p(3)]);
    [token, remain] = strtok(mapinfo, ',');
    mappar = str2num(token);
    while length(remain)>0
        [token, remain] = strtok(remain, ',');
        mappar = [mappar str2num(token)];
    end
    Est = mappar(3);
    Nst = mappar(4);

    doy = xlsread(yfile);
    doy = doy(:,1);
    doyp = fix(doy/1000) + (doy/1000 - fix(doy/1000))/0.365;
    labels=cell(length(doy),1);
    for i = 1:length(doy)
        labels(i) = cellstr(num2str(doy(i)));
    end

    year = [min(fix(doy/1000)):max(fix(doy/1000))];
    n = length(year);
    ts = -10001 * ones(maxsample, n,length(samples));
    for lc = 1:length(samples);

        % read shape files of training dataset and find their pixel
        % locations
        data = shaperead(strcat(shapedir,char(samples(lc))));
        nump = length(data);
        east = [data(:).X];
        north = [data(:).Y];
        xst = fix((east - Est) / 30 + 1);
        yst = fix((Nst - north) / 30 + 1);

        lp = length(doyp);
        cc = lines(nump);
        for i = 1:nump
            vegidx = reshape(image(xst(i),yst(i),:),[lp,1]);
            if sum(vegidx ~= -10001) ~= 0
                [x, y] = annuallify(doy, vegidx, 100);
                y = denoise(y, 1);
                ts(i,:,lc) = y;   
            else
                disp([char(dnames(lc)) ' #' num2str(i) ' has no value']);
            end
        end
    end
    
    % max pieces
    mp = 5;
    % number of classes
    numc = 3;
    % Min Slope, Max Slope, Min Range Change, Max Range Change, Min, Max 
    % 6 features
    nums = 6;
    rstats = NaN(maxsample,length(samples),nums);

    figure;
    nodpoints = NaN(maxsample,6);
    nodvalues = NaN(maxsample,6);
    cd = 0;
    for lc = 1:length(samples)
        data = ts(ts(:,1,lc)~=-10001,:,lc);
        nump = size(data,1);

        for i = 1:nump
            y = data(i,:);
            [ypoints, bestmp, r2] = PLRtsfast(x, y, mp, 0.95, 0.9, 0.04);
            rstats(i,lc,:) = trendstats(ypoints);
            cd = cd + 1;
            nyp = size(ypoints);
            nodpoints(cd,1:nyp(1)) = ypoints(:,1)';
            nodvalues(cd,1:nyp(1)) = ypoints(:,2)';
        end

    end
    trref = [];
    for i = 1:numc
        data = rstats(~isnan(rstats(:,i,1)),i,:);
        rowcol = size(data); 
        trref = [trref; repmat(i,rowcol(1),1)];
    end
    for algorithm = 1:2
        trainingx = nodpoints(~isnan(nodpoints(:,1)),:);
        trainingy = nodvalues(~isnan(nodpoints(:,1)),:);
        nump = size(trainingx,1);
        X = NaN(nump,nums);
        for i = 1:nump
            ypoints = [trainingx(i,:); trainingy(i,:)]';
            ypoints = ypoints(~isnan(ypoints(:,1)),:);
            X(i,:) = trendstats(ypoints);
        end
        % build tree
        y = trref;
        if algorithm == 1   % CART
            y = nominal(y);
            CARTtree = classregtree(X,y); 
            save([modeldir vegx 'tree.mat'],'CARTtree');       
            y = double(y);
        elseif algorithm == 2   % SVM
            % Scaling is necessary here and the scaling factors are saved
            % too in the same directory as the model.
            minX = min(X(:));
            maxX = max(X(:));
            XX = (X-minX) ./ (maxX-minX);
            % Grid search the best 5-cv parameters are selected for the model
            % 
            bestcv = 0;
            log2c=SVMgsOption(1):SVMgsOption(2):SVMgsOption(3);
            log2g=SVMgsOption(4):SVMgsOption(5):SVMgsOption(6);
            px=size(log2c,2);
            py=size(log2g,2);
            for i = 1:px,
                for j = 1:py,
                    cmd = ['-v 5 -c ', num2str(2^log2c(i)), ' -g ', num2str(2^log2g(j))];
                    cv = svmtrain(y, XX, cmd);
                    if cv >= bestcv
                        bestcv = cv; 
                        bestc = 2^log2c(i); 
                        bestg = 2^log2g(j);
                    end
                end
            end
            fprintf('Best c=%g, g=%g, Cross Validation Accuracy = %g)\n', bestc, bestg, bestcv);
            SVMmodel = svmtrain(y, XX, ['-c ' num2str(bestc) ' -g ' num2str(bestg)]);
            save([modeldir vegx 'SVM.mat'],'SVMmodel');
            save([modeldir vegx 'minX.mat'],'minX');
            save([modeldir vegx 'maxX.mat'],'maxX');
        end
    end
end