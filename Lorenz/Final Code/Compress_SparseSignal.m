close all; clear all; clc;

% Define parameters
N = 512; 
K = 20; 
M = 6*K;

% Construction of K-sparse signal
x=zeros(N,1); 
x(randperm(N,K))=randn(K,1);
x_sparse = x;

psi = dct(N); %dct là đẹp

% Sensing matrix construction
phi=randn(M,N);

% Sensing using CS 
y=phi*x;
y_cp =y;
% save('y_sparse_v1.mat','phi','y_cp','x_sparse',"psi");
% save('y_sparse_v1_plot.mat');

%% Plot
figure;
subplot(1,2,1);
stem(x_sparse,'filled');
title('K-sparse signal');
xlabel('Index'); ylabel('Amplitude');
grid on;

subplot(1,2,2);
imagesc(abs(x_sparse)); 
colormap('hot'); colorbar;
title('Heatmap of sparse signal');

