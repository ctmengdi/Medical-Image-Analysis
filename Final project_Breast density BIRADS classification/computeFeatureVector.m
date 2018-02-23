function v = computeFeatureVector(Image,str)
%
% Describe an image A using texture features.
%   A is the image
%   v is a 1xN vector, being N the number of features used to describe the
% image
%

A = preprocessing(Image, 10, str);

v = extractLBPFeatures(A,'Upright',false);

v = double(v);





