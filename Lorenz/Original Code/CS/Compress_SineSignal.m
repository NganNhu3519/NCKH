% Author: Uyen L.P. Nguyen 
% Date: Sept 2024

close all;clear all; clc;

%% Define parameters
N = 1000; % signal length

%% finding the K value of an approximately sparse signal
% load ecgsig.mat
% x=ecgsig(1:N,1);
t = 0.01:0.01:10;
x_in = 0.3*cos(pi*t);
x_in = x_in';
psi = dctmtx(N); % sparsitying transform for ECG signals 
x_transform = psi*x_in;
%% Find out the minimum value of K
% K = 60; % sparsity of signal
% %K=length(find(abs(x_transform)>.05));
% M=6*K; % the number of measurements 
M=400;
%% Sensing matrix construction
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;

%% Sensing using CS 
y = phi*x_in;
y_cp =y;
% save('y_sine.mat','phi','y_cp')

% Theta1 = phi*psi';
% s21 = pinv(Theta1)*y;
% s1 = l1eq_pd(s21,Theta1,Theta1',y,5e-3,20); % L1-magic toolbox
% x1 = psi'*s1;
% %% Reconstruction with 
% figure;plot(y);title('linear measurement y')
% figure;plot(x); hold on; plot(x1, 'r.'); title('bernoulli'); legend('Original', 'Recovered');
% mse1 = mse(x,x1);
% disp('ECG signal')
% fprintf('MSE of Ber: %d \n',mse1)