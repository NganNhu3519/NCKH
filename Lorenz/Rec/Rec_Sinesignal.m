% Author: Uyen L.P. Nguyen 
% Date: Sept 2024

close all;clear;clc;

%% Load WS-Inputv in
load D:\Thungan\Github\NCKH\Lorenz\y_sine.mat
% load D:\NCKH\Github\NCKH\Lorenz\Result\Sine_results_v1.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\Sine_results_v3.mat
y_new = results.x_est(4,:)';

t = 0.01:0.01:10;
x = 0.3*cos(pi*t);
psi = dctmtx(1000);
Theta1 = phi*psi';
s21 = pinv(Theta1)*y_new;

tic
s1 = l1eq_pd(s21,Theta1,Theta1',y_new,5e-3,20); % L1-magic toolbox
recon = toc;

x1 = psi'*s1;

%% Reconstruction with 
% figure;
% subplot(211),plot(y_cp ,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
%     xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
% subplot(212),plot(x,'LineWidth',2); hold on; plot(x1, 'r.','MarkerSize',10);...
%     legend('Original', 'Recovered');;xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
% 
% sgtitle('Sine signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)

%% MSE
if size(x) ~= size(x1)
    x1 = x1';
end
disp('Sine ')

mse1 = mse(x,x1);
peak_val = max(abs(x));
[peaksnr, snr] = psnr(x1, x, peak_val);
R = corrcoef(x, x1);
CC = R(1,2);

fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %d \n',mse1)
fprintf('PSNR (Correct): %.4f dB\n', peaksnr);
fprintf('SNR: %.4f dB\n', snr);
format long
fprintf('Correlation Coefficient: %f\n', CC);

