function features = findSimpleColorFeatures(img, dims)
%
% features = findColorFeatures(img, dims)
% Find the R, G, B channels of the image and returns them as features

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

features=zeros(dims(1)*dims(2), 3);
img=imresize(img, dims);
img=im2double(img);

for i=1:3
    channel=img(:, :, i);
    features(:, i)=channel(:);
end

if nargout==0
    subplot(2, 3, 6); imshow(img);
    for i=1:3
        subplot(2, 3, i); imagesc(reshape(features(:, i), dims));
    end
    subplot(2, 3, 1); title('Red');
    subplot(2, 3, 2); title('Green');
    subplot(2, 3, 3); title('Blue');
end
