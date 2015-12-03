load('svmResults.mat')

numThresholds = size(thresholds, 2);

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
