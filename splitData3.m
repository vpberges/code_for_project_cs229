% Split data into 70% training, 30% testing on both high and low grade
clear all
close all
load('testIndices.mat')
load('data.mat')
cleanData

% Get rid of features 1, 2, 3, 4, 7, 8, 15, 16, 23, 24, 31, and 32
indices = 1:36;
indices = indices(indices > 4 & mod(indices, 8) & mod(indices + 1, 8));
X = X(:,indices);

numIterations = size(testIndices, 1);
numTestExamples = size(testIndices, 2);
numThresholds = 1001;
thresholds = linspace(0, 1, numThresholds);
thresholdsMatrix = repmat(thresholds, numTestExamples, 1);

logTPs = zeros(numIterations, numThresholds);
logTNs = zeros(numIterations, numThresholds);
logFPs = zeros(numIterations, numThresholds);
logFNs = zeros(numIterations, numThresholds);

for i = 1:numIterations
    % Construct training and testing matrices and labels
    testIndex = testIndices(i,:);
    trainIndex = 1:274;
    trainIndex(testIndex) = [];
    trainMatrix = X(trainIndex,:);
    testMatrix = X(testIndex,:);
    trainCategories = Y(trainIndex);
    testCategories = Y(testIndex);

    % Run logistic regression
    B = glmfit(trainMatrix, trainCategories, 'binomial', 'link', 'logit');
    pihat = glmval(B, testMatrix, 'logit');
    
    predictionsMatrix = repmat(pihat, 1, numThresholds) > thresholdsMatrix;
    testCategoriesMatrix = repmat(testCategories, 1, numThresholds);
    
    logTPs(i,:) = sum(predictionsMatrix .* testCategoriesMatrix);
    logTNs(i,:) = sum((1 - predictionsMatrix) .* (1 - testCategoriesMatrix));
    logFPs(i,:) = sum(predictionsMatrix .* (1 - testCategoriesMatrix));
    logFNs(i,:) = sum((1 - predictionsMatrix) .* testCategoriesMatrix);
end

save logResults.mat thresholds logTPs logTNs logFPs logFNs;
