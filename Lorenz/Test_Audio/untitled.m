%% FILE 1 — CS IMAGE (NO BLOCK-WISE)
close all; clear all; clc;
load gong.mat
y_audio = y(1:40000);
audio_new = zeros(10000,1);
for k = 1:10000
    audio_new(k) = y_audio(k*4);
end
x = audio_new;
x = (x - mean(x)) / std(x);
N = length(x);
psi = dctmtx(N);
M = 4000;
phi = randi([0 1], M, N);
phi(phi==0) = -1;
phi = phi / sqrt(M);
y_cp = phi * x;
save('y_Audio_noblock.mat','phi','psi','y_cp')

%% File 3
close all; clear; clc;

load gong.mat
y_audio = y(1:40000);

audio_new = zeros(10000,1);
for k = 1:10000
    audio_new(k) = y_audio(k*4);
end

audio_new = (audio_new - mean(audio_new)) / std(audio_new);

CS  = load('y_Audio_noblock.mat');
SMO = load('y_noblock.mat');

phi  = CS.phi;
psi  = CS.psi;
y_cp = CS.y_cp;

y_use = SMO.x_est(4,:)';
y_use = y_use(:);

Theta = phi * psi';

s0 = pinv(Theta) * y_use;
s_hat = l1eq_pd(s0, Theta, Theta', y_use, 5e-3, 20);

x_hat = psi' * s_hat;

x_hat_dn = x_hat * std(audio_new) + mean(audio_new);

figure;
subplot(211), plot(y_cp,'b.','MarkerSize',8);
legend('Compressed & encrypted signal');
subplot(212), plot(audio_new,'LineWidth',1.5); hold on;
plot(x_hat_dn,'r.');
legend('Original','Recovered');

peak_val = max(abs(audio_new));
[psnr1, snr1] = psnr(x_hat_dn, audio_new, peak_val);
R = corrcoef(audio_new, x_hat_dn);
CC = R(1,2);
mse1 = mse(audio_new, x_hat_dn);

fprintf('MSE = %.6f\n', mse1);
fprintf('PSNR = %.4f dB\n', psnr1);
fprintf('SNR = %.4f dB\n', snr1);
fprintf('CC = %.6f\n', CC);



