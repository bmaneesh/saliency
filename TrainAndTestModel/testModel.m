function ROCperformances = testModel(model, testingImgs, whiteningParams, dims, IMGS, MAPS, showResults)
% ROCperformances = 
% testModel(model, testingImgs, whiteningParams, dims, IMGS, MAPS, showResults)
% 

% ----------------------------------------------------------------------
% Matlab tools for "Learning to Predict Where Humans Look" ICCV 2009
% Tilke Judd, Kristen Ehinger, Fredo Durand, Antonio Torralba
% 
% Copyright (c) 2010 Tilke Judd
% Distributed under the MIT License
% See MITlicense.txt file in the distribution folder.
% 
% Contact: Tilke Judd at <tjudd@csail.mit.edu>
% ----------------------------------------------------------------------


% make features doubles and Whiten the features
meanVec = whiteningParams(1, :);
stdVec = whiteningParams(2, :);

% Test model on one image at a time
for i=1:length(testingImgs)
    
    % get the features for this image
    features = collectFeatures(testingImgs(i), IMGS, dims);
    X=whitenTestingData(features, meanVec, stdVec);
    
    % Get the results of the model given these features
    tic;
    predictions = X*model.w';
    
    % get the fixation map
    fixationMapFile = fullfile(MAPS, strcat(testingImgs(i).name(1:end-4), 'mat'));
    load (fixationMapFile);  % this brings in fixationPts which is the original size image which 1s at fixation locations
    [r, c] = size(fixationPts);
    
    % get the predictions in the same size as the fixation map
    predictions = reshape(predictions, [dims]);
    predictions = imresize(predictions, [r, c]); % resize predictions for direct comparison
    
    % Calculate the area under the ROC curve
    S = predictions(:);
    F = fixationPts(:);
    [S, k] = sort(S, 'descend');
    F = F(k);
    
    % calculate precision and false alarms
    n = length(F);
    cumSumF = cumsum(F);
    sumF = sum(F);
    cumSumOneMinusF = cumsum(1-F);
    sumOneMinusF = sum(1-F);
    
    precision = cumSumF / sumF;
    falseAlarms = cumSumOneMinusF / sumOneMinusF;
    
    % Save the output in an array
    areaUnderROC = sum(precision) / length(precision);
    ROCperformances(i) = areaUnderROC;
    
    if showResults
        % should also show the original image
        imagefile = fullfile(IMGS, testingImgs(i).name);
        img = imread(imagefile);
        fixationsdilate=conv2(double(fixationPts),ones(20),'same');
        subplot(141); imshow(img); title('Original Image');
        subplot(142); imagesc(predictions); title('Predictions');
        subplot(143); imshow(fixationsdilate); title('Actual Fixations');
        subplot(144); plot(falseAlarms, precision);   title(['Area under ROC curve: ', num2str(areaUnderROC)])
        pause;
    end
end