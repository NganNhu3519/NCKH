close all;clear ;clc;
N=1000;

%% Load WS-Inputv in
load D:\Thungan\Github\NCKH\Lorenz\Obs\y_ECGv1.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\ECG_results_4_11.mat
load D:\Thungan\Github\NCKH\Lorenz\Obs\ecgsig.mat
x_ecg = ecgsig(1:N,1);
y_new = results.x_est(4,:)';

psi = dctmtx(N); %phải là dctmtx
Theta1 = phi*psi';
% s21 = pinv(Theta1)*y_new;
s21 = zeros(N,1);

tic
s1 = l1eq_pd(s21,Theta1,Theta1',y_new,5e-3,20); % L1-magic toolbox
recon = toc;
x1 = psi'*s1;

% Reconstruction with 

figure;
subplot(211),plot(y_cp ,'b.','MarkerSize',7);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',20);
subplot(212),plot(x_ecg,'LineWidth',3); hold on; plot(x1, 'r.','MarkerSize',5);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',20);...
sgtitle('ECG signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)

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