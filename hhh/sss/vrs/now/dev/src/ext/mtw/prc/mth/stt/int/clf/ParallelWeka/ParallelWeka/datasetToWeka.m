function inst = datasetToWeka(dat)
%  This function converts a Matlab dataset to the equivalent in Weka, an
%  instance of Instances.  It is assumed the last column of the dataset
%  contains class label values.

    D = double(dat);
    numCols = size(dat,2);
 
    % create attributes list
    attributes = weka.core.FastVector(numCols);
    for i = 1:numCols-1
        attributes.addElement(weka.core.Attribute(dat.Properties.VarNames{i}));
    end
    
    % add class attribute
    numClasses = length(unique(D(:,end))); % number of unique values in class col
    classNames = weka.core.FastVector(numClasses);
    for i=1:numClasses
        classNames.addElement(['class' num2str(i)] );
    end
    classAttr = weka.core.Attribute('target', classNames);
    attributes.addElement(classAttr);

    % create instances (note: indexes are 0 relative)
    numRows = size(dat,1);
    inst = weka.core.Instances(dat.Properties.Description,attributes,numRows);   
    inst.setClass(classAttr);
    classIds = sort(unique(D(:,end)));  % class values ordered by size (eg -1,1)
    for i = 1:numRows
        classId = find(classIds==D(i,end))-1;  % ordered 0,1...
        inst.add( weka.core.Instance(1.0, [D(i,1:end-1) classId]) );
    end   
end