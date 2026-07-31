function predClass = Credit_Rating(newData)
% This function uses the previously constructed classification ensemble to
% assign credit ratings to new customers.

% We start by loading the classifier.
load('CreditRatingClassifier.mat')

% Next, we trim the |newData| so that only the three significant variables
% are passed to the classifier:
newData = newData(:, [2 4 6]);

% To predit the credit rating for this new data, we call the |predict|
% method on the classifier. The method returns two arguments, the predicted
% class and the classification score. We certainly want to get both output
% arguments, since the classification scores contain information on how
% certain the predicted ratings seem to be.

predClass = predict(b, newData);

%#function TreeBagger