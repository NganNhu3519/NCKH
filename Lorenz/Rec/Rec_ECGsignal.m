% Author: Uyen L.P. Nguyen 
% Date: Sept 2024
% ECG signal

close all;clear all;clc;
N=1000;
%% Load WS-Inputv in
load y_ECGv2.mat
% load x_estimate.mat
% load D:\NCKH\Github\NCKH\Lorenz\Result\ECG_results_v1.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\ECG_results_v3.mat
load ecgsig.mat
x_ecg=ecgsig(1:N,1);
y_new = results.x_est(4,:)';

Theta1 = phi*psi';
s21 = pinv(Theta1)*y_new;

tic
s1 = l1eq_pd(s21,Theta1,Theta1',y_new,5e-3,20); % L1-magic toolbox
toc

x1 = psi'*s1;
%% Reconstruction with 
% figure;plot(y_ecg_cp);title('linear measurement y')
% figure;plot(x_ecg); hold on; plot(x1, 'r.'); title('ECG Signal'); legend('Original', 'Recovered');

figure;
subplot(211),plot(y_ecg_cp ,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
subplot(212),plot(x_ecg,'LineWidth',2); hold on; plot(x1, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
sgtitle('ECG signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)

%% MSE
x_ecg = double(x_ecg);
x1 = double(x1);
if size(x_ecg) ~= size(x1)
    x1 = x1';
end

mse1 = immse(x_ecg, x1);
peak_val = max(abs(x_ecg)); 
[psnr1, snr1] = psnr(x1, x_ecg, peak_val); 

fprintf('ECG \n');
fprintf('MSE = %.6e | PSNR = %.2f dB | SNR = %.2f dB\n', mse1, psnr1, snr1);
