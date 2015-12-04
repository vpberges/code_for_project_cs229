clear all
close all
load('logResults.mat')
load('svmResults2.mat')

% Logistic regression results
numThresholds = size(thresholds, 2);

logTPR = nanmean(logTPs ./ (logTPs + logFNs));
logFPR = nanmean(logFPs ./ (logFPs + logTNs));
logPrecision = nanmean(logTPs ./ (logTPs + logFPs));
logRecall = logTPR;
logAccuracy = nanmean((logTPs + logTNs) ./ (logTPs + logTNs + logFPs + logFNs));
logError = 1 - logAccuracy;
logSensitivity = logTPR;
logSpecificity = 1 - logFPR;
logPPV = logPrecision;
logNPV = nanmean(logTNs ./ (logTNs + logFNs));

logAUC = abs(trapz(logFPR, logTPR));
% Precision is undefined (NaN) when threshold = 1
logAURPC = abs(trapz(logRecall(1:numThresholds - 1), logPrecision(1:numThresholds - 1)));

% SVM results
numDecisions = size(decisions, 2);

svmTPR = nanmean(svmTPs ./ (svmTPs + svmFNs));
svmFPR = nanmean(svmFPs ./ (svmFPs + svmTNs));
svmPrecision = nanmean(svmTPs ./ (svmTPs + svmFPs));
svmRecall = svmTPR;
svmAccuracy = nanmean((svmTPs + svmTNs) ./ (svmTPs + svmTNs + svmFPs + svmFNs));
svmError = 1 - svmAccuracy;
svmSensitivity = svmTPR;
svmSpecificity = 1 - svmFPR;
svmPPV = svmPrecision;
svmNPV = nanmean(svmTNs ./ (svmTNs + svmFNs));

svmAUC = abs(trapz(svmFPR, svmTPR));
svmAURPC = abs(trapz(svmRecall, svmPrecision));

figure;
plot(logFPR, logTPR, svmFPR, svmTPR);
legend_str = [{'Logistic Regression'}; {'SVM                '};];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('FPR');
ylabel('TPR');
title('ROC Plot');
axis([0 1 0 1]);

figure;
plot(logRecall, logPrecision, svmRecall, svmPrecision);
legend_str = [{'Logistic Regression'}; {'SVM                '};];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Recall');
ylabel('Precision');
title('Precision Recall Plot');
axis([0 1 0 1]);

figure;
plot(thresholds, logError);
xlabel('Threshold');
ylabel('Error');
title('Logistic Regression Error');
axis([0 1 0 1]);

figure;
plot(thresholds, logSensitivity, thresholds, logSpecificity);
legend_str = [{'sensitivity'}; {'specificity'};];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Threshold');
title('Logistic Regression Sensitivity and Specificity');
axis([0 1 0 1]);

figure;
plot(thresholds, logSensitivity, thresholds, logSpecificity, thresholds, logError);
legend_str = [{'sensitivity'}; {'specificity'}; {'error      '}];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Threshold');
title('Logistic Regression Sensitivity, Specificity, and Error');
axis([0 1 0 1]);

figure;
plot(decisions, svmError);
xlabel('Decision Value');
ylabel('Error');
title('SVM Error');
axis([-5 5 0 1]);

figure;
plot(decisions, svmSensitivity, decisions, svmSpecificity);
legend_str = [{'sensitivity'}; {'specificity'};];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Decision Value');
title('SVM Sensitivity and Specificity');
axis([-5 5 0 1]);

figure;
plot(decisions, svmSensitivity, decisions, svmSpecificity, decisions, svmError);
legend_str = [{'sensitivity'}; {'specificity'}; {'error      '}];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Decision Value');
title('SVM Sensitivity, Specificity, and Error');
axis([-5 5 0 1]);

figure;
plot(thresholds, logSensitivity, thresholds, logSpecificity, thresholds, logPPV, ...
     thresholds, logNPV, thresholds, logError, thresholds, logAccuracy);
legend_str = [{'sensitivity'}; {'specificity'}; {'PPV        '}; {'NPV        '}; {'error      '}; {'accuracy   '}];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Threshold');
title('Analysis');
axis([0 1 0 1]);

figure;
plot(decisions, svmSensitivity, decisions, svmSpecificity, decisions, svmPPV, ...
     decisions, svmNPV, decisions, svmError, decisions, svmAccuracy);
legend_str = [{'sensitivity'}; {'specificity'}; {'PPV        '}; {'NPV        '}; {'error      '}; {'accuracy   '}];
columnlegend(2, legend_str, 'Location', 'SouthEast');
xlabel('Decision Values');
title('Analysis');
axis([-5 5 0 1]);

% Confusion table parameters for min logistic regression error
[~, logErrIndex] = min(logError);
logErrThr = thresholds(logErrIndex);
logErrTP = nanmean(logTPs(:,logErrIndex));
logErrTN = nanmean(logTNs(:,logErrIndex));
logErrFP = nanmean(logFPs(:,logErrIndex));
logErrFN = nanmean(logFNs(:,logErrIndex));
logErrErr = logError(logErrIndex);

% Confusion table parameters for logistic regression where sensitivity =
% specificity
[~, logSensSpecIndex] = min(abs(logSensitivity - logSpecificity));
logSensSpecThr = thresholds(logSensSpecIndex);
logSensSpecTP = nanmean(logTPs(:,logSensSpecIndex));
logSensSpecTN = nanmean(logTNs(:,logSensSpecIndex));
logSensSpecFP = nanmean(logFPs(:,logSensSpecIndex));
logSensSpecFN = nanmean(logFNs(:,logSensSpecIndex));
logSensSpecErr = logError(logSensSpecIndex);

% Confusion table parameters for min SVM error
[~, svmErrIndex] = min(svmError);
svmErrDec = decisions(svmErrIndex);
svmErrTP = nanmean(svmTPs(:,svmErrIndex));
svmErrTN = nanmean(svmTNs(:,svmErrIndex));
svmErrFP = nanmean(svmFPs(:,svmErrIndex));
svmErrFN = nanmean(svmFNs(:,svmErrIndex));
svmErrErr = svmError(svmErrIndex);

% Confusion table parameters for SVM where sensitivity = specificity
[~, svmSensSpecIndex] = min(abs(svmSensitivity - svmSpecificity));
svmSensSpecDec = decisions(svmSensSpecIndex);
svmSensSpecTP = nanmean(svmTPs(:,svmSensSpecIndex));
svmSensSpecTN = nanmean(svmTNs(:,svmSensSpecIndex));
svmSensSpecFP = nanmean(svmFPs(:,svmSensSpecIndex));
svmSensSpecFN = nanmean(svmFNs(:,svmSensSpecIndex));
svmSensSpecErr = svmError(svmSensSpecIndex);
