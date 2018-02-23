function [ Iregistered, M] = affineReg2D( Imoving, Ifixed )
%Example of 2D affine registration
%   Robert Martí  (robert.marti@udg.edu)
%   Based on the files from  D.Kroon University of Twente

% clean
clear all; close all; clc;

% Read two imges
% rgb images
% Imoving=im2double(rgb2gray(imread('brain2.png')));
% Ifixed=im2double(rgb2gray(imread('brain1.png')));
% gray images
Imoving=im2double(imread('brain4.png'));
Ifixed=im2double(imread('brain1.png'));

% Smooth both images for faster registration
ISmoving=imfilter(Imoving,fspecial('gaussian'));
ISfixed=imfilter(Ifixed,fspecial('gaussian'));

mtype = 'sd'; % metric type: s: sd m: mutual information e: entropy
ttype = 'a'; % rigid registration, options: r: rigid, a: affine

switch ttype
    case 'r'
        % Parameter scaling of the Translation and Rotation
        scale = [1.0, 1.0, 1.0];
        % Set initial affine parameters
        x = [0.0, 0.0, 0.0];
    case 'a'
        scale=1.0*[1,1,100,1,1,100];
        x = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0];
end;
x=x./scale;

num_resolution = 4;
Imoving_res = cell(1, num_resolution);
Ifixed_res = cell(1, num_resolution);

Imoving_res{num_resolution} = ISmoving;
Ifixed_res{num_resolution} = ISfixed;

n = num_resolution;
while n~=1
    n = n - 1;
    Imoving_res{n} = imresize(Imoving_res{n+1}, 0.5);
    Ifixed_res{n} = imresize(Ifixed_res{n+1}, 0.5);
end

for i = 1:num_resolution
    figure, imshow(Imoving_res{i},[]);
%[x]=fminunc(@(x)affine_function(x,scale,Imoving,Ifixed,mtype),x,optimset('Display','iter','MaxIter',1000, 'TolFun', 1.000000e-06,'TolX',1.000000e-06, 'MaxFunEvals', 1000*length(x)));
[x]=fminsearch(@(x)affine_function(x,scale,Imoving_res{i},Ifixed_res{i},mtype,ttype),x,optimset('Display','iter','MaxIter',1000,'Algorithm','interior-point', 'TolFun', 1.000000e-20,'TolX',1.000000e-20, 'MaxFunEvals', 1000*length(x)));
%[x]=fminsearch(@(x)affine_function(x,scale,ISmoving,ISfixed,mtype,ttype),x,optimset('Display','iter','MaxIter',1000,'Algorithm','interior-point', 'TolFun', 1.000000e-20,'TolX',1.000000e-20, 'MaxFunEvals', 1000*length(x)));

    if i ~= num_resolution
        if ttype == 'r'
            x(1) = 2*x(1);
            x(2) = 2*x(2);
        end
        if ttype == 'a'
            x(3) = 2*x(3);
            x(6) = 2*x(6);
        end
    end
end
% Scale the translation, resize and rotation parameters to the real values
x=x.*scale;

switch ttype
    case 'r'
        % Make the rigid transformation matrix
        M=[ cos(x(3)) sin(x(3)) x(1);
            -sin(x(3)) cos(x(3)) x(2);
            0 0 1];        
    case 'a'
        % Make the rigid transformation matrix
        M=[ x(1) x(2) x(3);
            x(4) x(5) x(6);
            0 0 1];
    otherwise
        error('Unknown registration type');
end;


% Transform the image
Icor=affine_transform_2d_double(double(Imoving),double(M),0); % 3 stands for cubic interpolation

% Show the registration results
figure,
subplot(2,2,1), imshow(Ifixed);
subplot(2,2,2), imshow(Imoving);
subplot(2,2,3), imshow(Icor);
subplot(2,2,4), imshow(abs(Ifixed-Icor));

end

