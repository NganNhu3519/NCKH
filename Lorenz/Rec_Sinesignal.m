% Author: Uyen L.P. Nguyen 
% Date: Sept 2024

close all;clear;clc;

%% Load WS-Inputv in
load y_sine.mat
% load D:\NCKH\Github\NCKH\Lorenz\Result\Sine_results_v1.mat
load D:\Thungan\Github\NCKH\Lorenz\Result\Sine_results_v3.mat
y_new = results.x_est(4,:)';

t = 0.01:0.01:10;
x = 0.3*cos(pi*t);
psi = dctmtx(1000);
Theta1 = phi*psi';
s21 = pinv(Theta1)*y_new;
s1 = l1eq_pd(s21,Theta1,Theta1',y_new,5e-3,20); % L1-magic toolbox
x1 = psi'*s1;
%% Reconstruction with 
figure;
subplot(211),plot(y_cp ,'b.','MarkerSize',10);legend('Compressed & encrypted signal');...
    xlabel('(a)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);
subplot(212),plot(x,'LineWidth',2); hold on; plot(x1, 'r.','MarkerSize',10);...
    legend('Original', 'Recovered');;xlabel('(b)','Interpreter','latex','FontSize',20);set(gca,'FontSize',15);

sgtitle('Sine signal - Compressed \& Encrypted Signal','Interpreter','latex','FontSize',20)
mse1 = mse(x,x1);
disp('Sine signal')
fprintf('MSE of Ber: %d \n',mse1)
