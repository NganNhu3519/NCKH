close all; clear; clc;

%% Load & prepare audio
load chirp.mat
x_true = y(1:1000);                 % N = 1000 baseline
x_true = (x_true - mean(x_true)) / std(x_true);

N = length(x_true);

%% CS parameters (image-style)
psi = dctmtx(N);

M = 400;                            % 40% measurements
phi = randi([0 1], M, N);
phi(phi==0) = -1;
phi = phi / sqrt(M);

%% CS encoding
y_cs = phi * x_true;

%% CS decoding (L1)
Theta = phi * psi';

s0 = pinv(Theta) * y_cs;
s_hat = l1eq_pd(s0, Theta, Theta', y_cs, 5e-3, 20);

x_hat = psi' * s_hat;

%% Evaluation
figure;
subplot(211);
plot(y_cs,'b.');
title('CS measurements');

subplot(212);
plot(x_true,'LineWidth',1.2); hold on;
plot(x_hat,'r.');
legend('Original','Recovered');

peak_val = max(abs(x_true));
[psnr1, snr1] = psnr(x_hat, x_true, peak_val);
R = corrcoef(x_true, x_hat);
CC = R(1,2);
mse1 = mse(x_true, x_hat);

fprintf('N = %d | M = %d\n', N, M);
fprintf('MSE  = %.6f\n', mse1);
fprintf('PSNR = %.4f dB\n', psnr1);
fprintf('SNR  = %.4f dB\n', snr1);
fprintf('CC   = %.6f\n', CC);
