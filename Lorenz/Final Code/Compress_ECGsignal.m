close all;clear; clc;

% Define parameters
N = 1000;

load ecgsig.mat
x_ecg=ecgsig(1:N,1);

psi=dctmtx(N); %phải là dctmtx

M = 500;

% Sensing matrix construction - Gaussian hay Bernouli không quan trọng
phi=randi([0 1],M,N);
phi(phi==0)=-1;

phi = orth(randn(N,N))';
phi = phi(1:M,:);

y_ecg = phi*x_ecg;
y_cp = y_ecg;

% save('y_ECG_5_ver5_bernou.mat','phi','y_cp','psi')

%% Plot
load y_ECG_4_ver3.mat

% Original ECG signal
set(groot,'defaultFigureToolbar','none');
figure;
plot(x_ecg,'LineWidth',1.2);
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Original Signal');
exportgraphics(gcf,'Original_Signal.png','Resolution',300);

% Compressed measurements
figure;
plot(y_cp,'k','LineWidth',1);
grid on;
xlabel('Index'); ylabel('Amplitude');
title('Compressed Measurements');
exportgraphics(gcf,'Compressed_Measurements.png','Resolution',300);

% Histogram of original ECG
figure;
histogram(x_ecg,30);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Original');
exportgraphics(gcf,'Histogram_Original.png','Resolution',300);

% Histogram of compressed ECG
figure;
histogram(y_cp,30);
xlabel('Amplitude'); ylabel('Count');
title('Histogram Compressed');
exportgraphics(gcf,'Histogram_Compressed.png','Resolution',300);