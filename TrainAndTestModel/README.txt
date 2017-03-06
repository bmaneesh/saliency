 ----------------------------------------------------------------------
 Matlab tools for "Learning to Predict Where Humans Look" ICCV 2009
 Tilke Judd, Kristen Ehinger, Fredo Durand, Antonio Torralba
 
 Copyright (c) 2010 Tilke Judd
 Distributed under the MIT License
 See MITlicense.txt file in the distribution folder.
 
 Contact: Tilke Judd at <tjudd@csail.mit.edu>
 ----------------------------------------------------------------------

This is a simplified version of the code written to learn 
a model of saliency given several different features.  

It is code related to the paper from ICCV 2009
Learning to Predict Where Humans Look
Tilke Judd, Krista Ehinger, Fredo Durand, Antonio Torralba.

The principle code is in trainAndTestModel.m.  
In this file make sure to change the path files for  
IMGS = '????'; % Path to the Images on local computer 
(download from http://people.csail.mit.edu/tjudd/WherePeopleLook/ALLSTIMULI.zip)
MAPS = '????'; % Path to the fixation maps on local computer
(download from http://people.csail.mit.edu/tjudd/WherePeopleLook/ALLFIXATIONMAPSMAT.zip)

The supporting code is in 
selectSamplesPerImg.m  	
testModel.m 
whiten.m 
whitenTestingData.m
collectFeatures.m (This pulls in features for the images.  You can change this code to call in any other features you'd like to try)
FixationMapsBlock.mat (this is an array that stored the fixations maps for all the images in our database)

To make the code work, you need to have the Liblinear matlab package.
Download this and put it in your matlab path.
http://www.csie.ntu.edu.tw/~cjlin/liblinear/

Then navigate to Matlab and run 
>> [ROCperformances, Models] = trainAndTestModel(); *(see not to make shorter run time)
This function returns the ROC performances for all the images tested in each trial
It also returns the models that were learned for each trial.  
The weights of the model (Models.w) show a relative weighting of each feature.
The last number in Model.w is the offset for the model and not a weight of a feature.  

* If you want to get a quick sense of how the code works without going 
through all the training and testing trials, change the following variables in trainAndTestMode.m to smaller numbers:
numtraining=10; % a good default is 100, make smaller for testing
numtesting=20; % a good default is 500, make smaller for testing
numTrials=2; % a good default is 5, make smaller for testing

Send feedback, suggestions and questions to Tilke Judd at <tjudd@csail.mit.edu>