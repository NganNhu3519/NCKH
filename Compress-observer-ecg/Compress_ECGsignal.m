% Author: Uyen L.P. Nguyen 
% Date: Sept 2024
% Compress ECG signal
close all;clear all; clc;

%% Define parameters
N = 1000; % signal length

%% finding the K value of an approximately sparse signal
load ecgsig.mat
x_ecg=ecgsig(1:N,1);
psi=dctmtx(N); % sparsitying transform for ECG signals 
x_transform=psi*x_ecg;

%% Find out the minimum value of K
% K = 60; % sparsity of signal
% %K=length(find(abs(x_transform)>.05));
% M=6*K; % the number of measurements 
M=400;
%% Sensing matrix construction
phi=randi([0 1],M,N); %bernoulli
phi(phi==0)=-1;

%% Sensing using CS 
y_ecg = phi*x_ecg;
y_ecg_cp =y_ecg;
save('y_measurement.mat','phi','y_ecg_cp','psi')


