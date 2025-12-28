close all; clear; clc;
imgH = 64; imgW = 64;
Img_full = double(imread('cell.tif'));
% Img_full = double(imread('mri.tif'));
Img = Img_full([1:imgH],[1:imgW]);

x_true = Img(:);
load y_img_noblock_ver3.mat

y_ext= y_cp(:);
M=length(x_true);
Psi = dct(eye(M));   % hoặc idct(eye(M))
Theta = phi * Psi;
s0 = zeros(M,1);   % initial guess chuẩn
s1 = l1eq_pd(s0, Theta, Theta', y_ext, 5e-3, 50);
x_hat = Psi * s1;
Img_hat = reshape(x_hat, size(Img));
Img_hat = mat2gray(Img_hat);
Img_arr = mat2gray(x_true);

% Plotting
figure;
subplot(1,2,1);
imshow(uint8(Img));
title('Original image');
subplot(1,2,2);
imshow(Img_hat);
title('CS reconstructed image'); %(no block-wise)

% Evaluate metrics
mse_cal = immse(Img_hat(:), Img_arr(:));
psnr_cal = 10 *log10(1/mse_cal);
R_cal  = corrcoef(Img_hat(:),Img_arr(:));
CC_cal = R_cal(1,2);
fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', ...
        mse_cal, psnr_cal, CC_cal);

