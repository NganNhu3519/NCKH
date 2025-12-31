close all; clear; clc;

% Load & prepare audio
load chirp.mat
x_true = y(1:5000);               
N = length(x_true);
psi = dctmtx(N);

M = 2500;                           
% phi = randi([0 1], M, N);
% phi(phi==0) = -1;
% phi = phi / sqrt(M);

phi = orth(randn(N,N))';
phi = phi(1:M,:);

% CS encoding
y_cs = phi * x_true;

%% CS decoding
Theta = phi * psi';
% s0 = pinv(Theta) * y_cs;
s0 = zeros(1,M);
s_hat = l1eq_pd(s0, Theta, Theta', y_cs, 5e-3, 20);
x_hat = psi' * s_hat;

% Evaluation
figure;
subplot(211);
plot(y_cs,'b.');
title('CS measurements');

subplot(212);
plot(x_true,'LineWidth',1.2); hold on;
plot(x_hat,'r.');
legend('Original','Recovered');

R = corrcoef(x_true, x_hat);
CC = R(1,2);
mse1 = mse(x_true, x_hat);
psnr = 10*log10(1/mse1);

fprintf('MSE  = %e | PSNR = %.4f dB | CC = %.6f\n', mse1, psnr, CC);
