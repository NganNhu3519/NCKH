close all; clear; clc;

load chirp.mat
x_true = y(1:1000);

% load y_audio_noblock_ver1.mat
% load audio_noblock_ver1.mat

load y_Audio.mat
load Audio_result.mat

y_use = results.x_est(4,:)';
y_use = y_use(:);

Theta = phi * psi';

% s0 = pinv(Theta) * y_use;
N = length(x_true);
s0 = zeros(N,1);
s_hat = l1eq_pd(s0, Theta, Theta', y_use, 5e-3, 50);

x_hat = psi' * s_hat;

% figure;
% subplot(211);
% plot(y_use,'b.');
% title('SMO output (z\_estimated)');
% 
% subplot(212);
% plot(x_true,'LineWidth',1.2); hold on;
% plot(x_hat,'r.');
% legend('Original','Recovered');

% peak_val = max(abs(x_true));
% [psnr1, snr1] = psnr(x_hat, x_true, peak_val);
% R = corrcoef(x_true, x_hat);
% CC = R(1,2);
% mse1 = mse(x_true, x_hat);
% 
% fprintf('MSE  = %.6e\n', mse1);
% fprintf('PSNR = %.4f dB\n', psnr1);
% fprintf('SNR  = %.4f dB\n', snr1);
% fprintf('CC   = %.6f\n', CC);

x_true_n = (x_true - min(x_true)) / (max(x_true) - min(x_true));
x_hat_n  = (x_hat  - min(x_hat )) / (max(x_hat ) - min(x_hat ));
fprintf('x_true_n: min = %.3f | max = %.3f\n', min(x_true_n), max(x_true_n));
fprintf('x_hat_n : min = %.3f | max = %.3f\n', min(x_hat_n),  max(x_hat_n));

peak_val = 1;
mse01 = mse(x_true_n, x_hat_n);
[psnr01, snr01] = psnr(x_hat_n, x_true_n, peak_val);
R = corrcoef(x_true_n, x_hat_n); CC01 = R(1,2);

fprintf('MSE  = %.6e\n', mse01);
fprintf('PSNR = %.4f dB\n', psnr01);
fprintf('SNR  = %.4f dB\n', snr01);
fprintf('CC   = %.6f\n', CC01);

figure;
subplot(211);
plot(y_use,'b.');
title('SMO output (z_{estimated})');
subplot(212);
plot(x_true_n,'LineWidth',1.2); hold on;
plot(x_hat_n,'r.');
legend('Original (norm)','Recovered (norm)');