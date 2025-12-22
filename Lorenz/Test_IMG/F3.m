close all; clear; clc;

load y_img_noblock_ver3.mat
load img_noblock_ver3.mat

y_use = x_est(4,:)';
y_use = y_use(:);

imgH = 32;
imgW = 32;

% Img_full = double(imread('riceblurred.png'));
Img_full = double(imread('cell.tif'));
Img = Img_full(1:imgH,1:imgW);

x_true = Img(:);

opts.mu = 2^8;
opts.beta = 2^5;
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
subplot(1,2,2); imshow(Img_hat,[]);

fprintf('Reconstruction time: %.6f s\n', recon);
fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', mse1, psnr1, CC);
