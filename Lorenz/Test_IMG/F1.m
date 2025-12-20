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

M = 6000;
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

save('y_img_noblock_ver5.mat','phi','y_cp','mu','sigma');

%% File 3
close all; clear; clc;

load y_img_noblock_ver5.mat
load img_noblock_ver5.mat

y_use = x_est(4,:)';
y_use = y_use(:);

imgH = 64; imgW = 64;
Img_full = double(imread('riceblurred.png'));
% Img_full = double(imread('cell.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x_true = Img(:);
N = length(x_true);
psi = dctmtx(N);
Theta = phi * psi';
s0 = pinv(Theta) * y_use;
tic
s_hat = l1eq_pd(s0, Theta, Theta', y_use, 5e-3, 20);
recon = toc;
x_hat = psi' * s_hat;
% x_hat_dn = x_hat * sigma + mu;
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

fprintf('MSE=%.3e | PSNR=%.2f dB| CC=%.6f\n',mse1, psnr1, CC1);