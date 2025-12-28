  close all; clear; clc;

imgH = 64; imgW = 64;
% Img_full = double(imread('cell.tif'));
Img_full = double(imread('riceblurred.png'));
Img = Img_full([1:imgH],[1:imgW]);
x_true = Img(:);

load img_noblock_ver4.mat
load y_img_noblock_ver4.mat
y_use = x_est(4,:)';

opts.mu = 2^8;
opts.beta = 2^5;
opts.tol = 1e-4;
opts.maxit = 300;
opts.TVnorm = 1;

N = length(x_true);
psi = dctmtx(N);
Theta = phi * psi';
s0 = pinv(Theta) * y_cp;

tic
[Img_hat, out] = TVAL3(phi, y_use, imgH, imgW, opts);
recon = toc;

x_rec = Img_hat(:);
x_rec = reshape(x_rec,size(Img));
x_rec = mat2gray(x_rec);
Img_arr = mat2gray(Img);

mse1 = immse(x_rec, Img_arr);
psnr1 = 10*log10(1 / mse1);
R1  = corrcoef(Img_arr, x_rec);
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', mse1, psnr1, CC1);

subplot(1,2,1); imshow(Img,[]);
subplot(1,2,2); imshow(Img_hat,[]);