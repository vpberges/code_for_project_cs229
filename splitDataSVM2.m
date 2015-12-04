% Split data into 70% training, 30% testing on both high and low grade
addpath('liblinear-2.1/matlab');  % add LIBLINEAR to the path
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
numDecisions = 1001;
decisions = linspace(-5, 5, numDecisions);
decisionsMatrix = repmat(decisions, numTestExamples, 1);

svmTPs = zeros(numIterations, numDecisions);
svmTNs = zeros(numIterations, numDecisions);
svmFPs = zeros(numIterations, numDecisions);
svmFNs = zeros(numIterations, numDecisions);

for i = 1:numIterations
    % Construct training and testing matrices and labels
    testIndex = testIndices(i,:);
    trainIndex = 1:274;
    trainIndex(testIndex) = [];
    trainMatrix = X(trainIndex,:);
    testMatrix = X(testIndex,:);
    trainCategories = Y(trainIndex);
    testCategories = Y(testIndex);
    
    % Convert labels from {0,1} to {-1,1} to use SVM
    svmTrainCategories = 2 .* trainCategories - 1;
    svmModel = train(svmTrainCategories, sparse(trainMatrix));
    svmTestCategories = 2 .* testCategories - 1;
    [svmPredictedLabels, svmAccuracy, svmDecisionValues] = predict(svmTestCategories, sparse(testMatrix), svmModel);
    
    predictionsMatrix = repmat(svmDecisionValues, 1, numDecisions) > decisionsMatrix;
    testCategoriesMatrix = repmat(testCategories, 1, numDecisions);
    
    svmTPs(i,:) = sum(predictionsMatrix .* testCategoriesMatrix);
    svmTNs(i,:) = sum((1 - predictionsMatrix) .* (1 - testCategoriesMatrix));
    svmFPs(i,:) = sum(predictionsMatrix .* (1 - testCategoriesMatrix));
    svmFNs(i,:) = sum((1 - predictionsMatrix) .* testCategoriesMatrix);

end

save svmResults2.mat decisions svmTPs svmTNs svmFPs svmFNs;
