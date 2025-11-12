close all;clear;clc;

%% Define Audio Signal again 
% y_audio = y(1:1000);
% audioSignal=y_audio;
% audio_new = zeros(1000/4,1);
% for k=1:(1000)
%     audio_new(k) = audioSignal(k*4);
% end
%% Load WS-Inputv in
L = 1; % num of block of audio signal
N = 1000;

load gong.mat
audio_new = y(1:N);

load y.mat
load xest.mat
psi = dctmtx(N);
y_new = x_est(4,:)';
M = length(y_new)/L;  % length of y new
Theta = phi*psi';
for i=1 : L
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
tic;
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),5e-3,20);
recon =toc;
x1(:,i) = psi'*s1;
end
x_rec = x1(:);

%% Reconstruction

figure;
subplot(211),plot(y_cp,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
      ylim([-15 15])
subplot(212),plot(audio_new,'LineWidth',2); hold on; plot(x_rec, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
sgtitle('ECG signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)
mse1 = mse(audio_new,x1(:));
disp('Audio signal')
fprintf('MSE of Audio: %d \n',mse1)
 
  %% Sound
peak_val = max(abs(audio_new));
[peaksnr, snr] = psnr(x1(:), audio_new, peak_val);
R = corrcoef(audio_new, x1);
CC = R(1,2);

fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %d \n',mse1)
fprintf('PSNR (Correct): %.4f dB\n', peaksnr);
fprintf('SNR: %.4f dB\n', snr);
format long
fprintf('Correlation Coefficient: %f\n', CC);