% Author: Uyen L.P. Nguyen 
% Date: Sept 2024
% Sparse signal

close all;clear all;clc;

%% Define parameters
N=512; % signal length
K=20; % sparsity of signal
M=6*K; % the number of measurements 
psi=dctmtx(N); %make sparse
%% Load WS-Inputv in
load y_sparse.mat
% load x_est.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\Sparse_results_v1.mat
y_new = results.x_est(4,:)';
%%
% transfering l1 minimization into linear program
Vec_ones = ones([2 * N, 1]);
Vec_low = zeros([2 * N, 1]);
Vec_high = inf([2 * N, 1]);

ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');

tic %time
z_hat=linprog(Vec_ones,[],[], [phi -phi], y_new, Vec_low, Vec_high,ssOpt);
toc

x_hat=z_hat(1:N)-z_hat(1+N:end);
for i=1:N
    if abs(x_hat(i)) <1e-2
     x_hat(i) =0;
    end
end

%% Reconstruction stage
% y_new = x_est(4,:)';
% Theta1 = phi*psi';
% s21 = pinv(Theta1)*y_new;
% s1 = l1eq_pd(s21,Theta1,Theta1',y_new,5e-3,20); % L1-magic toolbox
% x1 = psi'*s1;

%% Reconstruction with 
figure;
subplot(211),plot(y_cp ,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
subplot(212),plot(x_sparse,'LineWidth',2); hold on; plot(x_hat, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
    xlim([0 512]);

sgtitle('Sparse signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20);

%% MSE
x_sparse = double(x_sparse);
x_hat = double(x_hat);

if size(x_sparse) ~= size(x_hat)
    x_hat = x_hat';
end

peak_val = max(abs(x_sparse));
mse1 = mse(x_sparse, x_hat);
[psnr1, snr1] = psnr(x_hat, x_sparse,peak_val);

fprintf('Sparse signal\n');
fprintf('MSE = %.6e | PSNR = %.2f dB | SNR = %.2f dB\n', mse1, psnr1, snr1);
