 close all;clear;clc;

%% Load WS-Inputv in
load y_sine_v1.mat
load Sine_results_v1_400.mat
y_new = results.x_est(4,:)';

t = 0.01:0.01:10;
x = 0.3*cos(pi*t);
psi = dctmtx(1000); %phải là dctmtx
Theta1 = phi*psi';
s21 = pinv(Theta1)*y_new;

tic
s1 = l1eq_pd(s21,Theta1,Theta1',y_new,5e-3,20); % L1-magic toolbox
recon = toc;

x1 = psi'*s1;
x1 = x1';

figure;
plot(y_cp ,'b.','MarkerSize',10);legend('Compressed & encrypted signal');
xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
exportgraphics(gcf,'Compressed & encrypted signal in Sparse domain.png','Resolution',300);

figure;
plot(x,'LineWidth',5); hold on; plot(x1, 'r.','MarkerSize',8);
legend('Original', 'Reconstructed');
xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
exportgraphics(gcf,'Reconstructed Sine.png','Resolution',300);

mse1 = mse(x,x1);
psnr1 = 10*log10(1/mse1);
CC1 = corrcoef(x, x1);
CC = CC1(1,2);

format long
fprintf('Reconstruction time: %.6f seconds\n', recon);
fprintf('MSE of Ber: %d \n',mse1)
fprintf('PSNR (Correct): %.4f dB\n', psnr1);
fprintf('Correlation Coefficient: %f\n', CC);

