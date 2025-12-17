close all; clear; clc;

N = 256;
imgH = 32;
imgW = 32;

Img_org = imread('cell.tif');
Img_org = Img_org(1:imgH,1:imgW);
Img_org = double(Img_org);
Img_arr = Img_org(:);

load y_32.mat
load img_32.mat

y_new = x_est(4,:)';
L = length(Img_arr) / N;
M = length(y_new) / L;

Theta = phi * psi';

x1 = zeros(N, L);

tic
for i = 1:L
    y_seg = y_new((i-1)*M+1:i*M);
    s0    = pinv(Theta) * y_seg;
    s_hat = l1eq_pd(s0, Theta, Theta', y_seg, 5e-3, 20);
    x1(:,i) = psi' * s_hat;
end
recon = toc;

x_rec = x1(:);
x_hat = reshape(x_rec, imgW, imgH)';

figure;
subplot(1,2,1); imshow(uint8(Img_org)); title('Original');
subplot(1,2,2); imshow(uint8(mat2gray(x_hat)*255)); title('Reconstructed');

x_hat_v = x_hat(:);

mse1 = immse(x_hat_v, Img_arr);
peak_val = max(abs(Img_arr));
[psnr1, snr1] = psnr(x_hat_v, Img_arr, peak_val);
CC = corrcoef(Img_arr, x_hat_v); CC = CC(1,2);

fprintf('Reconstruction time: %.4f s\n', recon);
fprintf('MSE = %.3e | PSNR = %.2f dB | SNR = %.2f dB | CC = %.6f\n', ...
        mse1, psnr1, snr1, CC);