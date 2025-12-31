close all;clear; clc;

% Define parameters
N = 1000;

load ecgsig.mat
x_ecg=ecgsig(1:N,1);

psi=dctmtx(N);
x_transform=psi*x_ecg;

M = 500;

% Sensing matrix construction - Gaussian hay Bernouli không quan trọng
phi=randi([0 1],M,N);
phi(phi==0)=-1;

% phi = orth(randn(N,N))';
% phi = phi(1:M,:);

% Sensing using CS 
y_ecg = phi*x_ecg;
y_cp = y_ecg;
save('y_ECG_5_ver5_bernou.mat','phi','y_cp','psi')


