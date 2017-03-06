function allfeatures = collectFeatures(images, path, dims)
%
% allfeatures = collectFeatures(images, M, N)
% return allfeatures of size [M*N*numImgs, numFeatures]

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

allfeatures = zeros(dims(1)*dims(2)*length(images), 3);
for i=1:length(images)
    imagefile = fullfile(path, images(i).name);
    image = imread(imagefile);
   index = (i-1)*(dims(1)*dims(2));
   allfeatures(index+1:index+dims(1)*dims(2), 1:3) = findSimpleColorFeatures(image, dims);
   fprintf('.')
end

% you can add any other features here that you'd like to test out
% the features that we used are available on our website under
% http://people.csail.mit.edu/tjudd/WherePeopleLook/Code/JuddSaliencyModel.zip