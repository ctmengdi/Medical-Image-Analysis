function [ output_img ] = transformation( input_img, r_off, theta_up, theta_low )
%TRANSFORMATION Summary of this function goes here
%   Detailed explanation goes here

num_col = 2*r_off + size(input_img,2);
num_row = 2*num_col;
output_img = zeros(num_row, num_col);

theta_up = theta_up*pi/180;
theta_low = theta_low*pi/180;

for yo = 1:num_row
    for xo = 1:num_col
        
        xi = round(sqrt(xo^2+ (yo-num_row/2)^2) - r_off);
        yi = round((atan2((yo-num_row/2),xo) - theta_up)*size(input_img,1)/(theta_low-theta_up));
        
        if xi >0 && xi <= size(input_img, 2) && yi > 0 && yi <= size(input_img,1)
            output_img(yo, xo) = input_img(yi, xi);
        end
    end
end
figure;
imshow(output_img, []);
title('transformed image');

end

