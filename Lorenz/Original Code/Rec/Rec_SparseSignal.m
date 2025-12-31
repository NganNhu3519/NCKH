close all;clear;clc;

% Define parameters
N=512;
K=20;
M=6*K;
psi=dct(N); %dct là đẹp

load D:\Thungan\Github\NCKH\Lorenz\Obs\y_sparse.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\Sparse_results_v1.mat
y_new = results.x_est(4,:)';

%% Dùng Thay Thế L1 được
% Vec_ones = ones([2 * N, 1]);
% Vec_low = zeros([2 * N, 1]);
% Vec_high = inf([2 * N, 1]);
% 
% ssOpt=optimoptions('linprog', 'Algorithm', 'interior-point');
% 
% tic %time
% z_hat=linprog(Vec_ones,[],[], [phi -phi], y_new, Vec_low, Vec_high,ssOpt);
% recon = toc;
% 
% x_hat=z_hat(1:N)-z_hat(1+N:end);
% for i=1:N
%     if abs(x_hat(i)) <1e-2
%      x_hat(i) =0;
%     end
% end

%% L1
% Reconstruction stage
Theta1 = phi*psi';
s0 = pinv(Theta1)*y_new;
% s0 = zeros(N,1);
tic;
s1 = l1eq_pd(s0,Theta1,Theta1',y_new,5e-3,20);
recon = toc;
x_hat = psi'*s1;

%% Plot
figure;
subplot(211),plot(y_cp ,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
subplot(212),plot(x_sparse,'LineWidth',2); hold on; plot(x_hat, 'r.','MarkerSize',5);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
    xlim([0 512]);

sgtitle('Sparse signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20);

%% MSE
x_sparse = double(x_sparse);
x_hat = double(x_hat);

if size(x_sparse) ~= size(x_hat)
    x_hat = x_hat';
end

mse1 = mse(x_sparse, x_hat);
psnr1 = 10*log10(1/mse1);
R = corrcoef(x_sparse, x_hat);
CC = R(1,2);

format long
fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %e \n',mse1)
fprintf('PSNR (Correct): %.4f dB\n', psnr1);
fprintf('Correlation Coefficient: %f\n', CC);