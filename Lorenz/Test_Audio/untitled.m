close all; clear; clc;

load gong.mat
y_audio = y(1:40000);
audioSignal = y_audio;
audio_new = zeros(40000/4,1);
for k = 1:10000
    audio_new(k) = audioSignal(k*4);
end

L = 10;
N = 1000;

load y_Audio_4_11.mat
load Audio_result.mat
y_new = results.x_est(4,:).';

M = size(phi,1);
y_cs = reshape(y_new, M, L);

Theta = phi * psi.';
x1 = zeros(N, L);

for i = 1:L
    y_seg = y_cs(:,i);
    s0 = pinv(Theta) * y_seg;
    s_rec = l1eq_pd(s0, Theta, Theta.', y_seg, 1e-4, 5);
    x1(:,i) = psi.' * s_rec;
end

x_rec = x1(:);

peak_val = max(abs(audio_new(1:length(x_rec))));
[peaksnr, snr] = psnr(x_rec, audio_new(1:length(x_rec)), peak_val);
R = corrcoef(audio_new(1:length(x_rec)), x_rec);
CC = R(1,2);

fprintf('PSNR: %.4f dB\n', peaksnr);
fprintf('SNR: %.4f dB\n', snr);
fprintf('CC: %.6f\n', CC);

figure;
subplot(211), plot(y_cp, 'b.');
subplot(212), hold on, plot(audio_new), plot(x_rec, 'r.');
