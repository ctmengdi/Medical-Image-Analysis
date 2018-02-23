%Ground Truth Combining
clc;
close all;

%expert 1
srcFiles = dir('images\gt\expert_1\*.png');
for i = 1 : length(srcFiles)
  filename = strcat('images\gt\expert_1\',srcFiles(i).name);
  s1(:,:,i) = imread(filename);
  %figure, imshow(s1(:,:,i));
end

%expert 2
srcFiles = dir('images\gt\expert_2\*.png');
for i = 1 : length(srcFiles)
  filename = strcat('images\gt\expert_2\',srcFiles(i).name);
  s2(:,:,i) = imread(filename);
  %figure, imshow(s2(:,:,i));
end

%expert 3
srcFiles = dir('images\gt\expert_3\*.png');
for i = 1 : length(srcFiles)
  filename = strcat('images\gt\expert_3\',srcFiles(i).name);
  s3(:,:,i) = imread(filename);
  %figure, imshow(s3(:,:,i));
end

imageDims = size(s1(:,:,1));

% Create the directory to save the output image
path_gt = 'images/gt/fusion/';
if ~exist(path_gt, 'dir')
  mkdir(path_gt);
end

%concatenate the images
for i=1:size(s1,3)
    %get each of the image
    X = reshape(s1(:,:,i),imageDims);
    Y = reshape(s2(:,:,i),imageDims);
    Z = reshape(s3(:,:,i),imageDims);
    
    D = [X(:), Y(:), Z(:)]; % pixels in rows, raters in columns
    
    [W, p, q]= STAPLE(D);
    % p,q values of your raters:
    p
    q
    %Estimated ground truth image:
    W = mat2gray(W);

    gtImage = reshape((W >= .5), imageDims);
    figure, imagesc(gtImage)
    % Save the image
    imwrite( gtImage, [ path_gt, srcFiles(i).name], 'png' )
end