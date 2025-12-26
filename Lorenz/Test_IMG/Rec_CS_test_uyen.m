close all; clear; clc;
imgH = 64; imgW = 64;
Img_full = double(imread('cell.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x_true = Img(:);

load y_img_noblock_ver3.mat
%============================
% uyen
%% recovering
%==================================
% Uyen
y_ext= y_cp(:);
M=length(x_true);
Psi = dct(eye(M));   % hoặc idct(eye(M))
Theta = phi * Psi;
s0 = zeros(M,1);   % initial guess chuẩn
s1 = l1eq_pd(s0, Theta, Theta', y_ext, 5e-3, 50);
x_hat = Psi * s1;
Img_hat = reshape(x_hat, size(Img));
Img_hat = mat2gray(Img_hat);
Img_arr =mat2gray(x_true);
% Plotting
figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(Img_hat);
title('CS reconstructed image'); %(no block-wise)
% Evaluate metrics
[peaksnr,snr_cal] = psnr(Img_hat(:),Img_arr(:))
mse_cal = immse(Img_hat(:), Img_arr(:))
psnr_cal = 10 *log10(1/mse_cal)
R_cal  = corrcoef(Img_hat(:),Img_arr(:));
CC_cal = R_cal(1,2)
fprintf('MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', ...
        mse_cal, psnr_cal, snr_cal, CC_cal);

%============================================================
% %% Ngan
% N = length(x_true);
% psi = dctmtx(N);
% Theta = phi * psi';
% s0 = pinv(Theta) * y_cp;
% tic
% s_hat = l1eq_pd(s0, Theta, Theta', y_cp, 5e-3, 20);
% %recon = toc
% x_hat = psi' * s_hat;
%  x_hat_dn = x_hat * std(x_true) + mean(x_true);
% %x_hat_dn = x_hat ;
% Img_hat = reshape(x_hat_dn, size(Img));
% Img_hat=(mat2gray(Img_hat));
% %===========================================
% 
% figure;
% subplot(1,2,1);
% imshow(uint8(Img));
% title('Original image');
% subplot(1,2,2);
% %imshow(uint8(mat2gray(Img_hat)*255));
% imshow(uint8(Img_hat));
% title('CS reconstructed image'); %(no block-wise)
% 
% Img_arr =mat2gray(x_true);
% x_hat_v = x_hat_dn(:);
% 
% 
% mse1 = mse(Img_hat(:), Img_arr(:));
% peak_val = max(abs(Img_arr));
% [psnr1, snr1] = psnr(x_hat_v, Img_arr, peak_val);
% R1  = corrcoef(Img_arr, x_hat_v);
% CC1 = R1(1,2);
% 
% fprintf('MSE=%.3e | PSNR=%.2f dB | SNR=%.2f dB | CC=%.6f\n', ...
%         mse1, psnr1, snr1, CC1);
% 
% figure;
% subplot(1,2,1);
% imshow(uint8(Img));
% title('Original image');
% subplot(1,2,2);
% imshow(uint8(mat2gray(Img_hat)*255));
% title('CS reconstructed image'); %(no block-wise)