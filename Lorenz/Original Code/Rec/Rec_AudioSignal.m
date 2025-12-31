close all;clear;clc;

% Define Audio Signal again 

load gong.mat
y_audio = y(1:40000);
audioSignal=y_audio;
audio_new = zeros(40000/4,1);
for k=1:(10000)
    audio_new(k) = audioSignal(k*4);
end

% Load WS-Inputv in
L = 10;
N = 1000;

load D:\Thungan\Github\NCKH\Lorenz\Obs\y_Audio_4_11.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\Audio_results_6_11.mat
y_new = results.x_est(4,:)';
M = length(y_new)/L;  % length of y new
psi = dct(N); %dctmtx hoặc dct đều được
Theta = phi*psi';
nmse_y = mean((y_cp - y_new).^2) / mean(y_cp.^2);
nmse_y_db = 10*log10(nmse_y);
fprintf('NMSE of chaotic layer (y_cp vs y_new): %.4f dB\n', nmse_y_db);

x1 = zeros(N, L);

for i=1 : L
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
tic
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),5e-3,20); % L1-magic toolbox
recon = toc;
x1(:,i) = psi'*s1;
end
x1 = x1(:);

% Reconstruction

figure;
subplot(211),plot(y_cp,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
      ylim([-15 15])
subplot(212),plot(audio_new,'LineWidth',2); hold on; plot(x1, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
sgtitle('Audio signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)
 
%% MSE

mse1 = mse(audio_new, x1);
peak_val = max(abs(audio_new));
[peaksnr, snr] = psnr(x1, audio_new, peak_val);
R = corrcoef(audio_new, x1);
CC = R(1,2);

format long
fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %d \n',mse1)
fprintf('PSNR (Correct): %.4f dB\n', peaksnr);
fprintf('SNR: %.4f dB\n', snr);
fprintf('Correlation Coefficient: %f\n', CC);