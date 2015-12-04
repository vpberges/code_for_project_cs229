% Generates numSamples random samples of testing data, each consisting of
% 16 low grade and 16 high grade. Saves the indices in testIndices.mat
function [] = generateTestIndices(numSamples)
    testIndices = zeros(numSamples, 32);
    for i = 1:numSamples
        testLGG = randsample(1:54, 16);
        testHGG = randsample(55:274, 16);
        testIndices(i,:) = [testLGG, testHGG];
    end
    save testIndices.mat testIndices;
end
