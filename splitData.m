% Split data into 70% training, 30% testing on both high and low grade
clear all
close all
load('data.mat')
cleanData

%threshold = 0.6;
randomness = 3;
indices = [5, 6, 9, 10, 11, 12, 13, 14, 17, 18, 19, 20, 21, 22, 25, 26, 27, 28, 29, 30, 33, 34, 35, 36];
X2 = X(:, indices);

errThre = [];
%for threshold = logspace(-13,0,20);
for threshold = linspace(0, 1, 20)
error = [];
for iter =1:100


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
trainHGG = randsample(55:274,153)';
testHGG = 55:274;
for i = 1:size(trainHGG,1)
    testHGG(testHGG==trainHGG(i)) = [];
end
trainMatrix = [X2(trainLGG,:);X2(trainHGG,:)];
testMatrix = [X2(testLGG,:);X2(testHGG,:)];
trainCategories = [Y(trainLGG);Y(trainHGG)];
testCategories = [Y(testLGG);Y(testHGG)];
end

% Run logistic regression
%B = mnrfit(trainMatrix, trainCategories + 1);
%B = glmfit(trainMatrix, trainCategories ,'binomial');
B = glmfit(trainMatrix, trainCategories, 'binomial', 'link', 'logit');

%pihat = mnrval(B, testMatrix);
pihat = glmval(B, testMatrix, 'logit');

%[~, indices] = max(pihat');
%predictedCategories = indices' - 1;
%predictedCategories = pihat(:,2)>threshold;
predictedCategories = pihat>threshold;
diff = abs(testCategories - predictedCategories);
err = sum(diff) / size(testCategories, 1);
TP = sum(predictedCategories .* testCategories);
TN = sum((1 - predictedCategories) .* (1 - testCategories));
FP = sum(predictedCategories .* (1 - testCategories));
FN = sum((1 - predictedCategories) .* testCategories);
TPR = TP / (TP + FN);
FPR = FP / (FP + TN);
%TPR = sum(predictedCategories.*testCategories)/sum(predictedCategories);
%FPR = sum((1-predictedCategories).*(testCategories))/sum((predictedCategories));

%disp(['The error rate is : ',num2str(err),'; the true positive rate is : ',...
  %  num2str(TPR),'; the false positive rate is :',num2str(FPR)]);
  %sum(predictedCategories)
error(iter,:) = [err,FPR,TPR];
end

errThre = [errThre;threshold,nanmean(error)];
%errThre = [errThre;threshold,err,TPR,FPR];
end


%using zscore with clean data is the same as using scores without clean
%data? 0.1807 in both cases

%save errThre.mat errThre;

plot(errThre(:,3),errThre(:,4),'o')
axis([0 1 0 1])
