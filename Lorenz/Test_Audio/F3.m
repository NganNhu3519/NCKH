close all; clear; clc;

load chirp.mat
x_true = y(1:1000);
x_true = (x_true - mean(x_true)) / std(x_true);

load y_audio_noblock_ver4.mat
load audio_noblock_ver4.mat

y_use = x_est(4,:)';
y_use = y_use(:);

Theta = phi * psi';

s0 = pinv(Theta) * y_use;
s_hat = l1eq_pd(s0, Theta, Theta', y_use, 5e-3, 20);

x_hat = psi' * s_hat;

figure;
subplot(211);
plot(y_use,'b.');
title('SMO output (z\_estimated)');

subplot(212);
plot(x_true,'LineWidth',1.2); hold on;
plot(x_hat,'r.');
legend('Original','Recovered');

peak_val = max(abs(x_true));
[psnr1, snr1] = psnr(x_hat, x_true, peak_val);
R = corrcoef(x_true, x_hat);
CC = R(1,2);
mse1 = mse(x_true, x_hat);

fprintf('MSE  = %.6e\n', mse1);
fprintf('PSNR = %.4f dB\n', psnr1);
fprintf('SNR  = %.4f dB\n', snr1);
fprintf('CC   = %.6f\n', CC);
