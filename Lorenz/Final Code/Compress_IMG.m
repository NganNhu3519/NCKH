%% FILE 1
clear; close all; clc;

Img = double(imread('mri.tif')); % 128x128
[p,q] = size(Img);

block_size = 32;
ratio = 0.5; %đo 50%

projection_matrix_file = ['projections.' num2str(block_size) '.' num2str(ratio) '.mat'];
A = BCS_SPL_GenerateProjection(block_size, ratio, projection_matrix_file); %key sensing matrix

x_hat = im2col(Img, [block_size block_size], 'distinct');
y = A * x_hat;
b = y(:);

% save('y_img_Rcos_ver7.mat', ...
%      'b', 'A', 'p', 'q', 'block_size', 'ratio');
% 
% save('y_img_Rcos_ver7_workspace.mat')

x_vis = A' * y;
Img_vis = reshape(x_vis(:), p, q);

figure;
subplot(1,2,1); imshow(mat2gray(Img)); title('Original image');
subplot(1,2,2); imshow(mat2gray(Img_vis)); title('Encrypted image');

figure;
subplot(2,2,1)
imshow(mat2gray(Img)); axis image;
title('Original image');
subplot(2,2,2)
plot(b,'k');
title('CS measurements b');
subplot(2,2,3)
histogram(Img(:),100);
title('Histogram of original image');
subplot(2,2,4)
histogram(b,100);
title('Histogram of CS measurements');

I = uint8(Img);
Ih = I(:,1:end-1);   Iv = I(1:end-1,:);   Id = I(1:end-1,1:end-1);
Jh = I(:,2:end);     Jv = I(2:end,:);     Jd = I(2:end,2:end);
E = uint8(mat2gray(Img_vis)*255);
Eh = E(:,1:end-1);   Ev = E(1:end-1,:);   Ed = E(1:end-1,1:end-1);
Fh = E(:,2:end);     Fv = E(2:end,:);     Fd = E(2:end,2:end);

figure;

subplot(2,3,1)
scatter(Ih(:),Jh(:),1,'.'); axis([0 255 0 255]);
title('(a) H-plain');
subplot(2,3,2)
scatter(Iv(:),Jv(:),1,'.'); axis([0 255 0 255]);
title('(b) V-plain');
subplot(2,3,3)
scatter(Id(:),Jd(:),1,'.'); axis([0 255 0 255]);
title('(c) D-plain');
subplot(2,3,4)
scatter(Eh(:),Fh(:),1,'.'); axis([0 255 0 255]);
title('(d) H-encrypted');
subplot(2,3,5)
scatter(Ev(:),Fv(:),1,'.'); axis([0 255 0 255]);
title('(e) V-encrypted');
subplot(2,3,6)
scatter(Ed(:),Fd(:),1,'.'); axis([0 255 0 255]);
title('(f) D-encrypted');