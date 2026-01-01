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
% (a) Sparse signal
subplot(2,2,1);
stem(x_sparse,'filled');
title('(a) K-sparse original signal');
xlabel('Index'); ylabel('Amplitude');
grid on;
exportgraphics(gcf,'K-sparse original signal.png','Resolution',300);

% (b) CS measurements
subplot(2,2,2);
plot(y_cp,'k');
title('(b) Compressed measurements y = \Phi x');
xlabel('Index'); ylabel('Amplitude');
grid on;
exportgraphics(gcf,'Compressed measurements.png','Resolution',300);

% (c) Histogram of sparse signal
subplot(2,2,3);
histogram(x_sparse,30);
title('(c) Histogram of original signal');
xlabel('Amplitude'); ylabel('Count');
exportgraphics(gcf,'Histogram of original signal.png','Resolution',300);

% (d) Histogram of measurements
subplot(2,2,4);
histogram(y_cp,30);
title('(d) Histogram of compressed signal');
xlabel('Amplitude'); ylabel('Count');
exportgraphics(gcf,'Histogram of compressed signal.png','Resolution',300);

figure;
imagesc(abs(x_sparse.'));
colormap hot; colorbar;
title('Magnitude map of sparse signal');
exportgraphics(gcf,'Heat Map.png','Resolution',300);