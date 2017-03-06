function FEATURES = whitenTestingData(FEATURES, meanVec, stdVec)
% FEATURES = whitenTestingData(FEATURES, meanVec, stdVec)
% make the test features APPROX zero mean and unit variance given
% parameters from the training data

% --------------------------------------------------------------------
% Matlab tools for "Learning to Predict Where Humans Look" ICCV 2009
% Tilke Judd, Kristen Ehinger, Fredo Durand, Antonio Torralba
% 
% Copyright (c) 2010 Tilke Judd
% Distributed under the MIT License
% See MITlicense.txt file in the distribution folder.
% 
% Contact: Tilke Judd at <tjudd@csail.mit.edu>
% --------------------------------------------------------------------

    FEATURES=FEATURES-repmat(meanVec, [size(FEATURES, 1), 1]);
    FEATURES=FEATURES./repmat(stdVec, [size(FEATURES, 1), 1]);
end