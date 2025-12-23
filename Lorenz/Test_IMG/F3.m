close all; clear; clc;
clear opts

load y_img_noblock_ver6.mat
load img_noblock_ver6.mat

y_use = x_est(4,:)';
y_use = y_use(:);

imgH = 128;
imgW = 128;

% Img_full = double(imread('riceblurred.png'));
Img_full = double(imread('mri.tif'));
Img = Img_full(1:imgH,1:imgW);

x_true = Img(:);

opts.mu = 2^6;
opts.beta = 2^4;
opts.tol = 1e-4;
opts.maxit = 300;
opts.TVnorm = 1;

tic
[Img_hat, out] = TVAL3(phi, y_use, imgH, imgW, opts);
recon = toc;

x_rec  = Img_hat(:);

x_rec = x_rec - mean(x_rec);
x_rec = x_rec / std(x_rec);
x_rec = x_rec * std(x_true);
x_rec = x_rec + mean(x_true);

mse1 = mean((x_rec - x_true).^2);

peak_val = max(x_true);
psnr1 = 10*log10(peak_val^2 / mse1);

R = corrcoef(x_true, x_rec);
CC = R(1,2);

figure;
subplot(1,2,1); imshow(Img,[]);
title('Original image with TVAL3');
subplot(1,2,2); imshow(Img_hat,[]);
title('CS reconstructed image with TVAL3');

fprintf('Reconstruction time: %.6f s\n', recon);
fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', mse1, psnr1, CC);

% %%
% Img_ref_fsim = im2uint8(mat2gray(Img));
% Img_hat_fsim = im2uint8(mat2gray(Img_hat));
% 
% [FSIM_val, FSIMc_val] = FSIM(Img_ref_fsim, Img_hat_fsim);
% 
% fprintf('FSIM = %.6f | FSIMc = %.6f\n', FSIM_val, FSIMc_val);