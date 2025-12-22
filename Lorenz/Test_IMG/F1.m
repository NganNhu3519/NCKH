%% FILE 1 — CS IMAGE (NO BLOCK-WISE)
close all; clear; clc;

imgH = 128; imgW = 128;
% Img_full = double(imread('cell.tif'));
% Img_full = double(imread('riceblurred.png'));
Img_full = double(imread('mri.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x = Img(:);
mu = mean(x);
sigma = std(x);
x = (x - mu) / sigma;

N = length(x);
psi = dctmtx(N);

M = 4000;
phi = randi([0 1], M, N);
phi(phi==0) = -1;
phi = phi / sqrt(M);

y_cp = phi * x;

figure;
subplot(2,2,1);
imshow(uint8(Img));
title('Original image');

subplot(2,2,2);
plot(y_cp,'k');
title('CS measurements y');

subplot(2,2,3);
histogram(x,100);
title('Histogram of original image');

subplot(2,2,4);
histogram(y_cp,100);
title('Histogram of CS measurements');

save('y_img_noblock_ver6.mat','phi','y_cp','mu','sigma');
