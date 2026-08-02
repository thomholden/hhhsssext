Jason Joseph Rebello
Harvard University (September 2013 - August 2014) 
Fellow in Computer Science
Calculation of True Positives, False Positives, True Negatives and False Negatives

This is a very simple function that takes in two matrices consisting of 1's and 0's and returns the number of True Positives, False Positives, True Negatives and False Negatives that can be used to calculate Precision, Recall and various other error metrics.

The matrices have to be of the same size.

Example matrices of trueMat and predictedMat are given. In order to see how the function works copy paste the following code in the function directory

% Start code

clear all
clc
close all

load trueMat.mat
load predictedMat.mat

[TP, FP, TN, FN] = calError(trueMat, predictedMat)

% End code

Performance metrics:
1) Precision = TP / (TP + FP)
2) Sensitivity = Recall = TP / (TP + FN)      
3) F1Score = 2*Precision*Recall / (Precision + Recall)
4) Specificity = TN / (TN + FP)