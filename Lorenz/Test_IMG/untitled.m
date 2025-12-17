%% FILE 1 — CS IMAGE (NO BLOCK-WISE)
close all; clear; clc;

imgH = 32; imgW = 32;
Img = imread('cell.tif');
Img = double(Img(1:imgH,1:imgW));

x = Img(:);
x = (x - mean(x)) / std(x);

N = length(x);
psi = dctmtx(N);

M = 600;
phi = randi([0 1], M, N);
phi(phi==0) = -1;
phi = phi / sqrt(M);

y_cp = phi * x;

save('y_img_noblock_ver2.mat','phi','psi','y_cp','Img');

%% File 3
close all; clear; clc;

load y_img_noblock.mat
load img_noblock.mat

y_use = x_est(4,:)';
y_use = y_use(:);

x_true = Img(:);
Theta = phi * psi';

s0 = pinv(Theta) * y_use;
s_hat = l1eq_pd(s0, Theta, Theta', y_use, 5e-3, 20);

x_hat = psi' * s_hat;
Img_hat = reshape(x_hat, size(Img));

x_hat_dn = x_hat * std(x_true) + mean(x_true);

figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(uint8(mat2gray(Img_hat)*255));
title('CS reconstructed image (no block-wise)');

Img_arr = x_true;
x_hat_v = x_hat_dn(:);

mse1 = immse(x_hat_v, Img_arr);
peak_val = max(abs(Img_arr));
[psnr1, snr1] = psnr(x_hat_v, Img_arr, peak_val);
R1  = corrcoef(Img_arr, x_hat_v);
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', ...
        mse1, psnr1, snr1, CC1);

