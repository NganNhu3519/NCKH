close all; clear; clc;
imgH = 64; imgW = 64;
% Img_full = double(imread('cell.tif'));
% Img_full = double(imread('mri.tif'));
Img_full = double(imread('riceblurred.png'));
Img = Img_full([1:imgH],[1:imgW]);
x_true = Img(:);

load y_img_noblock_ver4.mat
load img_noblock_ver4.mat
y_ext= x_est(4,:);

% Ngan
N = length(x_true);
psi = dctmtx(N);
Theta = phi * psi';
s0 = pinv(Theta) * y_cp; % initial guess cho nghiệm sparse s
tic
s_hat = l1eq_pd(s0, Theta, Theta', y_cp, 5e-3, 50);
x_hat = psi' * s_hat;

Img_hat = reshape(x_hat, size(Img));
Img_hat = mat2gray(Img_hat);
Img_arr = mat2gray(Img);

figure;
subplot(1,2,1);
imshow(Img_arr);
title('Original image');
subplot(1,2,2);
imshow(Img_hat);
title('CS reconstructed image'); %(no block-wise)

mse1 = immse(Img_hat(:), Img_arr(:));
psnr1 = 10*log10(1/mse1);
R1  = corrcoef(Img_arr, Img_hat);
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', mse1, psnr1, CC1);