% close all; clear; clc;
% N = 1000;
% M = 600;
% load gong.mat
% x = y(1:N);
% psi = dctmtx(N);
% x_sparse = psi * x;
% phi = randi([0 1], M, N);
% phi(phi == 0) = -1;
% y_cp = phi * x_sparse;
% save('y.mat','phi','y_cp','psi')

close all; clear; clc;

%% Load original audio
load gong.mat
audioSignal = y(1:40000);
N = 1000; 
x_true = audioSignal(1:N);      % chỉ lấy 1000 mẫu đầu

%% Load CS + chaotic data
load y.mat              % chứa phi, y_cp, psi
load xest.mat           % chứa x_est
y_new = x_est(4,:)';    % chaotic output

M = length(y_new);      % ví dụ 400 phép đo
Theta = phi;            % sensing matrix (400x1000)

%% Scale lại chaotic output
alpha = (y_cp.' * y_new) / (y_new.' * y_new);
y_new = alpha * y_new;

%% L1 Reconstruction
eps = 0.03 * norm(y_new);
s0 = zeros(N,1);

tic;
s_hat = l1eq_pd(s0, Theta, Theta', y_new, eps, 20);
recon_time = toc;

%% Quay về miền thời gian
x_rec = psi' * s_hat;   % inverse DCT

%% Đánh giá
mse1 = immse(x_true, x_rec);
peak_val = max(abs(x_true));
[peaksnr, snr] = psnr(x_rec, x_true, peak_val);
R = corrcoef(x_true, x_rec);
CC = R(1,2);

fprintf('Reconstruction time: %.6f seconds\n', recon_time);
fprintf('MSE  : %.6e\n', mse1);
fprintf('PSNR : %.4f dB\n', peaksnr);
fprintf('SNR  : %.4f dB\n', snr);
fprintf('CC   : %.6f\n', CC);

%% Plot
figure;
subplot(2,1,1); plot(y_cp,'b.','MarkerSize',10);
legend('Compressed & encrypted signal'); ylim([-15 15]);
xlabel('(a)','Interpreter','latex','FontSize',20); set(gca,'FontSize',15);

subplot(2,1,2);
plot(x_true,'LineWidth',2); hold on; plot(x_rec,'r.','MarkerSize',10);
legend('Original','Recovered');
xlabel('(b)','Interpreter','latex','FontSize',20); set(gca,'FontSize',15);
% sgtitle('Audio signal (1000 samples) - Reconstructed','Interpreter','latex','FontSize',20);


