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
% y_new = SMO.x_est(4,:)';
y_new = SMO.x_est(4,:)';
M = length(y_new)/L;

wname = 'db4';
J = 5;
Psi = zeros(N,N);
for i = 1:N
    e = zeros(N,1); e(i) = 1;
    [c,l] = wavedec(e, J, wname);
    Psi(:,i) = waverec(c,l,wname);
end

% Theta = phi*psi';
Theta = phi * Psi';
x1 = zeros(N, L);

for i=1: L
y_block = y_new((i-1)*M+1 : i*M);
s21 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
tic;
s1 = l1eq_pd(s21,Theta,Theta',y_new(M*(i-1)+1: M*i),1e-4,5);
% s1 = omp(Theta, y_block, K);
recon = toc;
% x1(:,i) = psi'*s1;
x1(:,i) = Psi' * s1
end

x_rec = x1(:);


%% Reconstruction
%  figure;plot(y_cp);title('linear measurement y')
%  figure;
%  plot(audio_new); hold on; 
%  plot(x_rec, 'r.'); title('Audio Signal Reconstruction');
%  legend('Original', 'Recovered');

figure;
subplot(211),plot(y_cp,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
      ylim([-15 15])
subplot(212),plot(audio_new,'LineWidth',2); hold on; plot(x_rec, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);...
sgtitle('ECG signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)

%%
peak_val = max(abs(audio_new));
[peaksnr, snr] = psnr(x_rec, audio_new, peak_val);
R = corrcoef(audio_new, x_rec);
CC = R(1,2);
mse1 = mse(audio_new, x_rec);

format long g;
fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %f \n',mse1)
fprintf('PSNR (Correct): %.4f dB\n', peaksnr);
format long
fprintf('Correlation Coefficient: %f\n', CC);