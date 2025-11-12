% close all; clear; clc;
% N = 1000;
% M = 600;
% 
% load gong.mat
% x = y(1:N);                  % lấy 1000 mẫu đầu tiên
% 
% phi = randi([0 1], M, N);    % sensing matrix Bernoulli
% phi(phi == 0) = -1;
% 
% y_cp = phi * x;              % nén trực tiếp (chưa DCT)
% 
% save('y.mat','phi','y_cp');

close all; clear; clc;

%% Define Audio Signal
load gong.mat
audioSignal = y(1:1000);     % chỉ lấy 1k mẫu để test
N = 1000;                    % original length
M = 600;                     % compressed length

%% Load compressed data (y.mat + xest.mat)
load y.mat                   % chứa: phi, y_cp, psi (nén từ 1k -> 600)
load xest.mat                % chứa: x_est (nếu có)
psi = dctmtx(N);

%% Chuẩn bị dữ liệu tái tạo
L = 1;                       % chỉ 1 block
y_new = x_est(4,:)';         % lấy tín hiệu truyền z tái tạo lại
Theta = phi * psi';

%% Reconstruction for 1 block
s_hat = l1eq_pd(zeros(N,1), Theta, Theta', y_new, 5e-3, 20); % L1-magic
x_rec = psi' * s_hat;        % khôi phục tín hiệu thời gian

%% Visualization
figure;
subplot(2,1,1);
plot(audioSignal, 'LineWidth', 1.2); hold on;
plot(x_rec, 'r--', 'LineWidth', 1.2);
legend('Original', 'Reconstructed');
xlabel('Sample index'); ylabel('Amplitude');
title('Audio Signal Reconstruction (1 000 → 600 samples)');
grid on;

subplot(2,1,2);
plot(audioSignal - x_rec, 'b');
title('Reconstruction Error');
xlabel('Sample index'); ylabel('Error');
grid on;

%% Evaluation metrics
mse_val = mean((audioSignal - x_rec).^2);
peak_val = max(abs(audioSignal));
[peaksnr, snr] = psnr(x_rec, audioSignal, peak_val);
R = corrcoef(audioSignal, x_rec);
CC = R(1,2);

fprintf('\nReconstruction results for 1 block (1k → 600):\n');
fprintf('MSE   = %.6e\n', mse_val);
fprintf('PSNR  = %.3f dB\n', peaksnr);
fprintf('SNR   = %.3f dB\n', snr);
fprintf('CC    = %.4f\n', CC);

