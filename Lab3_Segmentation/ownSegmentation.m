% Path of loading original images
srcFiles = dir('images\original\*.jpg');

% Create the directory to save the output image
path_seg = 'images/seg/ownSegmentation/';
if ~exist(path_seg, 'dir')
  mkdir(path_seg);
end

for i = 1 : length(srcFiles)
    % Read images
    filename = strcat('images\original\',srcFiles(i).name);
    img = imread(filename);
    
    % Convert image from rgb to hsv colorspace
    img = rgb2hsv(img);
    img = img(:,:,2);
    
    % Ostu thresholding 
    level = graythresh(img);
    BW = imbinarize(img,level);
    
    % Fill the holes
    I = imfill(BW, 'holes');
    
    % Seperate image into regions
    stats = regionprops(I, 'Area', 'PixelList');
    
    % Get the index of biggest area
    [~,ind] = max([stats.Area]);
    
    % Get the all the pixel positions of this area
    pix = sub2ind(size(I), stats(ind).PixelList(:,2), stats(ind).PixelList(:,1));
    
    % Extract the biggest area
    segmented_img = zeros(size(I));
    segmented_img(pix) = 1;

    % Show the segmented image
    figure, imshow(segmented_img,[]);
    
    % Save the image
    segmented_img = logical(segmented_img);
    imwrite( segmented_img, [ path_seg, srcFiles(i).name], 'png' );
end

