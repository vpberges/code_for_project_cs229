% Split data into 70% training, 30% testing on both high and low grade
clear all
close all
load('data.mat')
cleanData

randomness = 3;
indices = [5, 6, 9, 10, 11, 12, 13, 14, 17, 18, 19, 20, 21, 22, 25, 26, 27, 28, 29, 30, 33, 34, 35, 36];
X2 = X(:, indices);

numIterations = 1000;
numTestExamples = 32; % originally 83
numThresholds = 1001;
thresholds = linspace(0, 1, numThresholds);
thresholdsMatrix = repmat(thresholds, numTestExamples, 1);

TPs = zeros(numIterations, numThresholds);
TNs = zeros(numIterations, numThresholds);
FPs = zeros(numIterations, numThresholds);
FNs = zeros(numIterations, numThresholds);

for i = 1:numIterations
    if randomness == 1 
        %No random
        trainMatrix = [X2(1:37,:); X2(55:208,:)];
        testMatrix = [X2(38:54,:); X2(209:274,:)];
        trainCategories = [Y(1:37); Y(55:208)];
        testCategories = [Y(38:54); Y(209:274)];
    elseif randomness == 2
        %full Random
        train = randsample(274,192)';
        test = 1:274;
        test(train) = [];
        trainMatrix = X2(train,:);
        testMatrix = X2(test,:);
        trainCategories = Y(train);
        testCategories = Y(test);
    else
        % Half Random
        trainLGG = randsample(1:54,38)';
        testLGG = 1:54;
        testLGG(trainLGG) = [];
        %trainHGG = randsample(55:274,153)'; % 83 test examples
        trainHGG = randsample(55:274,204)'; % 32 test examples
        testHGG = 55:274;
        for j = 1:size(trainHGG,1)
            testHGG(testHGG==trainHGG(j)) = [];
        end
        trainMatrix = [X2(trainLGG,:);X2(trainHGG,:)];
        testMatrix = [X2(testLGG,:);X2(testHGG,:)];
        trainCategories = [Y(trainLGG);Y(trainHGG)];
        testCategories = [Y(testLGG);Y(testHGG)];
    end

    % Run logistic regression
    B = glmfit(trainMatrix, trainCategories, 'binomial', 'link', 'logit');
    pihat = glmval(B, testMatrix, 'logit');
    
    predictionsMatrix = repmat(pihat, 1, numThresholds) > thresholdsMatrix;
    testCategoriesMatrix = repmat(testCategories, 1, numThresholds);
    
    TP = sum(predictionsMatrix .* testCategoriesMatrix);
    TN = sum((1 - predictionsMatrix) .* (1 - testCategoriesMatrix));
    FP = sum(predictionsMatrix .* (1 - testCategoriesMatrix));
    FN = sum((1 - predictionsMatrix) .* testCategoriesMatrix);

    TPs(i,:) = TP;
    TNs(i,:) = TN;
    FPs(i,:) = FP;
    FNs(i,:) = FN;

end

TPR = nanmean(TPs ./ (TPs + FNs));
FPR = nanmean(FPs ./ (FPs + TNs));
precision = nanmean(TPs ./ (TPs + FPs));
recall = TPR;
accuracy = nanmean((TPs + TNs) ./ (TPs + TNs + FPs + FNs));
error = 1 - accuracy;
sensitivity = TPR;
specificity = 1 - FPR;
PPV = precision;
NPV = nanmean(TNs ./ (TNs + FNs));

AUC = abs(trapz(FPR, TPR));
% Precision is undefined (NaN) when threshold = 1
AURPC = abs(trapz(recall(1:numThresholds - 1), precision(1:numThresholds - 1)));

figure;
plot(FPR, TPR);
xlabel('FPR');
ylabel('TPR');
title('ROC Plot');
axis([0 1 0 1]);

figure;
plot(recall, precision);
xlabel('Recall');
ylabel('Precision');
title('Precision Recall Plot');
axis([0 1 0 1]);

figure;
plot(thresholds, sensitivity, thresholds, specificity, thresholds, PPV, ...
    thresholds, NPV, thresholds, error, thresholds, accuracy);
legend('sensitivity','specificity','PPV','NPV','error','accuracy','Location','SouthEast');
xlabel('Threshold');
title('Analysis');
axis([0 1 0 1]);
