close all;clear;clc;

load y_Audio_v1.mat
load audio_v1_500.mat
load chirp.mat

y_est = x_est(4,:)';

audio_new = y(1:1000);


N = 1000;
L = length(audio_new) / N;
y_new = y_cp;
M = length(y_new)/L;

Theta = phi*psi';
x1 = zeros(N, L);

for i=1: L
% s0 = pinv(Theta)*y_new(M*(i-1)+1: M*i);
s0 = zeros(N,1);
tic;
% l1eq_pd(x0, A, At, b, pdtol, pdmaxiter, cgtol, cgmaxiter)
s1 = l1eq_pd(s0,Theta,Theta',y_est,5e-3,50);
recon = toc;
x1(:,i) = psi'*s1;
end

x_rec = x1(:);
x_rec = (x_rec- min(x_rec))/(max(x_rec)-min(x_rec));
audio_new = (audio_new - min(audio_new)) / (max(audio_new) - min(audio_new));

figure;
subplot(211)
plot(y_est,'b.','MarkerSize',8);
legend('Estimated signal');
ylim([-15 15])

subplot(212)
plot(audio_new,'LineWidth',1.5); hold on;
plot(x_rec,'r.','MarkerSize',10);
legend('Original','Recoverer');

%
mse1 = immse(x_rec(:), audio_new(:));
psnr1 = 10*log10(1/mse1);
R1 = corrcoef(audio_new(:), x_rec(:));
CC1 = R1(1,2);
SSIM1 = ssim(x_rec(:), audio_new(:));
x = audio_new(:);
y = x_rec(:);
mux = mean(x);
muy = mean(y);
sigx2 = var(x);
sigy2 = var(y);
sigxy = cov(x,y); 
sigxy = sigxy(1,2);
Lrange = max(x) - min(x);
c1 = (0.01 * Lrange)^2;
c2 = (0.03 * Lrange)^2;
SSIM2 = ((2*mux*muy + c1)*(2*sigxy + c2)) / ...
        ((mux^2 + muy^2 + c1)*(sigx2 + sigy2 + c2));

fprintf('SSIM (function)=%.6f | SSIM (formula)=%.6f\n', SSIM1, SSIM2);
fprintf('MSE=%.3e | PSNR=%.2f dB | CC=%.6f\n', mse1, psnr1, CC1);

%%
figure;
plot(y_est,'b.','MarkerSize',8);
grid on;
legend('Estimated signal');
ylim([-15 15]);
exportgraphics(gcf,'Estimated_Signal_SMO.png','Resolution',300);

% Original vs Recovered audio
figure;
plot(audio_new,'LineWidth',1.5); hold on;
plot(x_rec,'r.','MarkerSize',10);
grid on;
legend('Original','Recovered');
exportgraphics(gcf,'Original_vs_Recovered.png','Resolution',300);

