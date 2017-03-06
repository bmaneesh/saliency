function [ROCperformances, Models] = trainAndTestModel()
%
% [ROCperformances, Models] = trainAndTestModel()
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

% Inputs
IMGS = '../ALLSTIMULI'; %Change this to the path on your local computer
MAPS = '../ALLFIXATIONMAPS'; %Change this to the path on your local computer
imagefiles = dir(fullfile(IMGS, '*.jpeg'));
numImgs = length(imagefiles);
numtraining=10; % a good default is 100, make smaller to test
numtesting=20; % a good default is 500, make smaller to test
numTrials=2; % a good default is 5, make smaller to test
posPtsPerImg=10; % number of positive samples taken per image to do the learning
negPtsPerImg=10; % numbe of negative samples taken
p=5; % pos samples are taken from the top p percent salient pixels of the fixation map
q=30; % neg samples are taken from below the top q percent
c=1; % parameter for the liblinear machine learning 
w1=1; % parameter for the liblinear machine learning
M = 200; % size of the downsized images we work with
N = 200;
showResults = 0;

% initialize the return objects
ROCperformances = zeros(numTrials, numtesting);

% Run n trials of training and testing
for n=1:numTrials
    
    fprintf(['Starting Trial ', num2str(n), '\n']);
    
    % randomize image order
    imgIndices=shuffle([1:1:numImgs]);
    trainingIndices = imgIndices([1:numtraining]);
    testingIndices =  imgIndices([numtraining+1:numtraining+numtesting]);
    
    % find images needed for training and testing
    trainingImgs = imagefiles([trainingIndices]);
    testingImgs = imagefiles([testingIndices]);
    
    % find features of training and testing images
    fprintf('Finding training features...'); tic
    featuresTraining = collectFeatures(trainingImgs, IMGS, [M, N]); % this should be size [M*N*numImages, numFeatures]
    fprintf([num2str(toc), ' seconds \n']);
        
    % find fixation map labels of training images (ground truth saliency)
    fprintf('loading fixation maps...'); tic
    load FixationMapsBlock.mat % loads in the FIXATION_MAPS block [M, N, 1, numImgs]
    labels = FIXATION_MAPS(:, :, :, [trainingIndices]); % should be size [M, N, 1, numImgs]
    labels = reshape(labels, [M*N*numtraining, 1]); % should be size [M*N*numImages, 1]
    fprintf([num2str(toc), 'seconds \n']);
   
    fprintf('Finding random pos and neg samples per image...'); tic
    [posIndices, negIndices] = selectSamplesPerImg(labels, p, q, numtraining, [M, N], posPtsPerImg, negPtsPerImg);
    X = double(featuresTraining([posIndices, negIndices], :)); %trainingFeatures
    Y = double([ones(1, length(posIndices)), zeros(1, length(negIndices))])'; %trainingLabels
    fprintf([num2str(toc), ' seconds \n']);
    
    %%%%%%%%%%%%
    % Training %
    %%%%%%%%%%%%
    
    fprintf('Whitening the data...'); tic
    [X, meanVec, stdVec]=whiten(X);
    whiteningParams = [meanVec; stdVec];
    fprintf([num2str(toc), ' seconds \n']);
    
    fprintf('Training the model...'); tic
    params=['-c', blanks(1), num2str(c), ' -B -1'];
    model=train(Y, sparse(X), params);
    fprintf([num2str(toc), ' seconds \n']);
    
    Models(n)=model;
    clear X Y  featuresTraining FIXATION_MAPS labels
        
    %%%%%%%%%%%
    % Testing %
    %%%%%%%%%%%
    
    % Instead of testing on a few samples per image,
    % we test on all the pixels of the image.  The model provides a
    % continous prediction of saliency over the image.  We measure its
    % performance for predicting where people look as the area under the
    % ROC curve.
    
    % This should output one ROC value per testing image
    fprintf('Testing the model...'); tic
    ROCperformances(n, :) = testModel(model, testingImgs, whiteningParams, [200, 200], IMGS, MAPS, showResults);
    fprintf([num2str(toc), ' seconds \n']);
    mean(ROCperformances, 2) 
end

savefile = 'results.mat'
save(savefile, 'ROCperformances', 'Models');








