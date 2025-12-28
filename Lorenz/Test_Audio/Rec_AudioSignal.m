close all;clear;clc;

load gong.mat
y_audio = y(1:40000);
audioSignal=y_audio;
audio_new = zeros(40000/4,1);
for k=1:(10000)
    audio_new(k) = audioSignal(k*4);
end
%% Load WS-Inputv in

CS = load ("y_Audio.mat");
SMO = load ("Audio_result_1211.mat");
L = 10;
N = 1000;

phi  = CS.phi;
psi  = CS.psi;
y_cp = CS.y_cp;
y_new = SMO.x_est(4,:)';
M = length(y_new)/L;

Theta = phi*psi';
x1 = zeros(N, L);

for i=1: L
y_block = y_new((i-1)*M+1 : i*M);
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
% s21 = zeros(N,1);
tic;
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),1e-4,5);
recon = toc;
x1(:,i) = psi'*s1;
end

x_rec = x1(:);
audio_n = (audio_new - min(audio_new)) / (max(audio_new) - min(audio_new));
x_rec_n = (x_rec     - min(x_rec))     / (max(x_rec)     - min(x_rec));

figure;
subplot(211)
plot(y_cp,'b.','MarkerSize',10);
legend('Compressed & encrypted signal');
ylim([-15 15])

subplot(212)
plot(audio_n,'LineWidth',2); hold on;
plot(x_rec_n,'r.','MarkerSize',10);
legend('Original (norm)','Recovered (norm)');

sgtitle('output SMO');

%%
mse1 = immse(x_rec_n(:), audio_n(:));
psnr1 = 10*log10(1/mse1);

[acor, lag] = xcorr(x_rec_n, audio_n);
[~, I] = max(acor);
shift = lag(I);
x_rec_align = circshift(x_rec_n, shift);
R1 = corrcoef(audio_n(:), x_rec_align(:));
CC1 = R1(1,2);

fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', mse1, psnr1, CC1);

