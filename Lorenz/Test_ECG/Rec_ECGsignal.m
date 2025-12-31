close all;clear ;clc;
N=1000;

%% Load WS-Inputv in
load y_ECG_5_ver5_bernou.mat
load ecg_ver5.mat
load ecgsig.mat

x_ecg = ecgsig(1:N,1);
xmin = min(x_ecg); 
xmax = max(x_ecg);
x_ecg = (x_ecg - xmin) / (xmax - xmin);

y_new = x_est(4,:)';

Theta1 = phi*psi';
s21 = pinv(Theta1)*y_new; %cái này hay cái dưới đều không quan trọng
% s21 = zeros(N,1);

tic
s1 = l1eq_pd(s21,Theta1,Theta1',y_new,1e-4,20);
recon = toc;
x1 = psi'*s1;

xmin_1 = min(x1);
xmax_1= max(x1);
x1 = (x1 - xmin_1) / (xmax_1 - xmin_1);

% Reconstruction with 
figure;
subplot(2,1,1);
plot(y_cp,'.');
title('Compressed signal');

subplot(2,1,2);
plot(x_ecg,'LineWidth',2); hold on;
plot(x1,'r.', 'MarkerSize',7);
legend('Original','Recovered');
title('ECG reconstruction');

%% MSE
x_ecg = double(x_ecg);
x1 = double(x1);
if size(x_ecg) ~= size(x1)
    x1 = x1';
end

mse1 = immse(x_ecg, x1);
psnr = 10*log10(1/mse1);
R = corrcoef(x_ecg, x1);
CC = R(1,2);
PRD   = sqrt(sum((x_ecg - x1).^2) / sum(x1.^2)) * 100;

format long
fprintf('Recon: %.6f seconds | MSE: %e | PSNR: %.4f dB | CC: %f | PRD: %.4f %%\n', recon, mse1, psnr, CC, PRD);