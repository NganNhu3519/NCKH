close all; clear; clc;
imgH = 64; imgW = 64;
Img_full = double(imread('cell.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x_true = Img(:);

load y_img_noblock_ver3.mat

N = length(x_true);
psi = dctmtx(N);
Theta = phi * psi';
s0 = pinv(Theta) * y_cp;
tic
s_hat = l1eq_pd(s0, Theta, Theta', y_cp, 5e-3, 20);
recon = toc;
x_hat = psi' * s_hat;
x_hat_dn = x_hat * std(x_true) + mean(x_true);
Img_hat = reshape(x_hat_dn, size(Img));

figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(uint8(mat2gray(Img_hat)*255));
title('CS reconstructed image'); %(no block-wise)

Img_arr = x_true;
x_hat_v = x_hat_dn(:);

mse1 = mse(x_hat_v, Img_arr);
peak_val = max(abs(Img_arr));
[psnr1, snr1] = psnr(x_hat_v, Img_arr, peak_val);
R1  = corrcoef(Img_arr, x_hat_v);
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', ...
        mse1, psnr1, snr1, CC1);

figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(uint8(mat2gray(Img_hat)*255));
title('CS reconstructed image'); %(no block-wise)