close all;

dicomlist = dir(fullfile('C:\Users\rizzu\Desktop\Medical Imaging\Lab1\MRI', '*.dcm'));

for count = 1 : numel(dicomlist)
    info{count} = dicominfo(dicomlist(count).name);
    I(:,:,count) = dicomread(info{count});
end

name = dicominfo('C:\Users\rizzu\Desktop\Medical Imaging\Lab1\MRI\04534601');
ultra = dicomread(name);

ultra = squeeze(ultra);

size(ultra)

figure,
subplot(1,2,1)
imhist(ultra(:));
title('ultrasound')
subplot(1,2,2)
imhist(I(:))
title('MRI')

figure,
imshow(ultra(:,:,80));
title('coronal')
figure,
imshow(squeeze(ultra(130,:,:)));
title('sagittal')
figure
imshow(squeeze(ultra(:,500,:)));
title('axial');


figure,
imshow(I(:,:,10));
title('coronal');
% figure,
% imshow(squeeze(I(30,:,:)));
% figure,
% imshow(squeeze(I(:,50,:)));

%I1 = I{:};

%figure,
%imhist(I1);