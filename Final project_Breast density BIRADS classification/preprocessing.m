function [ proj ] = preprocessing( input_img, skin_width, str)
% input: original slice
% output: normalized slice with skin
input_img = squeeze(input_img);

for n = 1:size(input_img,3)

    % if the breast is on right side, flip the image
    slice = input_img(:,:,n);
    if str == 'r'
        slice = fliplr(slice);
    end
    
    slice_row = size(slice, 1);
    slice_col = size(slice, 2);
    
    % convert to binary to get the contour
    binary_DBT = imbinarize(slice);
    [c,~] = contour(binary_DBT);
    
    % take all the pixels of skin
    contour_new = c;
    contour_new(1,:) = c(1,:) - skin_width;

    [neg_x, neg_y] = find(contour_new<1);
    contour_new(neg_x, neg_y) = 1;
    
    c = c';
    contour_new = contour_new';
    crop = [];
    for m = 1:size(contour_new,1)
        crop(m,1) = contour_new(m,1);
        crop(m,2) = c(m,1);
        crop(m,3) = c(m,2);
    end
    crop =  floor(crop);
    
    for i = 1:size(crop,1)
        slice(crop(i,3), crop(i,1):crop(i,2)) = 0;
    end
    
    slice = imcrop(slice, [0,0,slice_col, slice_row]);
    slice = histeq(slice);
    output_slice = uint8(255*mat2gray(slice));
    input_img(:,:,n) = output_slice;
end

    % add up all the slices into one projection
    proj = input_img(:,:,1);
    for j = 2:size(input_img,3)
        proj = proj + input_img(:,:,j);
    end

end

