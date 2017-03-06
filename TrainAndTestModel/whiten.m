function [FEATURES, meanVec, stdVec] = whiten(FEATURES)
% Tilke Judd
% Feb 2009
%
% [FEATURES, meanVec, stdVec] = whiten(FEATURES)
% Whiten the data so that it has zero mean and unit variance

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

% create zero mean by subtracting the mean
meanVec=mean(FEATURES, 1);
FEATURES=FEATURES-repmat(meanVec, [size(FEATURES, 1), 1]);

% create unit variance by dividing by the standard deviation
stdVec=std(FEATURES);
z=find(stdVec==0);
if length(z)>0
    display('Alert: DIVIDE by 0 in the Whiten call!');
end
FEATURES=FEATURES./repmat(stdVec, [size(FEATURES, 1), 1]);

